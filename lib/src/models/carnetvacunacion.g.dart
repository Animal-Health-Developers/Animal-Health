// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'carnetvacunacion.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CarnetVacunacion _$CarnetVacunacionFromJson(Map<String, dynamic> json) =>
    CarnetVacunacion(
      nombreVacuna: json['nombreVacuna'] as String,
      fechaVacunacion: DateTime.parse(json['fechaVacunacion'] as String),
      lote: json['lote'] as String,
      veterinario: json['veterinario'] as String,
      numeroDosis: (json['numeroDosis'] as num).toInt(),
      proximaDosis: DateTime.parse(json['proximaDosis'] as String),
    );

Map<String, dynamic> _$CarnetVacunacionToJson(CarnetVacunacion instance) =>
    <String, dynamic>{
      'nombreVacuna': instance.nombreVacuna,
      'fechaVacunacion': instance.fechaVacunacion.toIso8601String(),
      'lote': instance.lote,
      'veterinario': instance.veterinario,
      'numeroDosis': instance.numeroDosis,
      'proximaDosis': instance.proximaDosis.toIso8601String(),
    };
