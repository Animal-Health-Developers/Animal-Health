import 'package:json_annotation/json_annotation.dart';
import 'historia_clinica.dart';
import 'carnetvacunacion.dart';
part 'animal.g.dart';
@JsonSerializable()
class Animal {
  // Nombre del animal
  String nombre;
  // Especie del animal (ejemplos: "Perro", "Gato", "Ave")
  String especie;
  //Fecha de nacimiento del Animalito
  DateTime fechaNacimiento;
  // Peso del animal en kilogramos
  num peso;
  // Largo del animal en metros
  num largo;
  //Ancho del animal en metros
  num ancho;
  // Registro de vacunación opcional (si está disponible)
  CarnetVacunacion carnetVacunacion;
  // Historia clínica opcional (si está disponible)
  HistoriaClinica historia_clinica;
  //Foto de perfil del animal de compania.
  String? fotoperfil;
  // Constructor para inicializar un objeto de la clase Animal
  static List<String> get especiesDisponibles => [
    "Perro",
    "Gato",
    "Ave",
    "Roedor",
    "Reptil",
    "Otro"
  ];
  Animal({
    required this.nombre,
    required this.especie,
    required this.fechaNacimiento,
    required this.peso,
    required this.largo,
    required this.ancho,
    required this.carnetVacunacion,
    required this.historia_clinica,
    required this.fotoperfil
  }): assert(especiesDisponibles.contains(especie),
  "La especie '$especie' no es válida."); // Validación

  // Método para comprobar si el animal es adulto
  bool esAdulto() {
    final edadesAdultas = {
      "Perro": 2,
      "Gato": 1,
      "Roedor": {
        "Hamster": 2,
        "Rata": 3,
        "Ratón": 1.5,
        "Cobayo": 3,
        "Gerbo": 2,

      },
      "Reptil": {
        "Tortuga": 5,
        "Serpiente": 2,
        "Lagartija": 1.5,

      },
      "Ave": {
        "Canario": 1,
        "Cacatua Ninfa": 1,
        "Periquito": 1,
        "Loro": 2,
        "Guacamayo": 3,
      },
    };
    // Obtener la edad adulta para la especie y subespecie (si existe)
    if (edadesAdultas.containsKey(especie)) {
      final valorEspecie = edadesAdultas[especie];
      if (valorEspecie is Map && valorEspecie.containsKey(especie)) {
        return edad >= valorEspecie[especie]; // Edad adulta de la subespecie
      } else if (valorEspecie is num) {
        return edad >= valorEspecie; // Edad adulta general de la especie
      }
    }
    return edad >= 3; // Edad adulta predeterminada si no se encuentra
  }
  int get edad {
    final now = DateTime.now();
    int age = now.year - fechaNacimiento.year;
    if (now.month < fechaNacimiento.month ||
        (now.month == fechaNacimiento.month && now.day < fechaNacimiento.day)) {
      age--;
    }
    return age;
  }
  //Método para calcular el IMC (Índice de Masa Corporal) del animal
  double calcularIMC() {
    return peso / (largo * ancho / 10000);
  }
  factory Animal.fromJson(Map<String, dynamic> json) {
    final animal = _$AnimalFromJson(json);
    animal.fechaNacimiento = DateTime.parse(json['fechaNacimiento'] as String); // Convertir de String a DateTime
    return animal;
  }
  Map<String, dynamic> toJson() {
    return {
      'nombre': nombre,
      'especie': especie,
      'fechaNacimiento': fechaNacimiento.toIso8601String(), // Guardar como String en Firestore
      'peso': peso,
      'largo': largo,
      'ancho': ancho,
      'carnetVacunacion': carnetVacunacion.toMap(),
      'historia_clinica': historia_clinica.toMap(),
      'fotoperfil': fotoperfil,
    };
  }
}