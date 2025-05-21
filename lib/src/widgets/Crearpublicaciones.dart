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
    _searchController.dispose(); // No olvidar el dispose del nuevo controller
    super.dispose();
  }

  Future<void> _pickImage() async {
    try {
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery, imageQuality: 85);
      if (image == null) return;

      await _videoController?.dispose(); // Dispose video controller if any
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
      _isVideoSelected = true; // Marcar que un video fue seleccionado

      if (kIsWeb) {
        final bytes = await video.readAsBytes();
        if (mounted) {
          setState(() {
            _selectedMediaBytes = bytes;
            _selectedFile = null;
            _fileNameForWeb = video.name;
            // Para web, la vista previa de video con Uint8List es compleja.
            // Podríamos mostrar un ícono o un mensaje "Video seleccionado".
            // O intentar crear un Object URL si el navegador lo permite (más avanzado).
            // Por ahora, solo almacenamos los bytes y el nombre.
            // La inicialización real del VideoPlayer para web se haría desde la URL después de subirlo.
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
        setState(() {}); // Actualiza la UI para mostrar el reproductor
      }
    }).catchError((error) {
      developer.log("Error inicializando VideoPlayer: $error");
      if (mounted) {
        setState(() { // Marcar que hubo un error para mostrar un mensaje
          _videoController = null;
          _isVideoSelected = false; // Resetear si falla
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al cargar la vista previa del video: $error')),
        );
      }
    });
    if (mounted) setState(() {}); // Para mostrar el CircularProgressIndicator mientras inicializa
  }


  Future<void> _guardarPublicacionEnFirestore(String mediaUrl, bool esVideo) async { // Añadido parámetro esVideo
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Usuario no autenticado')));
        return;
      }

      final userDoc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
      final userData = userDoc.data() as Map<String, dynamic>? ?? {};

      await FirebaseFirestore.instance.collection('publicaciones').add({
        'usuarioId': user.uid,
        'usuarioNombre': userData['displayName']?.toString() ?? user.displayName ?? 'Usuario Anónimo',
        'usuarioFoto': userData['profilePhotoUrl']?.toString() ?? '',
        'imagenUrl': mediaUrl,
        'esVideo': esVideo, // Usar el parámetro
        'caption': _captionController.text,
        'fecha': Timestamp.now(),
        'likes': 0,
        "likedBy": [],
        'comentarios': 0,
        // 'compartir': 0, // Campo no usado en la UI de Home, se puede omitir o añadir si es necesario
        'tipoPublicacion': 'Público', // Asumiendo que siempre es público por ahora
      });
    } catch (e) {
      developer.log("Error al guardar publicación en Firestore: $e");
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error al guardar publicación: $e')));
      rethrow;
    }
  }

  Future<void> _uploadFile() async {
    if ((_selectedFile == null && _selectedMediaBytes == null)) { // Ya no se requiere caption obligatoriamente
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

      bool currentIsVideo = _isVideoSelected; // Usar el estado _isVideoSelected

      if (currentIsVideo) {
        if (!['.mp4', '.mov', '.avi', '.mkv'].contains(extension)) { // Ampliar formatos de video comunes
          throw 'Formato de video no soportado. Usa MP4, MOV, AVI, MKV.';
        }
        contentType = 'video/$extension.substring(1)'; // ej: video/mp4
      } else {
        if (!['.jpg', '.jpeg', '.png', '.gif'].contains(extension)) {
          throw 'Formato de imagen no soportado. Usa JPG, JPEG, PNG, GIF.';
        }
        contentType = 'image/${extension == '.jpg' ? 'jpeg' : extension.substring(1)}'; // ej: image/png, image/jpeg
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
                const Padding(padding: EdgeInsets.all(12.0)), // Aumentado padding
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
        // Muestra un indicador de carga mientras el video se inicializa
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
        // Para web, si es video y no hay controller, mostrar un placeholder
        return _buildPlaceholderPreview("Video seleccionado (vista previa no disponible para web antes de subir).");
      }
      else {
        // Si es video pero no hay controller ni future (podría ser un error de selección)
        return _buildErrorPreview("Error al seleccionar el video.");
      }
    } else if (_selectedMediaBytes != null && kIsWeb) { // Imagen en Web
      return Image.memory(_selectedMediaBytes!, fit: BoxFit.contain);
    } else if (_selectedFile != null && !kIsWeb) { // Imagen en Móvil
      return Image.file(_selectedFile!, fit: BoxFit.contain);
    } else { // Placeholder para seleccionar archivo
      return GestureDetector(
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


  @override
  Widget build(BuildContext context) {
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
          Pinned.fromPins(
            Pin(size: 74.0, middle: 0.5),
            Pin(size: 73.0, start: 42.0),
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
          Pinned.fromPins(
            Pin(size: 40.5, middle: 0.8328),
            Pin(size: 50.0, start: 49.0),
            child: PageLink(
              links: [PageLinkInfo(pageBuilder: () => const Ayuda(key: Key('Ayuda')))],
              child: Container(
                decoration: const BoxDecoration(
                  image: DecorationImage(image: AssetImage('assets/images/help.png'), fit: BoxFit.fill),
                ),
              ),
            ),
          ),
          // BARRA DE BÚSQUEDA FUNCIONAL
          Pinned.fromPins(
            Pin(size: 307.0, middle: 0.5), // CENTRADO
            Pin(size: 45.0, middle: 0.1995),
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
                        contentPadding: EdgeInsets.only(left: 4, right: 4, top: 12, bottom: 12),
                      ),
                      textInputAction: TextInputAction.search,
                      onSubmitted: (value) { if (!_isSearchingWithGemini) _performSearchWithGemini(value); },
                    ),
                  ),
                  if (_isSearchingWithGemini)
                    const Padding(padding: EdgeInsets.all(8.0), child: SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2.0)))
                  else
                    IconButton(icon: const Icon(Icons.search, color: Colors.black54), onPressed: () { if (!_isSearchingWithGemini) _performSearchWithGemini(_searchController.text); }),
                ],
              ),
            ),
          ),
          Pinned.fromPins(
            Pin(size: 60.0, start: 6.0),
            Pin(size: 60.0, middle: 0.1947),
            child: StreamBuilder<DocumentSnapshot>(
              stream: FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser?.uid).snapshots(),
              builder: (context, snapshot) {
                final profilePhotoUrl = snapshot.data?['profilePhotoUrl'] as String?;
                return PageLink(
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
                );
              },
            ),
          ),
          Pinned.fromPins(
            Pin(size: 47.2, end: 7.6),
            Pin(size: 50.0, start: 49.0),
            child: PageLink(
              links: [PageLinkInfo(pageBuilder: () => Configuraciones(key: const Key('Settings'), authService: AuthService()))],
              child: Container(decoration: const BoxDecoration(image: DecorationImage(image: AssetImage('assets/images/settingsbutton.png'), fit: BoxFit.fill))),
            ),
          ),
          Pinned.fromPins(
            Pin(size: 60.1, start: 6.0),
            Pin(size: 60.0, start: 44.0),
            child: PageLink(
              links: [PageLinkInfo(pageBuilder: () => ListadeAnimales(key: const Key('ListadeAnimales')))],
              child: Container(decoration: const BoxDecoration(image: DecorationImage(image: AssetImage('assets/images/listaanimales.png'), fit: BoxFit.fill))),
            ),
          ),
          Pinned.fromPins(
            Pin(size: 58.5, end: 2.0),
            Pin(size: 60.0, start: 105.0),
            child: PageLink(
              links: [PageLinkInfo(pageBuilder: () => CompradeProductos(key: const Key('CompradeProductos')))],
              child: Container(decoration: const BoxDecoration(image: DecorationImage(image: AssetImage('assets/images/store.png'), fit: BoxFit.fill))),
            ),
          ),
          Pinned.fromPins(
            Pin(size: 54.3, start: 24.0),
            Pin(size: 60.0, middle: 0.2712),
            child: PageLink(
              links: [PageLinkInfo(pageBuilder: () => Home(key: const Key('Home')))],
              child: Container(decoration: const BoxDecoration(image: DecorationImage(image: AssetImage('assets/images/noticias.png'), fit: BoxFit.fill))),
            ),
          ),
          Align(
            alignment: const Alignment(-0.459, -0.458),
            child: PageLink(
              links: [PageLinkInfo(pageBuilder: () => CuidadosyRecomendaciones(key: const Key('CuidadosyRecomendaciones')))],
              child: Container(width: 63.0, height: 60.0, decoration: const BoxDecoration(image: DecorationImage(image: AssetImage('assets/images/cuidadosrecomendaciones.png'), fit: BoxFit.fill))),
            ),
          ),
          Align(
            alignment: const Alignment(0.0, -0.458),
            child: PageLink(
              links: [PageLinkInfo(pageBuilder: () => Emergencias(key: const Key('Emergencias')))],
              child: Container(width: 65.0, height: 60.0, decoration: const BoxDecoration(image: DecorationImage(image: AssetImage('assets/images/emergencias.png'), fit: BoxFit.fill))),
            ),
          ),
          Align(
            alignment: const Alignment(0.477, -0.458),
            child: PageLink(
              links: [PageLinkInfo(pageBuilder: () => Comunidad(key: const Key('Comunidad')))],
              child: Container(width: 67.0, height: 60.0, decoration: const BoxDecoration(image: DecorationImage(image: AssetImage('assets/images/comunidad.png'), fit: BoxFit.fill))),
            ),
          ),
          Pinned.fromPins(
            Pin(size: 53.6, end: 20.3),
            Pin(size: 60.0, middle: 0.2712),
            child: Container(
              decoration: BoxDecoration(
                image: const DecorationImage(image: AssetImage('assets/images/crearpublicacion.png'), fit: BoxFit.fill),
                boxShadow: const [BoxShadow(color: Color(0xff9decf9), offset: Offset(0, 3), blurRadius: 6)],
              ),
            ),
          ),
          // Sección desplazable de creación de publicaciones
          Positioned( // Usar Positioned para un control más preciso
            top: MediaQuery.of(context).size.height * 0.2712 + 60 + 20, // Debajo de la barra de navegación
            left: 16.0,
            right: 15.0,
            bottom: 20.0, // Espacio en la parte inferior
            child: Container(
              padding: const EdgeInsets.all(15.0),
              decoration: BoxDecoration(
                color: const Color(0xe3a0f4fe), // Color de fondo del SVG
                borderRadius: BorderRadius.circular(20.0), // Coincidir con el radio del SVG
                border: Border.all(width: 1.0, color: const Color(0xe3000000)),
              ),
              child: SingleChildScrollView( // Para permitir scroll si el contenido es mucho
                controller: _scrollController,
                child: Column( // Usar Column para organizar los elementos
                  mainAxisSize: MainAxisSize.min, // Para que la columna no ocupe más de lo necesario
                  children: <Widget>[
                    // Encabezado con foto de perfil y nombre
                    StreamBuilder<DocumentSnapshot>(
                      stream: FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser?.uid).snapshots(),
                      builder: (context, snapshot) {
                        final userData = snapshot.data?.data() as Map<String, dynamic>? ?? {};
                        final profilePhotoUrl = userData['profilePhotoUrl'] as String?;
                        final displayName = userData['displayName'] as String? ?? FirebaseAuth.instance.currentUser?.displayName ?? 'Usuario Anónimo';
                        return Row(
                          children: [
                            CircleAvatar(
                              radius: 25, // Un poco más grande
                              backgroundColor: Colors.grey[300],
                              backgroundImage: profilePhotoUrl != null && profilePhotoUrl.isNotEmpty ? NetworkImage(profilePhotoUrl) : null,
                              child: profilePhotoUrl == null || profilePhotoUrl.isEmpty ? const Icon(Icons.person, color: Colors.white, size: 30) : null,
                            ),
                            const SizedBox(width: 12),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(displayName, style: const TextStyle(fontFamily: 'Comic Sans MS', fontSize: 17, fontWeight: FontWeight.bold)),
                                Row(
                                  children: [
                                    Image.asset('assets/images/publico.png', width: 20, height: 20), // Ajustar tamaño
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
                    // Campo de texto para el caption
                    TextField(
                      controller: _captionController,
                      decoration: const InputDecoration(
                        hintText: '¿Qué estás pensando?',
                        border: InputBorder.none,
                        hintStyle: TextStyle(fontFamily: 'Comic Sans MS', fontSize: 17, color: Color(0xff000000)),
                      ),
                      maxLines: 4, // Permitir más líneas para el caption
                      minLines: 1,
                      style: const TextStyle(fontFamily: 'Comic Sans MS', fontSize: 17, color: Color(0xff000000)),
                    ),
                    const SizedBox(height: 15),
                    // Vista previa del medio o botón para seleccionar
                    AspectRatio( // Para mantener una proporción
                      aspectRatio: 16 / 9, // Proporción común para imágenes/videos
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.black12, // Un fondo para el área de vista previa
                            borderRadius: BorderRadius.circular(15.0),
                            border: Border.all(color: Colors.grey.shade400)
                        ),
                        child: ClipRRect(
                            borderRadius: BorderRadius.circular(14.0), // Un pixel menos que el borde del container
                            child: _buildMediaPreview()
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),
                    // Botones de acción (ubicación, gif, etiqueta) - Simplificado
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        IconButton(icon: Image.asset('assets/images/ubicacion.png', width: 50, height: 50), onPressed: () { /* Lógica ubicación */ }),
                        IconButton(icon: Image.asset('assets/images/gif.png', width: 50, height: 50), onPressed: () { /* Lógica GIF */ }),
                        IconButton(icon: Image.asset('assets/images/etiqueta.png', width: 50, height: 50), onPressed: () { /* Lógica etiqueta */ }),
                        IconButton(icon: Image.asset('assets/images/subirfotovideo.png', width: 50, height: 50), tooltip: "Seleccionar Foto/Video", onPressed: _showMediaSelectionDialog),

                      ],
                    ),
                    const SizedBox(height: 20),
                    // Botón de publicar
                    SizedBox(
                      width: double.infinity, // Ocupar todo el ancho
                      height: 50.0,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xff4ec8dd), // Color principal
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
