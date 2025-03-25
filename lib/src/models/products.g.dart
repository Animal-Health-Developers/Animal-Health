// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'products.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Product _$ProductFromJson(Map<String, dynamic> json) => Product(
  name: json['name'] as String,
  price: (json['price'] as num).toDouble(),
  description: json['description'] as String,
  qualification: (json['qualification'] as num?)?.toInt() ?? 0,
  images:
      (json['images'] as List<dynamic>)
          .map((e) => ProductImage.fromJson(e as Map<String, dynamic>))
          .toList(),
  category: json['category'] as String,
  seller: json['seller'] as String,
  stock: (json['stock'] as num).toInt(),
  qualificationsNumber: (json['qualificationsNumber'] as num?)?.toInt() ?? 0,
  opinions:
      (json['opinions'] as List<dynamic>?)
          ?.map((e) => ProductOpinion.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  userId: json['userId'] as String,
  creationDate:
      json['creationDate'] == null
          ? null
          : DateTime.parse(json['creationDate'] as String),
);

Map<String, dynamic> _$ProductToJson(Product instance) => <String, dynamic>{
  'name': instance.name,
  'price': instance.price,
  'description': instance.description,
  'qualification': instance.qualification,
  'images': instance.images,
  'category': instance.category,
  'seller': instance.seller,
  'stock': instance.stock,
  'qualificationsNumber': instance.qualificationsNumber,
  'opinions': instance.opinions,
  'userId': instance.userId,
  'creationDate': instance.creationDate.toIso8601String(),
};
