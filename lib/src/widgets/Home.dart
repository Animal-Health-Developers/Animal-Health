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
import 'dart:developer' as developer; // Import for logging

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

          // Botón de perfil - Ahora muestra la foto del usuario desde Firestore
          Pinned.fromPins(
            Pin(size: 60.0, start: 6.0),
            Pin(size: 60.0, middle: 0.1947),
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
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Color(0xff4ec8dd),
                              ),
                            ),
                          ),
                          errorWidget: (context, url, error) {
                            developer.log('Error CachedNetworkImage (Perfil): $error, URL: $url');
                            // Fallback a Image.network si CachedNetworkImage falla
                            return Image.network(
                              profilePhotoUrl, // Usar la misma URL
                              fit: BoxFit.cover,
                              loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                                if (loadingProgress == null) return child;
                                return Center(
                                  child: CircularProgressIndicator(
                                    value: loadingProgress.expectedTotalBytes != null
                                        ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                                        : null,
                                  ),
                                );
                              },
                              errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
                                developer.log('Error Image.network (Perfil Fallback): $exception, URL: $url');
                                return const Center(
                                  child: Icon(
                                    Icons.person,
                                    size: 30,
                                    color: Colors.grey,
                                  ),
                                );
                              },
                            );
                          }
                      )
                          : const Center(
                        child: Icon(
                          Icons.person,
                          size: 30,
                          color: Colors.grey,
                        ),
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
            child: PageLink(
              links: [
                PageLinkInfo(
                  transition: LinkTransition.Fade,
                  ease: Curves.easeOut,
                  duration: 0.3,
                  pageBuilder:
                      () => Configuraciones(
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
                  pageBuilder:
                      () => CompradeProductos(
                    key: const Key('CompradeProductos'),
                  ),
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
                  pageBuilder:
                      () => ListadeAnimales(key: const Key('ListadeAnimales')),
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
                  pageBuilder:
                      () => CuidadosyRecomendaciones(
                    key: const Key('CuidadosyRecomendaciones'),
                  ),
                ),
              ],
              child: Container(
                width: 63.0,
                height: 60.0,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(
                      'assets/images/cuidadosrecomendaciones.png',
                    ),
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
                  pageBuilder:
                      () => Crearpublicaciones(
                    key: const Key('Crearpublicaciones'),
                  ),
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

          // Lista de publicaciones (cambios principales aquí)
          Pinned.fromPins(
            Pin(start: 16.0, end: 16.0),
            Pin(start: 240.0, end: 0.0),
            child: StreamBuilder<QuerySnapshot>(
              stream:
              FirebaseFirestore.instance
                  .collection('publicaciones')
                  .orderBy('fecha', descending: true)
                  .snapshots(),
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
                  removeBottom: true,
                  child: ListView.builder(
                    padding: EdgeInsets.zero,
                    physics: const ClampingScrollPhysics(),
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

  Widget _buildPublicacionItem(
      DocumentSnapshot publicacion,
      BuildContext context,
      ) {
    final mediaUrl = publicacion['imagenUrl'] as String?;
    final isVideo = (publicacion['esVideo'] as bool?) ?? false;
    final hasValidMedia = mediaUrl != null && mediaUrl.isNotEmpty;
    final currentUserId = FirebaseAuth.instance.currentUser?.uid;
    final postOwnerId = publicacion['usuarioId'] as String?;
    final isOwnPost = currentUserId != null && postOwnerId == currentUserId;
    final likes = publicacion['likes'] as int? ?? 0;
    final likedBy = List<String>.from(publicacion['likedBy'] ?? []);

    return Container(
      margin: const EdgeInsets.only(top: 10.0),
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
                            ? NetworkImage(profilePhotoUrl) // Usar NetworkImage para la foto de perfil en la publicación, podría ser CachedNetworkImage también.
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
            SizedBox( // Changed from Container to SizedBox to avoid redundant width
              width: double.infinity, // This ensures it takes the parent's width
              child:
              isVideo
                  ? _VideoPlayerWidget(videoUrl: mediaUrl) // Added null check assertion
                  : _buildImageWidget(mediaUrl, context), // Added null check assertion
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
                        key: const Key('DetallesdeFotooVideo'), // TODO: Pasar datos de la publicación
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
                          () => CompartirPublicacion( // TODO: Pasar datos de la publicación
                        key: const Key('CompartirPublicacion'),
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
      borderRadius: BorderRadius.circular(8.0),
      child: CachedNetworkImage(
        imageUrl: imageUrl,
        fit: BoxFit.cover,
        width: MediaQuery.of(context).size.width - 32, // Ancho de la imagen
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
          // Intenta cargar la imagen directamente como fallback
          return Image.network(
              imageUrl,
              fit: BoxFit.cover,
              width: MediaQuery.of(context).size.width - 32,
              height: 300,
              loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                if (loadingProgress == null) return child;
                return Center(
                  child: CircularProgressIndicator(
                    value: loadingProgress.expectedTotalBytes != null
                        ? loadingProgress.cumulativeBytesLoaded /
                        loadingProgress.expectedTotalBytes!
                        : null,
                  ),
                );
              },
              errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
                developer.log('Error Image.network (Publicación Fallback): $exception, URL: $url');
                return _buildImageErrorWidget();
              }
          );
        },
      ),
    );
  }

  Widget _buildImageErrorWidget() {
    return Container(
      width: double.infinity, // Asegura que tome el ancho disponible
      height: 200, // Altura del widget de error
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
      width: double.infinity, // Asegura que tome el ancho disponible
      height: 200, // Altura del widget sin imagen
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

  Future<void> _toggleLike(
      String postId,
      String? userId,
      List<String> likedBy,
      BuildContext context,
      ) async {
    if (userId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Debes iniciar sesión para dar like')),
      );
      return;
    }

    try {
      final postRef = FirebaseFirestore.instance
          .collection('publicaciones')
          .doc(postId);

      await FirebaseFirestore.instance.runTransaction((transaction) async {
        final postSnapshot = await transaction.get(postRef);
        if (!postSnapshot.exists) {
          developer.log('Error: Publicación no encontrada para dar like: $postId');
          throw Exception("Publicación no encontrada.");
        }

        // Asegurarse de que 'likedBy' es una lista, incluso si es null en Firestore.
        List<String> currentLikedBy = List<String>.from(postSnapshot.data()?['likedBy'] as List<dynamic>? ?? []);
        final bool isLiked = currentLikedBy.contains(userId);

        List<String> newLikedBy;
        if (isLiked) {
          newLikedBy = currentLikedBy.where((id) => id != userId).toList();
        } else {
          newLikedBy = [...currentLikedBy, userId];
        }

        transaction.update(postRef, {
          'likes': newLikedBy.length,
          'likedBy': newLikedBy,
        });
      });
    } catch (e) {
      developer.log('Error al actualizar like: $e');
      if (context.mounted) { // Verificar si el widget está montado
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error al actualizar like: ${e.toString().substring(0, (e.toString().length > 50) ? 50 : e.toString().length)}...')));
      }
    }
  }

  Future<void> _guardarPublicacion(
      String publicacionId,
      BuildContext context,
      ) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Debes iniciar sesión para guardar publicaciones'),
            ),
          );
        }
        return;
      }

      await FirebaseFirestore.instance
          .collection('publicaciones_guardadas')
          .doc(user.uid)
          .collection('guardados')
          .doc(publicacionId)
          .set({
        'publicacionId': publicacionId,
        'fechaGuardado': FieldValue.serverTimestamp(),
      });
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Publicación guardada correctamente'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      developer.log('Error al guardar publicación: $e');
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al guardar: ${e.toString().substring(0, (e.toString().length > 50) ? 50 : e.toString().length)}...'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _eliminarPublicacion(
      String publicacionId,
      BuildContext context,
      ) async {
    // TODO: Considerar eliminar también la imagen de Firebase Storage
    try {
      await FirebaseFirestore.instance
          .collection('publicaciones')
          .doc(publicacionId)
          .delete();
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Publicación eliminada correctamente'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      developer.log('Error al eliminar publicación: $e');
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al eliminar: ${e.toString().substring(0, (e.toString().length > 50) ? 50 : e.toString().length)}...'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}

class _VideoPlayerWidget extends StatefulWidget {
  final String videoUrl;

  const _VideoPlayerWidget({Key? key, required this.videoUrl}) : super(key: key); // Added Key

  @override
  __VideoPlayerWidgetState createState() => __VideoPlayerWidgetState();
}

class __VideoPlayerWidgetState extends State<_VideoPlayerWidget> {
  late VideoPlayerController _controller;
  late Future<void> _initializeVideoPlayerFuture;
  bool _isPlaying = false;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.networkUrl(Uri.parse(widget.videoUrl)); // Changed to networkUrl
    _initializeVideoPlayerFuture = _controller.initialize().then((_) {
      if (mounted) {
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
        if (snapshot.connectionState == ConnectionState.done && !_hasError) { // Check _hasError again
          if (_controller.value.hasError) { // Check controller error state
            developer.log("Error en VideoPlayerController: ${_controller.value.errorDescription}, URL: ${widget.videoUrl}");
            return _buildVideoErrorWidget();
          }
          if (!_controller.value.isInitialized) { // Check if initialized
            return const Center(child: CircularProgressIndicator());
          }

          final videoAspectRatio = _controller.value.aspectRatio;
          // final screenWidth = MediaQuery.of(context).size.width; // No es necesario si se usa AspectRatio correctamente

          return AspectRatio( // Usar AspectRatio para mantener la proporción del video
            aspectRatio: videoAspectRatio,
            child: Stack(
              alignment: Alignment.center,
              children: [
                VideoPlayer(_controller),
                _buildPlayPauseOverlay(),
              ],
            ),
          );
        } else if (snapshot.hasError || _hasError) { // Check snapshot error
          developer.log("Error en FutureBuilder de VideoPlayer: ${snapshot.error}, URL: ${widget.videoUrl}");
          return _buildVideoErrorWidget();
        }
        else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  Widget _buildPlayPauseOverlay() {
    return GestureDetector(
      onTap: () {
        if (!_controller.value.isInitialized) return; // No hacer nada si no está inicializado
        setState(() {
          if (_controller.value.isPlaying) {
            _controller.pause();
            _isPlaying = false;
          } else {
            _controller.play();
            _isPlaying = true;
          }
        });
      },
      child: AnimatedOpacity(
        opacity: _controller.value.isPlaying ? 0.0 : 1.0, // Ocultar si está reproduciendo
        duration: const Duration(milliseconds: 300),
        child: Container(
          color: Colors.black26,
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
      height: 200, // O la altura que prefieras para el error de video
      color: Colors.black,
      child: const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, color: Colors.red, size: 40),
          SizedBox(height: 8),
          Text(
            'Error al cargar el video',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white, fontSize: 14),
          ),
        ],
      ),
    );
  }
}