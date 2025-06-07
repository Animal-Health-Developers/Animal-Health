import 'package:flutter/material.dart';
import 'package:adobe_xd/pinned.dart';
// Asegúrate de que la importación de Home sea la correcta y que
// EditarPublicacionWidget sea accesible (puede que necesites moverlo
// a un archivo separado si no está ya en Home.dart o un archivo común).
import './Home.dart' hide Home; // Ocultar Home para evitar conflicto
import 'package:animal_health/src/widgets/Home.dart' as home_widgets; // Alias para acceder a EditarPublicacionWidget

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
import './CompartirPublicacion.dart';
import 'package:firebase_storage/firebase_storage.dart'; // Para eliminar de Storage

// --- VideoPlayerWidget ---
// (Ya la tienes definida, asegúrate que sea la misma versión que en Home.dart)
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
    Uri? uri = Uri.tryParse(widget.videoUrl);
    if (uri == null || !uri.isAbsolute) {
      developer.log("URL de video inválida o no absoluta para VideoPlayer: ${widget.videoUrl}", name: "VideoPlayerWidget.Init");
      if (mounted) {
        setState(() {
          _hasError = true;
        });
      }
      _initializeVideoPlayerFuture = Future.error("URL inválida");
      return;
    }

    _controller = VideoPlayerController.networkUrl(uri);
    _initializeVideoPlayerFuture = _controller.initialize().then((_) {
      if (mounted) {
        setState(() {});
      }
    }).catchError((error) {
      developer.log("Error inicializando VideoPlayer: $error, URL: ${widget.videoUrl}", name: "VideoPlayerWidget.Init");
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
  final String? ownerUserId; // ID del dueño de la publicación
  final String? ownerUserName; // Nombre del dueño de la publicación
  final String? ownerUserProfilePic; // Foto de perfil del dueño de la publicación

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
      // Guardar en la subcolección del usuario
      final userSavedPubRef = FirebaseFirestore.instance.collection('users').doc(user.uid).collection('publicacionesGuardadas').doc(publicacionId);
      final doc = await userSavedPubRef.get();

      if (doc.exists) {
        await userSavedPubRef.delete();
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Publicación eliminada de guardados'), backgroundColor: Colors.orangeAccent));
        }
      } else {
        await _firestore.collection('publicaciones_guardadas').doc(user.uid).collection('guardados').doc(publicacionId).set({
          'publicacionId': publicacionId,
          'fechaGuardado': FieldValue.serverTimestamp(),
        });
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Publicación guardada correctamente'), backgroundColor: Colors.green));
        }
      }
    } catch (e) {
      developer.log('Error al guardar publicación: $e', error: e, name: "Detalles.Save");
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error al guardar: ${e.toString().substring(0, (e.toString().length > 50) ? 50 : e.toString().length)}...'), backgroundColor: Colors.red));
      }
    }
  }

  // --- NUEVO: MÉTODOS DE EDICIÓN Y ELIMINACIÓN ADAPTADOS DE HOME ---
  Future<void> _eliminarPublicacion(String publicacionId) async {
    bool confirmar = await showDialog(
      context: context, // Usar el contexto de _DetallesdeFotooVideoState
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
      DocumentSnapshot postDoc = await _firestore.collection('publicaciones').doc(publicacionId).get();
      if (postDoc.exists) {
        final data = postDoc.data() as Map<String, dynamic>;
        final String? mediaUrlToDelete = data['imagenUrl'] as String?; // Asumiendo que este es el campo
        if (mediaUrlToDelete != null && mediaUrlToDelete.isNotEmpty) {
          // Solo intentar eliminar de Storage si es una URL de Firebase Storage
          if (mediaUrlToDelete.startsWith('https://firebasestorage.googleapis.com')) {
            try {
              await FirebaseStorage.instance.refFromURL(mediaUrlToDelete).delete();
              developer.log('Medio eliminado de Storage: $mediaUrlToDelete', name: "Detalles.DeleteStorage");
            } catch (storageError) {
              developer.log('Error eliminando medio de Storage: $storageError. URL: $mediaUrlToDelete', name: "Detalles.DeleteStorage", error: storageError);
            }
          }
        }
      }

      await _firestore.collection('publicaciones').doc(publicacionId).delete();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Publicación eliminada correctamente'), backgroundColor: Colors.green));
        Navigator.of(context).pop(); // Volver a la pantalla anterior después de eliminar
      }
    } catch (e) {
      developer.log('Error al eliminar publicación: $e', error: e, name: "Detalles.Delete");
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error al eliminar: ${e.toString().substring(0, (e.toString().length > 50) ? 50 : e.toString().length)}...'), backgroundColor: Colors.red));
      }
    }
  }

  Future<void> _mostrarDialogoEditarPublicacion(DocumentSnapshot publicacionDoc) async {
    // Asegurarse de que EditarPublicacionWidget es importado o accesible
    // Si está en Home.dart, puedes usar un alias como se muestra en los imports.
    // Si se movió a su propio archivo, importa ese archivo directamente.
    await showModalBottomSheet(
      context: context, // Usar el contexto de _DetallesdeFotooVideoState
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext modalContext) { // Usar un nuevo contexto para el builder del modal
        return home_widgets.EditarPublicacionWidget( // Usando el alias
          key: Key('edit_detail_${publicacionDoc.id}'),
          publicacionId: publicacionDoc.id,
          captionActual: publicacionDoc['caption'] as String? ?? '',
          mediaUrlActual: publicacionDoc['imagenUrl'] as String?,
          esVideoActual: (publicacionDoc['esVideo'] as bool?) ?? false,
          parentContext: context, // Pasar el contexto de _DetallesdeFotooVideoState para los SnackBars
        );
      },
    );
  }
  // --- FIN NUEVOS MÉTODOS DE PUBLICACIÓN ---

  // --- FUNCIONES PARA COMENTARIOS (INCLUIDA LA CORREGIDA _addComment) ---

  Future<void> _addComment() async { // <--- FUNCIÓN _addComment AQUÍ
    final User? currentUser = _auth.currentUser;
    if (currentUser == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Debes iniciar sesión para comentar', style: TextStyle(fontFamily: 'Comic Sans MS'))),
      );
      return;
    }
    if (_commentController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('El comentario no puede estar vacío', style: TextStyle(fontFamily: 'Comic Sans MS'))),
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

      // Actualiza el contador de comentarios en el documento principal de la publicación
      await _firestore
          .collection('publicaciones')
          .doc(widget.publicationId)
          .update({'comentariosCount': FieldValue.increment(1)}); // Campo preferido para el conteo

      _commentController.clear();
      FocusScope.of(context).unfocus();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Comentario añadido', style: TextStyle(fontFamily: 'Comic Sans MS')), backgroundColor: Colors.green),
      );
    } catch (e) {
      String errorMessage = 'Error desconocido al añadir comentario.';
      if (e is FirebaseException) {
        if (e.code == 'permission-denied') {
          errorMessage = 'No tienes permiso para actualizar el contador de comentarios en esta publicación. Asegúrate de que las reglas de Firebase sean correctas.';
        } else {
          errorMessage = 'Error de Firebase: ${e.message ?? e.toString()}';
        }
      } else {
        errorMessage = 'Error inesperado: ${e.toString()}';
      }
      developer.log('Error al añadir comentario: $e', error: e);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorMessage, style: const TextStyle(fontFamily: 'Comic Sans MS')),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 5), // Haz que el mensaje sea visible por más tiempo
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isPostingComment = false;
        });
      }
    }
  }


  Future<void> _deleteComment(String publicationId, String commentId) async {
    bool confirm = await showDialog(
      context: context,
      builder: (BuildContext ctx) {
        return AlertDialog(
          title: const Text('Confirmar Eliminación'),
          content: const Text('¿Estás seguro de que deseas eliminar este comentario?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancelar'),
              onPressed: () => Navigator.of(ctx).pop(false),
            ),
            TextButton(
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              child: const Text('Eliminar'),
              onPressed: () => Navigator.of(ctx).pop(true),
            ),
          ],
        );
      },
    ) ?? false;

    if (!confirm) return;

    try {
      await _firestore
          .collection('publicaciones')
          .doc(publicationId)
          .collection('comentarios')
          .doc(commentId)
          .delete();

      // Decrement comments count on the main publication document
      await _firestore
          .collection('publicaciones')
          .doc(publicationId)
          .update({'comentariosCount': FieldValue.increment(-1)});

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Comentario eliminado', style: TextStyle(fontFamily: 'Comic Sans MS')), backgroundColor: Colors.orangeAccent),
        );
      }
    } catch (e) {
      String errorMessage = 'Error desconocido al eliminar comentario.';
      if (e is FirebaseException) {
        if (e.code == 'permission-denied') {
          errorMessage = 'No tienes permiso para eliminar este comentario. Revisa las reglas de Firebase.';
        } else {
          errorMessage = 'Error de Firebase: ${e.message ?? e.toString()}';
        }
      } else {
        errorMessage = 'Error inesperado: ${e.toString()}';
      }
      developer.log('Error al eliminar comentario: $e', error: e);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(errorMessage, style: const TextStyle(fontFamily: 'Comic Sans MS')), backgroundColor: Colors.red),
        );
      }
    }
  }

  Future<void> _showEditCommentDialog(String publicationId, String commentId, String currentText) async {
    final TextEditingController editCommentController = TextEditingController(text: currentText);
    bool? confirm = await showDialog<bool>(
      context: context,
      builder: (BuildContext ctx) {
        return AlertDialog(
          title: const Text('Editar Comentario'),
          content: TextField(
            controller: editCommentController,
            maxLines: null,
            keyboardType: TextInputType.text, // Permite saltos de línea
            style: const TextStyle(fontFamily: 'Comic Sans MS'),
            decoration: const InputDecoration(
              hintText: 'Edita tu comentario aquí...',
              hintStyle: TextStyle(fontFamily: 'Comic Sans MS', color: Colors.grey),
              border: OutlineInputBorder(),
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancelar', style: TextStyle(fontFamily: 'Comic Sans MS')),
              onPressed: () => Navigator.of(ctx).pop(false),
            ),
            TextButton(
              child: const Text('Guardar', style: TextStyle(fontFamily: 'Comic Sans MS')),
              onPressed: () {
                if (editCommentController.text.trim().isNotEmpty) {
                  Navigator.of(ctx).pop(true);
                } else {
                  ScaffoldMessenger.of(ctx).showSnackBar(
                    const SnackBar(content: Text('El comentario no puede estar vacío.', style: TextStyle(fontFamily: 'Comic Sans MS'))),
                  );
                }
              },
            ),
          ],
        );
      },
    );

    if (confirm == true && editCommentController.text.trim().isNotEmpty) {
      try {
        await _firestore
            .collection('publicaciones')
            .doc(publicationId)
            .collection('comentarios')
            .doc(commentId)
            .update({'texto': editCommentController.text.trim()});

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Comentario actualizado', style: TextStyle(fontFamily: 'Comic Sans MS')), backgroundColor: Colors.green),
          );
        }
      } catch (e) {
        String errorMessage = 'Error desconocido al editar comentario.';
        if (e is FirebaseException) {
          if (e.code == 'permission-denied') {
            errorMessage = 'No tienes permiso para editar este comentario. Revisa las reglas de Firebase.';
          } else {
            errorMessage = 'Error de Firebase: ${e.message ?? e.toString()}';
          }
        } else {
          errorMessage = 'Error inesperado: ${e.toString()}';
        }
        developer.log('Error al editar comentario: $e', error: e);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(errorMessage, style: const TextStyle(fontFamily: 'Comic Sans MS')), backgroundColor: Colors.red),
          );
        }
      }
    }
  }
  // --- FIN FUNCIONES PARA COMENTARIOS ---


  @override
  Widget build(BuildContext context) {
    final bool hasValidMedia = widget.mediaUrl != null && widget.mediaUrl!.isNotEmpty;
    final currentUserId = _auth.currentUser?.uid;
    final bool isOwnPost = currentUserId != null && widget.ownerUserId == currentUserId;


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

          Pinned.fromPins(
            Pin(size: 74.0, middle: 0.5),
            Pin(size: 73.0, start: 42.0),
            child: PageLink(
              links: [
                PageLinkInfo(
                  transition: LinkTransition.Fade,
                  ease: Curves.easeOut,
                  duration: 0.3,
                  pageBuilder: () => home_widgets.Home(key: const Key('HomeFromDetails')), // Usando el alias si es necesario
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

          Pinned.fromPins(
            Pin(size: 52.9, start: 9.1),
            Pin(size: 50.0, start: 49.0),
            child: GestureDetector(
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

          Pinned.fromPins(
            Pin(size: 40.5, middle: 0.8328),
            Pin(size: 50.0, start: 49.0),
            child: PageLink(
              links: [
                PageLinkInfo(
                  transition: LinkTransition.Fade,
                  ease: Curves.easeOut,
                  duration: 0.3,
                  pageBuilder: () => Ayuda(key: const Key('AyudaFromDetails')),
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
                      border: Border.all(width: 1.0, color: const Color(0xff000000)),
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

          Pinned.fromPins(
            Pin(size: 47.2, end: 7.6),
            Pin(size: 50.0, start: 49.0),
            child: PageLink(
              links: [
                PageLinkInfo(
                  transition: LinkTransition.Fade,
                  ease: Curves.easeOut,
                  duration: 0.3,
                  pageBuilder: () => Configuraciones(key: const Key('SettingsFromDetails'), authService: AuthService()),
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
            Pin(size: 60.1, start: 13.0),
            Pin(size: 60.0, start: 180.0),
            child: PageLink(
              links: [
                PageLinkInfo(
                  transition: LinkTransition.Fade,
                  ease: Curves.easeOut,
                  duration: 0.3,
                  pageBuilder: () => ListadeAnimales(key: const Key('ListadeAnimalesFromDetails')),
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

          Pinned.fromPins(
            Pin(size: 58.5, end: 7.6),
            Pin(size: 60.0, start: 115.0),
            child: PageLink(
              links: [
                PageLinkInfo(
                  transition: LinkTransition.Fade,
                  ease: Curves.easeOut,
                  duration: 0.3,
                  pageBuilder: () => CompradeProductos(key: const Key('CompradeProductosFromDetails')),
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
                        Container(
                          padding: const EdgeInsets.all(8.0),
                          margin: const EdgeInsets.only(bottom: 10.0),
                          decoration: BoxDecoration(
                            color: const Color(0xe3a0f4fe),
                            borderRadius: BorderRadius.circular(9.0),
                            border: Border.all(width: 1.0, color: const Color(0xe3000000)),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
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
                                  Expanded( // Para que el nombre no se desborde y los iconos se alineen a la derecha
                                    child: Text(
                                      widget.ownerUserName ?? 'Usuario',
                                      style: const TextStyle(
                                        fontFamily: 'Comic Sans MS',
                                        fontSize: 18,
                                        color: Color(0xff000000),
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ),
                                  // ==================== INICIO DEL CAMBIO ====================
                                  // NUEVO: Iconos para editar/eliminar Publicación
                                  if (isOwnPost)
                                    Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Tooltip(
                                          message: 'Editar publicación',
                                          child: GestureDetector(
                                            onTap: () async {
                                              // Necesitamos el DocumentSnapshot de la publicación.
                                              DocumentSnapshot publicacionDoc = await _firestore
                                                  .collection('publicaciones')
                                                  .doc(widget.publicationId)
                                                  .get();
                                              if (publicacionDoc.exists && mounted) {
                                                _mostrarDialogoEditarPublicacion(publicacionDoc);
                                              } else {
                                                if (mounted) {
                                                  ScaffoldMessenger.of(context).showSnackBar(
                                                    const SnackBar(content: Text('Error: No se encontró la publicación para editar.')),
                                                  );
                                                }
                                              }
                                            },
                                            child: Image.asset(
                                              'assets/images/editar.png',
                                              height: 40.0,
                                              width: 40.0,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 8), // Espacio entre iconos
                                        Tooltip(
                                          message: 'Eliminar publicación',
                                          child: GestureDetector(
                                            onTap: () {
                                              _eliminarPublicacion(widget.publicationId);
                                            },
                                            child: Image.asset(
                                              'assets/images/eliminar.png',
                                              height: 40.0,
                                              width: 40.0,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  // ==================== FIN DEL CAMBIO ====================
                                ],
                              ),
                              const SizedBox(height: 10),
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

                              StreamBuilder<DocumentSnapshot>(
                                  stream: _firestore.collection('publicaciones').doc(widget.publicationId).snapshots(),
                                  builder: (context, snapshot) {
                                    if (!snapshot.hasData) {
                                      return const Padding(
                                        padding: EdgeInsets.symmetric(vertical: 8.0),
                                        child: Center(child: SizedBox(height: 40, width:40, child: CircularProgressIndicator(strokeWidth: 2))),
                                      );
                                    }
                                    final publicacionData = snapshot.data;
                                    if (publicacionData == null || !publicacionData.exists) {
                                      return const SizedBox.shrink();
                                    }
                                    return _buildActionButtons(publicacionData, currentUserId);
                                  }
                              ),
                            ],
                          ),
                        ),

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
                        _buildCommentsList(), // Aquí se renderiza la lista de comentarios
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
    final pubDataMap = publicacion.data() as Map<String, dynamic>?;

    if (pubDataMap == null) {
      developer.log('Error: pubDataMap es nulo para publicación: ${publicacion.id}', name: 'Detalles.buildActionButtons');
      return const SizedBox.shrink();
    }

    final likes = pubDataMap['likes'] as int? ?? 0;
    final likedBy = List<String>.from(pubDataMap['likedBy'] as List<dynamic>? ?? []);
    final comentariosCount = (pubDataMap['comentariosCount'] as int?) ?? (pubDataMap['comentarios'] as int?) ?? 0;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0.0, vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          GestureDetector(
            onTap: () => _toggleLike(widget.publicationId, currentUserId, likedBy),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset('assets/images/like.png', width: 40, height: 40),
                const SizedBox(width: 4),
                Text(
                  likes.toString(),
                  style: const TextStyle(fontFamily: 'Comic Sans MS', fontSize: 14, color: Colors.black),
                ),
              ],
            ),
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset('assets/images/comments.png', width: 40, height: 40),
              const SizedBox(width: 4),
              Text(
                comentariosCount.toString(), // Usa el conteo corregido
                style: const TextStyle(fontFamily: 'Comic Sans MS', fontSize: 14, color: Colors.black),
              ),
            ],
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CompartirPublicacion(
                    key: Key('CompartirDesdeDetalles_${widget.publicationId}'),
                    publicationId: widget.publicationId, // Pasar el ID correcto
                    mediaUrl: widget.mediaUrl,
                    caption: widget.caption,
                  ),
                ),
              );
            },
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset('assets/images/share.png', width: 40, height: 40),
                const SizedBox(width: 4),
              ],
            ),
          ),
          GestureDetector(
            onTap: () => _guardarPublicacion(widget.publicationId),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset('assets/images/save.png', width: 40, height: 40),
                const SizedBox(width: 4),
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
          return const Center(child: Text('Error al cargar comentarios.', style: TextStyle(color: Colors.white, fontFamily: 'Comic Sans MS')));
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(child: Text('No hay comentarios aún. ¡Sé el primero!', style: TextStyle(color: Colors.white, fontFamily: 'Comic Sans MS')));
        }

        final comments = snapshot.data!.docs;
        final currentUserId = _auth.currentUser?.uid;
        final bool isPostOwner = widget.ownerUserId == currentUserId;

        return ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: comments.length,
          itemBuilder: (context, index) {
            final commentDoc = comments[index];
            final String commentId = commentDoc.id;
            final Map<String, dynamic> commentData = commentDoc.data() as Map<String, dynamic>;

            final String commenterId = commentData['usuarioId'] as String? ?? '';
            final String commenterName = commentData['usuarioNombre'] ?? 'Usuario Anónimo';
            final String commenterText = commentData['texto'] ?? '';
            final String? commenterPhotoUrl = commentData['usuarioFotoUrl'] as String?;

            final bool isCommentOwner = commenterId == currentUserId;

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
                  // ==================== INICIO DEL CAMBIO ====================
                  // NUEVO: Iconos para editar/eliminar Comentario
                  if (isCommentOwner || isPostOwner) // Visible para dueño de comentario o de publicación
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // El icono de editar solo es visible para el dueño del comentario
                        if (isCommentOwner)
                          Tooltip(
                            message: 'Editar comentario',
                            child: GestureDetector(
                              onTap: () {
                                _showEditCommentDialog(widget.publicationId, commentId, commenterText);
                              },
                              child: Image.asset(
                                'assets/images/editar.png',
                                height: 40.0,
                                width: 40.0,
                              ),
                            ),
                          ),
                        // El icono de eliminar es visible para el dueño del comentario O el dueño de la publicación
                        Tooltip(
                          message: 'Eliminar comentario',
                          child: GestureDetector(
                            onTap: () {
                              _deleteComment(widget.publicationId, commentId);
                            },
                            child: Image.asset(
                              'assets/images/eliminar.png',
                              height: 40.0,
                              width: 40.0,
                            ),
                          ),
                        ),
                      ],
                    ),
                  // ==================== FIN DEL CAMBIO ====================
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