// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'historia_clinica.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

HistoriaClinica _$HistoriaClinicaFromJson(Map<String, dynamic> json) =>
    HistoriaClinica(
      vacunas:
          (json['vacunas'] as List<dynamic>?)
              ?.map((e) => CarnetVacunacion.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      enfermedades:
          (json['enfermedades'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      tratamientos:
          (json['tratamientos'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      alergias:
          (json['alergias'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      visitas:
          (json['visitas'] as Map<String, dynamic>?)?.map(
            (k, e) => MapEntry(DateTime.parse(k), e as String),
          ) ??
          const {},
      examenes: json['examenes'] as Map<String, dynamic>? ?? const {},
    );

Map<String, dynamic> _$HistoriaClinicaToJson(
  HistoriaClinica instance,
) => <String, dynamic>{
  'vacunas': instance.vacunas,
  'enfermedades': instance.enfermedades,
  'tratamientos': instance.tratamientos,
  'alergias': instance.alergias,
  'visitas': instance.visitas.map((k, e) => MapEntry(k.toIso8601String(), e)),
  'examenes': instance.examenes,
};
