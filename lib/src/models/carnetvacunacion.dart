import 'package:json_annotation/json_annotation.dart' show JsonSerializable;
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
  Map<String, dynamic> toMap() {
    return {
      'nombreVacuna': nombreVacuna,
      'fechaVacunacion': fechaVacunacion.toIso8601String(), // Convierte DateTime a String
      'lote': lote,
      'veterinario': veterinario,
      'numeroDosis': numeroDosis,
      'proximaDosis': proximaDosis.toIso8601String(), // Convierte DateTime a String
    };
  }
  factory CarnetVacunacion.fromJson(Map<String, dynamic> json) => _$CarnetVacunacionFromJson(json);
  Map<String, dynamic> toJson() => _$CarnetVacunacionToJson(this);
}
