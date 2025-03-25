// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'veterinaria.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Veterinaria _$VeterinariaFromJson(Map<String, dynamic> json) => Veterinaria(
  nombre: json['nombre'] as String,
  servicios:
      (json['servicios'] as List<dynamic>).map((e) => e as String).toList(),
  direccion: json['direccion'] as String,
  numcontacto: (json['numcontacto'] as num).toInt(),
  ciudad: json['ciudad'] as String,
  barrio: json['barrio'] as String,
);

Map<String, dynamic> _$VeterinariaToJson(Veterinaria instance) =>
    <String, dynamic>{
      'nombre': instance.nombre,
      'servicios': instance.servicios,
      'direccion': instance.direccion,
      'numcontacto': instance.numcontacto,
      'ciudad': instance.ciudad,
      'barrio': instance.barrio,
    };
