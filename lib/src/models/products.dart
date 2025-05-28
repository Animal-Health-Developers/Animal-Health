import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:developer' as developer;

class ProductImageInfo {
  String url;
  String? description;

  ProductImageInfo({required this.url, this.description});

  // Factory constructor para crear una instancia desde un mapa (Firestore)
  factory ProductImageInfo.fromMap(Map<String, dynamic> map) {
    return ProductImageInfo(
      url: map['url'] as String,
      description: map['description'] as String?,
    );
  }

  // Método para convertir la instancia a un mapa (para guardar en Firestore)
  Map<String, dynamic> toMap() {
    return {
      'url': url,
      'description': description,
    };
  }
}
class Product {
  String id; // Firestore asignará el ID al crear, pero es útil tenerlo si actualizas
  String name;
  double price;
  String description;
  int qualification;
  List<ProductImage> images;
  String category;
  String seller;
  int stock;
  int qualificationsNumber;
  List<ProductOpinion> opinions;
  String userId; // ID del usuario que creó el producto
  DateTime creationDate;

  Product({
    required this.id, // Si se crea desde Firestore, este ID vendrá del documento. Si es nuevo, podría ser un placeholder o generarse.
    required this.name,
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
    // El 'id' del objeto Product no se incluye aquí porque Firestore lo maneja como ID del documento.
    return {
      'name': name,
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

  // Método de instancia para guardar este producto en Firestore
  // Nota: Este método asume que el objeto Product ya tiene un 'id' si es para actualizar,
  // o si es para crear, Firestore generará un nuevo ID.
  // Si llamas a este método en un objeto Product nuevo (sin 'id' de Firestore),
  // el 'id' del objeto no se usará para el ID del documento (Firestore lo genera).
  Future<DocumentReference> crearProductoEnFirestore() async {
    // No es necesario pasar 'this.id' aquí, ya que toJson() no lo incluye.
    // Firestore generará un nuevo ID para el documento.
    // Si quisieras establecer un ID específico, usarías .doc(this.id).set(toJson())
    return FirebaseFirestore.instance.collection('products').add(toJson());
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

    return Product(
      id: documentId,
      name: data['name'] as String? ?? 'Sin Nombre',
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

// ... (Clases ProductImage y ProductOpinion sin cambios)
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