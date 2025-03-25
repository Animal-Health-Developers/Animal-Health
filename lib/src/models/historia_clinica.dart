import 'package:json_annotation/json_annotation.dart';
import 'carnetvacunacion.dart';
part 'historia_clinica.g.dart';
@JsonSerializable()
class HistoriaClinica {
  List<CarnetVacunacion> vacunas;
  List<String> enfermedades;
  List<String> tratamientos;
  List<String> alergias;
  Map<DateTime, String> visitas; // Fecha y motivo de la visita
  Map<String, dynamic> examenes; // Resultados de exámenes (podría ser un Map más complejo)

  HistoriaClinica({

    this.vacunas = const [],
    this.enfermedades = const [],
    this.tratamientos = const [],
    this.alergias = const [],
    this.visitas = const {},
    this.examenes = const {},
  });
  Map<String, dynamic> toMap() {
    return {
      'vacunas': vacunas.map((vacuna) => vacuna.toMap()).toList(),
      'enfermedades': enfermedades,
      'tratamientos': tratamientos,
      'alergias': alergias,
      'visitas': visitas.map((key, value) => MapEntry(key.toIso8601String(), value)).cast<String, dynamic>(), // Convierte DateTime a String
      'examenes': examenes,
    };
  }
  factory HistoriaClinica.fromJson(Map<String, dynamic> json) => _$HistoriaClinicaFromJson(json);
  Map<String, dynamic> toJson() => _$HistoriaClinicaToJson(this);
}