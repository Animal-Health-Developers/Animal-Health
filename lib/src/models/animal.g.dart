// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'animal.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Animal _$AnimalFromJson(Map<String, dynamic> json) => Animal(
  nombre: json['nombre'] as String,
  especie: json['especie'] as String,
  fechaNacimiento: DateTime.parse(json['fechaNacimiento'] as String),
  peso: json['peso'] as num,
  largo: json['largo'] as num,
  ancho: json['ancho'] as num,
  carnetVacunacion: CarnetVacunacion.fromJson(
    json['carnetVacunacion'] as Map<String, dynamic>,
  ),
  historia_clinica: HistoriaClinica.fromJson(
    json['historia_clinica'] as Map<String, dynamic>,
  ),
  fotoperfil: json['fotoperfil'] as String?,
);

Map<String, dynamic> _$AnimalToJson(Animal instance) => <String, dynamic>{
  'nombre': instance.nombre,
  'especie': instance.especie,
  'fechaNacimiento': instance.fechaNacimiento.toIso8601String(),
  'peso': instance.peso,
  'largo': instance.largo,
  'ancho': instance.ancho,
  'carnetVacunacion': instance.carnetVacunacion,
  'historia_clinica': instance.historia_clinica,
  'fotoperfil': instance.fotoperfil,
};
