import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';
import 'historia_clinica.dart';
import 'carnetvacunacion.dart'; // Asegúrate de que esta importación sea correcta
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:flutter/foundation.dart';

part 'animal.g.dart';

// --- Funciones Helper para JsonKey (nivel superior) ---

// Para CarnetVacunacion:
// Convierte un mapa JSON en una instancia de CarnetVacunacion
CarnetVacunacion _carnetVacunacionFromJson(Map<String, dynamic> json) =>
    CarnetVacunacion.fromMap(json);

// Convierte una instancia de CarnetVacunacion a un mapa JSON para json_serializable.
// Adapta los Timestamps de Firestore a Strings ISO 8601.
Map<String, dynamic> _carnetVacunacionToJson(CarnetVacunacion object) {
  final map = object.toMap(); // Obtiene el mapa con Timestamps de Firestore
  return map.map((key, value) {
    if (value is Timestamp) {
      return MapEntry(key, value.toDate().toIso8601String()); // Convierte Timestamp a String para JSON
    }
    return MapEntry(key, value); // Mantiene otros valores sin cambios
  });
}
// --- Fin de funciones Helper ---

@JsonSerializable()
class Animal {
  String id;
  String nombre;
  String especie;
  String raza;
  DateTime fechaNacimiento;
  num peso;
  num largo;
  num ancho;

  // Usa JsonKey para decirle a json_serializable que use tus métodos fromMap/toMap (adaptados)
  @JsonKey(fromJson: _carnetVacunacionFromJson, toJson: _carnetVacunacionToJson)
  CarnetVacunacion carnetVacunacion;

  // HistoriaClinica está marcada con @JsonSerializable(), por lo que
  // json_serializable puede inferir cómo serializarla/deserializarla sin JsonKey aquí.
  HistoriaClinica historiaClinica;

  String fotoPerfilUrl;
  // Ignora estos campos para la serialización JSON, ya que son temporales o de UI.
  @JsonKey(includeFromJson: false, includeToJson: false)
  Uint8List? _imagenBytes; // Bytes de la imagen para manejo temporal
  @JsonKey(includeFromJson: false, includeToJson: false)
  File? _imagenFile; // Archivo de imagen para manejo temporal

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
    required this.raza,
    required this.fechaNacimiento,
    required this.peso,
    required this.largo,
    required this.ancho,
    required this.carnetVacunacion,
    required this.historiaClinica,
    this.fotoPerfilUrl = '',
    this.id = '',
  }) : assert(especiesDisponibles.contains(especie),
  "La especie '$especie' no es válida.");

  // Métodos para manejo de imágenes mejorados (sin cambios)
  Future<void> subirFotoPerfil(String userId) async {
    if (_imagenBytes == null && _imagenFile == null) return;

    try {
      final storageRef = FirebaseStorage.instance
          .ref()
          .child('animal_images/$userId/${DateTime.now().millisecondsSinceEpoch}.jpg');

      if (kIsWeb && _imagenBytes != null) {
        await storageRef.putData(_imagenBytes!);
      } else if (_imagenFile != null) {
        await storageRef.putFile(_imagenFile!);
      } else {
        return;
      }

      fotoPerfilUrl = await storageRef.getDownloadURL();
    } catch (e) {
      debugPrint('Error al subir imagen: $e');
      rethrow;
    }
  }

  Future<void> seleccionarFoto({bool fromCamera = false}) async {
    try {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(
        source: fromCamera ? ImageSource.camera : ImageSource.gallery,
        imageQuality: 85,
      );

      if (pickedFile != null) {
        if (kIsWeb) {
          final bytes = await pickedFile.readAsBytes();
          _imagenBytes = bytes;
        } else {
          _imagenFile = File(pickedFile.path);
        }
        fotoPerfilUrl = '';
      }
    } catch (e) {
      debugPrint('Error al seleccionar imagen: $e');
      rethrow;
    }
  }

  Future<void> cargarImagenDesdeUrl(String url) async {
    if (url.isEmpty) return;

    try {
      final ref = FirebaseStorage.instance.refFromURL(url);
      final bytes = await ref.getData();

      if (bytes != null) {
        if (kIsWeb) {
          _imagenBytes = bytes;
        } else {
          final tempDir = await Directory.systemTemp.createTemp();
          final file = File('${tempDir.path}/temp_img.jpg');
          await file.writeAsBytes(bytes);
          _imagenFile = file;
        }
        fotoPerfilUrl = url;
      }
    } catch (e) {
      debugPrint('Error al cargar imagen desde URL: $e');
    }
  }

  Uint8List? get imagenBytes => _imagenBytes;
  File? get imagenFile => _imagenFile;

  int get edad {
    final now = DateTime.now();
    int age = now.year - fechaNacimiento.year;
    if (now.month < fechaNacimiento.month ||
        (now.month == fechaNacimiento.month &&
            now.day < fechaNacimiento.day)) {
      age--;
    }
    return age;
  }

  double calcularIMC() => peso / (largo * ancho / 10000);

  // Serialización para JSON (usará los helpers que definimos y los generados para HistoriaClinica)
  factory Animal.fromJson(Map<String, dynamic> json) => _$AnimalFromJson(json);

  Map<String, dynamic> toJson() => _$AnimalToJson(this);

  // Método para guardar en Firestore (usa los toMap() de las clases hijas)
  Map<String, dynamic> toFirestore() {
    return {
      'nombre': nombre,
      'especie': especie,
      'raza': raza,
      'fechaNacimiento': fechaNacimiento.toIso8601String(), // Firestore puede manejar Strings de fecha
      'peso': peso,
      'largo': largo,
      'ancho': ancho,
      'carnetVacunacion': carnetVacunacion.toMap(), // Usa CarnetVacunacion.toMap() (con Timestamp)
      'historiaClinica': historiaClinica.toMap(),   // Usa HistoriaClinica.toMap()
      'fotoPerfilUrl': fotoPerfilUrl,
      'id': id,
    };
  }

  // Método para crear desde Firestore (usa los fromMap() de las clases hijas)
  factory Animal.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    return Animal(
      id: doc.id,
      nombre: data['nombre'] ?? '',
      especie: data['especie'] ?? '',
      raza: data['raza'] ?? '',
      fechaNacimiento: DateTime.parse(data['fechaNacimiento']),
      peso: data['peso'] ?? 0,
      largo: data['largo'] ?? 0,
      ancho: data['ancho'] ?? 0,
      carnetVacunacion: CarnetVacunacion.fromMap(
          data['carnetVacunacion'] as Map<String, dynamic>? ?? {}),
      historiaClinica: HistoriaClinica.fromMap(
          data['historiaClinica'] as Map<String, dynamic>? ?? {}),
      fotoPerfilUrl: data['fotoPerfilUrl'] ?? '',
    );
  }
}