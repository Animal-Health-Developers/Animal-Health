import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:developer' as developer;

// Clase para representar una imagen de producto
class ProductImage {
  String publicId;
  String url;

  ProductImage({required this.publicId, required this.url});

  Map<String, dynamic> toJson() {
    return {
      'public_id': publicId,
      'url': url,
    };
  }

  factory ProductImage.fromJson(Map<String, dynamic> json) {
    return ProductImage(
      publicId: json['public_id'] as String? ?? '',
      url: json['url'] as String? ?? '',
    );
  }
}

class ProductOpinion {
  String clientName;
  int rating;
  String comment;

  ProductOpinion({
    required this.clientName,
    required this.rating,
    required this.comment,
  });

  Map<String, dynamic> toJson() {
    return {
      'clientName': clientName,
      'rating': rating,
      'comment': comment,
    };
  }

  factory ProductOpinion.fromJson(Map<String, dynamic> json) {
    return ProductOpinion(
      clientName: json['clientName'] as String? ?? 'Anónimo',
      rating: (json['rating'] as num?)?.toInt() ?? 0,
      comment: json['comment'] as String? ?? '',
    );
  }
}

class Product {
  String id;
  String name;
  String nameLower; // <-- ¡NUEVO CAMPO AQUÍ!
  double price;
  String description;
  int qualification;
  List<ProductImage> images;
  String category;
  String seller;
  int stock;
  int qualificationsNumber;
  List<ProductOpinion> opinions;
  String userId;
  DateTime creationDate;

  Product({
    required this.id,
    required this.name,
    required this.nameLower, // <-- Añadido al constructor
    required this.price,
    required this.description,
    this.qualification = 0,
    required this.images,
    required this.category,
    required this.seller,
    required this.stock,
    this.qualificationsNumber = 0,
    this.opinions = const [],
    required this.userId,
    DateTime? creationDate,
  }) : creationDate = creationDate ?? DateTime.now();

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'nameLower': nameLower, // <-- ¡INCLUIDO EN toJson!
      'price': price,
      'description': description,
      'qualification': qualification,
      'images': images.map((image) => image.toJson()).toList(),
      'category': category,
      'seller': seller,
      'stock': stock,
      'qualificationsNumber': qualificationsNumber,
      'opinions': opinions.map((opinion) => opinion.toJson()).toList(),
      'userId': userId,
      'creationDate': Timestamp.fromDate(creationDate),
    };
  }

  Future<DocumentReference> crearProductoEnFirestore() async {
    // Al crear un producto, asegúrate de que 'nameLower' se calcule y se incluya.
    // Aunque este método esté aquí, la recomendación es calcularlo en VenderProductos.dart.
    // Aquí es un ejemplo de cómo se debería ver si lo gestionara el modelo directamente.
    final Map<String, dynamic> data = toJson();
    data['nameLower'] = name.toLowerCase(); // Sobrescribe para asegurar que es minúscula
    return FirebaseFirestore.instance.collection('products').add(data);
  }

  factory Product.fromFirestore(Map<String, dynamic> data, String documentId) {
    developer.log("--- Product.fromFirestore ---");
    developer.log("Parseando producto ID: $documentId");

    List<ProductImage> parsedImages = [];
    final imagesData = data['images'];
    if (imagesData is List) {
      for (var imgItem in imagesData) {
        if (imgItem is Map<String, dynamic>) {
          try {
            parsedImages.add(ProductImage.fromJson(imgItem));
          } catch (e, s) {
            developer.log("ERROR en ProductImage.fromJson para item $imgItem en producto $documentId: $e\n$s");
          }
        } else {
          developer.log("Item en 'images' no es Map<String, dynamic> para producto $documentId: $imgItem (tipo: ${imgItem.runtimeType})");
        }
      }
    } else if (imagesData != null) {
      developer.log("'images' no es una List para producto $documentId, es: ${imagesData.runtimeType}");
    } else {
      developer.log("'images' es null o no existe para producto $documentId");
    }

    List<ProductOpinion> parsedOpinions = [];
    final opinionsData = data['opinions'];
    if (opinionsData is List) {
      for (var opItem in opinionsData) {
        if (opItem is Map<String, dynamic>) {
          try {
            parsedOpinions.add(ProductOpinion.fromJson(opItem));
          } catch (e, s) {
            developer.log("ERROR en ProductOpinion.fromJson para item $opItem en producto $documentId: $e\n$s");
          }
        } else {
          developer.log("Item en 'opinions' no es Map<String, dynamic> para producto $documentId: $opItem (tipo: ${opItem.runtimeType})");
        }
      }
    } else if (opinionsData != null) {
      developer.log("'opinions' no es una List para producto $documentId, es: ${opinionsData.runtimeType}");
    } else {
      developer.log("'opinions' es null o no existe para producto $documentId");
    }

    // Manejo del campo 'name' y el nuevo 'nameLower'
    final String fetchedName = data['name'] as String? ?? 'Sin Nombre';
    // Si 'nameLower' no existe en los datos (ej. productos antiguos), lo genera a partir de 'name'
    final String fetchedNameLower = data['nameLower'] as String? ?? fetchedName.toLowerCase();

    return Product(
      id: documentId,
      name: fetchedName,
      nameLower: fetchedNameLower, // <-- ¡Asignado aquí!
      price: (data['price'] as num?)?.toDouble() ?? 0.0,
      description: data['description'] as String? ?? 'Sin Descripción',
      qualification: (data['qualification'] as num?)?.toInt() ?? 0,
      images: parsedImages,
      category: data['category'] as String? ?? 'General',
      seller: data['seller'] as String? ?? 'Vendedor Desconocido',
      stock: (data['stock'] as num?)?.toInt() ?? 0,
      qualificationsNumber: (data['qualificationsNumber'] as num?)?.toInt() ?? 0,
      opinions: parsedOpinions,
      userId: data['userId'] as String? ?? '',
      creationDate: (data['creationDate'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }
}