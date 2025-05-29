import 'package:json_annotation/json_annotation.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Asegúrate de tener esta importación si no la tienes

part 'carnetvacunacion.g.dart';

@JsonSerializable()
class CarnetVacunacion {
  String nombreVacuna;
  DateTime fechaVacunacion;
  String lote;
  String veterinario;
  int numeroDosis;
  DateTime proximaDosis;

  CarnetVacunacion({
    required this.nombreVacuna,
    required this.fechaVacunacion,
    required this.lote,
    required this.veterinario,
    required this.numeroDosis,
    required this.proximaDosis,
  });

  // Método fromMap para crear desde Firestore
  // Asegúrate de manejar correctamente la lectura de strings ISO 8601.
  factory CarnetVacunacion.fromMap(Map<String, dynamic> map) {
    return CarnetVacunacion(
      nombreVacuna: map['nombreVacuna'] ?? 'Sin nombre',
      fechaVacunacion: map['fechaVacunacion'] != null
          ? DateTime.parse(map['fechaVacunacion'])
          : DateTime.now(),
      lote: map['lote'] ?? 'Sin lote',
      veterinario: map['veterinario'] ?? 'Sin veterinario',
      numeroDosis: (map['numeroDosis'] ?? 1).toInt(), // Asegura que sea int
      proximaDosis: map['proximaDosis'] != null
          ? DateTime.parse(map['proximaDosis'])
          : DateTime.now().add(const Duration(days: 365)),
    );
  }

  // toMap para guardar en Firestore: Serializa las fechas a UTC ISO 8601 String con 'Z'
  Map<String, dynamic> toMap() {
    return {
      'nombreVacuna': nombreVacuna,
      'fechaVacunacion': fechaVacunacion.toUtc().toIso8601String(), // ¡CAMBIO AQUÍ!
      'lote': lote,
      'veterinario': veterinario,
      'numeroDosis': numeroDosis,
      'proximaDosis': proximaDosis.toUtc().toIso8601String(),       // ¡CAMBIO AQUÍ!
    };
  }

  factory CarnetVacunacion.fromJson(Map<String, dynamic> json) =>
      _$CarnetVacunacionFromJson(json);

  Map<String, dynamic> toJson() => _$CarnetVacunacionToJson(this);
}