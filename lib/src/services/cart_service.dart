// src/services/cart_service.dart
import '../models/products.dart'; // <--- Importa tus modelos Product, ProductImage, ProductOpinion
import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';
import 'dart:developer' as developer;

// Clase para representar un ítem en el carrito, incluyendo cantidad
// <--- CORRECTO: CartItem se define solo aquí
class CartItem {
  final Product product;
  int quantity;

  CartItem({required this.product, this.quantity = 1});

  Map<String, dynamic> toFirestore() {
    return {
      'productId': product.id,
      'quantity': quantity,
      'addedAt': FieldValue.serverTimestamp(),
    };
  }

  static Future<CartItem?> fromFirestore(DocumentSnapshot doc) async {
    try {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      String productId = data['productId'];
      int quantity = data['quantity'];

      DocumentSnapshot productDoc = await FirebaseFirestore.instance.collection('products').doc(productId).get();

      if (productDoc.exists) {
        // <--- CORRECCIÓN CLAVE AQUÍ: Llama a Product.fromFirestore con (data, documentId)
        // en lugar de solo (doc).
        Product product = Product.fromFirestore(productDoc.data() as Map<String, dynamic>, productDoc.id);
        return CartItem(product: product, quantity: quantity);
      } else {
        developer.log('Producto con ID $productId no encontrado en Firestore.');
        return null;
      }
    } catch (e) {
      developer.log('Error al convertir documento de carrito a CartItem: $e');
      return null;
    }
  }
}

class CartService with ChangeNotifier {
  static final CartService _instance = CartService._internal();
  factory CartService() => _instance;
  CartService._internal() {
    _authStateSubscription = FirebaseAuth.instance.authStateChanges().listen((user) {
      _currentUser = user;
      _resetAndLoadCart();
    });
  }

  final List<CartItem> _items = [];
  User? _currentUser;
  StreamSubscription? _authStateSubscription;
  StreamSubscription? _cartFirestoreSubscription;
  Timer? _debounceTimer;

  List<CartItem> get items => List.unmodifiable(_items);

  double get totalPrice {
    double total = 0.0;
    for (var item in _items) {
      total += item.product.price * item.quantity;
    }
    return total;
  }

  void _resetAndLoadCart() {
    developer.log('Reiniciando y cargando carrito. Usuario actual: ${_currentUser?.uid}');
    _items.clear();
    if (_cartFirestoreSubscription != null) {
      _cartFirestoreSubscription!.cancel();
      _cartFirestoreSubscription = null;
    }

    if (_currentUser != null) {
      _listenToUserCart();
    }
    notifyListeners();
  }

  void _listenToUserCart() {
    if (_currentUser == null) {
      developer.log('No hay usuario autenticado para escuchar el carrito.');
      return;
    }

    developer.log('Iniciando escucha de carrito para usuario: ${_currentUser!.uid}');
    _cartFirestoreSubscription = FirebaseFirestore.instance
        .collection('users')
        .doc(_currentUser!.uid)
        .collection('cart')
        .snapshots()
        .listen((snapshot) async {
      developer.log('Snapshot de carrito recibido. Documentos: ${snapshot.docs.length}');
      List<CartItem> loadedItems = [];
      for (var doc in snapshot.docs) {
        CartItem? item = await CartItem.fromFirestore(doc);
        if (item != null) {
          loadedItems.add(item);
        }
      }
      if (!_areCartsEqual(loadedItems, _items)) {
        _items
          ..clear()
          ..addAll(loadedItems);
        notifyListeners();
        developer.log('Carrito cargado/actualizado desde Firestore. Total items: ${_items.length}');
      }
    }, onError: (error) {
      developer.log('Error escuchando carrito desde Firestore: $error');
    });
  }

  bool _areCartsEqual(List<CartItem> list1, List<CartItem> list2) {
    if (list1.length != list2.length) return false;
    for (int i = 0; i < list1.length; i++) {
      if (list1[i].product.id != list2[i].product.id || list1[i].quantity != list2[i].quantity) {
        return false;
      }
    }
    return true;
  }

  Future<void> _updateCartInFirestore() async {
    if (_currentUser == null) {
      developer.log('No hay usuario autenticado para guardar el carrito en Firestore.');
      return;
    }

    if (_debounceTimer?.isActive ?? false) _debounceTimer!.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 500), () async {
      developer.log('Guardando carrito en Firestore para usuario: ${_currentUser!.uid}');
      try {
        WriteBatch batch = FirebaseFirestore.instance.batch();
        CollectionReference cartCollection = FirebaseFirestore.instance
            .collection('users')
            .doc(_currentUser!.uid)
            .collection('cart');

        QuerySnapshot currentCartItems = await cartCollection.get();
        for (DocumentSnapshot doc in currentCartItems.docs) {
          batch.delete(doc.reference);
        }

        for (CartItem item in _items) {
          batch.set(cartCollection.doc(item.product.id), item.toFirestore());
        }
        await batch.commit();
        developer.log('Carrito guardado exitosamente en Firestore.');
      } catch (e) {
        developer.log('Error al guardar carrito en Firestore: $e');
      }
    });
  }

  void addToCart(Product product) {
    bool found = false;
    for (var item in _items) {
      if (item.product.id == product.id) {
        item.quantity++;
        found = true;
        break;
      }
    }
    if (!found) {
      _items.add(CartItem(product: product));
    }
    notifyListeners();
    _updateCartInFirestore();
  }

  void removeFromCart(Product product) {
    _items.removeWhere((item) => item.product.id == product.id);
    notifyListeners();
    _updateCartInFirestore();
  }

  void incrementQuantity(Product product) {
    for (var item in _items) {
      if (item.product.id == product.id) {
        item.quantity++;
        notifyListeners();
        _updateCartInFirestore();
        return;
      }
    }
  }

  void decrementQuantity(Product product) {
    for (var item in _items) {
      if (item.product.id == product.id) {
        if (item.quantity > 1) {
          item.quantity--;
        } else {
          _items.remove(item);
        }
        notifyListeners();
        _updateCartInFirestore();
        return;
      }
    }
  }

  void clearCart() {
    developer.log('Limpiando carrito local y en Firestore.');
    _items.clear();
    notifyListeners();
    _clearCartInFirestore();
  }

  Future<void> _clearCartInFirestore() async {
    if (_currentUser == null) return;
    try {
      QuerySnapshot currentCartItems = await FirebaseFirestore.instance
          .collection('users')
          .doc(_currentUser!.uid)
          .collection('cart')
          .get();
      WriteBatch batch = FirebaseFirestore.instance.batch();
      for (DocumentSnapshot doc in currentCartItems.docs) {
        batch.delete(doc.reference);
      }
      await batch.commit();
      developer.log('Carrito eliminado de Firestore.');
    } catch (e) {
      developer.log('Error al eliminar carrito de Firestore: $e');
    }
  }

  @override
  void dispose() {
    _authStateSubscription?.cancel();
    _cartFirestoreSubscription?.cancel();
    _debounceTimer?.cancel();
    developer.log('CartService disposed.');
    super.dispose();
  }
}