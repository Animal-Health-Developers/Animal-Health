import 'package:json_annotation/json_annotation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'carnetvacunacion.dart';

part 'historia_clinica.g.dart';

@JsonSerializable()
class HistoriaClinica {
  List<CarnetVacunacion> vacunas;
  List<String> enfermedades;
  List<String> tratamientos;
  List<String> alergias;
  Map<DateTime, String> visitas;
  Map<String, dynamic> examenes;

  HistoriaClinica({
    this.vacunas = const [],
    this.enfermedades = const [],
    this.tratamientos = const [],
    this.alergias = const [],
    this.visitas = const {},
    this.examenes = const {},
  });

  // Método fromMap para crear desde Firestore
  factory HistoriaClinica.fromMap(Map<String, dynamic> map) {
    return HistoriaClinica(
      vacunas: (map['vacunas'] as List<dynamic>? ?? [])
          .map((e) => CarnetVacunacion.fromMap(e as Map<String, dynamic>))
          .toList(),
      enfermedades: List<String>.from(map['enfermedades'] ?? []),
      tratamientos: List<String>.from(map['tratamientos'] ?? []),
      alergias: List<String>.from(map['alergias'] ?? []),
      visitas: (map['visitas'] as Map<String, dynamic>? ?? {})
          .map((key, value) => MapEntry(DateTime.parse(key), value as String)),
      examenes: Map<String, dynamic>.from(map['examenes'] ?? {}),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'vacunas': vacunas.map((vacuna) => vacuna.toMap()).toList(),
      'enfermedades': enfermedades,
      'tratamientos': tratamientos,
      'alergias': alergias,
      'visitas': visitas.map((key, value) =>
          MapEntry(key.toIso8601String(), value)),
      'examenes': examenes,
    };
  }

  factory HistoriaClinica.fromJson(Map<String, dynamic> json) =>
      _$HistoriaClinicaFromJson(json);

  Map<String, dynamic> toJson() => _$HistoriaClinicaToJson(this);
}