// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'historia_clinica.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

HistoriaClinica _$HistoriaClinicaFromJson(Map<String, dynamic> json) =>
    HistoriaClinica(
      vacunas:
          json['vacunas'] == null
              ? const []
              : _vacunasFromJson(json['vacunas'] as List),
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
          json['visitas'] == null
              ? const {}
              : _visitasFromJson(json['visitas'] as Map<String, dynamic>),
      examenes: json['examenes'] as Map<String, dynamic>? ?? const {},
    );

Map<String, dynamic> _$HistoriaClinicaToJson(HistoriaClinica instance) =>
    <String, dynamic>{
      'vacunas': _vacunasToJson(instance.vacunas),
      'enfermedades': instance.enfermedades,
      'tratamientos': instance.tratamientos,
      'alergias': instance.alergias,
      'visitas': _visitasToJson(instance.visitas),
      'examenes': instance.examenes,
    };
