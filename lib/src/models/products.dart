import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';
part 'products.g.dart';
@JsonSerializable()
class Product {
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
  String userId; // ID del usuario en Firestore
  DateTime creationDate;

  Product({
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
    DateTime? creationDate, // Fecha de creación (opcional)
  }) : creationDate = creationDate ?? DateTime.now();

  // Método para convertir el objeto a un mapa (para Firestore)
  Map<String, dynamic> toJson() {
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
      'creationDate': creationDate,
    };
  }
  Future<void> crearProducto(Product product) async {
    await FirebaseFirestore.instance.collection('products').add(product.toJson());
  }
}

// Clase para la imagen del producto
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
      publicId: json['public_id'],
      url: json['url'],
    );
  }
}

// Clase para la opinión del producto
class ProductOpinion {
  String clientName;
  int rating;
  String comment;

  ProductOpinion({required this.clientName, required this.rating, required this.comment});

  Map<String, dynamic> toJson() {
    return {
      'clientName': clientName,
      'rating': rating,
      'comment': comment,
    };
  }
  factory ProductOpinion.fromJson(Map<String, dynamic> json) {
    return ProductOpinion(
      clientName: json['clientName'],
      rating: json['rating'],
      comment: json['comment'],
    );
  }
}