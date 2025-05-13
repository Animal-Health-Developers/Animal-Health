import 'package:flutter/material.dart';
import 'package:adobe_xd/pinned.dart';
import 'package:adobe_xd/page_link.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:path/path.dart' as path;
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'Home.dart';
import 'Ayuda.dart';
import 'PerfilPublico.dart';
import 'Configuracion.dart';
import 'ListadeAnimales.dart';
import 'CompradeProductos.dart';
import 'CuidadosyRecomendaciones.dart';
import 'Emergencias.dart';
import 'Comunidad.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:video_player/video_player.dart';
import '../services/auth_service.dart';
import 'package:cached_network_image/cached_network_image.dart';

class Crearpublicaciones extends StatefulWidget {
  const Crearpublicaciones({required Key key}) : super(key: key);

  @override
  _CrearpublicacionesState createState() => _CrearpublicacionesState();
}

class _CrearpublicacionesState extends State<Crearpublicaciones> {
  final ImagePicker _picker = ImagePicker();
  File? _selectedFile;
  Uint8List? _selectedImageBytes;
  String? _downloadUrl;
  bool _isUploading = false;
  String? _fileExtension;
  final TextEditingController _captionController = TextEditingController();
  VideoPlayerController? _videoController;
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _captionController.dispose();
    _videoController?.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 85,
      );

      if (image != null) {
        if (kIsWeb) {
          final bytes = await image.readAsBytes();
          setState(() {
            _selectedImageBytes = bytes;
            _selectedFile = null;
            _fileExtension = path.extension(image.name).toLowerCase();
            _videoController?.dispose();
            _videoController = null;
          });
        } else {
          setState(() {
            _selectedFile = File(image.path);
            _selectedImageBytes = null;
            _fileExtension = path.extension(image.path).toLowerCase();
            _videoController?.dispose();
            _videoController = null;
          });
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al seleccionar imagen: $e')),
      );
    }
  }

  Future<void> _pickVideo() async {
    try {
      final XFile? video = await _picker.pickVideo(source: ImageSource.gallery);

      if (video != null) {
        if (kIsWeb) {
          final bytes = await video.readAsBytes();
          setState(() {
            _selectedImageBytes = bytes;
            _selectedFile = null;
            _fileExtension = path.extension(video.name).toLowerCase();
            _initializeVideoController(bytes, isWeb: true);
          });
        } else {
          setState(() {
            _selectedFile = File(video.path);
            _selectedImageBytes = null;
            _fileExtension = path.extension(video.path).toLowerCase();
            _initializeVideoController(_selectedFile!.path);
          });
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al seleccionar video: $e')),
      );
    }
  }

  Future<void> _initializeVideoController(dynamic source, {bool isWeb = false}) async {
    _videoController?.dispose();

    final controller = isWeb
        ? VideoPlayerController.networkUrl(Uri.parse(await _getWebVideoUrl(source)))
        : VideoPlayerController.file(File(source));

    await controller.initialize();
    setState(() {
      _videoController = controller;
    });
  }

  Future<String> _getWebVideoUrl(Uint8List bytes) async {
    return 'https://example.com/temp-video.mp4';
  }

  Future<void> _guardarPublicacionEnFirestore(String mediaUrl) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Usuario no autenticado')),
        );
        return;
      }

      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      await FirebaseFirestore.instance.collection('publicaciones').add({
        'usuarioId': user.uid,
        'usuarioNombre': (userDoc.data())?['displayName']?.toString() ??
            user.displayName ??
            'Usuario Anónimo',
        'usuarioFoto': (userDoc.data())?['profilePhotoUrl']?.toString() ?? '',
        'imagenUrl': mediaUrl,
        'esVideo': _fileExtension == '.mp4' || _fileExtension == '.avi',
        'caption': _captionController.text,
        'fecha': Timestamp.now(),
        'likes': 0,
        "likedBy": [],
        'comentarios': 0,
        'compartir': 0,
        'tipoPublicacion': 'Público',
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al guardar publicación: $e')),
      );
      rethrow;
    }
  }

  Future<void> _uploadFile() async {
    if ((_selectedFile == null && _selectedImageBytes == null) ||
        _captionController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor selecciona un archivo y escribe un mensaje'),
        ),
      );
      return;
    }

    setState(() => _isUploading = true);

    try {
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final extension = _fileExtension ??
          (_selectedFile != null
              ? path.extension(_selectedFile!.path).toLowerCase()
              : '.jpg');

      if (!['.jpg', '.jpeg', '.png', '.mp4', '.gif', '.avi'].contains(extension)) {
        throw 'Formato no soportado. Usa JPG, JPEG, PNG, MP4 o GIF';
      }

      final storageRef = FirebaseStorage.instance.ref();
      final fileRef = storageRef.child('publicaciones/$timestamp$extension');

      final metadata = SettableMetadata(
        contentType: extension == '.png' ? 'image/png' :
        extension == '.jpg' || extension == '.jpeg' ? 'image/jpeg' :
        extension == '.mp4' ? 'video/mp4' :
        extension == '.gif' ? 'image/gif' : 'application/octet-stream',
      );

      final uploadTask = kIsWeb && _selectedImageBytes != null
          ? fileRef.putData(_selectedImageBytes!, metadata)
          : _selectedFile != null
          ? fileRef.putFile(_selectedFile!, metadata)
          : throw 'No hay archivo seleccionado';

      final snapshot = await uploadTask.whenComplete(() {});
      _downloadUrl = await snapshot.ref.getDownloadURL();

      await _guardarPublicacionEnFirestore(_downloadUrl!);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Publicación creada exitosamente!'),
          backgroundColor: Colors.green,
        ),
      );

      setState(() {
        _selectedFile = null;
        _selectedImageBytes = null;
        _captionController.clear();
        _isUploading = false;
        _videoController?.dispose();
        _videoController = null;
      });

      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => Home(key: const Key('Home'))),
      );
    } catch (e) {
      setState(() => _isUploading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error al subir archivo: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _showMediaSelectionDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'Seleccionar medio',
            style: TextStyle(fontFamily: 'Comic Sans MS'),
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                GestureDetector(
                  child: const Text(
                    'Galería de fotos',
                    style: TextStyle(fontFamily: 'Comic Sans MS', fontSize: 18),
                  ),
                  onTap: () {
                    Navigator.of(context).pop();
                    _pickImage();
                  },
                ),
                const Padding(padding: EdgeInsets.all(8.0)),
                GestureDetector(
                  child: const Text(
                    'Galería de videos',
                    style: TextStyle(fontFamily: 'Comic Sans MS', fontSize: 18),
                  ),
                  onTap: () {
                    Navigator.of(context).pop();
                    _pickVideo();
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildMediaPreview() {
    if (_videoController != null && _videoController!.value.isInitialized) {
      return AspectRatio(
        aspectRatio: _videoController!.value.aspectRatio,
        child: VideoPlayer(_videoController!),
      );
    } else if (_selectedFile != null || _selectedImageBytes != null) {
      return kIsWeb
          ? Image.memory(_selectedImageBytes!, fit: BoxFit.cover)
          : Image.file(_selectedFile!, fit: BoxFit.cover);
    } else {
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
                const Text(
                  'Agregar fotos/videos',
                  style: TextStyle(
                    fontFamily: 'Comic Sans MS',
                    fontSize: 17,
                    color: Color(0xff000000),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff4ec8dd),
      body: Stack(
        children: <Widget>[
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/Animal Health Fondo de Pantalla.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Pinned.fromPins(
            Pin(size: 74.0, middle: 0.5),
            Pin(size: 73.0, start: 42.0),
            child: PageLink(
              links: [
                PageLinkInfo(
                  transition: LinkTransition.Fade,
                  ease: Curves.easeOut,
                  duration: 0.3,
                  pageBuilder: () => Home(key: const Key('Home')),
                ),
              ],
              child: Container(
                decoration: BoxDecoration(
                  image: const DecorationImage(
                    image: AssetImage('assets/images/logo.png'),
                    fit: BoxFit.cover,
                  ),
                  borderRadius: BorderRadius.circular(15.0),
                  border: Border.all(
                    width: 1.0,
                    color: const Color(0xff000000),
                  ),
                ),
              ),
            ),
          ),
          Pinned.fromPins(
            Pin(size: 40.5, middle: 0.8328),
            Pin(size: 50.0, start: 49.0),
            child: PageLink(
              links: [
                PageLinkInfo(
                  transition: LinkTransition.Fade,
                  ease: Curves.easeOut,
                  duration: 0.3,
                  pageBuilder: () => Ayuda(key: const Key('Ayuda')),
                ),
              ],
              child: Container(
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/help.png'),
                    fit: BoxFit.fill,
                  ),
                ),
              ),
            ),
          ),
          Pinned.fromPins(
            Pin(size: 307.0, middle: 0.5),
            Pin(size: 45.0, middle: 0.1995),
            child: Stack(
              children: <Widget>[
                Container(
                  decoration: BoxDecoration(
                    color: const Color(0xffffffff),
                    borderRadius: BorderRadius.circular(5.0),
                    border: Border.all(
                      width: 1.0,
                      color: const Color(0xff707070),
                    ),
                  ),
                ),
                Pinned.fromPins(
                  Pin(size: 216.0, end: 40.0),
                  Pin(size: 28.0, middle: 0.4118),
                  child: const Text(
                    '¿Qué estás buscando?',
                    style: TextStyle(
                      fontFamily: 'Comic Sans MS',
                      fontSize: 20,
                      color: Color(0xff000000),
                      fontWeight: FontWeight.w700,
                    ),
                    softWrap: false,
                  ),
                ),
                Pinned.fromPins(
                  Pin(size: 31.0, start: 7.0),
                  Pin(start: 7.0, end: 7.0),
                  child: Container(
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/images/busqueda1.png'),
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Pinned.fromPins(
            Pin(size: 60.0, start: 6.0),
            Pin(size: 60.0, middle: 0.1947),
            child: StreamBuilder<DocumentSnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('users')
                  .doc(FirebaseAuth.instance.currentUser?.uid)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData || !snapshot.data!.exists) {
                  return Center(
                    child: Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        color: Colors.grey[200],
                      ),
                      child: const Icon(Icons.person, size: 30, color: Colors.grey),
                    ),
                  );
                }

                final userData = snapshot.data!.data() as Map<String, dynamic>? ?? {};
                final profilePhotoUrl = userData['profilePhotoUrl'] as String?;

                return PageLink(
                  links: [
                    PageLinkInfo(
                      transition: LinkTransition.Fade,
                      ease: Curves.easeOut,
                      duration: 0.3,
                      pageBuilder: () => PerfilPublico(key: const Key('PerfilPublico')),
                    ),
                  ],
                  child: Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      color: Colors.grey[200],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10.0),
                      child: profilePhotoUrl != null && profilePhotoUrl.isNotEmpty
                          ? CachedNetworkImage(
                        imageUrl: profilePhotoUrl,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => Center(
                          child: Icon(Icons.person, size: 30, color: Colors.grey),
                        ),
                        errorWidget: (context, url, error) => Center(
                          child: Icon(Icons.person, size: 30, color: Colors.grey),
                        ),
                      )
                          : Center(
                        child: Icon(Icons.person, size: 30, color: Colors.grey),
                      ),
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
              links: [
                PageLinkInfo(
                  transition: LinkTransition.Fade,
                  ease: Curves.easeOut,
                  duration: 0.3,
                  pageBuilder: () => Configuraciones(
                    key: const Key('Settings'),
                    authService: AuthService(),
                  ),
                ),
              ],
              child: Container(
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/settingsbutton.png'),
                    fit: BoxFit.fill,
                  ),
                ),
              ),
            ),
          ),
          Pinned.fromPins(
            Pin(size: 60.1, start: 6.0),
            Pin(size: 60.0, start: 44.0),
            child: PageLink(
              links: [
                PageLinkInfo(
                  transition: LinkTransition.Fade,
                  ease: Curves.easeOut,
                  duration: 0.3,
                  pageBuilder: () => ListadeAnimales(key: const Key('ListadeAnimales')),
                ),
              ],
              child: Container(
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/listaanimales.png'),
                    fit: BoxFit.fill,
                  ),
                ),
              ),
            ),
          ),
          Pinned.fromPins(
            Pin(size: 58.5, end: 2.0),
            Pin(size: 60.0, start: 105.0),
            child: PageLink(
              links: [
                PageLinkInfo(
                  transition: LinkTransition.Fade,
                  ease: Curves.easeOut,
                  duration: 0.3,
                  pageBuilder: () => CompradeProductos(key: const Key('CompradeProductos')),
                ),
              ],
              child: Container(
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/store.png'),
                    fit: BoxFit.fill,
                  ),
                ),
              ),
            ),
          ),
          Pinned.fromPins(
            Pin(size: 54.3, start: 24.0),
            Pin(size: 60.0, middle: 0.2712),
            child: PageLink(
              links: [
                PageLinkInfo(
                  transition: LinkTransition.Fade,
                  ease: Curves.easeOut,
                  duration: 0.3,
                  pageBuilder: () => Home(key: const Key('Home')),
                ),
              ],
              child: Container(
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/noticias.png'),
                    fit: BoxFit.fill,
                  ),
                ),
              ),
            ),
          ),
          Align(
            alignment: const Alignment(-0.459, -0.458),
            child: PageLink(
              links: [
                PageLinkInfo(
                  transition: LinkTransition.Fade,
                  ease: Curves.easeOut,
                  duration: 0.3,
                  pageBuilder: () => CuidadosyRecomendaciones(key: const Key('CuidadosyRecomendaciones')),
                ),
              ],
              child: Container(
                width: 63.0,
                height: 60.0,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/cuidadosrecomendaciones.png'),
                    fit: BoxFit.fill,
                  ),
                ),
              ),
            ),
          ),
          Align(
            alignment: const Alignment(0.0, -0.458),
            child: PageLink(
              links: [
                PageLinkInfo(
                  transition: LinkTransition.Fade,
                  ease: Curves.easeOut,
                  duration: 0.3,
                  pageBuilder: () => Emergencias(key: const Key('Emergencias')),
                ),
              ],
              child: Container(
                width: 65.0,
                height: 60.0,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/emergencias.png'),
                    fit: BoxFit.fill,
                  ),
                ),
              ),
            ),
          ),
          Align(
            alignment: const Alignment(0.477, -0.458),
            child: PageLink(
              links: [
                PageLinkInfo(
                  transition: LinkTransition.Fade,
                  ease: Curves.easeOut,
                  duration: 0.3,
                  pageBuilder: () => Comunidad(key: const Key('Comunidad')),
                ),
              ],
              child: Container(
                width: 67.0,
                height: 60.0,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/comunidad.png'),
                    fit: BoxFit.fill,
                  ),
                ),
              ),
            ),
          ),
          Pinned.fromPins(
            Pin(size: 53.6, end: 20.3),
            Pin(size: 60.0, middle: 0.2712),
            child: Container(
              decoration: BoxDecoration(
                image: const DecorationImage(
                  image: AssetImage('assets/images/crearpublicacion.png'),
                  fit: BoxFit.fill,
                ),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0xff9decf9),
                    offset: Offset(0, 3),
                    blurRadius: 6,
                  ),
                ],
              ),
            ),
          ),
          // Sección desplazable de creación de publicaciones
          Pinned.fromPins(
            Pin(start: 16.0, end: 15.0),
            Pin(size: MediaQuery.of(context).size.height * 0.65, end: 0.0),
            child: SingleChildScrollView(
              controller: _scrollController,
              child: Container(
                height: MediaQuery.of(context).size.height * 0.8,
                child: Stack(
                  children: <Widget>[
                    Stack(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 73.0),
                          child: SizedBox.expand(
                            child: SvgPicture.string(
                              _svg_cepmj,
                              allowDrawingOutsideViewBox: true,
                              fit: BoxFit.fill,
                            ),
                          ),
                        ),
                        Pinned.fromPins(
                          Pin(start: 15.0, end: 15.0),
                          Pin(size: 70.0, start: 15.0),
                          child: StreamBuilder<DocumentSnapshot>(
                            stream: FirebaseFirestore.instance
                                .collection('users')
                                .doc(FirebaseAuth.instance.currentUser?.uid)
                                .snapshots(),
                            builder: (context, snapshot) {
                              if (!snapshot.hasData || !snapshot.data!.exists) {
                                return Row(
                                  children: [
                                    CircleAvatar(
                                      radius: 5,
                                      backgroundColor: Colors.grey[200],
                                      child: const Icon(Icons.person, color: Colors.white, size: 40),
                                    ),
                                    const SizedBox(width: 10),
                                    const Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          'Usuario Anónimo',
                                          style: TextStyle(
                                            fontFamily: 'Comic Sans MS',
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Row(
                                          children: [
                                            SizedBox(width: 35, height: 35),
                                            SizedBox(width: 5),
                                            Text(
                                              'Público',
                                              style: TextStyle(
                                                fontFamily: 'Comic Sans MS',
                                                fontSize: 14,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ],
                                );
                              }

                              final userData = snapshot.data!.data() as Map<String, dynamic>? ?? {};
                              final profilePhotoUrl = userData['profilePhotoUrl'] as String?;
                              final displayName = userData['displayName'] as String? ??
                                  FirebaseAuth.instance.currentUser?.displayName ??
                                  'Usuario Anónimo';

                              return Row(
                                children: [
                                  CircleAvatar(
                                    radius: 20,
                                    backgroundColor: Colors.grey[200],
                                    backgroundImage: profilePhotoUrl != null && profilePhotoUrl.isNotEmpty
                                        ? NetworkImage(profilePhotoUrl)
                                        : null,
                                    child: profilePhotoUrl == null || profilePhotoUrl.isEmpty
                                        ? const Icon(Icons.person, color: Colors.white, size: 20)
                                        : null,
                                  ),
                                  const SizedBox(width: 10),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        displayName,
                                        style: const TextStyle(
                                          fontFamily: 'Comic Sans MS',
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Row(
                                        children: [
                                          Image.asset(
                                            'assets/images/publico.png',
                                            width: 35,
                                            height: 35,
                                          ),
                                          const SizedBox(width: 5),
                                          const Text(
                                            'Público',
                                            style: TextStyle(
                                              fontFamily: 'Comic Sans MS',
                                              fontSize: 14,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              );
                            },
                          ),
                        ),
                        Pinned.fromPins(
                          Pin(start: 15.0, end: 15.0),
                          Pin(size: 100.0, start: 80.0),
                          child: TextField(
                            controller: _captionController,
                            decoration: const InputDecoration(
                              hintText: '¿Qué estás pensando?',
                              border: InputBorder.none,
                              hintStyle: TextStyle(
                                fontFamily: 'Comic Sans MS',
                                fontSize: 17,
                                color: Color(0xff000000),
                              ),
                            ),
                            maxLines: 3,
                            style: const TextStyle(
                              fontFamily: 'Comic Sans MS',
                              fontSize: 17,
                              color: Color(0xff000000),
                            ),
                          ),
                        ),
                        Pinned.fromPins(
                          Pin(start: 15.0, end: 15.0),
                          Pin(size: 280.0, middle: 0.55),
                          child: AspectRatio(
                            aspectRatio: 1,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(15.0),
                              child: _buildMediaPreview(),
                            ),
                          ),
                        ),
                        Pinned.fromPins(
                          Pin(start: 15.0, end: 15.0),
                          Pin(size: 50.0, middle: 0.85),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Container(
                                width: 47.0,
                                height: 50.0,
                                decoration: const BoxDecoration(
                                  image: DecorationImage(
                                    image: AssetImage('assets/images/ubicacion.png'),
                                    fit: BoxFit.fill,
                                  ),
                                ),
                              ),
                              Container(
                                width: 45.0,
                                height: 50.0,
                                decoration: const BoxDecoration(
                                  image: DecorationImage(
                                    image: AssetImage('assets/images/gif.png'),
                                    fit: BoxFit.fill,
                                  ),
                                ),
                              ),
                              Container(
                                width: 52.5,
                                height: 50.0,
                                decoration: const BoxDecoration(
                                  image: DecorationImage(
                                    image: AssetImage('assets/images/etiqueta.png'),
                                    fit: BoxFit.fill,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Pinned.fromPins(
                          Pin(start: 15.0, end: 15.0),
                          Pin(size: 50.0, end: 10.0),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xff4ec8dd),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15.0),
                                side: const BorderSide(
                                  width: 1.0,
                                  color: Color(0xff000000),
                                ),
                              ),
                              elevation: 3,
                              shadowColor: const Color(0xff000000),
                            ),
                            onPressed: _isUploading ? null : _uploadFile,
                            child: _isUploading
                                ? const CircularProgressIndicator()
                                : const Text(
                              'publicar',
                              style: TextStyle(
                                fontFamily: 'Comic Sans MS',
                                fontSize: 20,
                                color: Color(0xff000000),
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ),
                      ],
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

const String _svg_cepmj =
    '<svg viewBox="0.2 0.0 381.0 410.0" ><path transform="translate(0.2, 0.0)" d="M 20 0 L 361 0 C 372.0456848144531 0 381 8.954304695129395 381 20 L 381 390 C 381 401.0456848144531 372.0456848144531 410 361 410 L 20 410 C 8.954304695129395 410 0 401.0456848144531 0 390 L 0 20 C 0 8.954304695129395 8.954304695129395 0 20 0 Z" fill="#a0f4fe" fill-opacity="0.89" stroke="#000000" stroke-width="1" stroke-opacity="0.89" stroke-miterlimit="4" stroke-linecap="butt" /></svg>';