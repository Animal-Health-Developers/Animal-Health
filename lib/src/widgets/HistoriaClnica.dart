import 'package:flutter/material.dart';
import 'package:adobe_xd/pinned.dart';
import '../services/auth_service.dart';
import './Home.dart';
import 'package:adobe_xd/page_link.dart';
import './Ayuda.dart';
import './EditarPerfildeAnimal.dart';
import './FuncionesdelaApp.dart';
import './Configuracion.dart';
import './ListadeAnimales.dart';
import 'dart:ui' as ui; // Para BackdropFilter
// Importa el archivo del modelo Animal
import '../models/animal.dart';
// Importa las dependencias necesarias de Firebase y para selección de archivos
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:developer' as developer; // Para depuración
import 'package:cached_network_image/cached_network_image.dart'; // Para la foto del animal

// Imports para la funcionalidad de visualización del historial (anteriormente en VisualizaciondeHistoriaClnica)
import 'package:url_launcher/url_launcher.dart'; // Para abrir URLs (como PDFs) en aplicaciones externas
import 'package:intl/intl.dart'; // Para formatear fechas en la visualización del historial

import './CarnetdeVacunacin.dart'; // Asegúrate que esta ruta es correcta

// Constantes de estilo para mantener la consistencia
const Color APP_PRIMARY_COLOR = Color(0xff4ec8dd);
const Color APP_TEXT_COLOR = Color(0xff000000);
const String APP_FONT_FAMILY = 'Comic Sans MS';

// Modelo para una entrada de historial clínico (movido aquí desde VisualizaciondeHistoriaClnica)
class ClinicalHistoryEntry {
  final String id;
  final String fileName;
  final String fileUrl;
  final String fileType; // Por ejemplo: "application/pdf", "image/jpeg"
  final DateTime uploadDate;

  ClinicalHistoryEntry({
    required this.id,
    required this.fileName,
    required this.fileUrl,
    required this.fileType,
    required this.uploadDate,
  });

  // Constructor de fábrica para crear una instancia desde un DocumentSnapshot de Firestore
  factory ClinicalHistoryEntry.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return ClinicalHistoryEntry(
      id: doc.id,
      fileName: data['fileName'] as String? ?? 'Archivo desconocido',
      fileUrl: data['fileUrl'] as String? ?? '',
      fileType: data['fileType'] as String? ?? 'application/octet-stream',
      uploadDate: (data['uploadDate'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }
}

class HistoriaClnica extends StatefulWidget {
  final String animalId;

  const HistoriaClnica({
    required Key key,
    required this.animalId,
  }) : super(key: key);

  @override
  _HistoriaClnicaState createState() => _HistoriaClnicaState();
}

class _HistoriaClnicaState extends State<HistoriaClnica> {
  String? _animalName;
  String? _animalPhotoUrl;
  bool _isLoadingAnimalData = true;
  bool _isUploadingFile = false; // Para mostrar un indicador de carga al subir

  @override
  void initState() {
    super.initState();
    _fetchAnimalData();
  }

  // Método para obtener los datos del animal desde Firestore
  Future<void> _fetchAnimalData() async {
    final User? currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) {
      developer.log("No hay usuario logueado para cargar datos del animal.");
      if (mounted) {
        setState(() {
          _isLoadingAnimalData = false;
        });
      }
      return;
    }

    try {
      final animalDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser.uid)
          .collection('animals')
          .doc(widget.animalId)
          .get();

      if (animalDoc.exists) {
        final animalData = Animal.fromFirestore(animalDoc);
        if (mounted) {
          setState(() {
            _animalName = animalData.nombre;
            _animalPhotoUrl = animalData.fotoPerfilUrl;
            _isLoadingAnimalData = false;
          });
        }
      } else {
        developer.log("Documento del animal con ID ${widget.animalId} no encontrado.");
        if (mounted) {
          setState(() {
            _isLoadingAnimalData = false;
          });
        }
      }
    } catch (e) {
      developer.log("Error al cargar datos del animal para HistoriaClnica: $e");
      if (mounted) {
        setState(() {
          _isLoadingAnimalData = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al cargar datos del animal: $e', style: const TextStyle(fontFamily: APP_FONT_FAMILY))),
        );
      }
    }
  }

  // Helper para determinar el tipo MIME basado en la extensión del archivo
  String _getMimeTypeFromExtension(String? extension) {
    if (extension == null) return 'application/octet-stream';
    switch (extension.toLowerCase()) {
      case 'pdf': return 'application/pdf';
      case 'jpg':
      case 'jpeg': return 'image/jpeg';
      case 'png': return 'image/png';
    // Puedes añadir más tipos si es necesario
      default: return 'application/octet-stream';
    }
  }

  // Método para cargar un archivo (PDF o imagen) al historial clínico
  Future<void> _uploadClinicalHistory() async {
    final User? currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Debes iniciar sesión para cargar archivos.', style: TextStyle(fontFamily: APP_FONT_FAMILY))),
      );
      return;
    }

    if (widget.animalId.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('ID de animal no válido.', style: TextStyle(fontFamily: APP_FONT_FAMILY))),
      );
      return;
    }

    setState(() {
      _isUploadingFile = true; // Activa el indicador de carga
    });

    try {
      // Abre el selector de archivos, permitiendo PDFs, JPG, JPEG y PNG
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'jpg', 'jpeg', 'png'],
        withData: true, // Importante para la web, obtiene los bytes del archivo
      );

      if (result != null && result.files.single.bytes != null) {
        PlatformFile file = result.files.single;
        String fileName = file.name;
        String? fileExtension = file.extension; // Obtén la extensión del archivo

        // Determina el tipo MIME usando la extensión
        String mimeType = _getMimeTypeFromExtension(fileExtension);

        // Define la ruta en Firebase Storage
        String filePath = 'users/${currentUser.uid}/animals/${widget.animalId}/clinical_history/${DateTime.now().millisecondsSinceEpoch}_$fileName';

        Reference storageRef = FirebaseStorage.instance.ref().child(filePath);
        // Sube los bytes del archivo a Firebase Storage, usando el mimeType inferido
        UploadTask uploadTask = storageRef.putData(file.bytes!, SettableMetadata(contentType: mimeType));

        TaskSnapshot snapshot = await uploadTask;
        String downloadUrl = await snapshot.ref.getDownloadURL(); // Obtiene la URL de descarga

        // Guarda la información del archivo en Firestore
        await FirebaseFirestore.instance
            .collection('users')
            .doc(currentUser.uid)
            .collection('animals')
            .doc(widget.animalId)
            .collection('clinicalHistory') // Colección para guardar entradas del historial
            .add({
          'fileName': fileName,
          'fileUrl': downloadUrl,
          'fileType': mimeType, // Guarda el tipo MIME inferido
          'uploadDate': FieldValue.serverTimestamp(), // Fecha de subida
        });

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Archivo cargado correctamente.', style: TextStyle(fontFamily: APP_FONT_FAMILY)), backgroundColor: Colors.green),
          );
        }
      } else {
        // El usuario canceló la selección de archivos
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Carga de archivo cancelada.', style: TextStyle(fontFamily: APP_FONT_FAMILY))),
          );
        }
      }
    } catch (e) {
      developer.log("Error al cargar archivo de historial clínico: $e");
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al cargar el archivo: $e', style: const TextStyle(fontFamily: APP_FONT_FAMILY)), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isUploadingFile = false; // Desactiva el indicador de carga
        });
      }
    }
  }

  // Método para ver el historial clínico en un modal (ahora llama a la clase privada)
  Future<void> _viewClinicalHistory() async {
    final User? currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Debes iniciar sesión para ver el historial.', style: TextStyle(fontFamily: APP_FONT_FAMILY))),
      );
      return;
    }

    if (widget.animalId.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('ID de animal no válido.', style: TextStyle(fontFamily: APP_FONT_FAMILY))),
      );
      return;
    }

    // Muestra _VisualizaciondeHistoriaClnicaModalWidget como un modal inferior
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true, // Permite que el modal ocupe casi toda la pantalla
      backgroundColor: Colors.transparent, // Necesario para los bordes redondeados
      builder: (BuildContext modalContext) {
        return _VisualizaciondeHistoriaClnicaModalWidget(
          key: Key('VisualizaciondeHistoriaClinicaModal_${widget.animalId}'),
          animalId: widget.animalId, // Pasa el ID del animal al modal
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // Estas posiciones se ajustan para dejar espacio para la foto y el contenido
    // Tomado de los cálculos en FuncionesdelaApp para consistencia
    const double logoBottomY = 42.0 + 73.0; // El logo termina en Y = 115.0
    const double spaceAfterLogo = 25.0; // Espacio entre el logo y la foto del animal
    const double animalProfilePhotoTop = logoBottomY + spaceAfterLogo; // La foto del animal comienza en Y = 140.0
    const double animalProfilePhotoHeight = 90.0;
    const double animalNameHeight = 20.0; // Altura aproximada del nombre del animal
    const double spaceAfterAnimalProfile = 15.0; // Espacio entre el nombre del animal y el título de las funciones

    // Calcula la posición superior para el contenido principal (cajones de funciones)
    final double mainContentStackTop = animalProfilePhotoTop + animalProfilePhotoHeight + animalNameHeight + spaceAfterAnimalProfile;

    return Scaffold(
      backgroundColor: APP_PRIMARY_COLOR,
      body: Stack(
        children: <Widget>[
          // --- Fondo de Pantalla ---
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: const AssetImage('assets/images/Animal Health Fondo de Pantalla.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          // --- Logo de la App (Navega a Home) ---
          Pinned.fromPins(
            Pin(size: 74.0, middle: 0.5), Pin(size: 73.0, start: 42.0),
            child: PageLink(
              links: [
                PageLinkInfo(
                  transition: LinkTransition.Fade,
                  ease: Curves.easeOut,
                  duration: 0.3,
                  pageBuilder: () => Home(key: const Key('Home_From_HistoriaClinica')),
                ),
              ],
              child: Container(
                decoration: BoxDecoration(
                  image: const DecorationImage(image: AssetImage('assets/images/logo.png'), fit: BoxFit.cover),
                  borderRadius: BorderRadius.circular(15.0),
                  border: Border.all(width: 1.0, color: const Color(0xff000000)),
                ),
              ),
            ),
          ),
          // --- Botón de Retroceso (Manteniendo tamaño y posición) ---
          Pinned.fromPins(
            Pin(size: 52.9, start: 15.0), Pin(size: 50.0, start: 49.0),
            child: InkWell(
              onTap: () => Navigator.of(context).pop(),
              child: Container(decoration: const BoxDecoration(image: DecorationImage(image: AssetImage('assets/images/back.png'), fit: BoxFit.fill))),
            ),
          ),
          // --- Botón de Ayuda (Manteniendo tamaño y posición) ---
          Pinned.fromPins(
            Pin(size: 40.5, end: 15.0), Pin(size: 50.0, start: 49.0),
            child: PageLink(
              links: [PageLinkInfo(pageBuilder: () => Ayuda(key: const Key('Ayuda_From_HistoriaClinica')))],
              child: Container(decoration: const BoxDecoration(image: DecorationImage(image: AssetImage('assets/images/help.png'), fit: BoxFit.fill))),
            ),
          ),
          // --- Iconos Laterales (Configuración y Lista General de Animales) ---
          // Ajustados para empezar desde el top 110.0, dejando espacio para la foto del animal
          Pinned.fromPins(
            Pin(size: 47.2, end: 15.0), Pin(size: 50.0, start: 110.0),
            child: PageLink(
              links: [
                PageLinkInfo(
                  pageBuilder: () => Configuraciones(key: const Key('Settings_From_HistoriaClinica'), authService: AuthService()),
                ),
              ],
              child: Container(decoration: const BoxDecoration(image: DecorationImage(image: AssetImage('assets/images/settingsbutton.png'), fit: BoxFit.fill))),
            ),
          ),
          Pinned.fromPins(
            Pin(size: 60.1, start: 15.0), Pin(size: 60.0, start: 110.0),
            child: PageLink(
              links: [
                PageLinkInfo(
                  pageBuilder: () => const ListadeAnimales(key: Key('ListadeAnimales_From_HistoriaClinica')),
                ),
              ],
              child: Container(decoration: const BoxDecoration(image: DecorationImage(image: AssetImage('assets/images/listaanimales.png'), fit: BoxFit.fill))),
            ),
          ),

          // --- Foto de Perfil del Animal Específico y Nombre ---
          Positioned(
            top: animalProfilePhotoTop, // Usa la posición calculada
            left: 0,
            right: 0,
            child: _isLoadingAnimalData // Muestra un indicador de carga mientras se obtienen los datos del animal
                ? Center(child: CircleAvatar(radius: 45, backgroundColor: Colors.grey[300], child: CircularProgressIndicator(strokeWidth: 2.0, valueColor: AlwaysStoppedAnimation<Color>(APP_PRIMARY_COLOR))))
                : Center(
              child: GestureDetector(
                onTap: () {
                  // Navega a EditarPerfildeAnimal para este animal específico
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EditarPerfildeAnimal(
                        key: Key('EditarPerfilDesdeHistoriaClinica_${widget.animalId}'),
                        animalId: widget.animalId,
                      ),
                    ),
                  );
                },
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 90.0, height: 90.0,
                      decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(25.0),
                          border: Border.all(color: Colors.white, width: 2.5),
                          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.3), spreadRadius: 2, blurRadius: 5, offset: Offset(0,3))]
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(22.5),
                        child: (_animalPhotoUrl != null && _animalPhotoUrl!.isNotEmpty)
                            ? CachedNetworkImage(
                            imageUrl: _animalPhotoUrl!,
                            fit: BoxFit.cover,
                            placeholder: (context, url) => const Center(child: CircularProgressIndicator(strokeWidth: 2.0)),
                            errorWidget: (context, url, error) => Icon(Icons.pets, size: 50, color: Colors.grey[600]))
                            : Icon(Icons.pets, size: 50, color: Colors.grey[600]),
                      ),
                    ),
                    if (_animalName != null && _animalName!.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text(
                          _animalName!,
                          style: TextStyle(
                              fontFamily: APP_FONT_FAMILY,
                              fontSize: 16,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              shadows: [Shadow(blurRadius: 1.0, color: Colors.black.withOpacity(0.5), offset: Offset(1.0,1.0))]
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),

          // --- Contenido Principal de Historia Clínica (Cajones) ---
          Pinned.fromPins(
            Pin(start: 20.0, end: 20.0),
            Pin(start: mainContentStackTop, end: 20.0), // Ajusta el pin superior para que el contenido empiece más abajo
            child: Stack(
              children: <Widget>[
                // Cajón del título "Historia Clínica"
                Pinned.fromPins(
                  Pin(start: 71.5, end: 71.5),
                  Pin(size: 35.0, start: 0.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color(0xe3a0f4fe),
                      borderRadius: BorderRadius.circular(10.0),
                      border: Border.all(
                          width: 1.0, color: const Color(0xe3000000)),
                    ),
                  ),
                ),
                // Texto del título
                Pinned.fromPins(
                  Pin(size: 146.0, middle: 0.5),
                  Pin(size: 28.0, start: 4.0),
                  child: Text(
                    'Historia Clínica',
                    style: TextStyle(
                      fontFamily: APP_FONT_FAMILY,
                      fontSize: 20,
                      color: APP_TEXT_COLOR,
                      fontWeight: FontWeight.w700,
                    ),
                    textAlign: TextAlign.center,
                    softWrap: false,
                  ),
                ),

                // Cajón "Cargar Historia"
                Align(
                  alignment: Alignment(-1.0, -0.49),
                  child: GestureDetector(
                    onTap: _isUploadingFile ? null : _uploadClinicalHistory, // Deshabilita el botón si hay una subida en curso
                    child: ClipRect(
                      child: BackdropFilter(
                        filter: ui.ImageFilter.blur(sigmaX: 2.0, sigmaY: 2.0),
                        child: Container(
                          width: 178.0,
                          height: 163.0,
                          decoration: BoxDecoration(
                            color: const Color(0x5e4ec8dd),
                            borderRadius: BorderRadius.circular(20.0),
                            border: Border.all(
                                width: 1.0, color: const Color(0xff707070)),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0x29000000),
                                offset: Offset(0, 3),
                                blurRadius: 6,
                              ),
                            ],
                          ),
                          child: _isUploadingFile
                              ? Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.white)))
                              : Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                'assets/images/cargarhistoria.png',
                                width: 105.5,
                                height: 120.0,
                                fit: BoxFit.fill,
                              ),
                              SizedBox(height: 8.0),
                              Text(
                                'Cargar Historia',
                                style: TextStyle(
                                  fontFamily: APP_FONT_FAMILY,
                                  fontSize: 20,
                                  color: APP_TEXT_COLOR,
                                  fontWeight: FontWeight.w700,
                                ),
                                textAlign: TextAlign.center,
                                softWrap: false,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                // Cajón "Ver Historia"
                Align(
                  alignment: Alignment(1.0, -0.49),
                  child: ClipRect(
                    child: BackdropFilter(
                      filter: ui.ImageFilter.blur(sigmaX: 2.0, sigmaY: 2.0),
                      child: GestureDetector(
                        onTap: _viewClinicalHistory, // Llama al método para mostrar el modal
                        child: Container(
                          width: 178.0,
                          height: 163.0,
                          decoration: BoxDecoration(
                            color: const Color(0x5e4ec8dd),
                            borderRadius: BorderRadius.circular(20.0),
                            border: Border.all(
                                width: 1.0, color: const Color(0xff707070)),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0x29000000),
                                offset: Offset(0, 3),
                                blurRadius: 6,
                              ),
                            ],
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                'assets/images/verhistoria.png',
                                width: 118.8,
                                height: 120.0,
                                fit: BoxFit.fill,
                              ),
                              SizedBox(height: 8.0),
                              Text(
                                'Ver Historia',
                                style: TextStyle(
                                  fontFamily: APP_FONT_FAMILY,
                                  fontSize: 20,
                                  color: APP_TEXT_COLOR,
                                  fontWeight: FontWeight.w700,
                                ),
                                textAlign: TextAlign.center,
                                softWrap: false,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                // Cajón "Agregar Carnet de Vacunación"
                Pinned.fromPins(
                  Pin(start: 6.0, end: 6.0),
                  Pin(size: 163.0, end: 0.0), // Posicionado al final del Stack
                  child: ClipRect(
                    child: BackdropFilter(
                      filter: ui.ImageFilter.blur(sigmaX: 2.0, sigmaY: 2.0),
                      child: PageLink(
                        links: [
                          PageLinkInfo(
                            transition: LinkTransition.Fade,
                            ease: Curves.easeOut,
                            duration: 0.3,
                            // Asegúrate de pasar el animalId aquí
                            pageBuilder: () => CarnetdeVacunacin(key: Key('CarnetdeVacunacin'), animalId: widget.animalId,),
                          ),
                        ],
                        child: Container(
                          decoration: BoxDecoration(
                            color: const Color(0x5e4ec8dd),
                            borderRadius: BorderRadius.circular(20.0),
                            border: Border.all(
                                width: 1.0, color: const Color(0xff707070)),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0x29000000),
                                offset: Offset(0, 3),
                                blurRadius: 6,
                              ),
                            ],
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                'assets/images/carnetvacunacion.png',
                                width: 114.5,
                                height: 120.0,
                                fit: BoxFit.fill,
                              ),
                              SizedBox(height: 8.0),
                              Text(
                                'Agregar Carnet de Vacunación',
                                style: TextStyle(
                                  fontFamily: APP_FONT_FAMILY,
                                  fontSize: 20,
                                  color: APP_TEXT_COLOR,
                                  fontWeight: FontWeight.w700,
                                ),
                                textAlign: TextAlign.center,
                                softWrap: false,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// --- Inicio de la implementación del modal _VisualizaciondeHistoriaClnicaModalWidget ---
// Esta clase es el StatefulWidget que contendrá la lógica y la UI del modal desplegable.
class _VisualizaciondeHistoriaClnicaModalWidget extends StatefulWidget {
  final String animalId;

  const _VisualizaciondeHistoriaClnicaModalWidget({
    required Key key,
    required this.animalId,
  }) : super(key: key);

  @override
  _VisualizaciondeHistoriaClnicaModalState createState() => _VisualizaciondeHistoriaClnicaModalState();
}

// Estado del widget modal del historial clínico
class _VisualizaciondeHistoriaClnicaModalState extends State<_VisualizaciondeHistoriaClnicaModalWidget> {
  final User? currentUser = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    super.initState();
    // Verifica si el usuario o el ID del animal son válidos al inicializar
    if (currentUser == null || widget.animalId.isEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error: No se puede cargar el historial sin usuario o ID de animal válido.', style: TextStyle(fontFamily: APP_FONT_FAMILY)), backgroundColor: Colors.red),
        );
        // Cierra el modal si los datos son inválidos desde el principio
        if (Navigator.canPop(context)) {
          Navigator.pop(context);
        }
      });
    }
  }

  // Método para eliminar una entrada del historial clínico
  Future<void> _deleteHistoryEntry(String entryId, String fileUrl, String fileName) async {
    bool? confirmDelete = await showDialog<bool>(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          backgroundColor: const Color(0xe3a0f4fe), // Color de fondo del AlertDialog
          title: const Text('Confirmar Eliminación', style: TextStyle(fontFamily: APP_FONT_FAMILY, color: APP_TEXT_COLOR)),
          content: Text('¿Estás seguro de que quieres eliminar "$fileName"? Esta acción no se puede deshacer.', style: const TextStyle(fontFamily: APP_FONT_FAMILY, color: APP_TEXT_COLOR)),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancelar', style: TextStyle(fontFamily: APP_FONT_FAMILY, color: Colors.grey)),
              onPressed: () {
                Navigator.of(dialogContext).pop(false);
              },
            ),
            TextButton(
              style: TextButton.styleFrom(foregroundColor: Colors.red), // Estilo para el botón de eliminar
              child: const Text('Eliminar', style: TextStyle(fontFamily: APP_FONT_FAMILY)),
              onPressed: () {
                Navigator.of(dialogContext).pop(true);
              },
            ),
          ],
        );
      },
    );

    if (confirmDelete == true) {
      try {
        // Primero, intentar eliminar el archivo de Firebase Storage
        if (fileUrl.startsWith('https://firebasestorage.googleapis.com')) {
          try {
            await FirebaseStorage.instance.refFromURL(fileUrl).delete();
            developer.log('Archivo de Storage eliminado: $fileUrl');
          } catch (e) {
            developer.log('Error eliminando archivo de storage: $fileUrl, error: $e');
            // Continuar con la eliminación de Firestore incluso si Storage falla
            // Esto es importante para que la entrada no quede huérfana en Firestore.
          }
        }

        // Luego, eliminar el documento de Firestore
        await FirebaseFirestore.instance
            .collection('users')
            .doc(currentUser!.uid)
            .collection('animals')
            .doc(widget.animalId)
            .collection('clinicalHistory')
            .doc(entryId)
            .delete();

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Entrada eliminada correctamente.', style: TextStyle(fontFamily: APP_FONT_FAMILY)), backgroundColor: Colors.green),
          );
        }
      } catch (e) {
        developer.log('Error al eliminar entrada de historial: $e');
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error al eliminar la entrada: $e', style: const TextStyle(fontFamily: APP_FONT_FAMILY)), backgroundColor: Colors.red),
          );
        }
      }
    }
  }

  // Widget para construir una tarjeta individual del historial
  Widget _buildHistoryCard(BuildContext context, ClinicalHistoryEntry entry) {
    bool isImage = entry.fileType.startsWith('image/');
    bool isPdf = entry.fileType == 'application/pdf';

    return Card(
      color: const Color(0xe3a0f4fe).withOpacity(0.92), // Fondo semitransparente para el cajón
      margin: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 4.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
        leading: SizedBox(
          width: 65,
          height: 65,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8.0),
            child: isImage
                ? CachedNetworkImage(
              imageUrl: entry.fileUrl,
              fit: BoxFit.cover,
              placeholder: (ctx, url) => Container(color: Colors.grey[300], child: const Center(child: CircularProgressIndicator(strokeWidth: 2.5, valueColor: AlwaysStoppedAnimation<Color>(APP_PRIMARY_COLOR)))),
              errorWidget: (ctx, url, err) => Container(color: Colors.grey[300], child: const Icon(Icons.broken_image, color: Colors.grey, size: 30)),
            )
                : Container(
              color: Colors.grey[300],
              child: isPdf
                  ? const Icon(Icons.picture_as_pdf, color: Colors.red, size: 40)
                  : const Icon(Icons.insert_drive_file, color: Colors.grey, size: 40),
            ),
          ),
        ),
        title: Text(entry.fileName, style: const TextStyle(fontFamily: APP_FONT_FAMILY, fontWeight: FontWeight.bold, fontSize: 16, color: APP_TEXT_COLOR)),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Aquí se muestra el tipo, por ejemplo, "PDF" o "JPEG"
            Text('Tipo: ${entry.fileType.split('/').last.toUpperCase()}', style: const TextStyle(fontFamily: APP_FONT_FAMILY, color: APP_TEXT_COLOR, fontSize: 13)),
            Text('Fecha: ${DateFormat('dd/MM/yyyy HH:mm').format(entry.uploadDate)}', style: const TextStyle(fontFamily: APP_FONT_FAMILY, color: APP_TEXT_COLOR, fontSize: 13)),
          ],
        ),
        trailing: PopupMenuButton<String>(
          icon: Icon(Icons.more_vert, color: APP_TEXT_COLOR.withOpacity(0.7)),
          color: const Color(0xffa0f4fe).withOpacity(0.95), // Fondo semitransparente para el menú desplegable
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          onSelected: (String value) {
            if (value == 'open') {
              _launchURL(entry.fileUrl);
            } else if (value == 'delete') {
              _deleteHistoryEntry(entry.id, entry.fileUrl, entry.fileName);
            }
          },
          itemBuilder: (BuildContext popupCtx) => <PopupMenuEntry<String>>[
            const PopupMenuItem<String>(
              value: 'open',
              child: Row(
                children: [
                  Icon(Icons.open_in_new, color: APP_PRIMARY_COLOR, size: 20),
                  SizedBox(width: 8),
                  Text('Abrir', style: TextStyle(fontFamily: APP_FONT_FAMILY, color: APP_TEXT_COLOR)),
                ],
              ),
            ),
            const PopupMenuItem<String>(
              value: 'delete',
              child: Row(
                children: [
                  Icon(Icons.delete_sweep_outlined, color: Colors.red, size: 20),
                  SizedBox(width: 8),
                  Text('Eliminar', style: TextStyle(fontFamily: APP_FONT_FAMILY, color: Colors.red)),
                ],
              ),
            ),
          ],
        ),
        onTap: () => _launchURL(entry.fileUrl), // Abre el archivo al tocar la tarjeta
      ),
    );
  }

  // Método para abrir una URL (usado para ver PDFs o imágenes grandes)
  Future<void> _launchURL(String url) async {
    if (!await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication)) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No se pudo abrir el archivo.', style: TextStyle(fontFamily: APP_FONT_FAMILY)), backgroundColor: Colors.red),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (currentUser == null || widget.animalId.isEmpty) {
      // Si no hay usuario o animalId, no se puede cargar el historial.
      // Se muestra un SnackBar al initState y se cierra el modal.
      return const SizedBox.shrink(); // No renderiza nada si los datos son inválidos
    }

    return FractionallySizedBox(
      heightFactor: 0.92, // El modal ocupará el 92% de la altura de la pantalla
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20.0),
          topRight: Radius.circular(20.0),
        ),
        child: Scaffold(
          backgroundColor: Colors.transparent, // El fondo transparente permite que el Stack muestre la imagen de fondo
          appBar: AppBar(
            title: const Text('Historial Clínico', style: TextStyle(fontFamily: APP_FONT_FAMILY, color: Colors.white)),
            backgroundColor: APP_PRIMARY_COLOR,
            elevation: 1,
            automaticallyImplyLeading: false, // No muestra el botón de retroceso automático en el modal
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20.0),
                topRight: Radius.circular(20.0),
              ),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.close, color: Colors.white),
                onPressed: () => Navigator.of(context).pop(), // Cierra el modal
              )
            ],
          ),
          body: Stack(
            children: [
              // Fondo de pantalla dentro del modal
              Container(
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/Animal Health Fondo de Pantalla.png'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              // StreamBuilder para escuchar cambios en las entradas del historial clínico
              StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('users')
                    .doc(currentUser!.uid)
                    .collection('animals')
                    .doc(widget.animalId)
                    .collection('clinicalHistory')
                    .orderBy('uploadDate', descending: true) // Ordena por fecha de subida, los más recientes primero
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.white)));
                  }
                  if (snapshot.hasError) {
                    developer.log('Error cargando historial clínico: ${snapshot.error}');
                    return Center(
                        child: Text('Error al cargar el historial: ${snapshot.error}',
                            textAlign: TextAlign.center,
                            style: const TextStyle(color: Colors.white, fontFamily: APP_FONT_FAMILY)));
                  }
                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return const Center(
                        child: Padding(
                          padding: EdgeInsets.all(20.0),
                          child: Text('Aún no hay entradas en el historial clínico.\n¡Carga tu primera entrada!',
                              textAlign: TextAlign.center,
                              style: TextStyle(color: Colors.white, fontSize: 18, fontFamily: APP_FONT_FAMILY, fontWeight: FontWeight.w600)),
                        ));
                  }

                  final historyEntries = snapshot.data!.docs.map((doc) => ClinicalHistoryEntry.fromFirestore(doc)).toList();

                  return ListView.builder(
                    padding: const EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 20.0), // Padding inferior para que no quede pegado al borde del modal
                    itemCount: historyEntries.length,
                    itemBuilder: (context, index) {
                      return _buildHistoryCard(context, historyEntries[index]);
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}