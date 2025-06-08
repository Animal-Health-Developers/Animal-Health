import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:video_player/video_player.dart';
import 'package:adobe_xd/page_link.dart';
import 'package:adobe_xd/pinned.dart';
import 'dart:developer' as developer;

import '../services/auth_service.dart';
import './Home.dart';
import './Ayuda.dart';
import './Configuracion.dart';
import './ListadeAnimales.dart';
import './Crearpublicaciondesdeperfil.dart';
import './DetallesdeFotooVideo.dart';
import './CompartirPublicacion.dart';

// --- Constantes de Estilo ---
const String _fontFamily = 'Comic Sans MS';
const Color _primaryTextColor = Color(0xff000000);
const Color _buttonBackgroundColor = Color(0xff54d1e0);
const Color _tabBackgroundColor = Color(0xe3a0f4fe);
const Color _infoTabActiveColor = Color(0xff54d1e0);
const Color _boxShadowColor = Color(0xff080808);
const Color _scaffoldBgColorModal = Color(0xff4ec8dd);

class PerfilPublico extends StatefulWidget {
  const PerfilPublico({Key? key}) : super(key: key);

  @override
  _PerfilPublicoState createState() => _PerfilPublicoState();
}

class _PerfilPublicoState extends State<PerfilPublico> {
  final AuthService _authService = AuthService();
  int _selectedTabIndex = 0; // 0: Información, 1: Historias, 2: Comunidad

  Future<void> _mostrarDialogoEditarPerfilUsuario(BuildContext pageContext, String userId, Map<String, dynamic> currentUserData) async {
    await showModalBottomSheet(
      context: pageContext,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext modalBuildContext) {
        return _EditarPerfilUsuarioModalWidget(
          key: Key('edit_profile_modal_$userId'),
          userId: userId,
          currentUserData: currentUserData,
          parentContextForSnackbars: pageContext,
        );
      },
    );
  }

  Future<void> _mostrarDialogoCrearHistoria(BuildContext pageContext, String userId, Map<String, dynamic> currentUserData) async {
    await showModalBottomSheet(
      context: pageContext,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext modalBuildContext) {
        return _CrearHistoriaModalWidget(
          key: Key('create_story_modal_$userId'),
          userId: userId,
          userName: currentUserData['nombreUsuario'] ?? currentUserData['name'] ?? 'Usuario',
          userProfilePic: currentUserData['profilePhotoUrl'] as String?,
          parentContextForSnackbars: pageContext,
        );
      },
    );
  }

  void _showProfileImageDialog(BuildContext context, String? imageUrl) {
    if (imageUrl == null || imageUrl.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No hay imagen de perfil para mostrar.', style: TextStyle(fontFamily: _fontFamily))),
      );
      return;
    }
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.all(10),
          child: GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: InteractiveViewer(
              panEnabled: true,
              minScale: 0.5,
              maxScale: 4.0,
              child: CachedNetworkImage(
                imageUrl: imageUrl,
                fit: BoxFit.contain,
                placeholder: (context, url) => const Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(_buttonBackgroundColor))),
                errorWidget: (context, url, error) => const Center(child: Icon(Icons.broken_image, size: 100, color: Colors.grey)),
              ),
            ),
          ),
        );
      },
    );
  }

  // NUEVA FUNCIÓN PARA MOSTRAR LA HISTORIA EN PANTALLA COMPLETA
  void _showStoryDialog(BuildContext context, DocumentSnapshot storyDoc) {
    final storyData = storyDoc.data() as Map<String, dynamic>;
    final mediaUrl = storyData['mediaUrl'] as String?;
    if (mediaUrl == null || mediaUrl.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No se puede mostrar la historia, no tiene contenido.', style: TextStyle(fontFamily: _fontFamily))),
      );
      return;
    }
    showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.85),
      builder: (BuildContext dialogContext) {
        return Dialog(
          insetPadding: EdgeInsets.zero,
          backgroundColor: Colors.transparent,
          child: _StoryViewerWidget(
            key: Key('story_viewer_${storyDoc.id}'),
            mediaUrl: mediaUrl,
            isVideo: (storyData['esVideo'] as bool?) ?? false,
            caption: storyData['caption'] as String? ?? '',
            userName: storyData['userName'] as String? ?? 'Usuario',
            userProfilePic: storyData['userProfilePic'] as String?,
          ),
        );
      },
    );
  }


  Future<void> _toggleLike(String postId, String? userId, List<String> likedBy, BuildContext contextForSnackBar) async {
    if (userId == null) {
      if (contextForSnackBar.mounted) {
        ScaffoldMessenger.of(contextForSnackBar).showSnackBar(
          const SnackBar(content: Text('Debes iniciar sesión para dar like', style: TextStyle(fontFamily: _fontFamily))),
        );
      }
      return;
    }
    try {
      final postRef = FirebaseFirestore.instance.collection('publicaciones').doc(postId);
      await FirebaseFirestore.instance.runTransaction((transaction) async {
        final postSnapshot = await transaction.get(postRef);
        if (!postSnapshot.exists) {
          developer.log('Error: Publicación no encontrada para dar like: $postId', name: "PerfilPublico.Like");
          throw Exception("Publicación no encontrada.");
        }
        List<String> currentLikedBy = List<String>.from(postSnapshot.data()?['likedBy'] as List<dynamic>? ?? []);
        final bool isLiked = currentLikedBy.contains(userId);
        if (isLiked) {
          transaction.update(postRef, {'likes': FieldValue.increment(-1), 'likedBy': FieldValue.arrayRemove([userId])});
        } else {
          transaction.update(postRef, {'likes': FieldValue.increment(1), 'likedBy': FieldValue.arrayUnion([userId])});
        }
      });
    } catch (e) {
      developer.log('Error al actualizar like: $e', error: e, name: "PerfilPublico.Like");
      if (contextForSnackBar.mounted) {
        ScaffoldMessenger.of(contextForSnackBar).showSnackBar(const SnackBar(content: Text('Error al actualizar like...', style: TextStyle(fontFamily: _fontFamily))));
      }
    }
  }

  Future<void> _guardarPublicacion(String publicacionId, BuildContext contextForSnackBar) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        if (contextForSnackBar.mounted) {
          ScaffoldMessenger.of(contextForSnackBar).showSnackBar(const SnackBar(content: Text('Debes iniciar sesión para guardar', style: TextStyle(fontFamily: _fontFamily))));
        }
        return;
      }
      final docRef = FirebaseFirestore.instance.collection('users').doc(user.uid).collection('publicacionesGuardadas').doc(publicacionId);
      final doc = await docRef.get();

      if (doc.exists) {
        await docRef.delete();
        if (contextForSnackBar.mounted) {
          ScaffoldMessenger.of(contextForSnackBar).showSnackBar(const SnackBar(content: Text('Publicación eliminada de guardados', style: TextStyle(fontFamily: _fontFamily)), backgroundColor: Colors.orangeAccent));
        }
      } else {
        await docRef.set({
          'publicacionId': publicacionId,
          'fechaGuardado': FieldValue.serverTimestamp(),
        });
        if (contextForSnackBar.mounted) {
          ScaffoldMessenger.of(contextForSnackBar).showSnackBar(const SnackBar(content: Text('Publicación guardada', style: TextStyle(fontFamily: _fontFamily)), backgroundColor: Colors.green));
        }
      }
    } catch (e) {
      developer.log('Error al guardar/desguardar publicación: $e', error: e, name: "PerfilPublico.SaveToggle");
      if (contextForSnackBar.mounted) {
        ScaffoldMessenger.of(contextForSnackBar).showSnackBar(const SnackBar(content: Text('Error al procesar guardado...', style: TextStyle(fontFamily: _fontFamily)), backgroundColor: Colors.red));
      }
    }
  }

  Future<void> _eliminarPublicacion(String publicacionId, BuildContext contextForDialogsAndSnackbars, String? mediaUrlToDelete) async {
    bool confirmar = await showDialog<bool>(
      context: contextForDialogsAndSnackbars,
      builder: (BuildContext ctx) {
        return AlertDialog(
          backgroundColor: _tabBackgroundColor,
          title: const Text('Confirmar Eliminación', style: TextStyle(fontFamily: _fontFamily, color: _primaryTextColor)),
          content: const Text('¿Estás seguro de que deseas eliminar esta publicación? Esta acción no se puede deshacer.', style: TextStyle(fontFamily: _fontFamily, color: _primaryTextColor)),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancelar', style: TextStyle(fontFamily: _fontFamily, color: _buttonBackgroundColor)),
              onPressed: () => Navigator.of(ctx).pop(false),
            ),
            TextButton(
              style: TextButton.styleFrom(backgroundColor: Colors.red[400]),
              child: const Text('Eliminar', style: TextStyle(fontFamily: _fontFamily, color: Colors.white)),
              onPressed: () => Navigator.of(ctx).pop(true),
            ),
          ],
        );
      },
    ) ?? false;

    if (!confirmar) return;

    try {
      if (mediaUrlToDelete != null && mediaUrlToDelete.isNotEmpty) {
        if (mediaUrlToDelete.startsWith('https://firebasestorage.googleapis.com')) {
          try {
            await FirebaseStorage.instance.refFromURL(mediaUrlToDelete).delete();
            developer.log('Medio eliminado de Storage: $mediaUrlToDelete', name: "PerfilPublico.DeleteStorage");
          } catch (storageError) {
            developer.log('Error eliminando medio de Storage: $storageError. URL: $mediaUrlToDelete', name: "PerfilPublico.DeleteStorage", error: storageError);
          }
        }
      }
      await FirebaseFirestore.instance.collection('publicaciones').doc(publicacionId).delete();
      if (contextForDialogsAndSnackbars.mounted) {
        ScaffoldMessenger.of(contextForDialogsAndSnackbars).showSnackBar(const SnackBar(content: Text('Publicación eliminada', style: TextStyle(fontFamily: _fontFamily)), backgroundColor: Colors.green));
      }
    } catch (e) {
      developer.log('Error al eliminar publicación: $e', error: e, name: "PerfilPublico.Delete");
      if (contextForDialogsAndSnackbars.mounted) {
        ScaffoldMessenger.of(contextForDialogsAndSnackbars).showSnackBar(SnackBar(content: Text('Error al eliminar: $e', style: const TextStyle(fontFamily: _fontFamily)), backgroundColor: Colors.red));
      }
    }
  }

  Future<void> _mostrarDialogoEditarPublicacionIndividual(DocumentSnapshot publicacion, BuildContext contextForModals) async {
    await showModalBottomSheet(
      context: contextForModals,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext modalContext) {
        return EditarPublicacionIndividualWidget(
          key: Key('edit_pub_perfil_indiv_${publicacion.id}'),
          publicacionId: publicacion.id,
          captionActual: (publicacion.data() as Map<String, dynamic>)['caption'] ?? '',
          mediaUrlActual: (publicacion.data() as Map<String, dynamic>)['imagenUrl'],
          esVideoActual: (publicacion.data() as Map<String, dynamic>)['esVideo'] ?? false,
          parentContext: contextForModals,
        );
      },
    );
  }

  int _calculateAge(DateTime birthDate) {
    DateTime currentDate = DateTime.now();
    int age = currentDate.year - birthDate.year;
    if (currentDate.month < birthDate.month ||
        (currentDate.month == birthDate.month && currentDate.day < birthDate.day)) {
      age--;
    }
    return age;
  }

  Future<void> _removeFriend(BuildContext dialogContext, String currentUserId, String friendUid) async {
    bool confirm = await showDialog<bool>(
      context: dialogContext,
      builder: (BuildContext ctx) {
        return AlertDialog(
          backgroundColor: _tabBackgroundColor,
          title: const Text('Eliminar Amigo', style: TextStyle(fontFamily: _fontFamily, color: _primaryTextColor)),
          content: const Text('¿Estás seguro de que deseas eliminar a este amigo? Esta acción también lo eliminará de su lista de amigos.', style: TextStyle(fontFamily: _fontFamily, color: _primaryTextColor)),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancelar', style: TextStyle(fontFamily: _fontFamily, color: _buttonBackgroundColor)),
              onPressed: () => Navigator.of(ctx).pop(false),
            ),
            TextButton(
              style: TextButton.styleFrom(backgroundColor: Colors.red[400]),
              child: const Text('Eliminar', style: TextStyle(fontFamily: _fontFamily, color: Colors.white)),
              onPressed: () => Navigator.of(ctx).pop(true),
            ),
          ],
        );
      },
    ) ?? false;

    if (!confirm) return;

    try {
      await FirebaseFirestore.instance.collection('users').doc(currentUserId).collection('amigos').doc(friendUid).delete();
      await FirebaseFirestore.instance.collection('users').doc(friendUid).collection('amigos').doc(currentUserId).delete();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Amigo eliminado correctamente.', style: TextStyle(fontFamily: _fontFamily)), backgroundColor: Colors.green),
        );
      }
    } catch (e) {
      developer.log('Error al eliminar amigo: $e', name: "PerfilPublico.RemoveFriend", error: e);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error al eliminar amigo.', style: TextStyle(fontFamily: _fontFamily)), backgroundColor: Colors.red),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser == null) {
      return Scaffold(
        backgroundColor: const Color(0xff4ec8dd),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Usuario no autenticado.', style: TextStyle(fontFamily: _fontFamily, fontSize: 18, color: Colors.white)),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (_) => Home(key: const Key("Home_From_Unauth_Perfil"))),
                        (route) => false,
                  );
                },
                child: const Text('Ir a Inicio', style: TextStyle(fontFamily: _fontFamily)),
              )
            ],
          ),
        ),
      );
    }

    return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
      stream: FirebaseFirestore.instance.collection('users').doc(currentUser.uid).snapshots(),
      builder: (context, userSnapshot) {
        if (userSnapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(backgroundColor: Color(0xff4ec8dd), body: Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(_buttonBackgroundColor))));
        }
        if (userSnapshot.hasError) {
          developer.log("Error cargando datos del usuario: ${userSnapshot.error}", name:"PerfilPublico.UserStream");
          return Scaffold(
            backgroundColor: const Color(0xff4ec8dd),
            body: Center(
              child: Text('Error al cargar el perfil: ${userSnapshot.error}', style: const TextStyle(fontFamily: _fontFamily, fontSize: 18, color: Colors.white)),
            ),
          );
        }
        if (!userSnapshot.hasData || !userSnapshot.data!.exists) {
          developer.log("Usuario no encontrado en Firestore: ${currentUser.uid}", name:"PerfilPublico.UserStream");
          return const Scaffold(
            backgroundColor: Color(0xff4ec8dd),
            body: Center(
              child: Text('No se encontraron datos para este usuario.', style: TextStyle(fontFamily: _fontFamily, fontSize: 18, color: Colors.white)),
            ),
          );
        }

        final userData = userSnapshot.data!.data()!;
        final profilePhotoUrl = userData['profilePhotoUrl'] as String?;
        final userName = userData['nombreUsuario'] ?? userData['name'] ?? 'Usuario';
        final viveEn = userData['ciudad'] ?? 'No especificado';
        final deDonde = userData['ciudadOrigen'] ?? 'No especificado';
        final preferencias = userData['preferenciasUsuario'] ?? 'Todos';
        final genero = userData['genero'] ?? 'No especificado';

        String edadString = 'N/A';
        if (userData['fechaNacimiento'] != null && userData['fechaNacimiento'] is Timestamp) {
          DateTime birthDate = (userData['fechaNacimiento'] as Timestamp).toDate();
          edadString = _calculateAge(birthDate).toString();
        } else if (userData['edad'] != null) {
          edadString = userData['edad'].toString();
        }

        return Scaffold(
          body: Stack(
            children: <Widget>[
              Positioned.fill(
                child: Image.asset('assets/images/Animal Health Fondo de Pantalla.png', fit: BoxFit.cover),
              ),
              // --- Widgets Pinned de la AppBar ---
              Pinned.fromPins(
                Pin(size: 52.9, start: 9.0),
                Pin(size: 50.0, start: 40.0),
                child: Tooltip(
                  message: 'Volver a la página anterior',
                  textStyle: const TextStyle(fontFamily: _fontFamily, color: Colors.white, fontSize: 14),
                  decoration: BoxDecoration(color: Colors.black.withOpacity(0.8), borderRadius: BorderRadius.circular(5)),
                  child: PageLink(
                    links: [PageLinkInfo(pageBuilder: () {
                      if (Navigator.canPop(context)) { Navigator.of(context).pop(); return Container();}
                      else { return Home(key: const Key('Home_FromPerfil_Back_AppBar')); }
                    })],
                    child: Container(decoration: const BoxDecoration(image: DecorationImage(image: AssetImage('assets/images/back.png'), fit: BoxFit.fill))),
                  ),
                ),
              ),

              Pinned.fromPins(
                  Pin(size: 74.0, middle: 0.5),
                  Pin(size: 73.0, start: 42.0),
                  child: Tooltip(
                    message: 'Ir a la página de inicio',
                    textStyle: const TextStyle(fontFamily: _fontFamily, color: Colors.white, fontSize: 14),
                    decoration: BoxDecoration(color: Colors.black.withOpacity(0.8), borderRadius: BorderRadius.circular(5)),
                    child: PageLink(
                      links: [PageLinkInfo(transition: LinkTransition.Fade, ease: Curves.easeOut, duration: 0.3, pageBuilder: () => Home(key: const Key('Home_FromPerfil_Logo_AppBar')))],
                      child: Container(
                        decoration: BoxDecoration(
                          image: const DecorationImage(image: AssetImage('assets/images/logo.png'), fit: BoxFit.cover),
                          borderRadius: BorderRadius.circular(15.0),
                          border: Border.all(width: 1.0, color: const Color(0xff000000)),
                        ),
                      ),
                    ),
                  )
              ),

              Pinned.fromPins(
                Pin(size: 40.5, middle: 0.8328),
                Pin(size: 50.0, start: 49.0),
                child: Tooltip(
                  message: 'Ayuda y soporte',
                  textStyle: const TextStyle(fontFamily: _fontFamily, color: Colors.white, fontSize: 14),
                  decoration: BoxDecoration(color: Colors.black.withOpacity(0.8), borderRadius: BorderRadius.circular(5)),
                  child: PageLink(
                    links: [
                      PageLinkInfo(
                        transition: LinkTransition.Fade,
                        ease: Curves.easeOut,
                        duration: 0.3,
                        pageBuilder: () => Ayuda(key: const Key('Ayuda_FromPerfil_AppBar')),
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
              ),

              Pinned.fromPins(
                Pin(size: 47.2, end: 7.6),
                Pin(size: 50.0, start: 49.0),
                child: Tooltip(
                  message: 'Configuración de la aplicación',
                  textStyle: const TextStyle(fontFamily: _fontFamily, color: Colors.white, fontSize: 14),
                  decoration: BoxDecoration(color: Colors.black.withOpacity(0.8), borderRadius: BorderRadius.circular(5)),
                  child: PageLink(
                    links: [
                      PageLinkInfo(
                        transition: LinkTransition.Fade,
                        ease: Curves.easeOut,
                        duration: 0.3,
                        pageBuilder: () => Configuraciones(key: const Key('Settings_FromPerfil_AppBar'), authService: _authService),
                      ),
                    ],
                    child: Container(
                      decoration: const BoxDecoration(
                        image: DecorationImage(image: AssetImage('assets/images/settingsbutton.png'), fit: BoxFit.fill),
                      ),
                    ),
                  ),
                ),
              ),

              Pinned.fromPins(
                Pin(size: 60.1, start: 80.0),
                Pin(size: 60.0, start: 44.0),
                child: Tooltip(
                  message: 'Ver mi lista de animales',
                  textStyle: const TextStyle(fontFamily: _fontFamily, color: Colors.white, fontSize: 14),
                  decoration: BoxDecoration(color: Colors.black.withOpacity(0.8), borderRadius: BorderRadius.circular(5)),
                  child: PageLink(
                    links: [
                      PageLinkInfo(
                        transition: LinkTransition.Fade,
                        ease: Curves.easeOut,
                        duration: 0.3,
                        pageBuilder: () => ListadeAnimales(key: const Key('ListadeAnimales_FromPerfil_AppBar')),
                      ),
                    ],
                    child: Container(
                      decoration: const BoxDecoration(
                        image: DecorationImage(image: AssetImage('assets/images/listaanimales.png'), fit: BoxFit.fill),
                      ),
                    ),
                  ),
                ),
              ),


              Positioned(
                top: 120.0,
                left: 0,
                right: 0,
                bottom: 0,
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(8.0, 0, 8.0, 8.0),
                  child: Column(
                    children: <Widget>[
                      _buildProfileHeader(context, profilePhotoUrl, userName, userData, currentUser.uid),
                      const SizedBox(height: 20),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: _buildActionButton(
                          context,
                          text: 'Crear Historia',
                          onTapAction: () => _mostrarDialogoCrearHistoria(context, currentUser.uid, userData),
                        ),
                      ),
                      const SizedBox(height: 20),
                      _buildInfoTabs(context),
                      const SizedBox(height: 10),
                      _buildContentForSelectedTab(currentUser.uid, viveEn, deDonde, preferencias, genero, edadString),
                      const SizedBox(height: 20),
                      if (_selectedTabIndex == 0)
                        _buildUserPublicationsSection(context, currentUser.uid, userData),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildProfileHeader(BuildContext context, String? profilePhotoUrl, String userName, Map<String, dynamic> currentUserData, String currentUserId) {
    return Column(children: <Widget>[
      GestureDetector(
        onTap: () => _showProfileImageDialog(context, profilePhotoUrl),
        child: Container(
          width: 150.0,
          height: 150.0,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(25.0),
              border: Border.all(color: _primaryTextColor, width: 1.0),
              color: Colors.grey[300]
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(24.0),
            child: profilePhotoUrl != null && profilePhotoUrl.isNotEmpty
                ? CachedNetworkImage(
                imageUrl: profilePhotoUrl,
                fit: BoxFit.cover,
                placeholder: (context, url) => const Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(_buttonBackgroundColor))),
                errorWidget: (context, url, error) => const Icon(Icons.person, size: 80, color: Colors.grey)
            )
                : const Icon(Icons.person, size: 80, color: Colors.grey),
          ),
        ),
      ),
      const SizedBox(height: 12.0),
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        decoration: BoxDecoration(color: _tabBackgroundColor.withOpacity(0.89), borderRadius: BorderRadius.circular(10.0), border: Border.all(color: _primaryTextColor.withOpacity(0.89), width: 1.0)),
        child: Text(userName, style: const TextStyle(fontFamily: _fontFamily, fontSize: 20, color: _primaryTextColor, fontWeight: FontWeight.w700), softWrap: false),
      ),
      const SizedBox(height: 18.0),
      Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: <Widget>[
        SizedBox(width: 179.0, height: 40.0,
          child: PageLink(
            links: [PageLinkInfo(transition: LinkTransition.Fade, ease: Curves.easeOut, duration: 0.3, pageBuilder: () => Crearpublicaciondesdeperfil(key: const Key('Crearpublicaciondesdeperfil')))],
            child: Container(
              decoration: BoxDecoration(color: _buttonBackgroundColor, borderRadius: BorderRadius.circular(7.0), border: Border.all(width: 1.0, color: _primaryTextColor),
                  boxShadow: const [BoxShadow(color: _boxShadowColor, offset: Offset(0, 3), blurRadius: 6)]),
              child: const Center(child: Text('Crear Publicación', style: TextStyle(fontFamily: _fontFamily, fontSize: 20, color: _primaryTextColor, fontWeight: FontWeight.w700), softWrap: false)),
            ),
          ),
        ),
        _buildActionButton(context, text: 'Editar Perfil', onTapAction: () => _mostrarDialogoEditarPerfilUsuario(context, currentUserId, currentUserData)),
      ]),
    ]);
  }

  Widget _buildActionButton(BuildContext context, {required String text, required VoidCallback onTapAction}) {
    return SizedBox(width: 179.0, height: 40.0,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: _buttonBackgroundColor,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(7.0), side: const BorderSide(width: 1.0, color: _primaryTextColor)),
          elevation: 6, shadowColor: _boxShadowColor,
        ),
        onPressed: onTapAction,
        child: Text(text, style: const TextStyle(fontFamily: _fontFamily, fontSize: 20, color: _primaryTextColor, fontWeight: FontWeight.w700), softWrap: false),
      ),
    );
  }

  Widget _buildInfoTabs(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      decoration: BoxDecoration(color: _tabBackgroundColor, borderRadius: BorderRadius.circular(9.0), border: Border.all(width: 1.0, color: _primaryTextColor.withOpacity(0.89))),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: <Widget>[
        _buildTabButton(context, text: 'Información', index: 0, iconPath: 'assets/images/infoperfil.png'),
        _buildTabButton(context, text: 'Historias', index: 1, iconPath: 'assets/images/historias.png'),
        _buildTabButton(context, text: 'Comunidad', index: 2, iconPath: 'assets/images/comunidad.png'),
      ]),
    );
  }

  Widget _buildTabButton(BuildContext context, {required String text, required int index, required String iconPath}) {
    bool isActive = _selectedTabIndex == index;

    BoxDecoration decoration;
    if (isActive) {
      decoration = BoxDecoration(
          color: _infoTabActiveColor,
          borderRadius: BorderRadius.circular(8.0),
          border: Border.all(width: 1.0, color: _primaryTextColor),
          boxShadow: const [BoxShadow(color: _boxShadowColor, offset: Offset(0,3), blurRadius: 6)]
      );
    } else {
      decoration = BoxDecoration(
          color: _tabBackgroundColor.withOpacity(0.7),
          borderRadius: BorderRadius.circular(8.0),
          border: Border.all(color: _primaryTextColor.withOpacity(0.7), width: 1.0)
      );
    }

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedTabIndex = index;
        });
      },
      child: Container(
        width: 115.0,
        height: 50.0,
        decoration: decoration,
        child: Center(
          child: Image.asset(
            iconPath,
            height: 40.0,
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }

  Widget _buildContentForSelectedTab(String currentUserId, String viveEn, String deDonde, String preferencias, String genero, String edad) {
    switch (_selectedTabIndex) {
      case 0: // Información
        return _buildUserInfoDetails(viveEn, deDonde, preferencias, genero, edad);
      case 1: // Historias
        return _buildStoriesSection(currentUserId);
      case 2: // Comunidad (Lista de Amigos)
        return _buildFriendsListSection(currentUserId);
      default:
        return _buildUserInfoDetails(viveEn, deDonde, preferencias, genero, edad);
    }
  }

  Widget _buildUserInfoDetails(String viveEn, String deDonde, String preferencias, String genero, String edad) {
    return Container(
      padding: const EdgeInsets.all(15.0),
      decoration: BoxDecoration(color: _tabBackgroundColor, borderRadius: BorderRadius.circular(9.0), border: Border.all(width: 1.0, color: _primaryTextColor.withOpacity(0.89))),
      child: Column(children: <Widget>[
        _buildProfileStatItem(iconAsset: 'assets/images/viveen.png', label: 'Vive en', value: viveEn),
        _buildProfileStatItem(iconAsset: 'assets/images/de.png', label: 'De', value: deDonde),
        _buildProfileStatItem(iconAsset: 'assets/images/preferencias.png', label: 'Preferencias:', value: preferencias),
        _buildProfileStatItem(iconAsset: 'assets/images/genero.png', label: 'Género', value: genero),
        _buildProfileStatItem(iconAsset: 'assets/images/edadusuario.png', label: 'Edad', value: '$edad Años'),
      ]),
    );
  }

  Widget _buildProfileStatItem({required String iconAsset, required String label, required String value}) {
    double iconWidth = (iconAsset.contains('viveen') || iconAsset.contains('preferencias')) ? 45.5 : (iconAsset.contains('edad')) ? 41.2 : (iconAsset.contains('de')) ? 37.9 : 35.8;
    return Padding(padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(children: <Widget>[
        Image.asset(iconAsset, width: iconWidth, height: 40.0, fit: BoxFit.fill),
        const SizedBox(width: 15.0),
        Expanded(child: RichText(
            text: TextSpan(style: const TextStyle(fontFamily: _fontFamily, fontSize: 17, color: _primaryTextColor),
                children: [TextSpan(text: '$label '), TextSpan(text: value, style: const TextStyle(fontWeight: FontWeight.w700))]))),
      ]),
    );
  }

  Widget _buildFriendsListSection(String currentUserId) {
    return Container(
      margin: const EdgeInsets.only(top:0, bottom: 15.0),
      padding: const EdgeInsets.all(10.0),
      decoration: BoxDecoration(
          color: _tabBackgroundColor,
          borderRadius: BorderRadius.circular(9.0),
          border: Border.all(width: 1.0, color: _primaryTextColor.withOpacity(0.89))
      ),
      child: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('users').doc(currentUserId).collection('amigos').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(_buttonBackgroundColor)));
          }
          if (snapshot.hasError) {
            developer.log("Error cargando lista de amigos: ${snapshot.error}", name:"PerfilPublico.FriendsStream");
            return const Center(child: Text('Error al cargar amigos.', style: TextStyle(fontFamily: _fontFamily, color: Colors.redAccent)));
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 20.0),
                child: Text(
                  'Aún no tienes amigos.\n¡Conecta con otros usuarios!',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontFamily: _fontFamily, fontSize: 18, color: _primaryTextColor),
                ),
              ),
            );
          }

          final friendDocs = snapshot.data!.docs;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 8.0, bottom: 10.0, top: 5.0),
                child: Text(
                  'Amigos (${friendDocs.length})',
                  style: const TextStyle(fontFamily: _fontFamily, fontSize: 18, fontWeight: FontWeight.bold, color: _primaryTextColor),
                ),
              ),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: friendDocs.length,
                itemBuilder: (context, index) {
                  String friendUid = friendDocs[index].id;
                  return _buildFriendListItem(context, friendUid, currentUserId);
                },
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildFriendListItem(BuildContext context, String friendUid, String currentUserId) {
    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance.collection('users').doc(friendUid).snapshots(),
      builder: (context, userSnapshot) {
        if (!userSnapshot.hasData) {
          return const ListTile(title: Text('Cargando amigo...', style: TextStyle(fontFamily: _fontFamily)));
        }
        if (userSnapshot.hasError || !userSnapshot.data!.exists) {
          developer.log("Error cargando datos del amigo $friendUid: ${userSnapshot.error}", name:"PerfilPublico.FriendItem");
          return const ListTile(title: Text('Error al cargar datos del amigo.', style: TextStyle(fontFamily: _fontFamily, color: Colors.red)));
        }

        final friendData = userSnapshot.data!.data() as Map<String, dynamic>;
        final friendName = friendData['nombreUsuario'] ?? friendData['name'] ?? 'Amigo';
        final friendProfilePicUrl = friendData['profilePhotoUrl'] as String?;

        return Card(
          color: _tabBackgroundColor.withAlpha(200),
          elevation: 1,
          margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 0),
          child: ListTile(
            leading: CircleAvatar(
              radius: 25,
              backgroundColor: Colors.grey[300],
              backgroundImage: friendProfilePicUrl != null && friendProfilePicUrl.isNotEmpty
                  ? CachedNetworkImageProvider(friendProfilePicUrl)
                  : null,
              child: (friendProfilePicUrl == null || friendProfilePicUrl.isEmpty)
                  ? const Icon(Icons.person, color: _primaryTextColor)
                  : null,
            ),
            title: Text(friendName, style: const TextStyle(fontFamily: _fontFamily, fontWeight: FontWeight.bold, color: _primaryTextColor)),
            trailing: IconButton(
              icon: Icon(Icons.person_remove_alt_1_outlined, color: Colors.red[700]),
              tooltip: 'Eliminar amigo',
              onPressed: () => _removeFriend(context, currentUserId, friendUid),
            ),
            onTap: () {
              developer.log("Ver perfil de $friendName (UID: $friendUid)", name: "PerfilPublico.ViewFriendProfile");
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Funcionalidad "Ver Perfil" no implementada aún.', style: TextStyle(fontFamily: _fontFamily))),
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildStoriesSection(String userId) {
    return Container(
      margin: const EdgeInsets.only(top: 0, bottom: 15.0),
      padding: const EdgeInsets.all(10.0),
      decoration: BoxDecoration(
        color: _tabBackgroundColor,
        borderRadius: BorderRadius.circular(9.0),
        border: Border.all(width: 1.0, color: _primaryTextColor.withOpacity(0.89)),
      ),
      child: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('stories')
            .where('userId', isEqualTo: userId)
            .where('expiresAt', isGreaterThan: Timestamp.now())
            .orderBy('expiresAt', descending: false)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(_buttonBackgroundColor)));
          }
          if (snapshot.hasError) {
            developer.log("Error cargando historias del perfil: ${snapshot.error}", name: "PerfilPublico.StoryStream", error: snapshot.error);
            return Padding(
              padding: const EdgeInsets.all(20.0),
              child: Text(
                'Error al cargar historias.\nDetalle: ${snapshot.error}',
                textAlign: TextAlign.center,
                style: const TextStyle(fontFamily: _fontFamily, color: Colors.redAccent),
              ),
            );
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Padding(
              padding: EdgeInsets.all(30.0),
              child: Center(
                child: Text(
                  'Aún no tienes historias activas.\n¡Crea una y compártela!',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontFamily: _fontFamily, fontSize: 18, color: _primaryTextColor),
                ),
              ),
            );
          }

          final storyDocs = snapshot.data!.docs;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 8.0, bottom: 10.0, top: 5.0),
                child: Text(
                  'Historias Activas (${storyDocs.length})',
                  style: const TextStyle(fontFamily: _fontFamily, fontSize: 18, fontWeight: FontWeight.bold, color: _primaryTextColor),
                ),
              ),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 8.0,
                  mainAxisSpacing: 8.0,
                  childAspectRatio: 0.7,
                ),
                itemCount: storyDocs.length,
                itemBuilder: (context, index) {
                  final story = storyDocs[index];
                  final storyData = story.data() as Map<String, dynamic>;
                  final mediaUrl = storyData['mediaUrl'] as String?;
                  final isVideo = (storyData['esVideo'] as bool?) ?? false;
                  final caption = storyData['caption'] as String? ?? '';
                  final expiresAt = (storyData['expiresAt'] as Timestamp?)?.toDate();

                  String timeRemaining = '';
                  if (expiresAt != null) {
                    final remaining = expiresAt.difference(DateTime.now());
                    if (remaining.isNegative) {
                      timeRemaining = 'Expirada';
                    } else if (remaining.inHours > 0) {
                      timeRemaining = '${remaining.inHours}h restantes';
                    } else {
                      timeRemaining = '${remaining.inMinutes}m restantes';
                    }
                  }

                  return GestureDetector(
                    onTap: () => _showStoryDialog(context, story),
                    child: Container(
                      decoration: BoxDecoration(
                        color: _tabBackgroundColor.withOpacity(0.8),
                        borderRadius: BorderRadius.circular(10.0),
                        border: Border.all(color: _primaryTextColor.withOpacity(0.5)),
                        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2))],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          if (mediaUrl != null && mediaUrl.isNotEmpty)
                            Expanded(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(8.0),
                                child: isVideo
                                    ? Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    _VideoPlayerWidgetFromHome(key: ValueKey('story_preview_video_${story.id}'), videoUrl: mediaUrl),
                                    const Icon(Icons.play_circle_outline, color: Colors.white70, size: 40),
                                  ],
                                )
                                    : CachedNetworkImage(
                                  imageUrl: mediaUrl,
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                  height: double.infinity,
                                  placeholder: (context, url) => const Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(_buttonBackgroundColor))),
                                  errorWidget: (context, url, error) => const Icon(Icons.image_not_supported_outlined, size: 40, color: Colors.grey),
                                ),
                              ),
                            )
                          else
                            const Expanded(
                              child: Center(
                                child: Icon(Icons.photo_library_outlined, size: 40, color: Colors.grey),
                              ),
                            ),
                          Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Text(
                              caption.isNotEmpty ? caption : (isVideo ? 'Video' : 'Imagen'),
                              textAlign: TextAlign.center,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(fontFamily: _fontFamily, fontSize: 12, color: _primaryTextColor, fontWeight: FontWeight.bold),
                            ),
                          ),
                          Text(
                            timeRemaining,
                            style: TextStyle(fontFamily: _fontFamily, fontSize: 10, color: Colors.grey[700]),
                          ),
                          const SizedBox(height: 4),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildUserPublicationsSection(BuildContext context, String userId, Map<String, dynamic> ownerUserData) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('publicaciones')
          .where('usuarioId', isEqualTo: userId)
          .orderBy('fecha', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(_buttonBackgroundColor)));
        }
        if (snapshot.hasError) {
          developer.log("Error cargando publicaciones del perfil: ${snapshot.error}", name:"PerfilPublico.PubStream", error: snapshot.error);
          return Padding(
              padding: const EdgeInsets.all(20.0),
              child: Text(
                  'Error al cargar publicaciones.\nDetalle: ${snapshot.error}',
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontFamily: _fontFamily, color: Colors.redAccent)
              )
          );
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Padding(
            padding: EdgeInsets.all(30.0),
            child: Center(
              child: Text(
                'Aún no tienes publicaciones.\n¡Anímate a compartir algo!',
                textAlign: TextAlign.center,
                style: TextStyle(fontFamily: _fontFamily, fontSize: 18, color: _primaryTextColor),
              ),
            ),
          );
        }
        return ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: snapshot.data!.docs.length,
          itemBuilder: (itemBuilderContext, index) {
            var publicacion = snapshot.data!.docs[index];
            return _buildPublicacionItemEstiloHome(publicacion, itemBuilderContext, ownerUserData);
          },
        );
      },
    );
  }

  Widget _buildPublicacionItemEstiloHome(DocumentSnapshot publicacion, BuildContext itemContext, Map<String, dynamic> postOwnerUserDataFromProfile) {
    final pubData = publicacion.data() as Map<String, dynamic>;
    final mediaUrl = pubData['imagenUrl'] as String?;
    final isVideo = (pubData['esVideo'] as bool?) ?? false;
    final hasValidMedia = mediaUrl != null && mediaUrl.isNotEmpty;
    final currentUserId = FirebaseAuth.instance.currentUser?.uid;
    final String postOwnerId = pubData['usuarioId'] ?? currentUserId!;
    final String postOwnerName = pubData['usuarioNombre'] ?? postOwnerUserDataFromProfile['nombreUsuario'] ?? postOwnerUserDataFromProfile['name'] ?? 'Usuario';
    final String? postOwnerProfilePicUrl = pubData['usuarioFoto'] ?? postOwnerUserDataFromProfile['profilePhotoUrl'];
    final likes = pubData['likes'] as int? ?? 0;
    final likedBy = List<String>.from(pubData['likedBy'] as List<dynamic>? ?? []);
    final commentsCount = (pubData['comentariosCount'] as int?) ?? (pubData['comentarios'] as int?) ?? 0;
    final String tipoPublicacion = pubData['tipoPublicacion'] ?? 'Público';

    return Container(
      margin: const EdgeInsets.only(bottom: 15.0),
      decoration: BoxDecoration(
          color: _tabBackgroundColor,
          borderRadius: BorderRadius.circular(9.0),
          border: Border.all(width: 1.0, color: _primaryTextColor.withOpacity(0.89))
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundColor: Colors.grey[200],
                  backgroundImage: postOwnerProfilePicUrl != null && postOwnerProfilePicUrl.isNotEmpty
                      ? CachedNetworkImageProvider(postOwnerProfilePicUrl)
                      : null,
                  child: (postOwnerProfilePicUrl == null || postOwnerProfilePicUrl.isEmpty)
                      ? const Icon(Icons.person, color: Colors.grey)
                      : null,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        postOwnerName,
                        style: const TextStyle(fontFamily: _fontFamily, fontSize: 17, fontWeight: FontWeight.bold, color: _primaryTextColor),
                      ),
                      Row(
                        children: [
                          Image.asset('assets/images/publico.png', width: 15, height: 15),
                          const SizedBox(width: 5),
                          Text(
                            tipoPublicacion,
                            style: TextStyle(fontFamily: _fontFamily, fontSize: 14, color: Colors.grey[700]),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                if (currentUserId == postOwnerId)
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        padding: const EdgeInsets.all(4),
                        constraints: const BoxConstraints(),
                        icon: Image.asset('assets/images/editar.png', width: 40, height: 40),
                        tooltip: 'Editar publicación',
                        onPressed: () => _mostrarDialogoEditarPublicacionIndividual(publicacion, itemContext),
                      ),
                      const SizedBox(width: 8),
                      IconButton(
                        padding: const EdgeInsets.all(4),
                        constraints: const BoxConstraints(),
                        icon: Image.asset('assets/images/eliminar.png', width: 40, height: 40),
                        tooltip: 'Eliminar publicación',
                        onPressed: () => _eliminarPublicacion(publicacion.id, itemContext, mediaUrl),
                      ),
                    ],
                  ),
              ],
            ),
          ),
          if (hasValidMedia)
            GestureDetector(
              onTap: () => Navigator.push(itemContext, MaterialPageRoute(builder: (_) => DetallesdeFotooVideo(
                key: Key('Detalles_Pub_Perfil_${publicacion.id}'),
                publicationId: publicacion.id,
                mediaUrl: mediaUrl,
                isVideo: isVideo,
                caption: pubData['caption'] as String?,
                ownerUserId: postOwnerId,
                ownerUserName: postOwnerName,
                ownerUserProfilePic: postOwnerProfilePicUrl,
              ))),
              child: Container(
                width: double.infinity,
                constraints: BoxConstraints(maxHeight: MediaQuery.of(itemContext).size.height * 0.55),
                color: Colors.grey[200],
                child: isVideo
                    ? _VideoPlayerWidgetFromHome(key: ValueKey('video_pub_perfil_${publicacion.id}'), videoUrl: mediaUrl)
                    : CachedNetworkImage(
                    imageUrl: mediaUrl!,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => const Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(_buttonBackgroundColor))),
                    errorWidget: (context, url, error) {
                      developer.log("Error CachedNetworkImage (Perfil Pub): $error, URL: $url", name: "PerfilPublico.PubImage", error: error);
                      return _buildMediaErrorWidget('la imagen');
                    }
                ),
              ),
            )
          else
            _buildMediaErrorWidget('contenido multimedia no disponible'),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
            child: Text(
              pubData['caption'] ?? '',
              style: const TextStyle(fontFamily: _fontFamily, fontSize: 15, color: _primaryTextColor, fontWeight: FontWeight.w700),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Divider(height: 1, color: Colors.grey.withOpacity(0.5), indent: 10, endIndent: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 6.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildPostActionEstiloHome(
                    iconAsset: 'assets/images/like.png',
                    label: likes.toString(),
                    isLiked: likedBy.contains(currentUserId),
                    onTap: () => _toggleLike(publicacion.id, currentUserId, likedBy, itemContext)
                ),
                _buildPostActionEstiloHome(
                    iconAsset: 'assets/images/comments.png',
                    label: commentsCount.toString(),
                    onTap: () => Navigator.push(itemContext, MaterialPageRoute(builder: (_) => DetallesdeFotooVideo(
                      key: Key('Detalles_Comments_Perfil_${publicacion.id}'),
                      publicationId: publicacion.id,
                      mediaUrl: mediaUrl,
                      isVideo: isVideo,
                      caption: pubData['caption'] as String?,
                      ownerUserId: postOwnerId,
                      ownerUserName: postOwnerName,
                      ownerUserProfilePic: postOwnerProfilePicUrl,
                    )))
                ),
                _buildPostActionEstiloHome(
                    iconAsset: 'assets/images/share.png',
                    label: 'SHARE',
                    onTap: () => Navigator.push(itemContext, MaterialPageRoute(builder: (_) => CompartirPublicacion(
                      key: Key('Compartir_Perfil_${publicacion.id}'),
                      publicationId: publicacion.id,
                      mediaUrl: mediaUrl,
                      caption: pubData['caption'] as String?,
                    )))
                ),
                StreamBuilder<DocumentSnapshot>(
                    stream: FirebaseFirestore.instance.collection('users').doc(currentUserId).collection('publicacionesGuardadas').doc(publicacion.id).snapshots(),
                    builder: (context, snapshotSaved) {
                      bool isSaved = snapshotSaved.hasData && snapshotSaved.data!.exists;
                      return _buildPostActionEstiloHome(
                          iconAsset: isSaved ? 'assets/images/saved_filled.png' : 'assets/images/save.png',
                          label: isSaved ? 'SAVED' : 'SAVE',
                          isSavedStyle: isSaved,
                          onTap: () => _guardarPublicacion(publicacion.id, itemContext)
                      );
                    }
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPostActionEstiloHome({required String iconAsset, required String label, bool isLiked = false, bool isSavedStyle = false, required VoidCallback onTap}) {
    double iconSize = 40.0;
    Color? activeColor;

    if (isSavedStyle) {
      activeColor = _buttonBackgroundColor;
    }

    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 6.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(iconAsset, width: iconSize, height: iconSize, fit: BoxFit.contain, color: activeColor),
              const SizedBox(width: 6),
              Text(label, style: TextStyle(fontFamily: _fontFamily, fontSize: 16, color: activeColor ?? _primaryTextColor)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMediaErrorWidget(String typeMessage) {
    IconData iconData = Icons.image_not_supported_outlined;
    String message = 'Error al cargar $typeMessage';
    if (typeMessage.contains('no disponible')) {
      message = 'Contenido no disponible';
    } else if (typeMessage.contains('video')) {
      iconData = Icons.videocam_off_outlined;
    }

    return Container(
      width: double.infinity,
      height: 200,
      color: Colors.grey[200],
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(iconData, size: 50, color: Colors.grey[500]),
          const SizedBox(height: 10),
          Text(
            message,
            textAlign: TextAlign.center,
            style: TextStyle(fontFamily: _fontFamily, fontSize: 16, color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }
}

// --- WIDGET PARA VISUALIZAR HISTORIA ---
class _StoryViewerWidget extends StatefulWidget {
  final String mediaUrl;
  final bool isVideo;
  final String caption;
  final String userName;
  final String? userProfilePic;

  const _StoryViewerWidget({
    Key? key,
    required this.mediaUrl,
    required this.isVideo,
    required this.caption,
    required this.userName,
    this.userProfilePic,
  }) : super(key: key);

  @override
  _StoryViewerWidgetState createState() => _StoryViewerWidgetState();
}

class _StoryViewerWidgetState extends State<_StoryViewerWidget> {
  VideoPlayerController? _videoController;
  bool _isMediaInitialized = false;

  @override
  void initState() {
    super.initState();
    if (widget.isVideo) {
      Uri? uri = Uri.tryParse(widget.mediaUrl);
      if (uri != null) {
        _videoController = VideoPlayerController.networkUrl(uri)
          ..initialize().then((_) {
            if (mounted) {
              setState(() {
                _isMediaInitialized = true;
              });
              _videoController?.play();
              _videoController?.setLooping(true);
            }
          }).catchError((e) {
            developer.log("Error inicializando video en StoryViewer: $e", name: "StoryViewer");
            if (mounted) setState(() => _isMediaInitialized = false);
          });
      }
    } else {
      // For images, we consider it "initialized" immediately.
      _isMediaInitialized = true;
    }
  }

  @override
  void dispose() {
    _videoController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.of(context).pop(),
      child: Scaffold(
        backgroundColor: Colors.transparent, // Background is controlled by the barrierColor of showDialog
        body: SafeArea(
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Media Content
              _buildMediaContent(),

              // Header with user info and close button
              Positioned(
                top: 15,
                left: 10,
                right: 10,
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 20,
                      backgroundColor: Colors.grey[300],
                      backgroundImage: widget.userProfilePic != null && widget.userProfilePic!.isNotEmpty
                          ? CachedNetworkImageProvider(widget.userProfilePic!)
                          : null,
                      child: (widget.userProfilePic == null || widget.userProfilePic!.isEmpty)
                          ? const Icon(Icons.person, color: Colors.grey)
                          : null,
                    ),
                    const SizedBox(width: 10),
                    Text(
                      widget.userName,
                      style: const TextStyle(
                        fontFamily: _fontFamily,
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        shadows: [Shadow(blurRadius: 3.0, color: Colors.black54)],
                      ),
                    ),
                    const Spacer(),
                    IconButton(
                      icon: const Icon(Icons.close, color: Colors.white, size: 30),
                      onPressed: () => Navigator.of(context).pop(),
                      tooltip: 'Cerrar historia',
                    ),
                  ],
                ),
              ),

              // Caption at the bottom
              if (widget.caption.isNotEmpty)
                Positioned(
                  bottom: 30,
                  left: 20,
                  right: 20,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.6),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Text(
                      widget.caption,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontFamily: _fontFamily,
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMediaContent() {
    if (!_isMediaInitialized) {
      return const Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(_buttonBackgroundColor)));
    }

    if (widget.isVideo) {
      if (_videoController != null && _videoController!.value.isInitialized) {
        return Center(
          child: AspectRatio(
            aspectRatio: _videoController!.value.aspectRatio,
            child: VideoPlayer(_videoController!),
          ),
        );
      } else {
        return const Center(child: Text("Error al cargar video", style: TextStyle(color: Colors.white, fontFamily: _fontFamily)));
      }
    } else {
      return CachedNetworkImage(
        imageUrl: widget.mediaUrl,
        fit: BoxFit.contain,
        placeholder: (context, url) => const Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(_buttonBackgroundColor))),
        errorWidget: (context, url, error) => const Center(child: Icon(Icons.broken_image, color: Colors.white70, size: 60)),
      );
    }
  }
}

// --- MODAL PARA EDITAR PERFIL ---
// Código del modal _EditarPerfilUsuarioModalWidget (sin cambios funcionales significativos, solo optimizaciones)
class _EditarPerfilUsuarioModalWidget extends StatefulWidget {
  final String userId;
  final Map<String, dynamic> currentUserData;
  final BuildContext parentContextForSnackbars;
  const _EditarPerfilUsuarioModalWidget({Key? key, required this.userId, required this.currentUserData, required this.parentContextForSnackbars}) : super(key: key);
  @override
  __EditarPerfilUsuarioModalWidgetState createState() => __EditarPerfilUsuarioModalWidgetState();
}
class __EditarPerfilUsuarioModalWidgetState extends State<_EditarPerfilUsuarioModalWidget> {
  late TextEditingController _userNameController;
  late TextEditingController _cityController;
  late TextEditingController _originCityController;
  late TextEditingController _preferencesController;
  DateTime? _selectedBirthDate;
  late TextEditingController _birthDateDisplayController;


  String? _selectedGender;
  File? _newProfileImageFile;
  Uint8List? _newProfileImageBytesPreview;
  bool _isUploading = false;
  final ImagePicker _picker = ImagePicker();
  final _formKey = GlobalKey<FormState>();
  final List<String> _genderOptions = ['Masculino', 'Femenino', 'Otro', 'Prefiero no decirlo'];

  @override
  void initState() {
    super.initState();
    _userNameController = TextEditingController(text: widget.currentUserData['nombreUsuario'] ?? widget.currentUserData['name'] ?? '');
    _cityController = TextEditingController(text: widget.currentUserData['ciudad'] ?? '');
    _originCityController = TextEditingController(text: widget.currentUserData['ciudadOrigen'] ?? '');
    _preferencesController = TextEditingController(text: widget.currentUserData['preferenciasUsuario'] ?? '');
    _selectedGender = widget.currentUserData['genero'];
    if (_selectedGender != null && !_genderOptions.contains(_selectedGender)) _selectedGender = null;

    _birthDateDisplayController = TextEditingController();
    if (widget.currentUserData['fechaNacimiento'] != null && widget.currentUserData['fechaNacimiento'] is Timestamp) {
      _selectedBirthDate = (widget.currentUserData['fechaNacimiento'] as Timestamp).toDate();
      _birthDateDisplayController.text = DateFormat('dd/MM/yyyy', 'es_ES').format(_selectedBirthDate!);
    }
  }

  Future<void> _selectProfileImage() async {
    try {
      final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery, imageQuality: 70, maxWidth: 800, maxHeight: 800);
      if (pickedFile != null) {
        if (kIsWeb) {
          _newProfileImageBytesPreview = await pickedFile.readAsBytes();
        }
        if (mounted) {
          setState(() {
            _newProfileImageFile = File(pickedFile.path);
          });
        }
      }
    } catch (e) {
      developer.log("Error seleccionando imagen de perfil: $e", name: "EditarPerfilModal.Picker", error: e);
      if (mounted) ScaffoldMessenger.of(widget.parentContextForSnackbars).showSnackBar(SnackBar(content: Text('Error al seleccionar imagen: $e', style: const TextStyle(fontFamily: _fontFamily))));
    }
  }

  Future<void> _selectBirthDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedBirthDate ?? DateTime.now().subtract(const Duration(days: 365 * 18)),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      locale: const Locale('es', 'ES'),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: _buttonBackgroundColor,
              onPrimary: Colors.white,
              surface: _tabBackgroundColor,
              onSurface: _primaryTextColor,
            ),
            dialogBackgroundColor: Colors.white,
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                  foregroundColor: _buttonBackgroundColor,
                  textStyle: const TextStyle(fontFamily: _fontFamily, fontWeight: FontWeight.bold)
              ),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _selectedBirthDate) {
      setState(() {
        _selectedBirthDate = picked;
        _birthDateDisplayController.text = DateFormat('dd/MM/yyyy', 'es_ES').format(_selectedBirthDate!);
      });
    }
  }

  Future<void> _saveProfileChanges() async {
    if (!_formKey.currentState!.validate()) return;
    if (_isUploading) return;
    setState(() => _isUploading = true);
    Map<String, dynamic> dataToUpdate = {}; bool hasChanges = false;

    void checkAndAdd(String key, dynamic newValue, dynamic oldValue) {
      var effNew = (newValue is String) ? newValue.trim() : newValue;
      var effOld = (oldValue is String) ? oldValue?.trim() : oldValue;

      if (effNew != effOld) {
        if ((effNew is String && effNew.isEmpty) || effNew == null) {
          if (effOld != null && (effOld is! String || effOld.isNotEmpty)) {
            dataToUpdate[key] = FieldValue.delete();
            hasChanges = true;
          }
        } else {
          dataToUpdate[key] = effNew;
          hasChanges = true;
        }
      }
    }
    checkAndAdd('nombreUsuario', _userNameController.text, widget.currentUserData['nombreUsuario'] ?? widget.currentUserData['name']);
    checkAndAdd('ciudad', _cityController.text, widget.currentUserData['ciudad']);
    checkAndAdd('ciudadOrigen', _originCityController.text, widget.currentUserData['ciudadOrigen']);
    checkAndAdd('preferenciasUsuario', _preferencesController.text, widget.currentUserData['preferenciasUsuario']);
    checkAndAdd('genero', _selectedGender, widget.currentUserData['genero']);

    final Timestamp? currentBirthDateTimestamp = widget.currentUserData['fechaNacimiento'] as Timestamp?;
    if (_selectedBirthDate != null) {
      Timestamp newBirthDateTimestamp = Timestamp.fromDate(_selectedBirthDate!);
      if (newBirthDateTimestamp != currentBirthDateTimestamp) {
        dataToUpdate['fechaNacimiento'] = newBirthDateTimestamp;
        hasChanges = true;
        if (widget.currentUserData.containsKey('edad')) {
          dataToUpdate['edad'] = FieldValue.delete();
        }
      }
    } else if (currentBirthDateTimestamp != null) {
      dataToUpdate['fechaNacimiento'] = FieldValue.delete();
      hasChanges = true;
      if (widget.currentUserData.containsKey('edad')) {
        dataToUpdate['edad'] = FieldValue.delete();
      }
    }

    if (_newProfileImageFile != null) {
      hasChanges = true;
      try {
        String fileExtension = _newProfileImageFile!.path.split('.').last.toLowerCase();
        if (!['jpg', 'jpeg', 'png'].contains(fileExtension)) fileExtension = 'jpeg';
        String fileName = 'profile_photos/${widget.userId}/profile_${DateTime.now().millisecondsSinceEpoch}.$fileExtension';
        String contentType = 'image/$fileExtension';

        UploadTask uploadTask;
        if (kIsWeb) {
          if (_newProfileImageBytesPreview != null) {
            uploadTask = FirebaseStorage.instance.ref(fileName).putData(_newProfileImageBytesPreview!, SettableMetadata(contentType: contentType));
          } else {
            throw Exception("Bytes de previsualización de imagen nulos para subida web.");
          }
        } else {
          uploadTask = FirebaseStorage.instance.ref(fileName).putFile(_newProfileImageFile!, SettableMetadata(contentType: contentType));
        }

        TaskSnapshot snapshot = await uploadTask;
        String newProfilePhotoUrl = await snapshot.ref.getDownloadURL();
        dataToUpdate['profilePhotoUrl'] = newProfilePhotoUrl;

        final String? oldProfilePhotoUrl = widget.currentUserData['profilePhotoUrl'] as String?;
        if (oldProfilePhotoUrl != null && oldProfilePhotoUrl.isNotEmpty && oldProfilePhotoUrl.startsWith('https://firebasestorage.googleapis.com') && oldProfilePhotoUrl != newProfilePhotoUrl) {
          try {
            await FirebaseStorage.instance.refFromURL(oldProfilePhotoUrl).delete();
            developer.log('Foto de perfil antigua eliminada de Storage: $oldProfilePhotoUrl', name: "EditarPerfilModal.DeleteOld");
          } catch (e) {
            developer.log('Error eliminando foto de perfil antigua de Storage: $e. URL: $oldProfilePhotoUrl', name: "EditarPerfilModal.DeleteOld", error: e);
          }
        }
      } catch (e) {
        developer.log('Error subiendo nueva foto de perfil: $e', name: "EditarPerfilModal.Upload", error: e);
        if (mounted) ScaffoldMessenger.of(widget.parentContextForSnackbars).showSnackBar(SnackBar(content: Text('Error al subir foto: $e', style: const TextStyle(fontFamily: _fontFamily))));
        setState(() => _isUploading = false); return;
      }
    }
    if (hasChanges) {
      try {
        dataToUpdate['lastProfileUpdate'] = FieldValue.serverTimestamp();
        await FirebaseFirestore.instance.collection('users').doc(widget.userId).update(dataToUpdate);
        if (mounted) { ScaffoldMessenger.of(widget.parentContextForSnackbars).showSnackBar(const SnackBar(content: Text('Perfil actualizado', style: TextStyle(fontFamily: _fontFamily)), backgroundColor: Colors.green)); Navigator.of(context).pop(); }
      } catch (e) { developer.log('Error actualizando perfil en Firestore: $e', name: "EditarPerfilModal.FirestoreUpdate", error: e); if (mounted) ScaffoldMessenger.of(widget.parentContextForSnackbars).showSnackBar(SnackBar(content: Text('Error al actualizar: $e', style: const TextStyle(fontFamily: _fontFamily)))); }
    } else { if (mounted) { ScaffoldMessenger.of(widget.parentContextForSnackbars).showSnackBar(const SnackBar(content: Text('No se realizaron cambios.', style: TextStyle(fontFamily: _fontFamily)))); Navigator.of(context).pop(); }}
    if (mounted) setState(() => _isUploading = false);
  }
  @override void dispose() {
    _userNameController.dispose();
    _cityController.dispose();
    _originCityController.dispose();
    _preferencesController.dispose();
    _birthDateDisplayController.dispose();
    super.dispose();
  }

  Widget _buildTextField(TextEditingController controller, String label, {TextInputType keyboardType = TextInputType.text, String? imageAssetPath, bool isRequired = false, int? maxLength, bool readOnly = false, VoidCallback? onTap}) {
    Widget? prefixWidget;
    if (imageAssetPath != null) {
      prefixWidget = Padding(
        padding: const EdgeInsets.all(12.0),
        child: Image.asset(imageAssetPath, width: 24, height: 24),
      );
    }

    return Padding(padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: TextFormField(
            controller: controller,
            style: const TextStyle(fontFamily: _fontFamily, color: _primaryTextColor),
            maxLength: maxLength,
            readOnly: readOnly,
            onTap: onTap,
            decoration: InputDecoration(
                labelText: label + (isRequired ? ' *' : ''),
                labelStyle: const TextStyle(fontFamily: _fontFamily, color: Colors.black54),
                prefixIcon: prefixWidget,
                filled: true, fillColor: Colors.white.withOpacity(0.9),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0), borderSide: BorderSide.none),
                focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0), borderSide: const BorderSide(color: _buttonBackgroundColor, width: 2)),
                errorStyle: TextStyle(fontFamily: _fontFamily, color: Colors.redAccent[700], fontWeight: FontWeight.bold), counterText: ""),
            keyboardType: keyboardType,
            validator: (value) {
              if (isRequired && (value == null || value.trim().isEmpty)) return '$label es obligatorio.';
              return null;
            }, autovalidateMode: AutovalidateMode.onUserInteraction));
  }
  @override Widget build(BuildContext modalContext) {
    String? displayPhotoUrl = widget.currentUserData['profilePhotoUrl'] as String?;
    return FractionallySizedBox(heightFactor: 0.92,
        child: ClipRRect(borderRadius: const BorderRadius.only(topLeft: Radius.circular(20.0), topRight: Radius.circular(20.0)),
            child: Scaffold(backgroundColor: Colors.transparent,
                appBar: AppBar(title: const Text('Editar Perfil', style: TextStyle(fontFamily: _fontFamily, color: Colors.white)), backgroundColor: _scaffoldBgColorModal, elevation: 0, automaticallyImplyLeading: false,
                    actions: [IconButton(icon: const Icon(Icons.close, color: Colors.white), onPressed: () => Navigator.of(modalContext).pop())]),
                body: Stack(children: [
                  Container(decoration: const BoxDecoration(image: DecorationImage(image: AssetImage('assets/images/Animal Health Fondo de Pantalla.png'), fit: BoxFit.cover))),
                  SingleChildScrollView(padding: const EdgeInsets.all(16.0),
                      child: Form(key: _formKey,
                          child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: <Widget>[
                            Center(child: Stack(children: [
                              Container(width: 130, height: 130, decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: _buttonBackgroundColor, width: 3), color: Colors.grey[300]),
                                  child: ClipOval(child: _newProfileImageFile != null
                                      ? (kIsWeb && _newProfileImageBytesPreview != null ? Image.memory(_newProfileImageBytesPreview!, fit: BoxFit.cover) : (!kIsWeb ? Image.file(_newProfileImageFile!, fit: BoxFit.cover) : const Center(child: Text("Preview...", style: TextStyle(fontFamily: _fontFamily)))))
                                      : (displayPhotoUrl != null && displayPhotoUrl.isNotEmpty ? CachedNetworkImage(imageUrl: displayPhotoUrl, fit: BoxFit.cover, placeholder: (ctx, url) => const Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(_buttonBackgroundColor))), errorWidget: (ctx, url, error) => const Icon(Icons.person, size: 70, color: Colors.grey)) : const Icon(Icons.person, size: 70, color: Colors.grey)))),
                              Positioned(bottom: 0, right: 0, child: Material(color: _buttonBackgroundColor, borderRadius: BorderRadius.circular(20), child: InkWell(onTap: _selectProfileImage, borderRadius: BorderRadius.circular(20), child: const Padding(padding: EdgeInsets.all(8.0), child: Icon(Icons.camera_alt, color: Colors.white, size: 20))))),
                            ])), const SizedBox(height: 20),
                            _buildTextField(_userNameController, 'Nombre de Usuario', imageAssetPath: 'assets/images/nombreusuario.png', isRequired: true, maxLength: 50),
                            _buildTextField(_cityController, 'Ciudad donde vives', imageAssetPath: 'assets/images/viveen.png', maxLength: 50),
                            _buildTextField(_originCityController, 'Ciudad de origen', imageAssetPath: 'assets/images/de.png', maxLength: 50),

                            _buildTextField(
                              _birthDateDisplayController,
                              'Fecha de Nacimiento',
                              imageAssetPath: 'assets/images/edadusuario.png',
                              readOnly: true,
                              onTap: () => _selectBirthDate(modalContext),
                            ),

                            Padding(padding: const EdgeInsets.symmetric(vertical: 8.0),
                                child: DropdownButtonFormField<String>(value: _selectedGender,
                                    decoration: InputDecoration(
                                        labelText: 'Género',
                                        labelStyle: const TextStyle(fontFamily: _fontFamily, color: Colors.black54),
                                        prefixIcon: Padding(
                                          padding: const EdgeInsets.all(12.0),
                                          child: Image.asset('assets/images/genero.png', width: 24, height: 24),
                                        ),
                                        filled: true, fillColor: Colors.white.withOpacity(0.9),
                                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0), borderSide: BorderSide.none),
                                        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0), borderSide: const BorderSide(color: _buttonBackgroundColor, width: 2))
                                    ),
                                    items: _genderOptions.map((String value) => DropdownMenuItem<String>(value: value, child: Text(value, style: const TextStyle(fontFamily: _fontFamily)))).toList(),
                                    onChanged: (String? newValue) => setState(() => _selectedGender = newValue), dropdownColor: Colors.white.withOpacity(0.95), style: const TextStyle(fontFamily: _fontFamily, color: _primaryTextColor))),
                            _buildTextField(_preferencesController, 'Preferencias de mascotas', imageAssetPath: 'assets/images/preferencias.png', maxLength: 100),
                            const SizedBox(height: 30),
                            _isUploading ? const Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(_buttonBackgroundColor)))
                                : ElevatedButton.icon(icon: const Icon(Icons.save_alt_outlined, color: Colors.white), label: const Text('Guardar Cambios', style: TextStyle(color: Colors.white)), onPressed: _saveProfileChanges,
                                style: ElevatedButton.styleFrom(backgroundColor: _buttonBackgroundColor, padding: const EdgeInsets.symmetric(vertical: 15.0), textStyle: const TextStyle(fontFamily: _fontFamily, fontSize: 18, fontWeight: FontWeight.bold), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)))),
                            const SizedBox(height: 10),
                            TextButton(onPressed: () => Navigator.of(modalContext).pop(), child: const Text('Cancelar', style: TextStyle(fontFamily: _fontFamily, color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold))),
                            const SizedBox(height: 40),
                          ])))]))));
  }
}

// --- WIDGET DE VideoPlayer ---
// Código del widget _VideoPlayerWidgetFromHome (sin cambios funcionales significativos, solo optimizaciones)
class _VideoPlayerWidgetFromHome extends StatefulWidget {
  final String videoUrl;
  const _VideoPlayerWidgetFromHome({Key? key, required this.videoUrl}) : super(key: key);

  @override
  __VideoPlayerWidgetFromHomeState createState() => __VideoPlayerWidgetFromHomeState();
}

class __VideoPlayerWidgetFromHomeState extends State<_VideoPlayerWidgetFromHome> {
  late VideoPlayerController _controller;
  late Future<void> _initializeVideoPlayerFuture;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _initializePlayer();
  }

  @override
  void didUpdateWidget(covariant _VideoPlayerWidgetFromHome oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.videoUrl != oldWidget.videoUrl) {
      _controller.dispose();
      _initializePlayer();
    }
  }

  void _initializePlayer() {
    _hasError = false;
    Uri? uri = Uri.tryParse(widget.videoUrl);

    if (uri == null || !uri.isAbsolute) {
      developer.log("URL de video inválida o no absoluta para VideoPlayer: ${widget.videoUrl}", name: "VideoPlayerPerfil");
      if (mounted) setState(() => _hasError = true);
      _initializeVideoPlayerFuture = Future.error("URL inválida: ${widget.videoUrl}");
      return;
    }

    _controller = VideoPlayerController.networkUrl(uri);
    _initializeVideoPlayerFuture = _controller.initialize().then((_) {
      if (mounted) setState(() {});
    }).catchError((error) {
      developer.log("Error inicializando VideoPlayer (Perfil): $error, URL: ${widget.videoUrl}", name: "VideoPlayerPerfil", error: error);
      if (mounted) setState(() => _hasError = true);
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
    if (_hasError) return _buildVideoErrorWidget();

    return FutureBuilder(
      future: _initializeVideoPlayerFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done && !_hasError) {
          if (_controller.value.hasError) {
            developer.log("Error en VideoPlayerController (Perfil): ${_controller.value.errorDescription}, URL: ${widget.videoUrl}", name: "VideoPlayerPerfil", error: _controller.value.errorDescription);
            return _buildVideoErrorWidget();
          }
          if (!_controller.value.isInitialized) {
            return const Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(_buttonBackgroundColor)));
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
          developer.log("Error en FutureBuilder de VideoPlayer (Perfil): ${snapshot.error}, URL: ${widget.videoUrl}", name: "VideoPlayerPerfil", error: snapshot.error);
          return _buildVideoErrorWidget();
        }
        else {
          return const Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(_buttonBackgroundColor)));
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
          child: const Center(
            child: Icon(
              Icons.play_arrow,
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
            style: TextStyle(color: Colors.white, fontSize: 14, fontFamily: _fontFamily),
          ),
        ],
      ),
    );
  }
}

// --- WIDGET PARA EDITAR PUBLICACIÓN INDIVIDUAL ---
// Código del widget EditarPublicacionIndividualWidget (sin cambios funcionales significativos, solo optimizaciones)
class EditarPublicacionIndividualWidget extends StatefulWidget {
  final String publicacionId;
  final String captionActual;
  final String? mediaUrlActual;
  final bool esVideoActual;
  final BuildContext parentContext;

  const EditarPublicacionIndividualWidget({
    required Key key,
    required this.publicacionId,
    required this.captionActual,
    this.mediaUrlActual,
    required this.esVideoActual,
    required this.parentContext,
  }) : super(key: key);

  @override
  _EditarPublicacionIndividualWidgetState createState() => _EditarPublicacionIndividualWidgetState();
}

class _EditarPublicacionIndividualWidgetState extends State<EditarPublicacionIndividualWidget> {
  late TextEditingController _captionController;
  File? _nuevoMedioFile;
  Uint8List? _nuevoMedioBytesPreview;
  bool _esNuevoMedioVideo = false;
  bool _isUploading = false;
  final ImagePicker _picker = ImagePicker();
  final _formKeyModalPost = GlobalKey<FormState>();
  VideoPlayerController? _videoPlayerControllerPreview;

  @override
  void initState() {
    super.initState();
    _captionController = TextEditingController(text: widget.captionActual);
    _esNuevoMedioVideo = widget.esVideoActual;
    if (widget.mediaUrlActual != null && widget.esVideoActual) {
      _initializeVideoPlayerPreview(widget.mediaUrlActual!);
    }
  }

  void _initializeVideoPlayerPreview(String url, {bool isFile = false}) async {
    await _videoPlayerControllerPreview?.dispose();

    Uri? uri = Uri.tryParse(url);
    if (uri == null) {
      developer.log("URL inválida para VideoPlayer (Preview Edit): $url", name: "EditPubPerfil.Video");
      if (mounted) {
        ScaffoldMessenger.of(widget.parentContext).showSnackBar(
          SnackBar(content: Text('URL de video inválida: $url', style: const TextStyle(fontFamily: _fontFamily))),
        );
      }
      return;
    }

    if (isFile && !kIsWeb) {
      _videoPlayerControllerPreview = VideoPlayerController.file(File(url));
    } else {
      _videoPlayerControllerPreview = VideoPlayerController.networkUrl(uri);
    }

    try {
      await _videoPlayerControllerPreview!.initialize();
      if (mounted) setState(() {});
      _videoPlayerControllerPreview!.setLooping(true);
    } catch (e) {
      developer.log("Error inicializando VideoPlayer preview (Edit Perfil): $e, URL: $url", name: "EditPubPerfil.Video", error: e);
      if (mounted) {
        ScaffoldMessenger.of(widget.parentContext).showSnackBar(
          const SnackBar(content: Text('Error al cargar la vista previa del video.', style: TextStyle(fontFamily: _fontFamily))),
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

        if (kIsWeb) {
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
      developer.log("Error seleccionando media para editar (Perfil): $e", name: "EditPubPerfil.Picker", error: e);
      if (mounted) {
        ScaffoldMessenger.of(widget.parentContext).showSnackBar(
          SnackBar(content: Text('Error al seleccionar: $e', style: const TextStyle(fontFamily: _fontFamily))),
        );
      }
    }
  }

  Future<void> _guardarCambiosPublicacion() async {
    if (!_formKeyModalPost.currentState!.validate()) return;
    if (_isUploading) return;
    setState(() => _isUploading = true);

    Map<String, dynamic> datosParaActualizar = {};
    bool hayCambios = false;

    String nuevoCaption = _captionController.text.trim();
    if (nuevoCaption != widget.captionActual) {
      datosParaActualizar['caption'] = nuevoCaption;
      hayCambios = true;
    }

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
          Uint8List? bytesParaSubir = await _nuevoMedioFile!.readAsBytes();
          if (bytesParaSubir.isNotEmpty) {
            uploadTask = FirebaseStorage.instance.ref(fileName).putData(bytesParaSubir, SettableMetadata(contentType: contentType));
          } else {
            throw Exception("Bytes nulos para la subida del medio en web.");
          }
        } else {
          uploadTask = FirebaseStorage.instance.ref(fileName).putFile(_nuevoMedioFile!, SettableMetadata(contentType: contentType));
        }

        TaskSnapshot snapshot = await uploadTask;
        String urlMediaFinalParaActualizar = await snapshot.ref.getDownloadURL();

        datosParaActualizar['imagenUrl'] = urlMediaFinalParaActualizar;
        datosParaActualizar['esVideo'] = _esNuevoMedioVideo;

        if (widget.mediaUrlActual != null &&
            widget.mediaUrlActual!.isNotEmpty &&
            widget.mediaUrlActual!.startsWith('https://firebasestorage.googleapis.com')) {
          try {
            await FirebaseStorage.instance.refFromURL(widget.mediaUrlActual!).delete();
            developer.log('Medio antiguo eliminado (Edit Perfil): ${widget.mediaUrlActual}', name: "EditPubPerfil.DeleteOldStorage");
          } catch (e) {
            developer.log('Error eliminando medio antiguo (Edit Perfil): $e. URL: ${widget.mediaUrlActual}', name: "EditPubPerfil.DeleteOldStorage", error: e);
          }
        }
      } catch (e) {
        developer.log('Error subiendo nuevo medio (Edit Perfil): $e', name: "EditPubPerfil.Upload", error: e);
        if (mounted) {
          ScaffoldMessenger.of(widget.parentContext).showSnackBar(
            SnackBar(content: Text('Error al subir medio: $e', style: const TextStyle(fontFamily: _fontFamily))),
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
            const SnackBar(content: Text('Publicación actualizada', style: TextStyle(fontFamily: _fontFamily)), backgroundColor: Colors.green),
          );
          Navigator.of(context).pop();
        }
      } catch (e) {
        developer.log('Error actualizando publicación Firestore (Edit Perfil): $e', name: "EditPubPerfil.FirestoreUpdate", error: e);
        if (mounted) {
          ScaffoldMessenger.of(widget.parentContext).showSnackBar(
            SnackBar(content: Text('Error al actualizar: $e', style: const TextStyle(fontFamily: _fontFamily))),
          );
        }
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(widget.parentContext).showSnackBar(
          const SnackBar(content: Text('No se realizaron cambios.', style: TextStyle(fontFamily: _fontFamily))),
        );
        Navigator.of(context).pop();
      }
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

  Widget _buildMediaPreview() {
    // Preview para video nuevo seleccionado
    if (_nuevoMedioFile != null && _esNuevoMedioVideo) {
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
        return Container(height: 200, color: Colors.black, child: const Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(_buttonBackgroundColor)) ));
      }
    }
    // Preview para imagen nueva seleccionada
    else if (_nuevoMedioFile != null && !_esNuevoMedioVideo) {
      if (kIsWeb && _nuevoMedioBytesPreview != null) {
        return Image.memory(_nuevoMedioBytesPreview!, height: 200, fit: BoxFit.contain);
      } else if (!kIsWeb) {
        return Image.file(_nuevoMedioFile!, height: 200, fit: BoxFit.contain);
      }
    }
    // Preview para video existente (desde URL)
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
      }
    }
    // Preview para imagen existente (desde URL)
    else if (widget.mediaUrlActual != null && !widget.esVideoActual) {
      return CachedNetworkImage(
        imageUrl: widget.mediaUrlActual!,
        height: 200,
        fit: BoxFit.contain,
        placeholder: (context, url) => Container(height: 200, color: Colors.grey[300], child: const Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(_buttonBackgroundColor)))),
        errorWidget: (context, url, error) => Container(height: 200, color: Colors.grey[300], child: const Icon(Icons.broken_image, size: 50, color: Colors.grey)),
      );
    }
    // Placeholder si no hay nada
    return Container(
      height: 150,
      decoration: BoxDecoration(color: Colors.grey[800], borderRadius: BorderRadius.circular(10)),
      child: const Center(
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: Text(
            'No hay medio adjunto.\nPresiona "Cambiar Foto" o "Cambiar Video" para reemplazarlo.',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white70, fontFamily: _fontFamily),
          ),
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

  @override Widget build(BuildContext modalContext) {
    return FractionallySizedBox(
      heightFactor: 0.9,
      child: ClipRRect(
        borderRadius: const BorderRadius.only(topLeft: Radius.circular(20.0), topRight: Radius.circular(20.0)),
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Editar Publicación', style: TextStyle(fontFamily: _fontFamily, color: Colors.white)),
            backgroundColor: _scaffoldBgColorModal,
            elevation: 0,
            automaticallyImplyLeading: false,
            actions: [
              IconButton(icon: const Icon(Icons.close, color: Colors.white), onPressed: () => Navigator.of(modalContext).pop())
            ],
          ),
          body: Stack(
            children: [
              Container(
                decoration: const BoxDecoration(
                    image: DecorationImage(image: AssetImage('assets/images/Animal Health Fondo de Pantalla.png'), fit: BoxFit.cover)),
              ),
              SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _formKeyModalPost,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      const Text(
                        'Editar contenido:',
                        style: TextStyle(fontFamily: _fontFamily, fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                      const SizedBox(height: 15),
                      _buildMediaPreview(),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ElevatedButton.icon(
                            icon: const Icon(Icons.image_outlined, color: Colors.white),
                            label: const Text('Cambiar Foto', style: TextStyle(color: Colors.white, fontFamily: _fontFamily)),
                            onPressed: () => _seleccionarMedia(ImageSource.gallery, isVideo: false),
                            style: ElevatedButton.styleFrom(backgroundColor: _buttonBackgroundColor, padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8)),
                          ),
                          ElevatedButton.icon(
                            icon: const Icon(Icons.videocam_outlined, color: Colors.white),
                            label: const Text('Cambiar Video', style: TextStyle(color: Colors.white, fontFamily: _fontFamily)),
                            onPressed: () => _seleccionarMedia(ImageSource.gallery, isVideo: true),
                            style: ElevatedButton.styleFrom(backgroundColor: _buttonBackgroundColor, padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8)),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        controller: _captionController,
                        style: const TextStyle(fontFamily: _fontFamily, color: Colors.black),
                        decoration: InputDecoration(
                            labelText: 'Descripción (Caption)',
                            labelStyle: const TextStyle(fontFamily: _fontFamily, color: Colors.black54),
                            filled: true,
                            fillColor: Colors.white.withOpacity(0.85),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0), borderSide: BorderSide.none),
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                                borderSide: const BorderSide(color: _buttonBackgroundColor, width: 2)
                            ),
                            errorStyle: TextStyle(fontFamily: _fontFamily, color: Colors.redAccent[700], fontWeight: FontWeight.bold)
                        ),
                        maxLines: 4,
                        maxLength: 2200,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'La descripción no puede estar vacía.';
                          }
                          return null;
                        },
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                      ),
                      const SizedBox(height: 30),
                      _isUploading
                          ? const Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(_buttonBackgroundColor)))
                          : ElevatedButton.icon(
                        icon: const Icon(Icons.save_outlined, color: Colors.white),
                        label: const Text('Guardar Cambios', style: TextStyle(color: Colors.white)),
                        onPressed: _guardarCambiosPublicacion,
                        style: ElevatedButton.styleFrom(
                            backgroundColor: _buttonBackgroundColor,
                            padding: const EdgeInsets.symmetric(vertical: 15.0),
                            textStyle: const TextStyle(fontFamily: _fontFamily, fontSize: 18, fontWeight: FontWeight.bold),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))
                        ),
                      ),
                      const SizedBox(height: 10),
                      TextButton(
                        onPressed: () => Navigator.of(modalContext).pop(),
                        child: const Text('Cancelar', style: TextStyle(fontFamily: _fontFamily, color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// --- WIDGET PARA CREAR HISTORIA ---
// Código del widget _CrearHistoriaModalWidget (sin cambios funcionales significativos, solo optimizaciones)
class _CrearHistoriaModalWidget extends StatefulWidget {
  final String userId;
  final String userName;
  final String? userProfilePic;
  final BuildContext parentContextForSnackbars;

  const _CrearHistoriaModalWidget({
    Key? key,
    required this.userId,
    required this.userName,
    this.userProfilePic,
    required this.parentContextForSnackbars,
  }) : super(key: key);

  @override
  __CrearHistoriaModalWidgetState createState() => __CrearHistoriaModalWidgetState();
}

class __CrearHistoriaModalWidgetState extends State<_CrearHistoriaModalWidget> {
  final TextEditingController _captionController = TextEditingController();
  File? _selectedMediaFile;
  Uint8List? _selectedMediaBytesPreview; // For web image preview
  bool _isMediaVideo = false;
  bool _isUploading = false;
  final ImagePicker _picker = ImagePicker();
  final _formKeyStory = GlobalKey<FormState>();
  VideoPlayerController? _videoPlayerControllerPreview;

  @override
  void dispose() {
    _captionController.dispose();
    _videoPlayerControllerPreview?.dispose();
    super.dispose();
  }

  Future<void> _seleccionarMedia(ImageSource source, {bool isVideo = false}) async {
    XFile? pickedFile;
    try {
      if (isVideo) {
        pickedFile = await _picker.pickVideo(source: source);
      } else {
        pickedFile = await _picker.pickImage(source: source, imageQuality: 80, maxWidth: 1080, maxHeight: 1920);
      }

      if (pickedFile != null) {
        _selectedMediaBytesPreview = null; // Reset
        String pickedFilePath = pickedFile.path;

        if (kIsWeb) {
          _selectedMediaBytesPreview = await pickedFile.readAsBytes();
        }

        if (mounted) {
          setState(() {
            _selectedMediaFile = File(pickedFilePath);
            _isMediaVideo = isVideo;
            if (isVideo) {
              _initializeVideoPlayerPreview(pickedFilePath, isFile: true);
            }
          });
        }
      }
    } catch (e) {
      developer.log("Error seleccionando media para historia: $e", name: "CrearHistoriaModal.Picker", error: e);
      if (mounted) ScaffoldMessenger.of(widget.parentContextForSnackbars).showSnackBar(SnackBar(content: Text('Error al seleccionar media: $e', style: const TextStyle(fontFamily: _fontFamily))));
    }
  }

  void _initializeVideoPlayerPreview(String url, {bool isFile = false}) async {
    await _videoPlayerControllerPreview?.dispose();

    Uri? uri = Uri.tryParse(url);
    if (uri == null) {
      developer.log("URL inválida para VideoPlayer preview (Create Story): $url", name: "CreateStoryModal.Video");
      return;
    }

    if (isFile && !kIsWeb) {
      _videoPlayerControllerPreview = VideoPlayerController.file(File(url));
    } else {
      _videoPlayerControllerPreview = VideoPlayerController.networkUrl(uri);
    }

    try {
      await _videoPlayerControllerPreview!.initialize();
      if (mounted) setState(() {});
      _videoPlayerControllerPreview!.setLooping(true);
    } catch (e) {
      developer.log("Error inicializando VideoPlayer preview (Create Story): $e, URL: $url", name: "CreateStoryModal.Video", error: e);
      if (mounted) setState(() => _videoPlayerControllerPreview = null);
    }
  }


  Future<void> _publicarHistoria() async {
    if (!_formKeyStory.currentState!.validate()) return;
    if (_selectedMediaFile == null && _captionController.text.trim().isEmpty) {
      if (mounted) ScaffoldMessenger.of(widget.parentContextForSnackbars).showSnackBar(const SnackBar(content: Text('Debes añadir una foto/video o un texto para tu historia.', style: TextStyle(fontFamily: _fontFamily))));
      return;
    }
    if (_isUploading) return;
    setState(() => _isUploading = true);

    String? mediaUrl;
    try {
      if (_selectedMediaFile != null) {
        String fileExtension = _selectedMediaFile!.path.split('.').last.toLowerCase();
        if (_isMediaVideo) {
          if (!['mp4', 'mov', 'avi', 'mkv', 'webm'].contains(fileExtension)) fileExtension = 'mp4';
        } else {
          if (!['jpg', 'jpeg', 'png', 'gif', 'webp'].contains(fileExtension)) fileExtension = 'jpeg';
        }

        String fileName = 'stories/${widget.userId}/${DateTime.now().millisecondsSinceEpoch}.$fileExtension';
        String contentType = _isMediaVideo ? 'video/$fileExtension' : 'image/$fileExtension';
        if (_isMediaVideo && fileExtension == 'mov') contentType = 'video/quicktime';

        UploadTask uploadTask;
        if (kIsWeb) {
          Uint8List bytesToUpload = await _selectedMediaFile!.readAsBytes();
          if (bytesToUpload.isNotEmpty) {
            uploadTask = FirebaseStorage.instance.ref(fileName).putData(bytesToUpload, SettableMetadata(contentType: contentType));
          } else {
            throw Exception("Bytes nulos para la subida del medio en web.");
          }
        } else {
          uploadTask = FirebaseStorage.instance.ref(fileName).putFile(_selectedMediaFile!, SettableMetadata(contentType: contentType));
        }

        TaskSnapshot snapshot = await uploadTask;
        mediaUrl = await snapshot.ref.getDownloadURL();
      }

      await FirebaseFirestore.instance.collection('stories').add({
        'userId': widget.userId,
        'userName': widget.userName,
        'userProfilePic': widget.userProfilePic,
        'mediaUrl': mediaUrl,
        'esVideo': _isMediaVideo,
        'caption': _captionController.text.trim(),
        'timestamp': FieldValue.serverTimestamp(),
        'expiresAt': Timestamp.fromDate(DateTime.now().add(const Duration(hours: 24))),
      });

      if (mounted) {
        ScaffoldMessenger.of(widget.parentContextForSnackbars).showSnackBar(
          const SnackBar(content: Text('¡Historia publicada con éxito!', style: TextStyle(fontFamily: _fontFamily)), backgroundColor: Colors.green),
        );
        Navigator.of(context).pop();
      }
    } catch (e) {
      developer.log('Error al publicar historia: $e', name: "CrearHistoriaModal.Publish", error: e);
      if (mounted) {
        ScaffoldMessenger.of(widget.parentContextForSnackbars).showSnackBar(
          SnackBar(content: Text('Error al publicar historia: $e', style: const TextStyle(fontFamily: _fontFamily)), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) setState(() => _isUploading = false);
    }
  }

  Widget _buildMediaPreview() {
    if (_selectedMediaFile != null) {
      if (_isMediaVideo) {
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
          return Container(height: 200, color: Colors.black, child: const Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(_buttonBackgroundColor)) ));
        }
      } else { // It's an image
        if (kIsWeb && _selectedMediaBytesPreview != null) {
          return Image.memory(_selectedMediaBytesPreview!, height: 200, fit: BoxFit.contain);
        } else if (!kIsWeb) {
          return Image.file(_selectedMediaFile!, height: 200, fit: BoxFit.contain);
        }
      }
    }
    return Container(
      height: 150,
      decoration: BoxDecoration(color: Colors.grey[800], borderRadius: BorderRadius.circular(10)),
      child: const Center(
        child: Text(
          'Selecciona una foto o video para tu historia',
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.white70, fontFamily: _fontFamily),
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

  @override
  Widget build(BuildContext modalContext) {
    return FractionallySizedBox(
      heightFactor: 0.9,
      child: ClipRRect(
        borderRadius: const BorderRadius.only(topLeft: Radius.circular(20.0), topRight: Radius.circular(20.0)),
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Crear Historia', style: TextStyle(fontFamily: _fontFamily, color: Colors.white)),
            backgroundColor: _scaffoldBgColorModal,
            elevation: 0,
            automaticallyImplyLeading: false,
            actions: [
              IconButton(icon: const Icon(Icons.close, color: Colors.white), onPressed: () => Navigator.of(modalContext).pop())
            ],
          ),
          body: Stack(
            children: [
              Container(
                decoration: const BoxDecoration(
                    image: DecorationImage(image: AssetImage('assets/images/Animal Health Fondo de Pantalla.png'), fit: BoxFit.cover)),
              ),
              SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _formKeyStory,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      const Text(
                        'Crea tu historia:',
                        style: TextStyle(fontFamily: _fontFamily, fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                      const SizedBox(height: 15),
                      _buildMediaPreview(),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ElevatedButton.icon(
                            icon: const Icon(Icons.image_outlined, color: Colors.white),
                            label: const Text('Seleccionar Foto', style: TextStyle(color: Colors.white, fontFamily: _fontFamily)),
                            onPressed: () => _seleccionarMedia(ImageSource.gallery, isVideo: false),
                            style: ElevatedButton.styleFrom(backgroundColor: _buttonBackgroundColor, padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8)),
                          ),
                          ElevatedButton.icon(
                            icon: const Icon(Icons.videocam_outlined, color: Colors.white),
                            label: const Text('Seleccionar Video', style: TextStyle(color: Colors.white, fontFamily: _fontFamily)),
                            onPressed: () => _seleccionarMedia(ImageSource.gallery, isVideo: true),
                            style: ElevatedButton.styleFrom(backgroundColor: _buttonBackgroundColor, padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8)),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        controller: _captionController,
                        style: const TextStyle(fontFamily: _fontFamily, color: Colors.black),
                        decoration: InputDecoration(
                            labelText: 'Escribe tu historia (opcional)',
                            labelStyle: const TextStyle(fontFamily: _fontFamily, color: Colors.black54),
                            filled: true,
                            fillColor: Colors.white.withOpacity(0.85),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0), borderSide: BorderSide.none),
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                                borderSide: const BorderSide(color: _buttonBackgroundColor, width: 2)
                            ),
                            errorStyle: TextStyle(fontFamily: _fontFamily, color: Colors.redAccent[700], fontWeight: FontWeight.bold)
                        ),
                        maxLines: 3,
                        maxLength: 500,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                      ),
                      const SizedBox(height: 30),
                      _isUploading
                          ? const Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(_buttonBackgroundColor)))
                          : ElevatedButton.icon(
                        icon: const Icon(Icons.send_outlined, color: Colors.white),
                        label: const Text('Publicar Historia', style: TextStyle(color: Colors.white)),
                        onPressed: _publicarHistoria,
                        style: ElevatedButton.styleFrom(
                            backgroundColor: _buttonBackgroundColor,
                            padding: const EdgeInsets.symmetric(vertical: 15.0),
                            textStyle: const TextStyle(fontFamily: _fontFamily, fontSize: 18, fontWeight: FontWeight.bold),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))
                        ),
                      ),
                      const SizedBox(height: 10),
                      TextButton(
                        onPressed: () => Navigator.of(modalContext).pop(),
                        child: const Text('Cancelar', style: TextStyle(fontFamily: _fontFamily, color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}