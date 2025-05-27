import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:video_player/video_player.dart';
import 'dart:developer' as developer;

// --- Constantes de Estilo (puedes centralizarlas si las usas en múltiples archivos) ---
const String _fontFamily = 'Comic Sans MS';
const Color _primaryTextColor = Color(0xff000000);
const Color _buttonBackgroundColor = Color(0xff54d1e0); // Consistente con PerfilPublico
const Color _appBarBackgroundColor = Color(0xff4ec8dd);
const Color _scaffoldBgColor = Color(0xff4ec8dd);
const Color _formContainerColor = Color(0xe3a0f4fe);


class Crearpublicaciondesdeperfil extends StatefulWidget {
  const Crearpublicaciondesdeperfil({Key? key}) : super(key: key);

  @override
  _CrearpublicaciondesdeperfilState createState() =>
      _CrearpublicaciondesdeperfilState();
}

class _CrearpublicaciondesdeperfilState
    extends State<Crearpublicaciondesdeperfil> {
  final ImagePicker _picker = ImagePicker();
  File? _selectedFile; // Para móvil
  Uint8List? _selectedMediaBytes; // Para web (imágenes y videos)
  String? _fileNameForWeb; // Para obtener la extensión en web
  bool _isUploading = false;
  final TextEditingController _captionController = TextEditingController();
  VideoPlayerController? _videoController;
  Future<void>? _initializeVideoPlayerFuture;
  bool _isVideoSelected = false;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _captionController.dispose();
    _videoController?.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    try {
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery, imageQuality: 85);
      if (image == null) return;

      await _videoController?.dispose();
      _videoController = null;
      _initializeVideoPlayerFuture = null;
      _isVideoSelected = false;

      if (kIsWeb) {
        final bytes = await image.readAsBytes();
        if (mounted) {
          setState(() {
            _selectedMediaBytes = bytes;
            _selectedFile = null;
            _fileNameForWeb = image.name;
          });
        }
      } else {
        if (mounted) {
          setState(() {
            _selectedFile = File(image.path);
            _selectedMediaBytes = null;
          });
        }
      }
    } catch (e) {
      developer.log("Error al seleccionar imagen: $e", name: "CrearPubPerfil.PickImage");
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error al seleccionar imagen: $e', style: const TextStyle(fontFamily: _fontFamily))));
      }
    }
  }

  Future<void> _pickVideo() async {
    try {
      final XFile? video = await _picker.pickVideo(source: ImageSource.gallery);
      if (video == null) return;

      await _videoController?.dispose();
      _videoController = null;
      _isVideoSelected = true;

      if (kIsWeb) {
        final bytes = await video.readAsBytes();
        if (mounted) {
          setState(() {
            _selectedMediaBytes = bytes;
            _selectedFile = null;
            _fileNameForWeb = video.name;
            // Para web, la previsualización de video directa es compleja, mostramos placeholder.
            // El _initializeVideoPlayerFuture no se usa para web aquí.
            _initializeVideoPlayerFuture = null;
          });
        }
      } else {
        if (mounted) {
          setState(() {
            _selectedFile = File(video.path);
            _selectedMediaBytes = null;
            _initializeVideoPlayerController(_selectedFile!);
          });
        }
      }
    } catch (e) {
      developer.log("Error al seleccionar video: $e", name: "CrearPubPerfil.PickVideo");
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error al seleccionar video: $e', style: const TextStyle(fontFamily: _fontFamily))));
      }
    }
  }

  Future<void> _initializeVideoPlayerController(File videoFile) async {
    _videoController = VideoPlayerController.file(videoFile);
    _initializeVideoPlayerFuture = _videoController!.initialize().then((_) {
      if (mounted) {
        _videoController!.setLooping(true); // Opcional: hacer que el video se repita en la preview
        setState(() {});
      }
    }).catchError((error) {
      developer.log("Error inicializando VideoPlayer: $error", name: "CrearPubPerfil.InitVideo");
      if (mounted) {
        setState(() {
          _videoController = null;
          _isVideoSelected = false; // Marcar como que no hay video si falla la inicialización
          _initializeVideoPlayerFuture = null;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al cargar la vista previa del video: $error', style: const TextStyle(fontFamily: _fontFamily))),
        );
      }
    });
    if (mounted) setState(() {}); // Actualizar para mostrar el FutureBuilder
  }

  Future<void> _guardarPublicacionEnFirestore(String mediaUrl, bool esVideo) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Usuario no autenticado', style: TextStyle(fontFamily: _fontFamily))));
        return;
      }

      final userDoc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
      final userData = userDoc.data() as Map<String, dynamic>? ?? {};

      await FirebaseFirestore.instance.collection('publicaciones').add({
        'usuarioId': user.uid,
        'usuarioNombre': userData['nombreUsuario'] ?? userData['name'] ?? user.displayName ?? 'Usuario Anónimo',
        'usuarioFoto': userData['profilePhotoUrl'] as String? ?? '',
        'imagenUrl': mediaUrl,
        'esVideo': esVideo,
        'caption': _captionController.text.trim(),
        'fecha': Timestamp.now(),
        'likes': 0,
        "likedBy": [],
        'comentariosCount': 0, // Usar comentariosCount consistentemente
        'tipoPublicacion': 'Público', // O permitir al usuario seleccionar
      });
    } catch (e) {
      developer.log("Error al guardar publicación en Firestore: $e", name: "CrearPubPerfil.SaveFirestore");
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error al guardar publicación: $e', style: const TextStyle(fontFamily: _fontFamily))));
      rethrow; // Para que _uploadFile maneje el estado de _isUploading
    }
  }

  Future<void> _uploadFile() async {
    if ((_selectedFile == null && _selectedMediaBytes == null)) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Por favor selecciona un archivo', style: TextStyle(fontFamily: _fontFamily))));
      return;
    }
    if (_captionController.text.trim().isEmpty) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Por favor ingresa una descripción', style: TextStyle(fontFamily: _fontFamily))));
      return;
    }


    if (mounted) setState(() => _isUploading = true);

    try {
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      String extension;
      String contentType;

      if (kIsWeb) {
        if (_fileNameForWeb == null) throw Exception('Nombre de archivo no disponible para web.');
        extension = path.extension(_fileNameForWeb!).toLowerCase();
      } else {
        if (_selectedFile == null) throw Exception('Archivo no seleccionado para móvil.');
        extension = path.extension(_selectedFile!.path).toLowerCase();
      }

      bool currentIsVideo = _isVideoSelected;

      if (currentIsVideo) {
        // Validaciones de extensiones de video comunes
        if (!['.mp4', '.mov', '.avi', '.mkv', '.webm'].contains(extension)) {
          throw Exception('Formato de video no soportado. Usa MP4, MOV, AVI, MKV, WEBM.');
        }
        contentType = 'video/${extension.substring(1)}';
        // Casos especiales para algunos navegadores/servidores
        if (extension == '.mov') contentType = 'video/quicktime';
      } else {
        // Validaciones de extensiones de imagen comunes
        if (!['.jpg', '.jpeg', '.png', '.gif', '.webp'].contains(extension)) {
          throw Exception('Formato de imagen no soportado. Usa JPG, JPEG, PNG, GIF, WEBP.');
        }
        contentType = 'image/${extension == '.jpg' ? 'jpeg' : extension.substring(1)}';
      }

      final storageRef = FirebaseStorage.instance.ref();
      final fileRef = storageRef.child('publicaciones/${FirebaseAuth.instance.currentUser!.uid}/$timestamp$extension');
      final metadata = SettableMetadata(contentType: contentType);
      UploadTask uploadTask;

      if (kIsWeb) {
        if (_selectedMediaBytes == null) throw Exception('Bytes no disponibles para subida web.');
        uploadTask = fileRef.putData(_selectedMediaBytes!, metadata);
      } else {
        if (_selectedFile == null) throw Exception('Archivo no seleccionado para subida móvil.');
        uploadTask = fileRef.putFile(_selectedFile!, metadata);
      }

      final snapshot = await uploadTask.whenComplete(() {});
      final downloadUrl = await snapshot.ref.getDownloadURL();

      await _guardarPublicacionEnFirestore(downloadUrl, currentIsVideo);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Publicación creada exitosamente!', style: TextStyle(fontFamily: _fontFamily)), backgroundColor: Colors.green),
        );
        // Limpiar estado y navegar
        setState(() {
          _selectedFile = null;
          _selectedMediaBytes = null;
          _fileNameForWeb = null;
          _captionController.clear();
          _isUploading = false;
          _videoController?.dispose();
          _videoController = null;
          _isVideoSelected = false;
          _initializeVideoPlayerFuture = null;
        });
        Navigator.of(context).pop(); // Volver a la pantalla anterior (PerfilPublico)
      }
    } catch (e) {
      developer.log("Error al subir archivo: $e", name: "CrearPubPerfil.Upload");
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al subir archivo: ${e.toString()}', style: const TextStyle(fontFamily: _fontFamily)), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) setState(() => _isUploading = false);
    }
  }

  void _showMediaSelectionDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: _formContainerColor,
          title: const Text('Seleccionar medio', style: TextStyle(fontFamily: _fontFamily, color: _primaryTextColor)),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                GestureDetector(
                  child: const Text('Galería de fotos', style: TextStyle(fontFamily: _fontFamily, fontSize: 18, color: _primaryTextColor)),
                  onTap: () { Navigator.of(context).pop(); _pickImage(); },
                ),
                const Padding(padding: EdgeInsets.all(12.0)),
                GestureDetector(
                  child: const Text('Galería de videos', style: TextStyle(fontFamily: _fontFamily, fontSize: 18, color: _primaryTextColor)),
                  onTap: () { Navigator.of(context).pop(); _pickVideo(); },
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancelar', style: TextStyle(fontFamily: _fontFamily, color: _buttonBackgroundColor)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildMediaPreview() {
    if (_isVideoSelected) {
      if (kIsWeb && _selectedMediaBytes != null) {
        // Para web, VideoPlayerController.memory no existe, y network con blob URLs es complejo.
        // Mostramos un placeholder indicando que es un video.
        return _buildPlaceholderPreview("Video seleccionado.\nLa previsualización para web estará disponible después de subir.");
      }
      else if (!kIsWeb && _videoController != null && _videoController!.value.isInitialized) {
        return AspectRatio(
          aspectRatio: _videoController!.value.aspectRatio > 0 ? _videoController!.value.aspectRatio : 16/9,
          child: Stack(
            alignment: Alignment.center,
            children: [
              VideoPlayer(_videoController!),
              GestureDetector(
                onTap: () {
                  setState(() {
                    if (_videoController!.value.isPlaying) {
                      _videoController!.pause();
                    } else {
                      _videoController!.play();
                    }
                  });
                },
                child: Container(
                  color: Colors.transparent, // Área de toque transparente
                  child: _videoController!.value.isPlaying
                      ? const SizedBox.shrink() // No mostrar nada si está reproduciendo
                      : const Icon(Icons.play_arrow, size: 60, color: Colors.white70),
                ),
              )
            ],
          ),
        );
      } else if (!kIsWeb && _initializeVideoPlayerFuture != null) {
        // Muestra un loader mientras el video se inicializa en móvil
        return FutureBuilder(
          future: _initializeVideoPlayerFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasError || _videoController == null || !_videoController!.value.isInitialized) {
                return _buildErrorPreview("Error al cargar vista previa del video.");
              }
              return AspectRatio(
                aspectRatio: _videoController!.value.aspectRatio > 0 ? _videoController!.value.aspectRatio : 16/9,
                child: VideoPlayer(_videoController!),
              );
            }
            return const Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(_buttonBackgroundColor)));
          },
        );
      } else {
        // Placeholder si algo falla o en web antes de tener bytes
        return _buildPlaceholderPreview("Cargando previsualización de video...");
      }
    } else if (_selectedMediaBytes != null && kIsWeb) {
      return Image.memory(_selectedMediaBytes!, fit: BoxFit.contain);
    } else if (_selectedFile != null && !kIsWeb) {
      return Image.file(_selectedFile!, fit: BoxFit.contain);
    } else {
      // Placeholder inicial para seleccionar media
      return GestureDetector(
        onTap: _showMediaSelectionDialog,
        child: Container(
          color: Colors.white.withOpacity(0.1), // Sutilmente diferente del fondo del form
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset('assets/images/subirfotovideo.png', width: 80, height: 80, fit: BoxFit.contain),
                const SizedBox(height: 10),
                const Text('Agregar foto o video', style: TextStyle(fontFamily: _fontFamily, fontSize: 17, color: _primaryTextColor)),
              ],
            ),
          ),
        ),
      );
    }
  }

  Widget _buildErrorPreview(String message) {
    return Container(
      color: Colors.grey[700], // Más oscuro para errores
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(message, textAlign: TextAlign.center, style: const TextStyle(color: Colors.redAccent, fontFamily: _fontFamily, fontWeight: FontWeight.bold)),
        ),
      ),
    );
  }

  Widget _buildPlaceholderPreview(String message) {
    return Container(
      color: Colors.black26,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.videocam_outlined, size: 50, color: Colors.white70),
              const SizedBox(height: 10),
              Text(message, textAlign: TextAlign.center, style: const TextStyle(color: Colors.white70, fontFamily: _fontFamily)),
            ],
          ),
        ),
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) {
      // Debería ser manejado por un AuthWrapper, pero por si acaso.
      return Scaffold(
        backgroundColor: _scaffoldBgColor,
        body: Center(child: Text("Usuario no autenticado.", style: TextStyle(fontFamily: _fontFamily, color: Colors.white))),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Crear Publicación', style: TextStyle(fontFamily: _fontFamily, color: Colors.white)),
        backgroundColor: _appBarBackgroundColor,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        elevation: 0,
      ),
      backgroundColor: _scaffoldBgColor,
      body: Stack(
        children: <Widget>[
          Positioned.fill(
            child: Image.asset(
              'assets/images/Animal Health Fondo de Pantalla.png',
              fit: BoxFit.cover,
            ),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
              child: Container(
                padding: const EdgeInsets.all(15.0),
                decoration: BoxDecoration(
                  color: _formContainerColor,
                  borderRadius: BorderRadius.circular(20.0),
                  border: Border.all(width: 1.0, color: _primaryTextColor.withOpacity(0.8)),
                ),
                child: SingleChildScrollView(
                  controller: _scrollController,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      StreamBuilder<DocumentSnapshot>(
                        stream: FirebaseFirestore.instance.collection('users').doc(currentUser.uid).snapshots(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return const Row(children: [CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(_buttonBackgroundColor)), SizedBox(width: 10), Text("Cargando usuario...")]);
                          }
                          if (!snapshot.hasData || snapshot.data?.data() == null) {
                            return Text("No se pudo cargar la información del usuario.", style: TextStyle(fontFamily: _fontFamily, color: Colors.red));
                          }

                          final userData = snapshot.data!.data() as Map<String, dynamic>;
                          final profilePhotoUrl = userData['profilePhotoUrl'] as String?;
                          final displayName = userData['nombreUsuario'] ?? userData['name'] ?? 'Usuario';

                          return Row(
                            children: [
                              CircleAvatar(
                                radius: 25,
                                backgroundColor: Colors.grey[300],
                                backgroundImage: profilePhotoUrl != null && profilePhotoUrl.isNotEmpty
                                    ? CachedNetworkImageProvider(profilePhotoUrl)
                                    : null,
                                child: (profilePhotoUrl == null || profilePhotoUrl.isEmpty)
                                    ? const Icon(Icons.person, color: _primaryTextColor, size: 30)
                                    : null,
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      displayName,
                                      style: const TextStyle(fontFamily: _fontFamily, fontSize: 17, fontWeight: FontWeight.bold, color: _primaryTextColor),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    Row(
                                      children: [
                                        Image.asset('assets/images/publico.png', width: 20, height: 20), // Ajustar tamaño si es necesario
                                        const SizedBox(width: 5),
                                        const Text('Público', style: TextStyle(fontFamily: _fontFamily, fontSize: 14, color: _primaryTextColor)),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                      const SizedBox(height: 15),
                      TextField(
                        controller: _captionController,
                        decoration: const InputDecoration(
                          hintText: '¿Qué estás pensando?',
                          border: InputBorder.none,
                          hintStyle: TextStyle(fontFamily: _fontFamily, fontSize: 17, color: _primaryTextColor),
                        ),
                        maxLines: 4,
                        minLines: 1,
                        style: const TextStyle(fontFamily: _fontFamily, fontSize: 17, color: _primaryTextColor),
                      ),
                      const SizedBox(height: 15),
                      AspectRatio(
                        aspectRatio: 16 / 9,
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.05),
                              borderRadius: BorderRadius.circular(15.0),
                              border: Border.all(color: Colors.grey.shade400)
                          ),
                          child: ClipRRect(
                              borderRadius: BorderRadius.circular(14.0),
                              child: _buildMediaPreview()
                          ),
                        ),
                      ),
                      const SizedBox(height: 15),
                      // --- FILA DE BOTONES MODIFICADA ---
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Tooltip(
                            message: "Agregar ubicación",
                            child: IconButton(
                              icon: Image.asset('assets/images/ubicacion.png', width: 50, height: 50),
                              onPressed: _isUploading ? null : () {
                                // Lógica para ubicación
                                developer.log("Botón de Ubicación presionado", name: "CrearPubPerfil.Actions");
                                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Funcionalidad de ubicación no implementada aún.', style: TextStyle(fontFamily: _fontFamily))));
                              },
                            ),
                          ),
                          Tooltip(
                            message: "Agregar GIF",
                            child: IconButton(
                              icon: Image.asset('assets/images/gif.png', width: 50, height: 50),
                              onPressed: _isUploading ? null : () {
                                // Lógica para GIF
                                developer.log("Botón de GIF presionado", name: "CrearPubPerfil.Actions");
                                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Funcionalidad de GIF no implementada aún.', style: TextStyle(fontFamily: _fontFamily))));
                              },
                            ),
                          ),
                          Tooltip(
                            message: "Etiquetar personas",
                            child: IconButton(
                              icon: Image.asset('assets/images/etiqueta.png', width: 50, height: 50),
                              onPressed: _isUploading ? null : () {
                                // Lógica para etiqueta
                                developer.log("Botón de Etiqueta presionado", name: "CrearPubPerfil.Actions");
                                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Funcionalidad de etiquetar no implementada aún.', style: TextStyle(fontFamily: _fontFamily))));
                              },
                            ),
                          ),
                          Tooltip(
                            message: "Seleccionar Foto/Video",
                            child: IconButton(
                              icon: Image.asset('assets/images/subirfotovideo.png', width: 50, height: 50),
                              onPressed: _isUploading ? null : _showMediaSelectionDialog,
                            ),
                          ),
                        ],
                      ),
                      // --- FIN DE FILA DE BOTONES MODIFICADA ---
                      const SizedBox(height: 20),
                      SizedBox(
                        width: double.infinity,
                        height: 50.0,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _buttonBackgroundColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15.0),
                              side: const BorderSide(width: 1.0, color: _primaryTextColor),
                            ),
                            elevation: 3,
                            shadowColor: Colors.black.withOpacity(0.5),
                          ),
                          onPressed: _isUploading ? null : _uploadFile,
                          child: _isUploading
                              ? const CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.white))
                              : const Text(
                            'Publicar',
                            style: TextStyle(fontFamily: _fontFamily, fontSize: 20, color: _primaryTextColor, fontWeight: FontWeight.w700),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}