// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) => User(
  uid: json['uid'] as String,
  email: json['email'] as String,
  userName: json['userName'] as String,
  password: json['password'] as String,
  emailVerified: json['emailVerified'] as bool,
  createdAt: DateTime.parse(json['createdAt'] as String),
  updatedAt: DateTime.parse(json['updatedAt'] as String),
  profilePhotoUrl: json['profilePhotoUrl'] as String?,
  fechaNacimiento: json['fechaNacimiento'] as String?,
  documento: json['documento'] as String?,
  contacto: json['contacto'] as String?,
);

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
  'uid': instance.uid,
  'email': instance.email,
  'userName': instance.userName,
  'emailVerified': instance.emailVerified,
  'createdAt': instance.createdAt.toIso8601String(),
  'updatedAt': instance.updatedAt.toIso8601String(),
  'profilePhotoUrl': instance.profilePhotoUrl,
  'fechaNacimiento': instance.fechaNacimiento,
  'documento': instance.documento,
  'contacto': instance.contacto,
};
