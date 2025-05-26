import '../models/products.dart';
import 'package:flutter/foundation.dart';

// Clase para representar un ítem en el carrito, incluyendo cantidad
class CartItem {
  final Product product;
  int quantity;

  CartItem({required this.product, this.quantity = 1});
}

class CartService with ChangeNotifier { // ChangeNotifier para notificar a los listeners
  static final CartService _instance = CartService._internal();
  factory CartService() => _instance;
  CartService._internal();

  final List<CartItem> _items = [];

  List<CartItem> get items => List.unmodifiable(_items); // Devuelve una copia inmutable

  double get totalPrice {
    double total = 0.0;
    for (var item in _items) {
      total += item.product.price * item.quantity;
    }
    return total;
  }

  void addToCart(Product product) {
    for (var item in _items) {
      if (item.product.id == product.id) { // Asume que Product tiene un campo 'id' único
        item.quantity++;
        notifyListeners();
        return;
      }
    }
    _items.add(CartItem(product: product));
    notifyListeners();
  }

  void removeFromCart(Product product) {
    _items.removeWhere((item) => item.product.id == product.id);
    notifyListeners();
  }

  void incrementQuantity(Product product) {
    for (var item in _items) {
      if (item.product.id == product.id) {
        item.quantity++;
        notifyListeners();
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
          // Si la cantidad es 1 y se decrementa, se elimina del carrito
          _items.remove(item);
        }
        notifyListeners();
        return;
      }
    }
  }

  void clearCart() {
    _items.clear();
    notifyListeners();
  }
}