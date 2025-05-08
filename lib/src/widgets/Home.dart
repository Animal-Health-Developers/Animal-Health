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

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

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
                image: AssetImage('assets/images/Animal Health Fondo de Pantalla.png'),
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
            Pin(size: 307.0, end: 33.0),
            Pin(size: 45.0, middle: 0.1995),
            child: Stack(
              children: <Widget>[
                Container(
                  decoration: BoxDecoration(
                    color: const Color(0xffffffff),
                    borderRadius: BorderRadius.circular(5.0),
                    border: Border.all(width: 1.0, color: const Color(0xff707070)),
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

          // Botón de perfil
          Pinned.fromPins(
            Pin(size: 60.0, start: 6.0),
            Pin(size: 60.0, middle: 0.1947),
            child: PageLink(
              links: [
                PageLinkInfo(
                  transition: LinkTransition.Fade,
                  ease: Curves.easeOut,
                  duration: 0.3,
                  pageBuilder: () => PerfilPublico(key: const Key('PerfilPublico')),
                ),
              ],
              child: Container(
                decoration: BoxDecoration(
                  image: const DecorationImage(
                    image: AssetImage('assets/images/perfilusuario.jpeg'),
                    fit: BoxFit.fill,
                  ),
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
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
                  pageBuilder: () => Configuraciones(
                    key: const Key('Configuraciones'),
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

          // Botón de tienda
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
                  image: DecorationImage(
                    image: AssetImage('assets/images/listaanimales.png'),
                    fit: BoxFit.fill,
                  ),
                ),
              ),
            ),
          ),

          // Botón de noticias
          Pinned.fromPins(
            Pin(size: 54.3, start: 24.0),
            Pin(size: 60.0, middle: 0.2712),
            child: Container(
              decoration: BoxDecoration(
                image: const DecorationImage(
                  image: AssetImage('assets/images/noticias.png'),
                  fit: BoxFit.fill,
                ),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0xff9ff1fb),
                    offset: Offset(0, 3),
                    blurRadius: 6,
                  ),
                ],
              ),
            ),
          ),

          // Botón de cuidados y recomendaciones
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

          // Botón de emergencias
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

          // Botón de comunidad
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

          // Botón de crear publicación
          Pinned.fromPins(
            Pin(size: 53.6, end: 20.3),
            Pin(size: 60.0, middle: 0.2712),
            child: PageLink(
              links: [
                PageLinkInfo(
                  transition: LinkTransition.Fade,
                  ease: Curves.easeOut,
                  duration: 0.3,
                  pageBuilder: () => Crearpublicaciones(key: const Key('Crearpublicaciones')),
                ),
              ],
              child: Container(
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/crearpublicacion.png'),
                    fit: BoxFit.fill,
                  ),
                ),
              ),
            ),
          ),

          // Lista de publicaciones
          Pinned.fromPins(
            Pin(start: 16.0, end: 16.0),
            Pin(start: 240.0, end: 16.0),
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('publicaciones')
                  .orderBy('fecha', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(child: Text('No hay publicaciones aún'));
                }

                return ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    var publicacion = snapshot.data!.docs[index];
                    return _buildPublicacionItem(publicacion, context);
                  },
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
    final hasValidMedia = mediaUrl != null && mediaUrl.isNotEmpty && mediaUrl.startsWith('http');
    final currentUserId = FirebaseAuth.instance.currentUser?.uid;
    final postOwnerId = publicacion['usuarioId'] as String?;
    final isOwnPost = currentUserId != null && postOwnerId == currentUserId;
    final likes = publicacion['likes'] as int? ?? 0;
    final likedBy = List<String>.from(publicacion['likedBy'] ?? []);

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 0),
      decoration: BoxDecoration(
        color: const Color(0xe3a0f4fe),
        borderRadius: BorderRadius.circular(9.0),
        border: Border.all(width: 1.0, color: const Color(0xe3000000)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Encabezado de la publicación
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                // Foto de perfil
                PageLink(
                  links: [
                    PageLinkInfo(
                      transition: LinkTransition.Fade,
                      ease: Curves.easeOut,
                      duration: 0.3,
                      pageBuilder: () => PerfilPublico(key: const Key('PerfilPublico')),
                    ),
                  ],
                  child: CircleAvatar(
                    radius: 20,
                    backgroundImage: publicacion['usuarioFoto'] != null &&
                        publicacion['usuarioFoto'].toString().isNotEmpty
                        ? NetworkImage(publicacion['usuarioFoto'])
                        : const AssetImage('assets/images/perfilusuario.jpeg') as ImageProvider,
                  ),
                ),
                const SizedBox(width: 10),

                // Nombre de usuario y tipo de publicación
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

                // Botón de opciones (solo visible para publicaciones propias)
                if (isOwnPost)
                  PopupMenuButton<String>(
                    icon: const Icon(Icons.more_vert, color: Colors.black),
                    onSelected: (value) {
                      if (value == 'eliminar') {
                        _eliminarPublicacion(publicacion.id, context);
                      } else if (value == 'editar') {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Funcionalidad de edición en desarrollo')),
                        );
                      }
                    },
                    itemBuilder: (BuildContext context) => [
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
            LayoutBuilder(
              builder: (context, constraints) {
                final maxWidth = constraints.maxWidth;
                return Container(
                  width: maxWidth,
                  child: AspectRatio(
                    aspectRatio: isVideo ? 16/9 : 1, // Relación de aspecto para video o imagen
                    child: isVideo
                        ? _VideoPlayerWidget(videoUrl: mediaUrl!)
                        : ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: CachedNetworkImage(
                        imageUrl: mediaUrl!,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => Center(
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(const Color(0xff4ec8dd)),
                          ),
                        ),
                        errorWidget: (context, url, error) => _buildImageErrorWidget(),
                      ),
                    ),
                  ),
                );
              },
            )
          else
            _buildNoImageWidget(),

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

          // Botones (like, comentario, compartir, guardar)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                // Botón de Like
                GestureDetector(
                  onTap: () => _toggleLike(publicacion.id, currentUserId, likedBy, context),
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

                // Comentario
                PageLink(
                  links: [
                    PageLinkInfo(
                      transition: LinkTransition.Fade,
                      ease: Curves.easeOut,
                      duration: 0.3,
                      pageBuilder: () => DetallesdeFotooVideo(key: const Key('DetallesdeFotooVideo')),
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

                // Compartir
                PageLink(
                  links: [
                    PageLinkInfo(
                      transition: LinkTransition.Fade,
                      ease: Curves.easeOut,
                      duration: 0.3,
                      pageBuilder: () => CompartirPublicacion(key: const Key('CompartirPublicacion')),
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

                // Botón de Guardar
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

  Widget _buildImageErrorWidget() {
    return Container(
      height: 200,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, color: Colors.red, size: 50),
          const SizedBox(height: 10),
          const Text(
            'Error al cargar el contenido',
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
      height: 200,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.image_not_supported, size: 50, color: Colors.grey),
          const SizedBox(height: 10),
          const Text(
            'Contenido no disponible',
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
      final isLiked = likedBy.contains(userId);

      await FirebaseFirestore.instance.runTransaction((transaction) async {
        final postSnapshot = await transaction.get(postRef);
        if (!postSnapshot.exists) return;

        final currentLikedBy = List<String>.from(postSnapshot['likedBy'] ?? []);
        final newLikedBy = isLiked
            ? currentLikedBy.where((id) => id != userId).toList()
            : [...currentLikedBy, userId];

        transaction.update(postRef, {
          'likes': newLikedBy.length,
          'likedBy': newLikedBy,
        });
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al actualizar like: $e')),
      );
    }
  }

  Future<void> _guardarPublicacion(String publicacionId, BuildContext context) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Debes iniciar sesión para guardar publicaciones')),
        );
        return;
      }

      await FirebaseFirestore.instance
          .collection('usuarios')
          .doc(user.uid)
          .collection('guardados')
          .doc(publicacionId)
          .set({
        'publicacionId': publicacionId,
        'fechaGuardado': FieldValue.serverTimestamp(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Publicación guardada correctamente'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error al guardar: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _eliminarPublicacion(String publicacionId, BuildContext context) async {
    try {
      await FirebaseFirestore.instance
          .collection('publicaciones')
          .doc(publicacionId)
          .delete();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Publicación eliminada correctamente'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error al eliminar: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}

class _VideoPlayerWidget extends StatefulWidget {
  final String videoUrl;

  const _VideoPlayerWidget({required this.videoUrl});

  @override
  __VideoPlayerWidgetState createState() => __VideoPlayerWidgetState();
}

class __VideoPlayerWidgetState extends State<_VideoPlayerWidget> {
  late VideoPlayerController _controller;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(widget.videoUrl)
      ..initialize().then((_) {
        if (mounted) {
          setState(() {
            _isInitialized = true;
          });
        }
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        if (_isInitialized)
          AspectRatio(
            aspectRatio: _controller.value.aspectRatio,
            child: VideoPlayer(_controller),
          )
        else
          const Center(child: CircularProgressIndicator()),

        Center(
          child: IconButton(
            icon: Icon(
              _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
              color: Colors.white,
              size: 50,
            ),
            onPressed: () {
              setState(() {
                if (_controller.value.isPlaying) {
                  _controller.pause();
                } else {
                  _controller.play();
                }
              });
            },
          ),
        ),
      ],
    );
  }
}