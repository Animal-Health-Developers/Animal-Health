import 'package:flutter/material.dart';
import 'package:adobe_xd/pinned.dart';
import 'package:adobe_xd/page_link.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:path/path.dart' as path; // Para obtener la extensión del archivo
import 'dart:io'; // Para File
import 'dart:typed_data'; // Para Uint8List (web)
import 'package:flutter/foundation.dart' show kIsWeb; // Para verificar si es web
import './Home.dart';
import './Ayuda.dart';
import './PerfilPublico.dart';
import './Configuracion.dart';
import './ListadeAnimales.dart';
import './CompradeProductos.dart';
import './CuidadosyRecomendaciones.dart';
import './Emergencias.dart';
import './Comunidad.dart';
import 'package:video_player/video_player.dart';
import '../services/auth_service.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:google_generative_ai/google_generative_ai.dart'; // Para Gemini
import 'dart:developer' as developer; // Para logging

// --- CONFIGURACIÓN DE API KEYS ---
const String GEMINI_API_KEY_CREATE_POST = 'AIzaSyAgv8dNt1etzPz8Lnl39e8Seb6N8B3nenc'; // TU API KEY DE GEMINI AQUÍ
// ---------------------------------


class Crearpublicaciones extends StatefulWidget {
  const Crearpublicaciones({required Key key}) : super(key: key);

  @override
  _CrearpublicacionesState createState() => _CrearpublicacionesState();
}

class _CrearpublicacionesState extends State<Crearpublicaciones> {
  final ImagePicker _picker = ImagePicker();
  File? _selectedFile; // Para móvil
  Uint8List? _selectedMediaBytes; // Para web (imágenes y videos)
  String? _fileNameForWeb; // Para obtener la extensión en web
  bool _isUploading = false;
  final TextEditingController _captionController = TextEditingController();
  VideoPlayerController? _videoController;
  Future<void>? _initializeVideoPlayerFuture; // Para el FutureBuilder
  bool _isVideoSelected = false;
  final ScrollController _scrollController = ScrollController();

  // Para la barra de búsqueda con Gemini
  final TextEditingController _searchController = TextEditingController();
  GenerativeModel? _geminiModelSearch;
  bool _isSearchingWithGemini = false;


  @override
  void initState() {
    super.initState();
    _initializeGeminiForSearch();
  }

  void _initializeGeminiForSearch() {
    if (GEMINI_API_KEY_CREATE_POST.isNotEmpty && GEMINI_API_KEY_CREATE_POST != 'TU_API_KEY_DE_GEMINI_AQUI') {
      try {
        _geminiModelSearch = GenerativeModel(
          model: 'gemini-1.5-flash-latest',
          apiKey: GEMINI_API_KEY_CREATE_POST,
        );
        developer.log("Modelo Gemini para búsqueda inicializado en CrearPublicacion.");
      } catch (e) {
        developer.log("Error inicializando modelo Gemini en CrearPublicacion: $e");
      }
    } else {
      developer.log("API Key de Gemini no configurada en CrearPublicacion. La búsqueda con IA no funcionará.");
    }
  }

  Future<void> _performSearchWithGemini(String query) async {
    if (query.isEmpty) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Por favor, ingresa un término de búsqueda')),
        );
      }
      return;
    }
    if (_geminiModelSearch == null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('La búsqueda con IA no está disponible.')),
        );
      }
      return;
    }
    if (mounted) {
      setState(() { _isSearchingWithGemini = true; });
    }
    try {
      final prompt = 'Busca información o ideas relacionadas con mascotas sobre: "$query" para inspirar una publicación. Proporciona una breve sugerencia o dato curioso.';
      final content = [Content.text(prompt)];
      final response = await _geminiModelSearch!.generateContent(content).timeout(const Duration(seconds: 20));
      developer.log("Respuesta de Gemini para búsqueda en CrearPublicacion '$query': ${response.text}");
      if (mounted) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Sugerencia para: $query'),
              content: SingleChildScrollView(child: Text(response.text ?? 'No se encontró información relevante.')),
              actions: <Widget>[
                TextButton(child: const Text('Cerrar'), onPressed: () => Navigator.of(context).pop()),
              ],
            );
          },
        );
      }
    } catch (e) {
      developer.log("Error al buscar en CrearPublicacion con Gemini: $e");
      String errorMessageText = "Hubo un problema al realizar la búsqueda.";
      if (e is GenerativeAIException) {
        if (e.message.contains('API key not valid')) {
          errorMessageText = "Error: La API Key de Gemini no es válida.";
        } else if (e.message.contains('quota')) {
          errorMessageText = "Cuota de API de Gemini alcanzada.";
        } else if (e.message.contains('not found for API version v1') || e.message.contains('not supported for generateContent')) {
          errorMessageText = "Error: El modelo de IA no es compatible.";
        }
      } else if (e.toString().contains('timeout')) {
        errorMessageText = "La búsqueda tardó demasiado.";
      }
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(errorMessageText)));
      }
    } finally {
      if (mounted) { setState(() { _isSearchingWithGemini = false; }); }
    }
  }


  @override
  void dispose() {
    _captionController.dispose();
    _videoController?.dispose();
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    try {
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery, imageQuality: 85);
      if (image == null) return;

      await _videoController?.dispose();
      _videoController = null;
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
      developer.log("Error al seleccionar imagen: $e");
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error al seleccionar imagen: $e')));
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
      developer.log("Error al seleccionar video: $e");
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error al seleccionar video: $e')));
      }
    }
  }

  Future<void> _initializeVideoPlayerController(File videoFile) async {
    _videoController = VideoPlayerController.file(videoFile);
    _initializeVideoPlayerFuture = _videoController!.initialize().then((_) {
      if (mounted) {
        setState(() {});
      }
    }).catchError((error) {
      developer.log("Error inicializando VideoPlayer: $error");
      if (mounted) {
        setState(() {
          _videoController = null;
          _isVideoSelected = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al cargar la vista previa del video: $error')),
        );
      }
    });
    if (mounted) setState(() {});
  }


  Future<void> _guardarPublicacionEnFirestore(String mediaUrl, bool esVideo) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Usuario no autenticado')));
        return;
      }

      final userDoc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
      final userData = userDoc.data() ?? {};

      await FirebaseFirestore.instance.collection('publicaciones').add({
        'usuarioId': user.uid,
        'usuarioNombre': userData['displayName']?.toString() ?? user.displayName ?? 'Usuario Anónimo',
        'usuarioFoto': userData['profilePhotoUrl']?.toString() ?? '',
        'imagenUrl': mediaUrl,
        'esVideo': esVideo,
        'caption': _captionController.text,
        'fecha': Timestamp.now(),
        'likes': 0,
        "likedBy": [],
        'comentarios': 0,
        'tipoPublicacion': 'Público',
      });
    } catch (e) {
      developer.log("Error al guardar publicación en Firestore: $e");
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error al guardar publicación: $e')));
      rethrow;
    }
  }

  Future<void> _uploadFile() async {
    if ((_selectedFile == null && _selectedMediaBytes == null)) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Por favor selecciona un archivo')));
      return;
    }

    if (mounted) setState(() => _isUploading = true);

    try {
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      String extension;
      String contentType;

      if (kIsWeb) {
        if (_fileNameForWeb == null) throw 'Nombre de archivo no disponible para web.';
        extension = path.extension(_fileNameForWeb!).toLowerCase();
      } else {
        if (_selectedFile == null) throw 'Archivo no seleccionado para móvil.';
        extension = path.extension(_selectedFile!.path).toLowerCase();
      }

      bool currentIsVideo = _isVideoSelected;

      if (currentIsVideo) {
        if (!['.mp4', '.mov', '.avi', '.mkv'].contains(extension)) {
          throw 'Formato de video no soportado. Usa MP4, MOV, AVI, MKV.';
        }
        contentType = 'video/${extension.substring(1)}';
      } else {
        if (!['.jpg', '.jpeg', '.png', '.gif'].contains(extension)) {
          throw 'Formato de imagen no soportado. Usa JPG, JPEG, PNG, GIF.';
        }
        contentType = 'image/${extension == '.jpg' ? 'jpeg' : extension.substring(1)}';
      }


      final storageRef = FirebaseStorage.instance.ref();
      final fileRef = storageRef.child('publicaciones/$timestamp$extension');
      final metadata = SettableMetadata(contentType: contentType);
      UploadTask uploadTask;

      if (kIsWeb) {
        if (_selectedMediaBytes == null) throw 'Bytes no disponibles para subida web.';
        uploadTask = fileRef.putData(_selectedMediaBytes!, metadata);
      } else {
        if (_selectedFile == null) throw 'Archivo no seleccionado para subida móvil.';
        uploadTask = fileRef.putFile(_selectedFile!, metadata);
      }

      final snapshot = await uploadTask.whenComplete(() {});
      final downloadUrl = await snapshot.ref.getDownloadURL();

      await _guardarPublicacionEnFirestore(downloadUrl, currentIsVideo);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Publicación creada exitosamente!'), backgroundColor: Colors.green),
        );
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
        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const Home(key: Key('Home'))));
      }
    } catch (e) {
      developer.log("Error al subir archivo: $e");
      if (mounted) {
        setState(() => _isUploading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al subir archivo: ${e.toString()}'), backgroundColor: Colors.red),
        );
      }
    }
  }

  void _showMediaSelectionDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Seleccionar medio', style: TextStyle(fontFamily: 'Comic Sans MS')),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                GestureDetector(
                  child: const Text('Galería de fotos', style: TextStyle(fontFamily: 'Comic Sans MS', fontSize: 18)),
                  onTap: () { Navigator.of(context).pop(); _pickImage(); },
                ),
                const Padding(padding: EdgeInsets.all(12.0)),
                GestureDetector(
                  child: const Text('Galería de videos', style: TextStyle(fontFamily: 'Comic Sans MS', fontSize: 18)),
                  onTap: () { Navigator.of(context).pop(); _pickVideo(); },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildMediaPreview() {
    if (_isVideoSelected) {
      if (_videoController != null && _videoController!.value.isInitialized) {
        return AspectRatio(
          aspectRatio: _videoController!.value.aspectRatio,
          child: VideoPlayer(_videoController!),
        );
      } else if (_initializeVideoPlayerFuture != null) {
        return FutureBuilder(
          future: _initializeVideoPlayerFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasError || _videoController == null || !_videoController!.value.isInitialized) {
                return _buildErrorPreview("Error al cargar vista previa del video.");
              }
              return AspectRatio(
                aspectRatio: _videoController!.value.aspectRatio,
                child: VideoPlayer(_videoController!),
              );
            }
            return const Center(child: CircularProgressIndicator());
          },
        );
      } else if (kIsWeb && _selectedMediaBytes != null) {
        return _buildPlaceholderPreview("Video seleccionado (vista previa no disponible para web antes de subir).");
      }
      else {
        return _buildErrorPreview("Error al seleccionar el video.");
      }
    } else if (_selectedMediaBytes != null && kIsWeb) {
      return Image.memory(_selectedMediaBytes!, fit: BoxFit.contain);
    } else if (_selectedFile != null && !kIsWeb) {
      return Image.file(_selectedFile!, fit: BoxFit.contain);
    } else {
      return Tooltip( // <--- Tooltip para el botón de seleccionar medio
        message: 'Seleccionar foto o video de la galería',
        child: GestureDetector(
          onTap: _showMediaSelectionDialog,
          child: Container(
            color: Colors.white.withOpacity(0.3),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 100.0,
                    height: 100.0,
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/images/subirfotovideo.png'),
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text('Agregar fotos/videos', style: TextStyle(fontFamily: 'Comic Sans MS', fontSize: 17, color: Color(0xff000000))),
                ],
              ),
            ),
          ),
        ),
      );
    }
  }

  Widget _buildErrorPreview(String message) {
    return Container(
      color: Colors.grey[300],
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(message, textAlign: TextAlign.center, style: const TextStyle(color: Colors.red, fontFamily: 'Comic Sans MS')),
        ),
      ),
    );
  }
  Widget _buildPlaceholderPreview(String message) {
    return Container(
      color: Colors.grey[300],
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.videocam_off, size: 50, color: Colors.black54),
              const SizedBox(height: 10),
              Text(message, textAlign: TextAlign.center, style: const TextStyle(color: Colors.black54, fontFamily: 'Comic Sans MS')),
            ],
          ),
        ),
      ),
    );
  }

  // Método para construir los items de la barra de navegación
  Widget _buildNavigationButtonItem({
    required String imagePath,
    required String label, // <--- Nuevo parámetro para el tooltip
    bool isHighlighted = false,
    double? fixedWidth,
    double height = 60.0,
  }) {
    double itemWidth;
    if (fixedWidth != null) {
      itemWidth = fixedWidth;
    } else {
      if (imagePath.contains('noticias')) {
        itemWidth = 54.3;
      } else if (imagePath.contains('cuidadosrecomendaciones')) itemWidth = 63.0;
      else if (imagePath.contains('emergencias')) itemWidth = 65.0;
      else if (imagePath.contains('comunidad')) itemWidth = 67.0;
      else if (imagePath.contains('crearpublicacion')) itemWidth = 53.6;
      else itemWidth = 60.0;
    }

    return Tooltip( // <--- ENVOLVER CON TOOLTIP
      message: label,
      child: Container(
        width: itemWidth,
        height: height,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(imagePath),
            fit: BoxFit.fill,
          ),
          boxShadow: isHighlighted
              ? const [BoxShadow(color: Color(0xff9decf9), offset: Offset(0, 3), blurRadius: 6)]
              : null,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const double navBarTopPosition = 200.0;
    const double navBarHeight = 60.0;
    const double spaceBelowNavBar = 20.0;
    final double topOffsetForContentBlock = navBarTopPosition + navBarHeight + spaceBelowNavBar;

    return Scaffold(
      backgroundColor: const Color(0xff4ec8dd),
      body: Stack(
        children: <Widget>[
          Positioned.fill(
            child: Image.asset(
              'assets/images/Animal Health Fondo de Pantalla.png',
              fit: BoxFit.cover,
            ),
          ),
          // Logo (Ir a Inicio)
          Pinned.fromPins(
            Pin(size: 74.0, middle: 0.5),
            Pin(size: 73.0, start: 42.0),
            child: Tooltip( // <--- Tooltip agregado
              message: 'Ir a Inicio',
              child: PageLink(
                links: [PageLinkInfo(pageBuilder: () => const Home(key: Key('Home')))],
                child: Container(
                  decoration: BoxDecoration(
                    image: const DecorationImage(image: AssetImage('assets/images/logo.png'), fit: BoxFit.cover),
                    borderRadius: BorderRadius.circular(15.0),
                    border: Border.all(width: 1.0, color: const Color(0xff000000)),
                  ),
                ),
              ),
            ),
          ),
          // Botón de ayuda
          Pinned.fromPins(
            Pin(size: 40.5, middle: 0.8328),
            Pin(size: 50.0, start: 49.0),
            child: Tooltip( // <--- Tooltip agregado
              message: 'Ayuda',
              child: PageLink(
                links: [PageLinkInfo(pageBuilder: () => const Ayuda(key: Key('Ayuda')))],
                child: Container(
                  decoration: const BoxDecoration(
                    image: DecorationImage(image: AssetImage('assets/images/help.png'), fit: BoxFit.fill),
                  ),
                ),
              ),
            ),
          ),
          // BARRA DE BÚSQUEDA FUNCIONAL
          Pinned.fromPins(
            Pin(size: 307.0, middle: 0.5),
            Pin(size: 45.0, start: 150.0), // Posición consistente
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xffffffff),
                borderRadius: BorderRadius.circular(5.0),
                border: Border.all(width: 1.0, color: const Color(0xff707070)),
              ),
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Image.asset('assets/images/busqueda1.png', width: 24.0, height: 24.0),
                  ),
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      style: const TextStyle(fontFamily: 'Comic Sans MS', fontSize: 18, color: Color(0xff000000)),
                      decoration: const InputDecoration(
                        hintText: 'Buscar ideas...',
                        hintStyle: TextStyle(fontFamily: 'Comic Sans MS', fontSize: 18, color: Colors.grey),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(vertical: 12.0),
                      ),
                      textInputAction: TextInputAction.search,
                      onSubmitted: (value) { if (!_isSearchingWithGemini) _performSearchWithGemini(value); },
                    ),
                  ),
                  if (_isSearchingWithGemini)
                    const Padding(padding: EdgeInsets.all(8.0), child: SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2.0)))
                  else
                    Tooltip( // <--- Tooltip para el icono de búsqueda en el TextField
                      message: 'Buscar ideas con IA',
                      child: IconButton(icon: const Icon(Icons.search, color: Colors.black54), onPressed: () { if (!_isSearchingWithGemini) _performSearchWithGemini(_searchController.text); }),
                    ),
                ],
              ),
            ),
          ),
          // Mini foto de perfil (Ver mi perfil)
          Pinned.fromPins(
            Pin(size: 60.0, start: 6.0),
            Pin(size: 60.0, middle: 0.1947),
            child: StreamBuilder<DocumentSnapshot>(
              stream: FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser?.uid).snapshots(),
              builder: (context, snapshot) {
                final profilePhotoUrl = snapshot.data?['profilePhotoUrl'] as String?;
                return Tooltip( // <--- Tooltip agregado
                  message: 'Ver mi perfil',
                  child: PageLink(
                    links: [PageLinkInfo(pageBuilder: () => PerfilPublico(key: const Key('PerfilPublico')))],
                    child: Container(
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(10.0), color: Colors.grey[200]),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10.0),
                        child: profilePhotoUrl != null && profilePhotoUrl.isNotEmpty
                            ? CachedNetworkImage(
                          imageUrl: profilePhotoUrl,
                          fit: BoxFit.cover,
                          placeholder: (context, url) => const Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Color(0xff4ec8dd)))),
                          errorWidget: (context, url, error) => const Icon(Icons.person, size: 30, color: Colors.grey),
                        )
                            : const Icon(Icons.person, size: 30, color: Colors.grey),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          // Botón de configuración
          Pinned.fromPins(
            Pin(size: 47.2, end: 7.6),
            Pin(size: 50.0, start: 49.0),
            child: Tooltip( // <--- Tooltip agregado
              message: 'Configuración',
              child: PageLink(
                links: [PageLinkInfo(pageBuilder: () => Configuraciones(key: const Key('Settings'), authService: AuthService()))],
                child: Container(decoration: const BoxDecoration(image: DecorationImage(image: AssetImage('assets/images/settingsbutton.png'), fit: BoxFit.fill))),
              ),
            ),
          ),
          // Botón de lista de animales
          Pinned.fromPins(
            Pin(size: 60.1, start: 6.0),
            Pin(size: 60.0, start: 44.0),
            child: Tooltip( // <--- Tooltip agregado
              message: 'Mi lista de animales',
              child: PageLink(
                links: [PageLinkInfo(pageBuilder: () => ListadeAnimales(key: const Key('ListadeAnimales')))],
                child: Container(decoration: const BoxDecoration(image: DecorationImage(image: AssetImage('assets/images/listaanimales.png'), fit: BoxFit.fill))),
              ),
            ),
          ),
          // Botón de tienda
          Pinned.fromPins(
            Pin(size: 58.5, end: 2.0),
            Pin(size: 60.0, start: 105.0),
            child: Tooltip( // <--- Tooltip agregado
              message: 'Tienda de productos',
              child: PageLink(
                links: [PageLinkInfo(pageBuilder: () => CompradeProductos(key: const Key('CompradeProductos')))],
                child: Container(decoration: const BoxDecoration(image: DecorationImage(image: AssetImage('assets/images/store.png'), fit: BoxFit.fill))),
              ),
            ),
          ),

          // --- SECCIÓN DE BOTONES DE NAVEGACIÓN ---
          Positioned(
            top: navBarTopPosition,
            left: 16.0,
            right: 16.0,
            height: navBarHeight,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                PageLink(
                  links: [PageLinkInfo(pageBuilder: () => Home(key: const Key('Home')))],
                  child: _buildNavigationButtonItem(
                    imagePath: 'assets/images/noticias.png',
                    label: 'Noticias y Novedades', // <--- Label para Tooltip
                    fixedWidth: 54.3,
                  ),
                ),
                PageLink(
                  links: [PageLinkInfo(pageBuilder: () => CuidadosyRecomendaciones(key: const Key('CuidadosyRecomendaciones')))],
                  child: _buildNavigationButtonItem(
                    imagePath: 'assets/images/cuidadosrecomendaciones.png',
                    label: 'Cuidados y Recomendaciones', // <--- Label para Tooltip
                    fixedWidth: 63.0,
                  ),
                ),
                PageLink(
                  links: [PageLinkInfo(pageBuilder: () => Emergencias(key: const Key('Emergencias')))],
                  child: _buildNavigationButtonItem(
                    imagePath: 'assets/images/emergencias.png',
                    label: 'Emergencias', // <--- Label para Tooltip
                    fixedWidth: 65.0,
                  ),
                ),
                PageLink(
                  links: [PageLinkInfo(pageBuilder: () => Comunidad(key: const Key('Comunidad')))],
                  child: _buildNavigationButtonItem(
                    imagePath: 'assets/images/comunidad.png',
                    label: 'Comunidad', // <--- Label para Tooltip
                    fixedWidth: 67.0,
                  ),
                ),
                _buildNavigationButtonItem( // Botón de Crear Publicación (resaltado)
                  imagePath: 'assets/images/crearpublicacion.png',
                  label: 'Crear Publicación', // <--- Label para Tooltip
                  isHighlighted: true,
                  fixedWidth: 53.6,
                ),
              ],
            ),
          ),
          // --- FIN DE SECCIÓN DE BOTONES DE NAVEGACIÓN ---

          // Sección desplazable de creación de publicaciones
          Positioned(
            top: topOffsetForContentBlock, // Debajo de la barra de navegación
            left: 16.0,
            right: 15.0,
            bottom: 20.0,
            child: Container(
              padding: const EdgeInsets.all(15.0),
              decoration: BoxDecoration(
                color: const Color(0xe3a0f4fe),
                borderRadius: BorderRadius.circular(20.0),
                border: Border.all(width: 1.0, color: const Color(0xe3000000)),
              ),
              child: SingleChildScrollView(
                controller: _scrollController,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    StreamBuilder<DocumentSnapshot>(
                      stream: FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser?.uid).snapshots(),
                      builder: (context, snapshot) {
                        final userData = snapshot.data?.data() as Map<String, dynamic>? ?? {};
                        final profilePhotoUrl = userData['profilePhotoUrl'] as String?;
                        final displayName = userData['displayName'] as String? ?? FirebaseAuth.instance.currentUser?.displayName ?? 'Usuario Anónimo';
                        return Row(
                          children: [
                            Tooltip( // <--- Tooltip para la foto de perfil del usuario que crea la publicación
                              message: 'Tu perfil',
                              child: CircleAvatar(
                                radius: 25,
                                backgroundColor: Colors.grey[300],
                                backgroundImage: profilePhotoUrl != null && profilePhotoUrl.isNotEmpty ? CachedNetworkImageProvider(profilePhotoUrl) : null,
                                onBackgroundImageError: profilePhotoUrl != null && profilePhotoUrl.isNotEmpty ? (e, s) => developer.log('Error cargando imagen de perfil: $e') : null,
                                child: profilePhotoUrl == null || profilePhotoUrl.isEmpty ? const Icon(Icons.person, color: Colors.white, size: 30) : null,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(displayName, style: const TextStyle(fontFamily: 'Comic Sans MS', fontSize: 17, fontWeight: FontWeight.bold)),
                                Row(
                                  children: [
                                    Tooltip( // <--- Tooltip para el icono de público
                                      message: 'Esta publicación será pública',
                                      child: Image.asset('assets/images/publico.png', width: 35, height: 35),
                                    ),
                                    const SizedBox(width: 5),
                                    const Text('Público', style: TextStyle(fontFamily: 'Comic Sans MS', fontSize: 14)),
                                  ],
                                ),
                              ],
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
                        hintStyle: TextStyle(fontFamily: 'Comic Sans MS', fontSize: 17, color: Color(0xff000000)),
                      ),
                      maxLines: 4,
                      minLines: 1,
                      style: const TextStyle(fontFamily: 'Comic Sans MS', fontSize: 17, color: Color(0xff000000)),
                    ),
                    const SizedBox(height: 15),
                    AspectRatio(
                      aspectRatio: 16 / 9,
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.black12,
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Tooltip( // <--- Tooltip para el icono de ubicación
                          message: 'Añadir ubicación',
                          child: IconButton(icon: Image.asset('assets/images/ubicacion.png', width: 50, height: 50), onPressed: () { /* Lógica ubicación */ }),
                        ),
                        Tooltip( // <--- Tooltip para el icono de GIF
                          message: 'Añadir GIF',
                          child: IconButton(icon: Image.asset('assets/images/gif.png', width: 50, height: 50), onPressed: () { /* Lógica GIF */ }),
                        ),
                        Tooltip( // <--- Tooltip para el icono de etiqueta
                          message: 'Etiquetar amigos',
                          child: IconButton(icon: Image.asset('assets/images/etiqueta.png', width: 50, height: 50), onPressed: () { /* Lógica etiqueta */ }),
                        ),
                        // Este ya tenía Tooltip, lo mantengo con el mensaje más específico
                        Tooltip(message: "Seleccionar Foto/Video", child: IconButton(icon: Image.asset('assets/images/subirfotovideo.png', width: 50, height: 50), onPressed: _showMediaSelectionDialog)),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Tooltip( // <--- Tooltip para el botón "Publicar"
                      message: 'Crea tu publicación',
                      child: SizedBox(
                        width: double.infinity,
                        height: 50.0,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xff4ec8dd),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15.0),
                              side: const BorderSide(width: 1.0, color: Color(0xff000000)),
                            ),
                            elevation: 3,
                            shadowColor: const Color(0xff000000),
                          ),
                          onPressed: _isUploading ? null : _uploadFile,
                          child: _isUploading
                              ? const CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.white))
                              : const Text(
                            'Publicar',
                            style: TextStyle(fontFamily: 'Comic Sans MS', fontSize: 20, color: Color(0xff000000), fontWeight: FontWeight.w700),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}