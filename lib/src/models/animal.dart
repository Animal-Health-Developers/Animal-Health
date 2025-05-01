import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';
import 'historia_clinica.dart';
import 'carnetvacunacion.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
part 'animal.g.dart';

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
  CarnetVacunacion carnetVacunacion;
  HistoriaClinica historiaClinica;
  String fotoPerfilUrl;
  Uint8List? _imagenBytes; // Bytes de la imagen para manejo temporal
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

  // Métodos para manejo de imágenes mejorados
  Future<void> subirFotoPerfil(String userId) async {
    if (_imagenBytes == null && _imagenFile == null) return;

    try {
      final storageRef = FirebaseStorage.instance
          .ref()
          .child('animal_images/$userId/${DateTime.now().millisecondsSinceEpoch}.jpg');

      // Subir la imagen según la plataforma
      if (kIsWeb && _imagenBytes != null) {
        await storageRef.putData(_imagenBytes!);
      } else if (_imagenFile != null) {
        await storageRef.putFile(_imagenFile!);
      } else {
        return;
      }

      // Obtener la URL de descarga
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
          // Para web, manejar como bytes
          final bytes = await pickedFile.readAsBytes();
          _imagenBytes = bytes;
        } else {
          // Para móvil, manejar como File
          _imagenFile = File(pickedFile.path);
        }
        // Limpiar la URL antigua si existe
        fotoPerfilUrl = '';
      }
    } catch (e) {
      debugPrint('Error al seleccionar imagen: $e');
      rethrow;
    }
  }

  // Método para cargar imagen desde URL (útil para edición)
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

  // Métodos para obtener la imagen según la plataforma
  Uint8List? get imagenBytes => _imagenBytes;
  File? get imagenFile => _imagenFile;

  // Métodos para calcular edad e IMC
  int get edad {
    final now = DateTime.now();
    int age = now.year - fechaNacimiento.year;
    if (now.month < fechaNacimiento.month ||
        (now.month == fechaNacimiento.month && now.day < fechaNacimiento.day)) {
      age--;
    }
    return age;
  }

  double calcularIMC() => peso / (largo * ancho / 10000);

  // Serialización
  factory Animal.fromJson(Map<String, dynamic> json) => _$AnimalFromJson(json);

  Map<String, dynamic> toJson() => _$AnimalToJson(this);

  Map<String, dynamic> toFirestore() {
    return {
      'nombre': nombre,
      'especie': especie,
      'raza': raza,
      'fechaNacimiento': fechaNacimiento.toIso8601String(),
      'peso': peso,
      'largo': largo,
      'ancho': ancho,
      'carnetVacunacion': carnetVacunacion.toMap(),
      'historiaClinica': historiaClinica.toMap(),
      'fotoPerfilUrl': fotoPerfilUrl,
      'id': id,
    };
  }

  // Método para crear desde Firestore
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