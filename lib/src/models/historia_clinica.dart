import 'package:cloud_firestore/cloud_firestore.dart'; // Necesario para Timestamp si se usa en fromMap/toMap
import 'package:json_annotation/json_annotation.dart';
import 'carnetvacunacion.dart'; // Asegúrate de que esta importación sea correcta

part 'historia_clinica.g.dart';

// --- Funciones Helper para JsonKey (nivel superior) ---

// Para List<CarnetVacunacion>:
// Convierte una lista de mapas JSON a una lista de CarnetVacunacion
List<CarnetVacunacion> _vacunasFromJson(List<dynamic> jsonList) =>
    jsonList.map((e) => CarnetVacunacion.fromMap(e as Map<String, dynamic>)).toList();

// Convierte una lista de CarnetVacunacion a una lista de mapas JSON para json_serializable.
// Adapta los Timestamps de Firestore a Strings ISO 8601 dentro de cada mapa.
List<Map<String, dynamic>> _vacunasToJson(List<CarnetVacunacion> objectList) =>
    objectList.map((carnetVacunacion) {
      final map = carnetVacunacion.toMap(); // Obtiene el mapa con Timestamps de Firestore
      return map.map((key, value) {
        if (value is Timestamp) {
          return MapEntry(key, value.toDate().toIso8601String()); // Convierte Timestamp a String para JSON
        }
        return MapEntry(key, value); // Mantiene otros valores sin cambios
      });
    }).toList();


// Para Map<DateTime, String> visitas:
// Convierte un mapa con claves String (fechas ISO) a Map<DateTime, String>
Map<DateTime, String> _visitasFromJson(Map<String, dynamic> json) =>
    json.map((key, value) => MapEntry(DateTime.parse(key), value as String));

// Convierte un Map<DateTime, String> a un mapa con claves String (fechas ISO)
Map<String, String> _visitasToJson(Map<DateTime, String> object) =>
    object.map((key, value) => MapEntry(key.toIso8601String(), value));
// --- Fin de funciones Helper ---


@JsonSerializable()
class HistoriaClinica {
  // Usa JsonKey para la lista de vacunas (adaptada para json_serializable)
  @JsonKey(fromJson: _vacunasFromJson, toJson: _vacunasToJson)
  List<CarnetVacunacion> vacunas;
  List<String> enfermedades;
  List<String> tratamientos;
  List<String> alergias;
  // Usa JsonKey para el Map<DateTime, String> visitas (adaptada para json_serializable)
  @JsonKey(fromJson: _visitasFromJson, toJson: _visitasToJson)
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

  // Método para crear desde Firestore (ya usa fromMap() de CarnetVacunacion y convierte Timestamp)
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

  // Método para convertir a mapa para guardar en Firestore (ya usa toMap() de CarnetVacunacion)
  Map<String, dynamic> toMap() {
    return {
      'vacunas': vacunas.map((vacuna) => vacuna.toMap()).toList(), // Usa CarnetVacunacion.toMap() (con Timestamp)
      'enfermedades': enfermedades,
      'tratamientos': tratamientos,
      'alergias': alergias,
      'visitas': visitas.map((key, value) =>
          MapEntry(key.toIso8601String(), value)), // Guarda fechas como String ISO para Firestore
      'examenes': examenes,
    };
  }

  // Serialización para JSON (usará los helpers que definimos)
  factory HistoriaClinica.fromJson(Map<String, dynamic> json) =>
      _$HistoriaClinicaFromJson(json);

  Map<String, dynamic> toJson() => _$HistoriaClinicaToJson(this);
}