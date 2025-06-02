import 'package:cloud_firestore/cloud_firestore.dart';

// Importante: Si esta clase no tiene @JsonSerializable(), no debe haber una línea 'part'
// part 'carnetvacunacion.g.dart'; // ¡ELIMINAR ESTA LÍNEA!

class CarnetVacunacion {
  String nombreVacuna;
  DateTime fechaVacunacion;
  String lote;
  String veterinario;
  int numeroDosis;
  DateTime proximaDosis;
  DateTime? lastUpdated; // Agregado para consistencia, puede ser nulo

  CarnetVacunacion({
    required this.nombreVacuna,
    required this.fechaVacunacion,
    required this.lote,
    required this.veterinario,
    required this.numeroDosis,
    required this.proximaDosis,
    this.lastUpdated, // Se añade como opcional
  });

  // Constructor factory para crear una instancia desde un mapa de Firestore
  factory CarnetVacunacion.fromMap(Map<String, dynamic> map) {
    String _safeString(dynamic value) {
      if (value == null) {
        return '';
      }
      if (value is String) {
        return value;
      }
      // Intenta convertir Timestamp a String si se encuentra (aunque no debería estar aquí para string fields)
      if (value is Timestamp) {
        return value.toDate().toIso8601String(); // Convierte la fecha a string
      }
      return value.toString(); // Convierte cualquier otro tipo a string
    }

    int _safeInt(dynamic value) {
      if (value == null) {
        return 0; // Valor por defecto si es nulo
      }
      if (value is num) { // Si es un número (int o double)
        return value.toInt(); // Convierte a entero
      }
      if (value is String) { // Si es un String, intenta parsearlo
        return int.tryParse(value) ?? 0; // Si falla, devuelve 0
      }
      return 0; // Para cualquier otro tipo, devuelve 0
    }

    // CRUCIAL: Helper para convertir un Timestamp de Firestore a DateTime
    // También maneja la posibilidad de que datos antiguos aún sean Strings ISO 8601.
    DateTime _parseFirestoreDate(dynamic value) {
      if (value is Timestamp) {
        return value.toDate();
      }
      if (value is String) {
        // Intenta parsear si la fecha está como string (para compatibilidad con datos antiguos)
        return DateTime.tryParse(value) ?? DateTime.now();
      }
      return DateTime.now(); // Valor por defecto si no es ni Timestamp ni String
    }

    return CarnetVacunacion(
      nombreVacuna: _safeString(map['nombreVacuna']),
      // Usamos el helper para las fechas, esperando Timestamp pero siendo flexibles con String
      fechaVacunacion: _parseFirestoreDate(map['fechaVacunacion']),
      lote: _safeString(map['lote']),
      veterinario: _safeString(map['veterinario']),
      numeroDosis: _safeInt(map['numeroDosis']),
      proximaDosis: _parseFirestoreDate(map['proximaDosis']),
      // También se hace seguro para lastUpdated
      lastUpdated: (map['lastUpdated'] is Timestamp) ? (map['lastUpdated'] as Timestamp).toDate() : null,
    );
  }

  // Método para convertir la instancia a un mapa para guardar en Firestore
  // ¡CAMBIO CLAVE AQUÍ! Guardar fechas como Timestamp para Firestore
  Map<String, dynamic> toMap() {
    return {
      'nombreVacuna': nombreVacuna,
      'fechaVacunacion': Timestamp.fromDate(fechaVacunacion), // Guardar como Timestamp
      'lote': lote,
      'veterinario': veterinario,
      'numeroDosis': numeroDosis,
      'proximaDosis': Timestamp.fromDate(proximaDosis), // Guardar como Timestamp
      'lastUpdated': lastUpdated != null ? Timestamp.fromDate(lastUpdated!) : null, // Incluye lastUpdated si existe
    };
  }
}