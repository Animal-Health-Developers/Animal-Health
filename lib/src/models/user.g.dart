// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) => User(
  nombre: json['nombre'] as String,
  email: json['email'] as String,
  password: json['password'] as String,
  userName: json['userName'] as String?,
  numcontact: json['numcontact'] as String,
  direccion: json['direccion'] as String,
  rol: json['rol'] as String,
  profilePicture: json['profilePicture'] as String?,
  fechanacimiento: const TimestampConverter().fromJson(json['fechanacimiento']),
  bio: json['bio'] as String,
);

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
  'nombre': instance.nombre,
  'email': instance.email,
  'password': instance.password,
  'userName': instance.userName,
  'numcontact': instance.numcontact,
  'direccion': instance.direccion,
  'rol': instance.rol,
  'profilePicture': instance.profilePicture,
  'fechanacimiento': const TimestampConverter().toJson(
    instance.fechanacimiento,
  ),
  'bio': instance.bio,
};
