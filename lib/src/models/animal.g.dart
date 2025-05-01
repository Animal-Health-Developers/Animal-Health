// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'animal.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Animal _$AnimalFromJson(Map<String, dynamic> json) => Animal(
  nombre: json['nombre'] as String,
  especie: json['especie'] as String,
  raza: json['raza'] as String,
  fechaNacimiento: DateTime.parse(json['fechaNacimiento'] as String),
  peso: json['peso'] as num,
  largo: json['largo'] as num,
  ancho: json['ancho'] as num,
  carnetVacunacion: CarnetVacunacion.fromJson(
    json['carnetVacunacion'] as Map<String, dynamic>,
  ),
  historiaClinica: HistoriaClinica.fromJson(
    json['historiaClinica'] as Map<String, dynamic>,
  ),
  fotoPerfilUrl: json['fotoPerfilUrl'] as String? ?? '',
  id: json['id'] as String? ?? '',
);

Map<String, dynamic> _$AnimalToJson(Animal instance) => <String, dynamic>{
  'id': instance.id,
  'nombre': instance.nombre,
  'especie': instance.especie,
  'raza': instance.raza,
  'fechaNacimiento': instance.fechaNacimiento.toIso8601String(),
  'peso': instance.peso,
  'largo': instance.largo,
  'ancho': instance.ancho,
  'carnetVacunacion': instance.carnetVacunacion,
  'historiaClinica': instance.historiaClinica,
  'fotoPerfilUrl': instance.fotoPerfilUrl,
};
