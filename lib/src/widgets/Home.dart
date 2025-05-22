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
import 'package:google_generative_ai/google_generative_ai.dart'; // Importar Gemini
// import 'dart:convert'; // Para json.decode en _fetchImageFromUnsplash (si se usa)
// Para _fetchImageFromUnsplash (si se usa)

// --- CONFIGURACIÓN DE API KEYS ---

const String GEMINI_API_KEY_HOME = 'AIzaSyAgv8dNt1etzPz8Lnl39e8Seb6N8B3nenc'; // TU API KEY DE GEMINI AQUÍ
// ---------------------------------


class Home extends StatefulWidget { // Convertido a StatefulWidget
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> { // Estado para Home
  final TextEditingController _searchController = TextEditingController();
  GenerativeModel? _geminiModel;
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    _initializeGemini();
  }

  void _initializeGemini() {
    if (GEMINI_API_KEY_HOME.isNotEmpty && GEMINI_API_KEY_HOME != 'AIzaSyD4FUbajaBbCslYPKZNyF-WGwrJZPcBZss') {
      _geminiModel = GenerativeModel(
        model: 'gemini-pro',
        apiKey: GEMINI_API_KEY_HOME,
      );
      developer.log("Modelo Gemini inicializado en Home.");
    } else {
      developer.log("API Key de Gemini no configurada en Home. La búsqueda con IA no funcionará.");
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
      developer.log("Intento de búsqueda pero el modelo Gemini no está inicializado.");
      return;
    }

    setState(() {
      _isSearching = true;
    });

    try {
      final prompt = 'Busca información o un consejo de cuidado relevante para mascotas sobre: "$query". Proporciona una respuesta concisa y útil. Si es un animal, menciona algún dato curioso o consejo de cuidado principal. Si es un producto o servicio, describe brevemente su utilidad para mascotas.';
      final content = [Content.text(prompt)];
      final response = await _geminiModel!.generateContent(content).timeout(const Duration(seconds: 20));

      developer.log("Respuesta de Gemini para búsqueda '$query': ${response.text}");

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
      developer.log("Error al buscar con Gemini: $e");
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

  // Método para construir los items de la barra de navegación
  Widget _buildNavigationButtonItem({
    required String imagePath,
    bool isHighlighted = false,
    double? fixedWidth, // Para mantener los anchos originales
    double height = 60.0,
  }) {
    double itemWidth;
    if (fixedWidth != null) {
      itemWidth = fixedWidth;
    } else {
      // Fallback si no se provee ancho específico, aunque se recomienda hacerlo
      if (imagePath.contains('noticias')) itemWidth = 54.3;
      else if (imagePath.contains('cuidadosrecomendaciones')) itemWidth = 63.0;
      else if (imagePath.contains('emergencias')) itemWidth = 65.0;
      else if (imagePath.contains('comunidad')) itemWidth = 67.0;
      else if (imagePath.contains('crearpublicacion')) itemWidth = 53.6;
      else itemWidth = 60.0; // Default
    }

    return Container(
      width: itemWidth,
      height: height,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(imagePath),
          fit: BoxFit.fill, // Mantenemos BoxFit.fill como en el original
        ),
        boxShadow: isHighlighted
            ? const [BoxShadow(color: Color(0xff9ff1fb), offset: Offset(0, 3), blurRadius: 6)]
            : null,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff4ec8dd),
      body: Stack(
        children: <Widget>[
          // Fondo de pantalla
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

          // Logo
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

          // Botón de ayuda
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

          // Barra de búsqueda
          Pinned.fromPins(
            Pin(size: 307.0, middle: 0.5),
            Pin(size: 45.0, start: 150), // Ajustado start en lugar de middle para más control
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


          // Botón de perfil
          Pinned.fromPins(
            Pin(size: 60.0, start: 6.0),
            Pin(size: 60.0, middle: 0.1947), // Este middle es relativo a la altura disponible
            child: StreamBuilder<DocumentSnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('users')
                  .doc(FirebaseAuth.instance.currentUser?.uid)
                  .snapshots(),
              builder: (context, snapshot) {
                final profilePhotoUrl = snapshot.data?['profilePhotoUrl'] as String?;
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
                            developer.log('Error CachedNetworkImage (Perfil): $error, URL: $url');
                            return const Center(child: Icon(Icons.person, size: 30, color: Colors.grey));
                          })
                          : const Center(child: Icon(Icons.person, size: 30, color: Colors.grey)),
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

          // Botón de tienda
          Pinned.fromPins(
            Pin(size: 58.5, end: 2.0),
            Pin(size: 60.0, start: 105.0), // Ajustar este valor si es necesario
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

          // Botón de lista de animales
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

          // --- NUEVA SECCIÓN DE BOTONES DE NAVEGACIÓN ---
          Positioned(
            top: 200.0, // Posición vertical fija desde la parte superior
            left: 16.0,  // Margen izquierdo para la fila
            right: 16.0, // Margen derecho para la fila
            height: 60.0, // Altura de los botones
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween, // Distribuye el espacio entre los botones
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                // Botón de noticias (resaltado) - sin PageLink según el original
                _buildNavigationButtonItem(
                  imagePath: 'assets/images/noticias.png',
                  isHighlighted: true,
                  fixedWidth: 54.3,
                ),

                // Botón de cuidados y recomendaciones
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

                // Botón de emergencias
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

                // Botón de comunidad
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

                // Botón de crear publicación
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
          // --- FIN DE NUEVA SECCIÓN DE BOTONES DE NAVEGACIÓN ---

          // Lista de publicaciones
          Pinned.fromPins(
            Pin(start: 16.0, end: 16.0),
            Pin(start: 270.0, end: 0.0), // Ajustado start para estar debajo de los botones de navegación
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance.collection('publicaciones').orderBy('fecha', descending: true).snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  developer.log('Error en StreamBuilder (publicaciones): ${snapshot.error}');
                  return Center(child: Text('Error: ${snapshot.error}'));
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(child: Text('No hay publicaciones aún'));
                }
                return MediaQuery.removePadding(
                  context: context,
                  removeBottom: true, // Importante si hay elementos fijos abajo
                  removeTop: true, // Importante ya que estamos usando Pinned para posicionar
                  child: ListView.builder(
                    padding: EdgeInsets.zero, // Asegurar que no haya padding extra
                    // physics: const ClampingScrollPhysics(), // Puede ser útil
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
    final mediaUrl = publicacion['imagenUrl'] as String?;
    final isVideo = (publicacion['esVideo'] as bool?) ?? false;
    final hasValidMedia = mediaUrl != null && mediaUrl.isNotEmpty;
    final currentUserId = FirebaseAuth.instance.currentUser?.uid;
    final postOwnerId = publicacion['usuarioId'] as String?;
    final isOwnPost = currentUserId != null && postOwnerId == currentUserId;
    final likes = publicacion['likes'] as int? ?? 0;
    final likedBy = List<String>.from(publicacion['likedBy'] as List<dynamic>? ?? []); // Asegurar tipo

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
          // Encabezado de la publicación
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
                      pageBuilder:
                          () => PerfilPublico(key: const Key('PerfilPublico')), // TODO: Pasar el userId del publicador
                    ),
                  ],
                  child: StreamBuilder<DocumentSnapshot>(
                    stream:
                    FirebaseFirestore.instance
                        .collection('users')
                        .doc(publicacion['usuarioId'])
                        .snapshots(),
                    builder: (context, userSnapshot) {
                      if (userSnapshot.connectionState == ConnectionState.waiting) {
                        return const CircleAvatar(radius: 20, backgroundColor: Colors.grey, child: CircularProgressIndicator(strokeWidth: 2, valueColor: AlwaysStoppedAnimation<Color>(Colors.white)));
                      }
                      if (userSnapshot.hasError) {
                        developer.log('Error cargando datos de usuario para publicación: ${userSnapshot.error}');
                        return const CircleAvatar(radius: 20, backgroundColor: Colors.grey, child: Icon(Icons.error, color: Colors.white));
                      }
                      if (!userSnapshot.hasData || !userSnapshot.data!.exists) {
                        return const CircleAvatar(radius: 20, backgroundColor: Colors.grey, child: Icon(Icons.person, color: Colors.white));
                      }

                      final profilePhotoUrl =
                      userSnapshot.data?['profilePhotoUrl'] as String?;

                      return CircleAvatar(
                        radius: 20,
                        backgroundColor: Colors.grey[200],
                        backgroundImage:
                        profilePhotoUrl != null &&
                            profilePhotoUrl.isNotEmpty
                            ? NetworkImage(profilePhotoUrl) // CachedNetworkImage podría ser una opción aquí también
                            : null,
                        child:
                        profilePhotoUrl == null || profilePhotoUrl.isEmpty
                            ? const Icon(Icons.person, color: Colors.white)
                            : null,
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
                        publicacion['usuarioNombre'] ?? 'Usuario Anónimo',
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
                            width: 15,
                            height: 15,
                          ),
                          const SizedBox(width: 5),
                          Text(
                            publicacion['tipoPublicacion'] ?? 'Público',
                            style: const TextStyle(
                              fontFamily: 'Comic Sans MS',
                              fontSize: 14,
                            ),
                          ),
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
                        // TODO: Implementar edición o mostrar mensaje
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              'Funcionalidad de edición en desarrollo',
                            ),
                          ),
                        );
                      }
                    },
                    itemBuilder:
                        (BuildContext context) => [
                      const PopupMenuItem<String>(
                        value: 'editar',
                        child: Text('Editar publicación'),
                      ),
                      const PopupMenuItem<String>(
                        value: 'eliminar',
                        child: Text('Eliminar publicación'),
                      ),
                    ],
                  ),
              ],
            ),
          ),

          // Contenido multimedia
          if (hasValidMedia)
            SizedBox( // Se asegura que el contenido multimedia no desborde
              width: double.infinity, // Ocupa el ancho disponible en la tarjeta
              child:
              isVideo
                  ? _VideoPlayerWidget(videoUrl: mediaUrl!) // Aseguramos que mediaUrl no es null aquí
                  : _buildImageWidget(mediaUrl!, context), // Aseguramos que mediaUrl no es null aquí
            )
          else
            _buildNoImageWidget(), // Placeholder si no hay media

          // Caption
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              publicacion['caption'] ?? '',
              style: const TextStyle(
                fontFamily: 'Comic Sans MS',
                fontSize: 15,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),

          // Acciones (Like, Comment, Share, Save)
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 8.0,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                GestureDetector(
                  onTap:
                      () => _toggleLike(
                    publicacion.id,
                    currentUserId,
                    likedBy,
                    context,
                  ),
                  child: Row(
                    children: [
                      Image.asset(
                        'assets/images/like.png',
                        width: 40,
                        height: 40,
                      ),
                      const SizedBox(width: 5),
                      Text(
                        likes.toString(),
                        style: const TextStyle(
                          fontFamily: 'Comic Sans MS',
                          fontSize: 16,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),

                PageLink(
                  links: [
                    PageLinkInfo(
                      transition: LinkTransition.Fade,
                      ease: Curves.easeOut,
                      duration: 0.3,
                      pageBuilder:
                          () => DetallesdeFotooVideo(
                        key: const Key('DetallesdeFotooVideo'),
                        // TODO: Pasar datos de la publicación
                        // publicationId: publicacion.id,
                        // mediaUrl: mediaUrl,
                        // isVideo: isVideo,
                        // caption: publicacion['caption'],
                        // userName: publicacion['usuarioNombre'],
                        // userProfilePic: (userSnapshot.data?['profilePhotoUrl'] as String?), // Necesitarías obtener esto de alguna manera
                      ),
                    ),
                  ],
                  child: Row(
                    children: [
                      Image.asset(
                        'assets/images/comments.png',
                        width: 40,
                        height: 40,
                      ),
                      const SizedBox(width: 5),
                      Text(
                        (publicacion['comentarios'] as int? ?? 0).toString(),
                        style: const TextStyle(
                          fontFamily: 'Comic Sans MS',
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),

                PageLink(
                  links: [
                    PageLinkInfo(
                      transition: LinkTransition.Fade,
                      ease: Curves.easeOut,
                      duration: 0.3,
                      pageBuilder:
                          () => CompartirPublicacion(
                        key: const Key('CompartirPublicacion'),
                        // TODO: Pasar datos de la publicación
                        // publicationId: publicacion.id,
                        // mediaUrl: mediaUrl,
                        // caption: publicacion['caption'],
                      ),
                    ),
                  ],
                  child: Row(
                    children: [
                      Image.asset(
                        'assets/images/share.png',
                        width: 40,
                        height: 40,
                      ),
                      const SizedBox(width: 5),
                      const Text(
                        'SHARE',
                        style: TextStyle(
                          fontFamily: 'Comic Sans MS',
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),

                GestureDetector(
                  onTap: () => _guardarPublicacion(publicacion.id, context),
                  child: Row(
                    children: [
                      Image.asset(
                        'assets/images/save.png',
                        width: 40,
                        height: 40,
                      ),
                      const SizedBox(width: 5),
                      const Text(
                        'Guardar',
                        style: TextStyle(
                          fontFamily: 'Comic Sans MS',
                          fontSize: 16,
                        ),
                      ),
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
      borderRadius: BorderRadius.circular(8.0), //Consistente con el contenedor de la publicación
      child: CachedNetworkImage(
        imageUrl: imageUrl,
        fit: BoxFit.cover,
        // El ancho se tomará del SizedBox padre en _buildPublicacionItem
        // width: MediaQuery.of(context).size.width - 32, // -32 por los márgenes del Pinned y del Container
        height: 300, // Altura fija para la imagen
        placeholder: (context, url) => const Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(
              Color(0xff4ec8dd),
            ),
          ),
        ),
        errorWidget: (context, url, error) {
          developer.log('Error CachedNetworkImage (Publicación): $error, URL: $url');
          return _buildImageErrorWidget(); // Simplificado: usar directamente el widget de error
        },
      ),
    );
  }

  Widget _buildImageErrorWidget() {
    return Container(
      width: double.infinity,
      height: 200, // Coincide con _buildNoImageWidget
      color: Colors.grey[200],
      child: const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, color: Colors.red, size: 50),
          SizedBox(height: 10),
          Text(
            'Error al cargar el contenido',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Comic Sans MS',
              fontSize: 16,
              color: Colors.red,
            ),
          ),
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
          Text(
            'Contenido no disponible',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Comic Sans MS',
              fontSize: 16,
              color: Colors.grey,
            ),
          ),
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
          developer.log('Error: Publicación no encontrada para dar like: $postId');
          throw Exception("Publicación no encontrada.");
        }
        // Asegurar que likedBy es una lista de Strings
        List<String> currentLikedBy = List<String>.from(postSnapshot.data()?['likedBy'] as List<dynamic>? ?? []);

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
      developer.log('Error al actualizar like: $e');
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
      await FirebaseFirestore.instance.collection('publicaciones_guardadas').doc(user.uid).collection('guardados').doc(publicacionId).set({
        'publicacionId': publicacionId,
        'fechaGuardado': FieldValue.serverTimestamp(),
      });
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Publicación guardada correctamente'), backgroundColor: Colors.green));
      }
    } catch (e) {
      developer.log('Error al guardar publicación: $e');
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error al guardar: ${e.toString().substring(0, (e.toString().length > 50) ? 50 : e.toString().length)}...'), backgroundColor: Colors.red));
      }
    }
  }

  Future<void> _eliminarPublicacion(String publicacionId, BuildContext context) async {
    try {
      await FirebaseFirestore.instance.collection('publicaciones').doc(publicacionId).delete();
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Publicación eliminada correctamente'), backgroundColor: Colors.green));
      }
    } catch (e) {
      developer.log('Error al eliminar publicación: $e');
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error al eliminar: ${e.toString().substring(0, (e.toString().length > 50) ? 50 : e.toString().length)}...'), backgroundColor: Colors.red));
      }
    }
  }
}

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
    _controller = VideoPlayerController.networkUrl(Uri.parse(widget.videoUrl));
    _initializeVideoPlayerFuture = _controller.initialize().then((_) {
      if (mounted) {
        // Asegurar que el estado se actualice solo si el widget está montado
        setState(() {});
      }
    }).catchError((error) {
      developer.log("Error inicializando VideoPlayer: $error, URL: ${widget.videoUrl}");
      if (mounted) {
        setState(() {
          _hasError = true;
        });
      }
    });
    _controller.setLooping(true); // Opcional: si quieres que el video se repita
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
            developer.log("Error en VideoPlayerController: ${_controller.value.errorDescription}, URL: ${widget.videoUrl}");
            return _buildVideoErrorWidget();
          }
          if (!_controller.value.isInitialized) {
            // Muestra un indicador de carga si aún no está inicializado después de 'done'.
            return const Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Color(0xff4ec8dd))));
          }

          final videoAspectRatio = _controller.value.aspectRatio;
          // Se asegura que el AspectRatio sea válido
          final validAspectRatio = (videoAspectRatio > 0) ? videoAspectRatio : 16/9;


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
          developer.log("Error en FutureBuilder de VideoPlayer: ${snapshot.error}, URL: ${widget.videoUrl}");
          return _buildVideoErrorWidget();
        }
        else { // ConnectionState.waiting or active
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
        opacity: _controller.value.isPlaying && _controller.value.isInitialized ? 0.0 : 1.0,
        duration: const Duration(milliseconds: 300),
        child: Container(
          color: Colors.black26, // Fondo semitransparente para el botón
          child: Center(
            child: Icon(
              _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
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
      height: 200, // Altura estándar para errores de media
      color: Colors.black, // Fondo oscuro para errores de video
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