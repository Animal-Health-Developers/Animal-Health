import 'package:flutter/material.dart';
import 'package:adobe_xd/pinned.dart';
import './Home.dart'; // Ocultar Home para evitar conflicto con la clase Home de este archivo si existiera
import 'package:adobe_xd/page_link.dart';
import './Ayuda.dart';
import './PerfilPublico.dart';
import './Configuracion.dart';
import './ListadeAnimales.dart';
import './CompradeProductos.dart';
import '../services/auth_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:video_player/video_player.dart';
import 'dart:developer' as developer;
import './CompartirPublicacion.dart'; // Importar CompartirPublicacion

// --- VideoPlayerWidget (sin cambios, se asume que está aquí o importado) ---
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
            developer.log("Error en VideoPlayerController: ${_controller.value.errorDescription}, URL: ${widget.videoUrl}");
            return _buildVideoErrorWidget();
          }
          if (!_controller.value.isInitialized) {
            return const Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Color(0xff4ec8dd))));
          }

          final videoAspectRatio = _controller.value.aspectRatio;
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
        opacity: _controller.value.isPlaying && _controller.value.isInitialized ? 0.0 : 1.0,
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
// --- FIN VideoPlayerWidget ---


class DetallesdeFotooVideo extends StatefulWidget {
  final String publicationId;
  final String? mediaUrl;
  final bool isVideo;
  final String? caption;
  final String? ownerUserId;
  final String? ownerUserName;
  final String? ownerUserProfilePic;

  DetallesdeFotooVideo({
    required Key key,
    required this.publicationId,
    this.mediaUrl,
    this.isVideo = false,
    this.caption,
    this.ownerUserId,
    this.ownerUserName,
    this.ownerUserProfilePic,
  }) : super(key: key);

  @override
  _DetallesdeFotooVideoState createState() => _DetallesdeFotooVideoState();
}

class _DetallesdeFotooVideoState extends State<DetallesdeFotooVideo> {
  final TextEditingController _commentController = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool _isPostingComment = false;

  // --- FUNCIONES COPIADAS Y ADAPTADAS DE Home.dart ---
  Future<void> _toggleLike(String postId, String? userId, List<String> likedBy) async {
    if (userId == null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Debes iniciar sesión para dar like')),
        );
      }
      return;
    }
    try {
      final postRef = _firestore.collection('publicaciones').doc(postId);
      await _firestore.runTransaction((transaction) async {
        final postSnapshot = await transaction.get(postRef);
        if (!postSnapshot.exists) {
          developer.log('Error: Publicación no encontrada para dar like: $postId', name: "Detalles.Like");
          throw Exception("Publicación no encontrada.");
        }
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
      developer.log('Error al actualizar like: $e', error: e, name: "Detalles.Like");
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error al actualizar like: ${e.toString().substring(0, (e.toString().length > 50) ? 50 : e.toString().length)}...')));
      }
    }
  }

  Future<void> _guardarPublicacion(String publicacionId) async {
    try {
      final user = _auth.currentUser;
      if (user == null) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Debes iniciar sesión para guardar publicaciones')));
        }
        return;
      }
      await _firestore.collection('publicaciones_guardadas').doc(user.uid).collection('guardados').doc(publicacionId).set({
        'publicacionId': publicacionId,
        'fechaGuardado': FieldValue.serverTimestamp(),
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Publicación guardada correctamente'), backgroundColor: Colors.green));
      }
    } catch (e) {
      developer.log('Error al guardar publicación: $e', error: e, name: "Detalles.Save");
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error al guardar: ${e.toString().substring(0, (e.toString().length > 50) ? 50 : e.toString().length)}...'), backgroundColor: Colors.red));
      }
    }
  }
  // --- FIN FUNCIONES COPIADAS ---

  Future<void> _addComment() async {
    final User? currentUser = _auth.currentUser;
    if (currentUser == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Debes iniciar sesión para comentar')),
      );
      return;
    }
    if (_commentController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('El comentario no puede estar vacío')),
      );
      return;
    }

    setState(() {
      _isPostingComment = true;
    });

    try {
      DocumentSnapshot userDoc = await _firestore.collection('users').doc(currentUser.uid).get();
      String userName = userDoc.get('userName') ?? 'Usuario Anónimo';
      String? userProfilePic = userDoc.get('profilePhotoUrl');

      await _firestore
          .collection('publicaciones')
          .doc(widget.publicationId)
          .collection('comentarios')
          .add({
        'texto': _commentController.text.trim(),
        'usuarioId': currentUser.uid,
        'usuarioNombre': userName,
        'usuarioFotoUrl': userProfilePic,
        'timestamp': FieldValue.serverTimestamp(),
      });

      // Actualizar contador de comentarios en el documento principal de la publicación
      await _firestore
          .collection('publicaciones')
          .doc(widget.publicationId)
          .update({'comentarios': FieldValue.increment(1)});

      _commentController.clear();
      FocusScope.of(context).unfocus();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Comentario añadido'), backgroundColor: Colors.green),
      );
    } catch (e) {
      developer.log('Error al añadir comentario: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al añadir comentario: $e'), backgroundColor: Colors.red),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isPostingComment = false;
        });
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    final bool hasValidMedia = widget.mediaUrl != null && widget.mediaUrl!.isNotEmpty;
    final currentUserId = _auth.currentUser?.uid;

    return Scaffold(
      backgroundColor: const Color(0xff000000),
      body: Stack(
        children: <Widget>[
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/Animal Health Fondo de Pantalla.png'),
                fit: BoxFit.cover,
              ),
            ),
            margin: const EdgeInsets.symmetric(horizontal: 0.0, vertical: 0.0),
          ),

          // --- WIDGETS DE NAVEGACIÓN SUPERIOR (Logo, Atrás, Ayuda, Perfil, Config, Lista Animales, Tienda) ---
          // ... (tu código existente para estos botones, sin cambios) ...
          Pinned.fromPins(
            Pin(size: 74.0, middle: 0.5),
            Pin(size: 73.0, start: 42.0),
            child: PageLink( // Permite volver a Home al tocar el logo
              links: [
                PageLinkInfo(
                  transition: LinkTransition.Fade,
                  ease: Curves.easeOut,
                  duration: 0.3,
                  pageBuilder: () => Home(key: Key('HomeFromDetails')),
                ),
              ],
              child: Container(
                decoration: BoxDecoration(
                  image: const DecorationImage(
                    image: AssetImage('assets/images/logo.png'),
                    fit: BoxFit.cover,
                  ),
                  borderRadius: BorderRadius.circular(15.0),
                  border:
                  Border.all(width: 1.0, color: const Color(0xff000000)),
                ),
              ),
            ),
          ),

          // Botón de "Atrás" (Volver)
          Pinned.fromPins(
            Pin(size: 52.9, start: 9.1),
            Pin(size: 50.0, start: 49.0),
            child: GestureDetector( // Usamos GestureDetector para Navigator.pop
              onTap: () {
                Navigator.pop(context);
              },
              child: Container(
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/back.png'),
                    fit: BoxFit.fill,
                  ),
                ),
              ),
            ),
          ),

          // Botón de ayuda (igual que en Home)
          Pinned.fromPins(
            Pin(size: 40.5, middle: 0.8328),
            Pin(size: 50.0, start: 49.0),
            child: PageLink(
              links: [
                PageLinkInfo(
                  transition: LinkTransition.Fade,
                  ease: Curves.easeOut,
                  duration: 0.3,
                  pageBuilder: () => Ayuda(key: Key('AyudaFromDetails')),
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

          // Botón de perfil del usuario actual (igual que en Home)
          Pinned.fromPins(
            Pin(size: 60.0, start: 13.0),
            Pin(size: 60.0, start: 115.0),
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
                      pageBuilder: () => PerfilPublico(key: const Key('PerfilPublicoFromDetails')),
                    ),
                  ],
                  child: Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      color: Colors.grey[200],
                      border: Border.all(color: const Color(0xff000000), width: 1.0),
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
                            developer.log('Error CachedNetworkImage (Perfil en Detalles): $error, URL: $url');
                            return const Center(child: Icon(Icons.person, size: 30, color: Colors.grey));
                          })
                          : const Center(child: Icon(Icons.person, size: 30, color: Colors.grey)),
                    ),
                  ),
                );
              },
            ),
          ),

          // Botón de configuración (igual que en Home)
          Pinned.fromPins(
            Pin(size: 47.2, end: 7.6),
            Pin(size: 50.0, start: 49.0),
            child: PageLink(
              links: [
                PageLinkInfo(
                  transition: LinkTransition.Fade,
                  ease: Curves.easeOut,
                  duration: 0.3,
                  pageBuilder: () => Configuraciones(key: Key('SettingsFromDetails'), authService: AuthService()),
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

          // Botón de lista de animales
          Pinned.fromPins(
            Pin(size: 60.1, start: 13.0),
            Pin(size: 60.0, start: 180.0),
            child: PageLink(
              links: [
                PageLinkInfo(
                  transition: LinkTransition.Fade,
                  ease: Curves.easeOut,
                  duration: 0.3,
                  pageBuilder: () => ListadeAnimales(key: Key('ListadeAnimalesFromDetails')),
                ),
              ],
              child: Container(
                decoration: BoxDecoration(
                  image: const DecorationImage(
                    image: AssetImage('assets/images/listaanimales.png'),
                    fit: BoxFit.fill,
                  ),
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
            ),
          ),

          // Botón de tienda
          Pinned.fromPins(
            Pin(size: 58.5, end: 7.6),
            Pin(size: 60.0, start: 115.0),
            child: PageLink(
              links: [
                PageLinkInfo(
                  transition: LinkTransition.Fade,
                  ease: Curves.easeOut,
                  duration: 0.3,
                  pageBuilder: () => CompradeProductos(key: Key('CompradeProductosFromDetails')),
                ),
              ],
              child: Container(
                decoration: BoxDecoration(
                  image: const DecorationImage(
                    image: AssetImage('assets/images/store.png'),
                    fit: BoxFit.fill,
                  ),
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
            ),
          ),
          // --- FIN WIDGETS DE NAVEGACIÓN SUPERIOR ---

          Positioned(
            top: 250.0,
            left: 0,
            right: 0,
            bottom: 0,
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        // Contenedor para la foto/video y su info
                        Container(
                          padding: const EdgeInsets.all(8.0),
                          margin: const EdgeInsets.only(bottom: 10.0), // Reducido margen inferior
                          decoration: BoxDecoration(
                            color: const Color(0xe3a0f4fe),
                            borderRadius: BorderRadius.circular(9.0),
                            border: Border.all(width: 1.0, color: const Color(0xe3000000)),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Info del publicador
                              Row(
                                children: [
                                  CircleAvatar(
                                    radius: 20,
                                    backgroundColor: Colors.grey[300],
                                    backgroundImage: widget.ownerUserProfilePic != null && widget.ownerUserProfilePic!.isNotEmpty
                                        ? CachedNetworkImageProvider(widget.ownerUserProfilePic!)
                                        : null,
                                    child: widget.ownerUserProfilePic == null || widget.ownerUserProfilePic!.isEmpty
                                        ? const Icon(Icons.person, size: 20, color: Colors.white)
                                        : null,
                                  ),
                                  const SizedBox(width: 10),
                                  Text(
                                    widget.ownerUserName ?? 'Usuario',
                                    style: const TextStyle(
                                      fontFamily: 'Comic Sans MS',
                                      fontSize: 18,
                                      color: Color(0xff000000),
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              // Caption
                              if (widget.caption != null && widget.caption!.isNotEmpty)
                                Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                                  child: Text(
                                    widget.caption!,
                                    style: const TextStyle(
                                      fontFamily: 'Comic Sans MS',
                                      fontSize: 16,
                                      color: Color(0xff000000),
                                    ),
                                  ),
                                ),
                              // Media (Foto o Video)
                              if (hasValidMedia)
                                SizedBox(
                                  width: double.infinity,
                                  child: widget.isVideo
                                      ? _VideoPlayerWidget(videoUrl: widget.mediaUrl!)
                                      : ClipRRect(
                                    borderRadius: BorderRadius.circular(8.0),
                                    child: CachedNetworkImage(
                                      imageUrl: widget.mediaUrl!,
                                      fit: BoxFit.cover,
                                      placeholder: (context, url) => Container(
                                        height: 200,
                                        color: Colors.grey[200],
                                        child: const Center(child: CircularProgressIndicator()),
                                      ),
                                      errorWidget: (context, url, error) => Container(
                                        height: 200,
                                        color: Colors.grey[200],
                                        child: const Center(child: Icon(Icons.error, color: Colors.red)),
                                      ),
                                    ),
                                  ),
                                )
                              else
                                Container(
                                  height: 200,
                                  width: double.infinity,
                                  color: Colors.grey[200],
                                  child: const Center(child: Text('Contenido no disponible', style: TextStyle(fontFamily: 'Comic Sans MS'))),
                                ),

                              // --- BOTONES DE ACCIÓN (LIKE, COMMENT, SHARE, SAVE) ---
                              StreamBuilder<DocumentSnapshot>(
                                  stream: _firestore.collection('publicaciones').doc(widget.publicationId).snapshots(),
                                  builder: (context, snapshot) {
                                    if (!snapshot.hasData) {
                                      // Muestra placeholders o nada mientras cargan los datos
                                      return const Padding(
                                        padding: EdgeInsets.symmetric(vertical: 8.0),
                                        child: Center(child: SizedBox(height: 40, width:40, child: CircularProgressIndicator(strokeWidth: 2))),
                                      );
                                    }
                                    final publicacionData = snapshot.data;
                                    if (publicacionData == null || !publicacionData.exists) {
                                      return const SizedBox.shrink(); // No mostrar nada si la publicación no existe
                                    }
                                    return _buildActionButtons(publicacionData, currentUserId);
                                  }
                              ),
                              // --- FIN BOTONES DE ACCIÓN ---
                            ],
                          ),
                        ),

                        // Sección de Comentarios
                        const Text(
                          'Comentarios:',
                          style: TextStyle(
                            fontFamily: 'Comic Sans MS',
                            fontSize: 20,
                            color: Color(0xffffffff),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 10),
                        _buildCommentsList(),
                      ],
                    ),
                  ),
                ),
                _buildAddCommentField(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(DocumentSnapshot publicacion, String? currentUserId) {
    final likes = publicacion['likes'] as int? ?? 0;
    final likedBy = List<String>.from(publicacion['likedBy'] as List<dynamic>? ?? []);
    // Obtener contador de comentarios del documento principal de la publicación
    final comentariosCount = publicacion['comentarios'] as int? ?? 0;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0.0, vertical: 8.0), // Ajustado el padding horizontal
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          // Botón de Like
          GestureDetector(
            onTap: () => _toggleLike(widget.publicationId, currentUserId, likedBy),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset('assets/images/like.png', width: 40, height: 40), // Tamaño reducido
                const SizedBox(width: 4),
                Text(
                  likes.toString(),
                  style: const TextStyle(fontFamily: 'Comic Sans MS', fontSize: 14, color: Colors.black), // Tamaño reducido
                ),
              ],
            ),
          ),
          // Botón de Comentarios (solo muestra contador)
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset('assets/images/comments.png', width: 40, height: 40), // Tamaño reducido
              const SizedBox(width: 4),
              Text(
                comentariosCount.toString(), // Usa el contador del documento principal
                style: const TextStyle(fontFamily: 'Comic Sans MS', fontSize: 14, color: Colors.black), // Tamaño reducido
              ),
            ],
          ),
          // Botón de Compartir
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CompartirPublicacion(
                    key: Key('CompartirDesdeDetalles_${widget.publicationId}'), publicationId: '',
                    // Asegúrate que CompartirPublicacion acepte estos parámetros
                    // publicationId: widget.publicationId,
                    // mediaUrl: widget.mediaUrl,
                    // caption: widget.caption,
                  ),
                ),
              );
            },
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset('assets/images/share.png', width: 40, height: 40), // Tamaño reducido
                const SizedBox(width: 4),
                // Opcional: Texto "SHARE" si cabe y se desea
                // const Text('SHARE', style: TextStyle(fontFamily: 'Comic Sans MS', fontSize: 14)),
              ],
            ),
          ),
          // Botón de Guardar
          GestureDetector(
            onTap: () => _guardarPublicacion(widget.publicationId),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset('assets/images/save.png', width: 40, height: 40), // Tamaño reducido
                const SizedBox(width: 4),
                // Opcional: Texto "Guardar" si cabe y se desea
                // const Text('Guardar', style: TextStyle(fontFamily: 'Comic Sans MS', fontSize: 14)),
              ],
            ),
          ),
        ],
      ),
    );
  }


  Widget _buildCommentsList() {
    return StreamBuilder<QuerySnapshot>(
      stream: _firestore
          .collection('publicaciones')
          .doc(widget.publicationId)
          .collection('comentarios')
          .orderBy('timestamp', descending: false)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.white)));
        }
        if (snapshot.hasError) {
          developer.log('Error cargando comentarios: ${snapshot.error}');
          return const Center(child: Text('Error al cargar comentarios.', style: TextStyle(color: Colors.white)));
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(child: Text('No hay comentarios aún. ¡Sé el primero!', style: TextStyle(color: Colors.white, fontFamily: 'Comic Sans MS')));
        }

        final comments = snapshot.data!.docs;

        return ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: comments.length,
          itemBuilder: (context, index) {
            final comment = comments[index].data() as Map<String, dynamic>;
            final commenterName = comment['usuarioNombre'] ?? 'Usuario Anónimo';
            final commenterText = comment['texto'] ?? '';
            final commenterPhotoUrl = comment['usuarioFotoUrl'] as String?;

            return Container(
              margin: const EdgeInsets.symmetric(vertical: 6.0),
              padding: const EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                  color: const Color(0xAAFFFFFF),
                  borderRadius: BorderRadius.circular(8.0),
                  border: Border.all(color: Colors.black54)
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 18,
                    backgroundColor: Colors.grey[200],
                    backgroundImage: commenterPhotoUrl != null && commenterPhotoUrl.isNotEmpty
                        ? CachedNetworkImageProvider(commenterPhotoUrl)
                        : null,
                    child: (commenterPhotoUrl == null || commenterPhotoUrl.isEmpty)
                        ? const Icon(Icons.person, size: 18, color: Colors.grey)
                        : null,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          commenterName,
                          style: const TextStyle(
                            fontFamily: 'Comic Sans MS',
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                            fontSize: 15,
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          commenterText,
                          style: const TextStyle(
                            fontFamily: 'Comic Sans MS',
                            color: Colors.black87,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildAddCommentField() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.8),
        border: const Border(top: BorderSide(color: Colors.grey)),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _commentController,
              style: const TextStyle(color: Colors.white, fontFamily: 'Comic Sans MS'),
              decoration: const InputDecoration(
                hintText: 'Añade un comentario...',
                hintStyle: TextStyle(color: Colors.white54, fontFamily: 'Comic Sans MS'),
                border: InputBorder.none,
              ),
              textInputAction: TextInputAction.send,
              onSubmitted: (_) => _isPostingComment ? null : _addComment(),
            ),
          ),
          _isPostingComment
              ? const Padding(
            padding: EdgeInsets.all(8.0),
            child: SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, valueColor: AlwaysStoppedAnimation<Color>(Colors.white))),
          )
              : IconButton(
            icon: const Icon(Icons.send, color: Colors.white),
            onPressed: _addComment,
          ),
        ],
      ),
    );
  }
}