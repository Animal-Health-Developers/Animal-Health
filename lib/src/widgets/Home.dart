// home.dart
import 'package:flutter/material.dart';
import 'package:adobe_xd/pinned.dart';
import '../services/auth_service.dart';
import './Ayuda.dart';
import 'package:adobe_xd/page_link.dart';
import './PerfilPublico.dart';
import './Configuracion.dart';
import './CompradeProductos.dart';
import './ListadeAnimales.dart';
import './CuidadosyRecomendaciones.dart';
import './Emergencias.dart';
import './Comunidad.dart';
import './Crearpublicaciones.dart';
import './DetallesdeFotooVideo.dart';
import './CompartirPublicacion.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:video_player/video_player.dart';
import 'dart:developer' as developer;
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb; // Para detectar si es web
import 'dart:typed_data'; // Para Uint8List


// --- CONFIGURACIÓN DE API KEYS ---
const String GEMINI_API_KEY_HOME = 'AIzaSyAgv8dNt1etzPz8Lnl39e8Seb6N8B3nenc'; // TU API KEY DE GEMINI AQUÍ
// ---------------------------------

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final TextEditingController _searchController = TextEditingController();
  GenerativeModel? _geminiModel;
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    _initializeGemini();
  }

  void _initializeGemini() {
    if (GEMINI_API_KEY_HOME.isNotEmpty && GEMINI_API_KEY_HOME != 'AIzaSyD4FUbajaBbCslYPKZNyF-WGwrJZPcBZss') { // Reemplaza con tu placeholder si es diferente
      _geminiModel = GenerativeModel(
        model: 'gemini-pro',
        apiKey: GEMINI_API_KEY_HOME,
      );
      developer.log("Modelo Gemini inicializado en Home.", name: "Home.Gemini");
    } else {
      developer.log("API Key de Gemini no configurada en Home. La búsqueda con IA no funcionará.", name: "Home.Gemini");
    }
  }

  Future<void> _performSearch(String query) async {
    if (query.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, ingresa un término de búsqueda')),
      );
      return;
    }

    if (_geminiModel == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('La búsqueda con IA no está disponible en este momento.')),
      );
      developer.log("Intento de búsqueda pero el modelo Gemini no está inicializado.", name: "Home.Search");
      return;
    }

    setState(() {
      _isSearching = true;
    });

    try {
      final prompt = 'Busca información o un consejo de cuidado relevante para mascotas sobre: "$query". Proporciona una respuesta concisa y útil. Si es un animal, menciona algún dato curioso o consejo de cuidado principal. Si es un producto o servicio, describe brevemente su utilidad para mascotas.';
      final content = [Content.text(prompt)];
      final response = await _geminiModel!.generateContent(content).timeout(const Duration(seconds: 20));

      developer.log("Respuesta de Gemini para búsqueda '$query': ${response.text}", name: "Home.Search");

      if (mounted) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Resultado para: $query'),
              content: SingleChildScrollView(child: Text(response.text ?? 'No se encontró información.')),
              actions: <Widget>[
                TextButton(
                  child: const Text('Cerrar'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      }
    } catch (e) {
      developer.log("Error al buscar con Gemini: $e", error: e, name: "Home.Search");
      String errorMessage = "Hubo un problema al realizar la búsqueda con IA.";
      if (e is GenerativeAIException && e.message.contains('API key not valid')) {
        errorMessage = "Error: La API Key de Gemini no es válida. Por favor, verifica la configuración.";
      } else if (e.toString().contains('timeout')) {
        errorMessage = "La búsqueda tardó demasiado en responder. Inténtalo de nuevo.";
      }
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(errorMessage)),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSearching = false;
        });
      }
    }
  }


  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Widget _buildNavigationButtonItem({
    required String imagePath,
    bool isHighlighted = false,
    double? fixedWidth,
    double height = 60.0,
  }) {
    double itemWidth;
    if (fixedWidth != null) {
      itemWidth = fixedWidth;
    } else {
      if (imagePath.contains('noticias')) itemWidth = 54.3;
      else if (imagePath.contains('cuidadosrecomendaciones')) itemWidth = 63.0;
      else if (imagePath.contains('emergencias')) itemWidth = 65.0;
      else if (imagePath.contains('comunidad')) itemWidth = 67.0;
      else if (imagePath.contains('crearpublicacion')) itemWidth = 53.6;
      else itemWidth = 60.0;
    }

    return Container(
      width: itemWidth,
      height: height,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(imagePath),
          fit: BoxFit.fill,
        ),
        boxShadow: isHighlighted
            ? const [BoxShadow(color: Color(0xff9ff1fb), offset: Offset(0, 3), blurRadius: 6)]
            : null,
      ),
    );
  }

  Future<void> _mostrarDialogoEditarPublicacion(DocumentSnapshot publicacion) async {
    final String publicacionId = publicacion.id;
    final data = publicacion.data() as Map<String, dynamic>?;
    final String? captionActual = data?['caption'] as String?;
    final String? mediaUrlActual = data?['imagenUrl'] as String?;
    final bool esVideoActual = (data?['esVideo'] as bool?) ?? false;

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return EditarPublicacionWidget(
          key: Key('edit_$publicacionId'),
          publicacionId: publicacionId,
          captionActual: captionActual ?? '',
          mediaUrlActual: mediaUrlActual,
          esVideoActual: esVideoActual,
          parentContext: this.context,
        );
      },
    );
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
                image: AssetImage(
                  'assets/images/Animal Health Fondo de Pantalla.png',
                ),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Pinned.fromPins(
            Pin(size: 74.0, middle: 0.5),
            Pin(size: 73.0, start: 42.0),
            child: Container(
              decoration: BoxDecoration(
                image: const DecorationImage(
                  image: AssetImage('assets/images/logo.png'),
                  fit: BoxFit.cover,
                ),
                borderRadius: BorderRadius.circular(15.0),
                border: Border.all(width: 1.0, color: const Color(0xff000000)),
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
            Pin(size: 45.0, start: 150),
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xffffffff),
                borderRadius: BorderRadius.circular(5.0),
                border: Border.all(
                  width: 1.0,
                  color: const Color(0xff707070),
                ),
              ),
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Image.asset(
                      'assets/images/busqueda1.png',
                      width: 24.0,
                      height: 24.0,
                    ),
                  ),
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      style: const TextStyle(
                        fontFamily: 'Comic Sans MS',
                        fontSize: 18,
                        color: Color(0xff000000),
                      ),
                      decoration: const InputDecoration(
                        hintText: '¿Qué estás buscando?',
                        hintStyle: TextStyle(
                          fontFamily: 'Comic Sans MS',
                          fontSize: 18,
                          color: Colors.grey,
                        ),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(vertical: 12.0),
                      ),
                      textInputAction: TextInputAction.search,
                      onSubmitted: (value) {
                        if (!_isSearching) {
                          _performSearch(value);
                        }
                      },
                    ),
                  ),
                  if (_isSearching)
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2.0),
                      ),
                    )
                  else
                    IconButton(
                      icon: const Icon(Icons.search, color: Colors.black54),
                      onPressed: () {
                        if (!_isSearching) {
                          _performSearch(_searchController.text);
                        }
                      },
                    ),
                ],
              ),
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
                final data = snapshot.data?.data() as Map<String, dynamic>?;
                final profilePhotoUrl = data?['profilePhotoUrl'] as String?;
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
                          placeholder: (context, url) => const Center(
                            child: CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(Color(0xff4ec8dd)),
                            ),
                          ),
                          errorWidget: (context, url, error) {
                            developer.log('Error CachedNetworkImage (Perfil): $error, URL: $url', name: "Home.ProfilePic");
                            return const Center(child: Icon(Icons.person, size: 30, color: Colors.grey));
                          })
                          : const Center(child: Icon(Icons.person, size: 30, color: Colors.grey)),
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
                  pageBuilder: () => Configuraciones(key: const Key('Configuraciones'), authService: AuthService()),
                ),
              ],
              child: Container(
                decoration: const BoxDecoration(
                  image: DecorationImage(image: AssetImage('assets/images/settingsbutton.png'), fit: BoxFit.fill),
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
                  image: DecorationImage(image: AssetImage('assets/images/store.png'), fit: BoxFit.fill),
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
                  image: DecorationImage(image: AssetImage('assets/images/listaanimales.png'), fit: BoxFit.fill),
                ),
              ),
            ),
          ),
          Positioned(
            top: 200.0,
            left: 16.0,
            right: 16.0,
            height: 60.0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                _buildNavigationButtonItem(
                  imagePath: 'assets/images/noticias.png',
                  isHighlighted: true,
                  fixedWidth: 54.3,
                ),
                PageLink(
                  links: [
                    PageLinkInfo(
                      transition: LinkTransition.Fade,
                      ease: Curves.easeOut,
                      duration: 0.3,
                      pageBuilder: () => CuidadosyRecomendaciones(key: const Key('CuidadosyRecomendaciones')),
                    ),
                  ],
                  child: _buildNavigationButtonItem(
                    imagePath: 'assets/images/cuidadosrecomendaciones.png',
                    fixedWidth: 63.0,
                  ),
                ),
                PageLink(
                  links: [
                    PageLinkInfo(
                      transition: LinkTransition.Fade,
                      ease: Curves.easeOut,
                      duration: 0.3,
                      pageBuilder: () => Emergencias(key: const Key('Emergencias')),
                    ),
                  ],
                  child: _buildNavigationButtonItem(
                    imagePath: 'assets/images/emergencias.png',
                    fixedWidth: 65.0,
                  ),
                ),
                PageLink(
                  links: [
                    PageLinkInfo(
                      transition: LinkTransition.Fade,
                      ease: Curves.easeOut,
                      duration: 0.3,
                      pageBuilder: () => Comunidad(key: const Key('Comunidad')),
                    ),
                  ],
                  child: _buildNavigationButtonItem(
                    imagePath: 'assets/images/comunidad.png',
                    fixedWidth: 67.0,
                  ),
                ),
                PageLink(
                  links: [
                    PageLinkInfo(
                      transition: LinkTransition.Fade,
                      ease: Curves.easeOut,
                      duration: 0.3,
                      pageBuilder: () => Crearpublicaciones(key: const Key('Crearpublicaciones')),
                    ),
                  ],
                  child: _buildNavigationButtonItem(
                    imagePath: 'assets/images/crearpublicacion.png',
                    fixedWidth: 53.6,
                  ),
                ),
              ],
            ),
          ),
          Pinned.fromPins(
            Pin(start: 16.0, end: 16.0),
            Pin(start: 270.0, end: 0.0),
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance.collection('publicaciones').orderBy('fecha', descending: true).snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  developer.log('Error en StreamBuilder (publicaciones): ${snapshot.error}', name: "Home.PubStream", error: snapshot.error);
                  return Center(child: Text('Error: ${snapshot.error}'));
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(child: Text('No hay publicaciones aún'));
                }
                return MediaQuery.removePadding(
                  context: context,
                  removeBottom: true,
                  removeTop: true,
                  child: ListView.builder(
                    padding: EdgeInsets.zero,
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      var publicacion = snapshot.data!.docs[index];
                      return _buildPublicacionItem(publicacion, context);
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPublicacionItem(DocumentSnapshot publicacion, BuildContext context) {
    final pubDataMap = publicacion.data() as Map<String, dynamic>?;
    final mediaUrl = pubDataMap?['imagenUrl'] as String?;
    final isVideo = (pubDataMap?['esVideo'] as bool?) ?? false;
    final hasValidMedia = mediaUrl != null && mediaUrl.isNotEmpty;
    final currentUserId = FirebaseAuth.instance.currentUser?.uid;
    final postOwnerId = pubDataMap?['usuarioId'] as String?;
    final isOwnPost = currentUserId != null && postOwnerId == currentUserId;
    final likes = pubDataMap?['likes'] as int? ?? 0;
    final likedBy = List<String>.from(pubDataMap?['likedBy'] as List<dynamic>? ?? []);

    return Container(
      margin: const EdgeInsets.only(top: 10.0),
      decoration: BoxDecoration(
        color: const Color(0xe3a0f4fe),
        borderRadius: BorderRadius.circular(9.0),
        border: Border.all(width: 1.0, color: const Color(0xe3000000)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                PageLink(
                  links: [
                    PageLinkInfo(
                      transition: LinkTransition.Fade,
                      ease: Curves.easeOut,
                      duration: 0.3,
                      pageBuilder: () => PerfilPublico(key: Key('PerfilPublicoOwner_${postOwnerId ?? "anon"}'), /* userId: postOwnerId */), // Asegúrate de que PerfilPublico pueda manejar un userId
                    ),
                  ],
                  child: StreamBuilder<DocumentSnapshot>(
                    stream: FirebaseFirestore.instance.collection('users').doc(postOwnerId).snapshots(),
                    builder: (context, userSnapshot) {
                      if (userSnapshot.connectionState == ConnectionState.waiting) {
                        return const CircleAvatar(radius: 20, backgroundColor: Colors.grey, child: CircularProgressIndicator(strokeWidth: 2, valueColor: AlwaysStoppedAnimation<Color>(Colors.white)));
                      }
                      if (userSnapshot.hasError) {
                        developer.log('Error cargando datos de usuario para publicación: ${userSnapshot.error}', name: "Home.PubUserStream", error: userSnapshot.error);
                        return const CircleAvatar(radius: 20, backgroundColor: Colors.grey, child: Icon(Icons.error, color: Colors.white));
                      }
                      if (!userSnapshot.hasData || !userSnapshot.data!.exists) {
                        return const CircleAvatar(radius: 20, backgroundColor: Colors.grey, child: Icon(Icons.person, color: Colors.white));
                      }
                      final userData = userSnapshot.data?.data() as Map<String, dynamic>?;
                      final profilePhotoUrl = userData?['profilePhotoUrl'] as String?;
                      return CircleAvatar(
                        radius: 20,
                        backgroundColor: Colors.grey[200],
                        backgroundImage: profilePhotoUrl != null && profilePhotoUrl.isNotEmpty ? NetworkImage(profilePhotoUrl) : null,
                        child: profilePhotoUrl == null || profilePhotoUrl.isEmpty ? const Icon(Icons.person, color: Colors.white) : null,
                      );
                    },
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        pubDataMap?['usuarioNombre'] ?? 'Usuario Anónimo',
                        style: const TextStyle(fontFamily: 'Comic Sans MS', fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      Row(
                        children: [
                          Image.asset('assets/images/publico.png', width: 15, height: 15),
                          const SizedBox(width: 5),
                          Text(pubDataMap?['tipoPublicacion'] ?? 'Público', style: const TextStyle(fontFamily: 'Comic Sans MS', fontSize: 14)),
                        ],
                      ),
                    ],
                  ),
                ),
                if (isOwnPost)
                  PopupMenuButton<String>(
                    icon: const Icon(Icons.more_vert, color: Colors.black),
                    onSelected: (value) {
                      if (value == 'eliminar') {
                        _eliminarPublicacion(publicacion.id, context);
                      } else if (value == 'editar') {
                        _mostrarDialogoEditarPublicacion(publicacion);
                      }
                    },
                    itemBuilder: (BuildContext context) => [
                      const PopupMenuItem<String>(value: 'editar', child: Text('Editar publicación')),
                      const PopupMenuItem<String>(value: 'eliminar', child: Text('Eliminar publicación')),
                    ],
                  ),
              ],
            ),
          ),
          if (hasValidMedia)
            SizedBox(
              width: double.infinity,
              child: isVideo
                  ? _VideoPlayerWidget(key: Key('video_pub_${publicacion.id}'), videoUrl: mediaUrl!)
                  : _buildImageWidget(mediaUrl!, context),
            )
          else
            _buildNoImageWidget(),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              pubDataMap?['caption'] ?? '',
              style: const TextStyle(fontFamily: 'Comic Sans MS', fontSize: 15, fontWeight: FontWeight.w700),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                GestureDetector(
                  onTap: () => _toggleLike(publicacion.id, currentUserId, likedBy, context),
                  child: Row(
                    children: [
                      Image.asset('assets/images/like.png', width: 40, height: 40),
                      const SizedBox(width: 5),
                      Text(likes.toString(), style: const TextStyle(fontFamily: 'Comic Sans MS', fontSize: 16, color: Colors.black)),
                    ],
                  ),
                ),
                PageLink(
                  links: [
                    PageLinkInfo(
                      transition: LinkTransition.Fade,
                      ease: Curves.easeOut,
                      duration: 0.3,
                      pageBuilder: () {
                        String pubId = publicacion.id;
                        developer.log("Navegando a Detalles: publicationId = '$pubId'", name: "Home.Navigation");

                        String? ownerProfilePic;
                        if (pubDataMap != null && pubDataMap.containsKey('usuarioFotoUrl')) {
                          ownerProfilePic = pubDataMap['usuarioFotoUrl'] as String?;
                        } else if (pubDataMap != null && pubDataMap.containsKey('profilePhotoUrl')) { // Fallback por si acaso
                          ownerProfilePic = pubDataMap['profilePhotoUrl'] as String?;
                        }

                        return DetallesdeFotooVideo(
                          key: Key('Detalles_$pubId'),
                          publicationId: pubId,
                          mediaUrl: mediaUrl,
                          isVideo: isVideo,
                          caption: pubDataMap?['caption'] as String?,
                          ownerUserId: postOwnerId,
                          ownerUserName: pubDataMap?['usuarioNombre'] as String?,
                          ownerUserProfilePic: ownerProfilePic,
                        );
                      },
                    ),
                  ],
                  child: Row(
                    children: [
                      Image.asset('assets/images/comments.png', width: 40, height: 40),
                      const SizedBox(width: 5),
                      // --- INICIO DE LA CORRECCIÓN ---
                      Builder(
                          builder: (context) {
                            final commentsCount = (pubDataMap?['comentariosCount'] as int?) ?? (pubDataMap?['comentarios'] as int?) ?? 0;
                            return Text(
                                commentsCount.toString(),
                                style: const TextStyle(fontFamily: 'Comic Sans MS', fontSize: 16)
                            );
                          }
                      ),
                      // --- FIN DE LA CORRECCIÓN ---
                    ],
                  ),
                ),
                PageLink(
                  links: [
                    PageLinkInfo(
                      transition: LinkTransition.Fade,
                      ease: Curves.easeOut,
                      duration: 0.3,
                      pageBuilder: () => CompartirPublicacion(
                        key: Key('Compartir_${publicacion.id}'),
                        publicationId: publicacion.id,
                        mediaUrl: mediaUrl,
                        caption: pubDataMap?['caption'] as String?,
                      ),
                    ),
                  ],
                  child: Row(
                    children: [
                      Image.asset('assets/images/share.png', width: 40, height: 40),
                      const SizedBox(width: 5),
                      const Text('SHARE', style: TextStyle(fontFamily: 'Comic Sans MS', fontSize: 16)),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () => _guardarPublicacion(publicacion.id, context),
                  child: Row(
                    children: [
                      Image.asset('assets/images/save.png', width: 40, height: 40),
                      const SizedBox(width: 5),
                      const Text('Guardar', style: TextStyle(fontFamily: 'Comic Sans MS', fontSize: 16)),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImageWidget(String imageUrl, BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8.0),
      child: CachedNetworkImage(
        imageUrl: imageUrl,
        fit: BoxFit.cover,
        height: 300,
        placeholder: (context, url) => const Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Color(0xff4ec8dd)),
          ),
        ),
        errorWidget: (context, url, error) {
          developer.log('Error CachedNetworkImage (Publicación): $error, URL: $url', name: "Home.Image", error: error);
          return _buildImageErrorWidget();
        },
      ),
    );
  }

  Widget _buildImageErrorWidget() {
    return Container(
      width: double.infinity,
      height: 200,
      color: Colors.grey[200],
      child: const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, color: Colors.red, size: 50),
          SizedBox(height: 10),
          Text('Error al cargar el contenido', textAlign: TextAlign.center, style: TextStyle(fontFamily: 'Comic Sans MS', fontSize: 16, color: Colors.red)),
        ],
      ),
    );
  }

  Widget _buildNoImageWidget() {
    return Container(
      width: double.infinity,
      height: 200,
      color: Colors.grey[200],
      child: const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.image_not_supported, size: 50, color: Colors.grey),
          SizedBox(height: 10),
          Text('Contenido no disponible', textAlign: TextAlign.center, style: TextStyle(fontFamily: 'Comic Sans MS', fontSize: 16, color: Colors.grey)),
        ],
      ),
    );
  }

  Future<void> _toggleLike(String postId, String? userId, List<String> likedBy, BuildContext context) async {
    if (userId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Debes iniciar sesión para dar like')),
      );
      return;
    }
    try {
      final postRef = FirebaseFirestore.instance.collection('publicaciones').doc(postId);
      await FirebaseFirestore.instance.runTransaction((transaction) async {
        final postSnapshot = await transaction.get(postRef);
        if (!postSnapshot.exists) {
          developer.log('Error: Publicación no encontrada para dar like: $postId', name: "Home.Like");
          throw Exception("Publicación no encontrada.");
        }
        final postData = postSnapshot.data() as Map<String, dynamic>?;
        List<String> currentLikedBy = List<String>.from(postData?['likedBy'] as List<dynamic>? ?? []);
        final bool isLiked = currentLikedBy.contains(userId);
        List<String> newLikedBy;
        if (isLiked) {
          newLikedBy = currentLikedBy.where((id) => id != userId).toList();
        } else {
          newLikedBy = [...currentLikedBy, userId];
        }
        transaction.update(postRef, {'likes': newLikedBy.length, 'likedBy': newLikedBy});
      });
    } catch (e) {
      developer.log('Error al actualizar like: $e', error: e, name: "Home.Like");
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error al actualizar like: ${e.toString().substring(0, (e.toString().length > 50) ? 50 : e.toString().length)}...')));
      }
    }
  }

  Future<void> _guardarPublicacion(String publicacionId, BuildContext context) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Debes iniciar sesión para guardar publicaciones')));
        }
        return;
      }
      // Guardar en la subcolección del usuario
      final userSavedPubRef = FirebaseFirestore.instance.collection('users').doc(user.uid).collection('publicacionesGuardadas').doc(publicacionId);
      final doc = await userSavedPubRef.get();

      if (doc.exists) {
        await userSavedPubRef.delete();
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Publicación eliminada de guardados'), backgroundColor: Colors.orangeAccent));
        }
      } else {
        await userSavedPubRef.set({
          'publicacionId': publicacionId, // Puedes guardar solo el ID o más datos si lo necesitas
          'fechaGuardado': FieldValue.serverTimestamp(),
        });
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Publicación guardada correctamente'), backgroundColor: Colors.green));
        }
      }
    } catch (e) {
      developer.log('Error al guardar/desguardar publicación: $e', error: e, name: "Home.Save");
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error al procesar guardado: ${e.toString().substring(0, (e.toString().length > 50) ? 50 : e.toString().length)}...'), backgroundColor: Colors.red));
      }
    }
  }

  Future<void> _eliminarPublicacion(String publicacionId, BuildContext context) async {
    bool confirmar = await showDialog(
      context: context,
      builder: (BuildContext ctx) {
        return AlertDialog(
          title: const Text('Confirmar Eliminación'),
          content: const Text('¿Estás seguro de que deseas eliminar esta publicación? Esta acción no se puede deshacer.'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancelar'),
              onPressed: () {
                Navigator.of(ctx).pop(false);
              },
            ),
            TextButton(
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              child: const Text('Eliminar'),
              onPressed: () {
                Navigator.of(ctx).pop(true);
              },
            ),
          ],
        );
      },
    ) ?? false;

    if (!confirmar) return;

    try {
      DocumentSnapshot postDoc = await FirebaseFirestore.instance.collection('publicaciones').doc(publicacionId).get();
      if (postDoc.exists) {
        final data = postDoc.data() as Map<String, dynamic>;
        final String? mediaUrlToDelete = data['imagenUrl'] as String?;
        if (mediaUrlToDelete != null && mediaUrlToDelete.isNotEmpty) {
          try {
            if (mediaUrlToDelete.startsWith('https://firebasestorage.googleapis.com')) {
              await FirebaseStorage.instance.refFromURL(mediaUrlToDelete).delete();
              developer.log('Medio eliminado de Storage: $mediaUrlToDelete', name: "Home.DeleteStorage");
            }
          } catch (storageError) {
            developer.log('Error eliminando medio de Storage: $storageError. URL: $mediaUrlToDelete', name: "Home.DeleteStorage", error: storageError);
          }
        }
      }

      await FirebaseFirestore.instance.collection('publicaciones').doc(publicacionId).delete();
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Publicación eliminada correctamente'), backgroundColor: Colors.green));
      }
    } catch (e) {
      developer.log('Error al eliminar publicación: $e', error: e, name: "Home.Delete");
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error al eliminar: ${e.toString().substring(0, (e.toString().length > 50) ? 50 : e.toString().length)}...'), backgroundColor: Colors.red));
      }
    }
  }
}


// --- WIDGET PARA EL MODAL DE EDICIÓN ---
class EditarPublicacionWidget extends StatefulWidget {
  final String publicacionId;
  final String captionActual;
  final String? mediaUrlActual;
  final bool esVideoActual;
  final BuildContext parentContext;

  const EditarPublicacionWidget({
    required Key key,
    required this.publicacionId,
    required this.captionActual,
    this.mediaUrlActual,
    required this.esVideoActual,
    required this.parentContext,
  }) : super(key: key);

  @override
  _EditarPublicacionWidgetState createState() => _EditarPublicacionWidgetState();
}

class _EditarPublicacionWidgetState extends State<EditarPublicacionWidget> {
  late TextEditingController _captionController;
  File? _nuevoMedioFile;
  Uint8List? _nuevoMedioBytesPreview;
  bool _esNuevoMedioVideo = false;
  bool _isUploading = false;
  final ImagePicker _picker = ImagePicker();
  VideoPlayerController? _videoPlayerControllerPreview;

  @override
  void initState() {
    super.initState();
    _captionController = TextEditingController(text: widget.captionActual);
    _esNuevoMedioVideo = widget.esVideoActual; // Inicializa con el estado actual
    if (widget.mediaUrlActual != null && widget.esVideoActual) {
      _initializeVideoPlayerPreview(widget.mediaUrlActual!);
    }
  }

  void _initializeVideoPlayerPreview(String url, {bool isFile = false}) async {
    await _videoPlayerControllerPreview?.dispose();

    Uri? uri = Uri.tryParse(url);
    if (uri == null) {
      developer.log("URL inválida para VideoPlayer: $url", name: "EditWidget.Video");
      if (mounted) {
        ScaffoldMessenger.of(widget.parentContext).showSnackBar(
          SnackBar(content: Text('URL de video inválida: $url')),
        );
      }
      return;
    }

    if (isFile && !kIsWeb) {
      _videoPlayerControllerPreview = VideoPlayerController.file(File(url));
    } else if (kIsWeb && isFile) {
      _videoPlayerControllerPreview = VideoPlayerController.networkUrl(uri);
    }
    else {
      _videoPlayerControllerPreview = VideoPlayerController.networkUrl(uri);
    }

    try {
      await _videoPlayerControllerPreview!.initialize();
      if (mounted) setState(() {});
      _videoPlayerControllerPreview!.setLooping(true);
    } catch (e) {
      developer.log("Error inicializando VideoPlayer preview para edición: $e, URL: $url", name: "EditWidget.Video");
      if (mounted) {
        ScaffoldMessenger.of(widget.parentContext).showSnackBar(
          const SnackBar(content: Text('Error al cargar la vista previa del video.')),
        );
      }
    }
  }

  Future<void> _seleccionarMedia(ImageSource source, {bool isVideo = false}) async {
    XFile? pickedFile;
    try {
      if (isVideo) {
        pickedFile = await _picker.pickVideo(source: source);
      } else {
        pickedFile = await _picker.pickImage(source: source, imageQuality: 70, maxWidth: 1080, maxHeight: 1920);
      }

      if (pickedFile != null) {
        _nuevoMedioBytesPreview = null;
        String pickedFilePath = pickedFile.path;

        if (!isVideo && kIsWeb) {
          _nuevoMedioBytesPreview = await pickedFile.readAsBytes();
        }

        if (mounted) {
          setState(() {
            _nuevoMedioFile = File(pickedFilePath);
            _esNuevoMedioVideo = isVideo;
            _videoPlayerControllerPreview?.dispose();
            _videoPlayerControllerPreview = null;
            if (isVideo) {
              _initializeVideoPlayerPreview(pickedFilePath, isFile: true);
            }
          });
        }
      }
    } catch (e) {
      developer.log("Error seleccionando media para editar: $e", name: "EditWidget.Picker");
      if (mounted) {
        ScaffoldMessenger.of(widget.parentContext).showSnackBar(
          SnackBar(content: Text('Error al seleccionar: ${e.toString()}')),
        );
      }
    }
  }

  Future<void> _guardarCambios() async {
    if (_isUploading) return;
    setState(() => _isUploading = true);

    String nuevoCaption = _captionController.text.trim();
    Map<String, dynamic> datosParaActualizar = {};
    bool hayCambios = false;

    if (nuevoCaption != widget.captionActual) {
      datosParaActualizar['caption'] = nuevoCaption;
      hayCambios = true;
    }

    String? mediaUrlParaActualizar = widget.mediaUrlActual;
    bool esVideoParaActualizar = widget.esVideoActual;

    if (_nuevoMedioFile != null) {
      hayCambios = true;
      try {
        String fileExtension = _nuevoMedioFile!.path.split('.').last.toLowerCase();
        if (_esNuevoMedioVideo) {
          if (!['mp4', 'mov', 'avi', 'mkv', 'webm'].contains(fileExtension)) fileExtension = 'mp4';
        } else {
          if (!['jpg', 'jpeg', 'png', 'gif', 'webp'].contains(fileExtension)) fileExtension = 'jpeg';
        }

        String fileName = 'publicaciones/${widget.publicacionId}/media_${DateTime.now().millisecondsSinceEpoch}.$fileExtension';
        String contentType = _esNuevoMedioVideo ? 'video/$fileExtension' : 'image/$fileExtension';
        if (_esNuevoMedioVideo && fileExtension == 'mov') contentType = 'video/quicktime';


        UploadTask uploadTask;
        if (kIsWeb) {
          Uint8List? bytesParaSubir;
          if(_esNuevoMedioVideo) {
            bytesParaSubir = await _nuevoMedioFile!.readAsBytes(); // Leer bytes del video para web
          } else {
            bytesParaSubir = _nuevoMedioBytesPreview; // Usar bytes de imagen ya leídos
          }

          if (bytesParaSubir != null) {
            uploadTask = FirebaseStorage.instance.ref(fileName).putData(bytesParaSubir, SettableMetadata(contentType: contentType));
          } else {
            // Si es video y no se pudieron leer bytes (debería ser raro, pero como fallback)
            // o si _nuevoMedioBytesPreview es null para una imagen (también raro si se seleccionó)
            // intentamos con putFile que en web espera una blob URL (que es lo que XFile.path es en web)
            developer.log("Intentando putFile para web con path: ${_nuevoMedioFile!.path}", name: "EditWidget.UploadWeb");
            uploadTask = FirebaseStorage.instance.ref(fileName).putFile(
                _nuevoMedioFile!, // En web, esto es una blob URL
                SettableMetadata(contentType: contentType)
            );
          }
        } else {
          uploadTask = FirebaseStorage.instance.ref(fileName).putFile(_nuevoMedioFile!);
        }

        TaskSnapshot snapshot = await uploadTask;
        mediaUrlParaActualizar = await snapshot.ref.getDownloadURL();
        esVideoParaActualizar = _esNuevoMedioVideo;

        datosParaActualizar['imagenUrl'] = mediaUrlParaActualizar;
        datosParaActualizar['esVideo'] = esVideoParaActualizar;

        if (widget.mediaUrlActual != null && widget.mediaUrlActual!.isNotEmpty && widget.mediaUrlActual != mediaUrlParaActualizar) {
          try {
            if (widget.mediaUrlActual!.startsWith('https://firebasestorage.googleapis.com')) {
              await FirebaseStorage.instance.refFromURL(widget.mediaUrlActual!).delete();
              developer.log('Medio antiguo eliminado de Storage: ${widget.mediaUrlActual}', name: "EditWidget.DeleteOldStorage");
            }
          } catch (e) {
            developer.log('Error eliminando medio antiguo de Storage: $e', name: "EditWidget.DeleteOldStorage", error: e);
          }
        }
      } catch (e) {
        developer.log('Error subiendo nuevo medio: $e', name: "EditWidget.Upload", error: e);
        if (mounted) {
          ScaffoldMessenger.of(widget.parentContext).showSnackBar(
            SnackBar(content: Text('Error al subir el nuevo medio: ${e.toString()}')),
          );
        }
        setState(() => _isUploading = false);
        return;
      }
    }

    if (hayCambios) {
      try {
        datosParaActualizar['fechaActualizacion'] = FieldValue.serverTimestamp();
        await FirebaseFirestore.instance.collection('publicaciones').doc(widget.publicacionId).update(datosParaActualizar);
        if (mounted) {
          ScaffoldMessenger.of(widget.parentContext).showSnackBar(
            const SnackBar(content: Text('Publicación actualizada exitosamente'), backgroundColor: Colors.green),
          );
          Navigator.of(context).pop();
        }
      } catch (e) {
        developer.log('Error actualizando publicación: $e', name: "EditWidget.FirestoreUpdate", error: e);
        if (mounted) {
          ScaffoldMessenger.of(widget.parentContext).showSnackBar(
            SnackBar(content: Text('Error al actualizar la publicación: ${e.toString()}')),
          );
        }
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(widget.parentContext).showSnackBar(
          const SnackBar(content: Text('No se realizaron cambios.')),
        );
      }
      if (mounted) Navigator.of(context).pop();
    }
    if (mounted) {
      setState(() => _isUploading = false);
    }
  }

  @override
  void dispose() {
    _captionController.dispose();
    _videoPlayerControllerPreview?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      heightFactor: 0.9,
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20.0),
          topRight: Radius.circular(20.0),
        ),
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Editar Publicación', style: TextStyle(fontFamily: 'Comic Sans MS', color: Colors.white)),
            backgroundColor: const Color(0xff4ec8dd),
            elevation: 0,
            automaticallyImplyLeading: false,
            actions: [
              IconButton(
                icon: const Icon(Icons.close, color: Colors.white),
                onPressed: () => Navigator.of(context).pop(),
              )
            ],
          ),
          body: Stack(
            children: [
              Container(
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/Animal Health Fondo de Pantalla.png'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    const Text(
                      'Editar contenido:',
                      style: TextStyle(fontFamily: 'Comic Sans MS', fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                    const SizedBox(height: 15),

                    _buildMediaPreview(),
                    const SizedBox(height: 10),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton.icon(
                          icon: const Icon(Icons.image, color: Colors.white),
                          label: const Text('Cambiar Foto', style: TextStyle(color: Colors.white, fontFamily: 'Comic Sans MS')),
                          onPressed: () => _seleccionarMedia(ImageSource.gallery, isVideo: false),
                          style: ElevatedButton.styleFrom(backgroundColor: const Color(0xff54d1e0), padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8)),
                        ),
                        ElevatedButton.icon(
                          icon: const Icon(Icons.videocam, color: Colors.white),
                          label: const Text('Cambiar Video', style: TextStyle(color: Colors.white, fontFamily: 'Comic Sans MS')),
                          onPressed: () => _seleccionarMedia(ImageSource.gallery, isVideo: true),
                          style: ElevatedButton.styleFrom(backgroundColor: const Color(0xff54d1e0), padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    TextFormField(
                      controller: _captionController,
                      style: const TextStyle(fontFamily: 'Comic Sans MS', color: Colors.black),
                      decoration: InputDecoration(
                        labelText: 'Descripción (Caption)',
                        labelStyle: const TextStyle(fontFamily: 'Comic Sans MS', color: Colors.black54),
                        filled: true,
                        fillColor: Colors.white.withOpacity(0.8),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: BorderSide.none,
                        ),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: const BorderSide(color: Color(0xff54d1e0), width: 2)
                        ),
                      ),
                      maxLines: 4,
                      maxLength: 2200,
                    ),
                    const SizedBox(height: 30),

                    _isUploading
                        ? const Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Color(0xff54d1e0))))
                        : ElevatedButton.icon(
                      icon: const Icon(Icons.save_outlined, color: Colors.white),
                      label: const Text('Guardar Cambios', style: TextStyle(color: Colors.white)),
                      onPressed: _guardarCambios,
                      style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xff54d1e0),
                          padding: const EdgeInsets.symmetric(vertical: 15.0),
                          textStyle: const TextStyle(fontFamily: 'Comic Sans MS', fontSize: 18, fontWeight: FontWeight.bold),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text(
                        'Cancelar',
                        style: TextStyle(fontFamily: 'Comic Sans MS', color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMediaPreview() {
    // Si hay un nuevo archivo de video seleccionado
    if (_nuevoMedioFile != null && _esNuevoMedioVideo) {
      if (kIsWeb) {
        // En web, la previsualización de video local (File) es complicada con VideoPlayerController.file.
        // Se muestra un placeholder. Una solución más avanzada implicaría usar `video_player_web` y `createObjectURL` si se tienen los bytes.
        return Container(height: 200, color: Colors.black, child: const Center(child: Text("Previsualización de video no disponible para web antes de subir.", textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontFamily: "Comic Sans MS"))));
      }
      if (_videoPlayerControllerPreview != null && _videoPlayerControllerPreview!.value.isInitialized) {
        return AspectRatio(
          aspectRatio: _videoPlayerControllerPreview!.value.aspectRatio > 0 ? _videoPlayerControllerPreview!.value.aspectRatio : 16/9,
          child: Stack(
            alignment: Alignment.bottomCenter,
            children: [
              VideoPlayer(_videoPlayerControllerPreview!),
              _buildPlayPauseOverlayPreview(_videoPlayerControllerPreview!)
            ],
          ),
        );
      } else {
        return Container(height: 200, color: Colors.black, child: const Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Color(0xff54d1e0)))));
      }
    }
    // Si hay un nuevo archivo de imagen seleccionado
    else if (_nuevoMedioFile != null && !_esNuevoMedioVideo) {
      if (kIsWeb && _nuevoMedioBytesPreview != null) {
        return Image.memory(_nuevoMedioBytesPreview!, height: 200, fit: BoxFit.contain);
      } else if (!kIsWeb) {
        return Image.file(_nuevoMedioFile!, height: 200, fit: BoxFit.contain);
      } else {
        return Container(height: 200, color: Colors.grey[300], child: const Center(child: Text("Cargando previsualización...", style: TextStyle(fontFamily: "Comic Sans MS"))));
      }
    }
    // Si hay un video actual y no se ha seleccionado uno nuevo
    else if (widget.mediaUrlActual != null && widget.esVideoActual) {
      if (_videoPlayerControllerPreview != null && _videoPlayerControllerPreview!.value.isInitialized) {
        return AspectRatio(
          aspectRatio: _videoPlayerControllerPreview!.value.aspectRatio > 0 ? _videoPlayerControllerPreview!.value.aspectRatio : 16/9,
          child: Stack(
            alignment: Alignment.bottomCenter,
            children: [
              VideoPlayer(_videoPlayerControllerPreview!),
              _buildPlayPauseOverlayPreview(_videoPlayerControllerPreview!)
            ],
          ),
        );
      } else if (widget.mediaUrlActual!.isNotEmpty) {
        return Container(height: 200, color: Colors.black, child: const Center(child: Text("Cargando video...", style: TextStyle(color: Colors.white, fontFamily: "Comic Sans MS"))));
      }
    }
    // Si hay una imagen actual y no se ha seleccionado una nueva
    else if (widget.mediaUrlActual != null && !widget.esVideoActual) {
      return CachedNetworkImage(
        imageUrl: widget.mediaUrlActual!,
        height: 200,
        fit: BoxFit.contain,
        placeholder: (context, url) => Container(height: 200, color: Colors.grey[300], child: const Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Color(0xff54d1e0))))),
        errorWidget: (context, url, error) => Container(height: 200, color: Colors.grey[300], child: const Icon(Icons.broken_image, size: 50, color: Colors.grey)),
      );
    }
    return Container(
      height: 150,
      decoration: BoxDecoration(
        color: Colors.grey[800],
        borderRadius: BorderRadius.circular(10),
      ),
      child: const Center(
        child: Text(
          'No hay medio adjunto o no se ha seleccionado uno nuevo.\nPresiona "Cambiar Foto" o "Cambiar Video" para añadir o reemplazar.',
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.white70, fontFamily: 'Comic Sans MS'),
        ),
      ),
    );
  }

  Widget _buildPlayPauseOverlayPreview(VideoPlayerController controller) {
    return GestureDetector(
      onTap: () {
        if (!controller.value.isInitialized) return;
        setState(() {
          if (controller.value.isPlaying) {
            controller.pause();
          } else {
            controller.play();
          }
        });
      },
      child: AnimatedOpacity(
        opacity: (controller.value.isInitialized && !controller.value.isPlaying) ? 1.0 : 0.0,
        duration: const Duration(milliseconds: 300),
        child: Container(
          color: Colors.black26,
          child: const Center(
            child: Icon(
              Icons.play_circle_outline,
              color: Colors.white,
              size: 60.0,
            ),
          ),
        ),
      ),
    );
  }
}


// --- CLASE _VideoPlayerWidget ---
class _VideoPlayerWidget extends StatefulWidget {
  final String videoUrl;
  const _VideoPlayerWidget({Key? key, required this.videoUrl}) : super(key: key);

  @override
  __VideoPlayerWidgetState createState() => __VideoPlayerWidgetState();
}

class __VideoPlayerWidgetState extends State<_VideoPlayerWidget> {
  late VideoPlayerController _controller;
  late Future<void> _initializeVideoPlayerFuture;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _initializePlayer();
  }

  @override
  void didUpdateWidget(covariant _VideoPlayerWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.videoUrl != oldWidget.videoUrl) {
      _controller.dispose();
      _initializePlayer();
    }
  }


  void _initializePlayer() {
    _hasError = false; // Resetear error en reinicialización
    Uri? uri = Uri.tryParse(widget.videoUrl);
    // Corrección: para web, !uri.isAbsolute puede ser falso para blob URLs, que son válidas.
    // Es mejor chequear si la URI es nula. Si no es absoluta Y no es web Y no es un path local, entonces es inválida.
    if (uri == null || (!uri.isAbsolute && !kIsWeb && !widget.videoUrl.startsWith('/'))) {
      developer.log("URL de video inválida o no absoluta para VideoPlayer: ${widget.videoUrl}", name: "VideoPlayer");
      if (mounted) {
        setState(() {
          _hasError = true;
        });
      }
      _initializeVideoPlayerFuture = Future.error("URL inválida: ${widget.videoUrl}");
      return;
    }

    _controller = VideoPlayerController.networkUrl(uri);
    _initializeVideoPlayerFuture = _controller.initialize().then((_) {
      if (mounted) {
        setState(() {});
      }
    }).catchError((error) {
      developer.log("Error inicializando VideoPlayer: $error, URL: ${widget.videoUrl}", name: "VideoPlayer", error: error);
      if (mounted) {
        setState(() {
          _hasError = true;
        });
      }
    });
    _controller.setLooping(true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_hasError) {
      return _buildVideoErrorWidget();
    }

    return FutureBuilder(
      future: _initializeVideoPlayerFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done && !_hasError) {
          if (_controller.value.hasError) {
            developer.log("Error en VideoPlayerController: ${_controller.value.errorDescription}, URL: ${widget.videoUrl}", name: "VideoPlayer", error: _controller.value.errorDescription);
            return _buildVideoErrorWidget();
          }
          if (!_controller.value.isInitialized) {
            // Esto puede pasar si hay un error después de 'done' pero antes de setear _hasError.
            // O si el controlador no se inicializó correctamente por alguna razón no capturada por el catchError.
            developer.log("VideoPlayerController no inicializado después de Future. URL: ${widget.videoUrl}", name: "VideoPlayer");
            return const Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Color(0xff4ec8dd))));
          }

          final videoAspectRatio = _controller.value.aspectRatio;
          final validAspectRatio = (videoAspectRatio > 0 && videoAspectRatio.isFinite) ? videoAspectRatio : 16/9;

          return AspectRatio(
            aspectRatio: validAspectRatio,
            child: Stack(
              alignment: Alignment.center,
              children: [
                VideoPlayer(_controller),
                _buildPlayPauseOverlay(),
              ],
            ),
          );
        } else if (snapshot.hasError || _hasError) {
          developer.log("Error en FutureBuilder de VideoPlayer: ${snapshot.error}, URL: ${widget.videoUrl}", name: "VideoPlayer", error: snapshot.error);
          return _buildVideoErrorWidget();
        }
        else {
          return const Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Color(0xff4ec8dd))));
        }
      },
    );
  }

  Widget _buildPlayPauseOverlay() {
    return GestureDetector(
      onTap: () {
        if (!_controller.value.isInitialized) return;
        setState(() {
          if (_controller.value.isPlaying) {
            _controller.pause();
          } else {
            _controller.play();
          }
        });
      },
      child: AnimatedOpacity(
        opacity: (_controller.value.isInitialized && !_controller.value.isPlaying) ? 1.0 : 0.0,
        duration: const Duration(milliseconds: 300),
        child: Container(
          color: Colors.black26,
          child: Center(
            child: Icon(
              Icons.play_arrow, // Siempre mostrar play, el overlay solo aparece cuando está pausado
              color: Colors.white,
              size: 50.0,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildVideoErrorWidget() {
    return Container(
      width: double.infinity,
      height: 200,
      color: Colors.black,
      child: const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, color: Colors.red, size: 40),
          SizedBox(height: 8),
          Text(
            'Error al cargar el video',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white, fontSize: 14, fontFamily: 'Comic Sans MS'),
          ),
        ],
      ),
    );
  }
}