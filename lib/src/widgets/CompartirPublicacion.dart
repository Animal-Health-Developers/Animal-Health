import 'package:flutter/material.dart';
import 'package:adobe_xd/pinned.dart';
import './Home.dart'; // Evitar conflicto
import 'package:adobe_xd/page_link.dart';
import './Ayuda.dart';
import './PerfilPublico.dart';
import './Configuracion.dart';
import './ListadeAnimales.dart';
// import 'dart:ui' as ui; // ui.ImageFilter.blur no se usará en esta versión simplificada
import '../services/auth_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'dart:developer' as developer;

// Modelo simple para un amigo
class Friend {
  final String id;
  final String userName;
  final String? profilePhotoUrl;

  Friend({required this.id, required this.userName, this.profilePhotoUrl});

  factory Friend.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Friend(
      id: doc.id,
      userName: data['userName'] ?? 'Usuario Desconocido',
      profilePhotoUrl: data['profilePhotoUrl'],
    );
  }
}

class CompartirPublicacion extends StatefulWidget {
  final String publicationId; // ID de la publicación que se va a compartir
  final String? mediaUrl;      // Para mostrar una miniatura si se desea (opcional)
  final String? caption;       // Para mostrar un resumen si se desea (opcional)

  const CompartirPublicacion({
    required Key key,
    required this.publicationId,
    this.mediaUrl,
    this.caption,
  }) : super(key: key);

  @override
  _CompartirPublicacionState createState() => _CompartirPublicacionState();
}

class _CompartirPublicacionState extends State<CompartirPublicacion> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  User? _currentUser;
  String? _currentUserProfilePic;

  List<Friend> _friendsList = [];
  bool _isLoadingFriends = true;
  final Set<String> _selectedFriendIds = {}; // IDs de amigos seleccionados para compartir

  @override
  void initState() {
    super.initState();
    _currentUser = _auth.currentUser;
    if (_currentUser != null) {
      _loadCurrentUserProfilePic();
      _loadFriends();
    }
  }

  Future<void> _loadCurrentUserProfilePic() async {
    if (_currentUser == null) return;
    try {
      DocumentSnapshot userDoc =
      await _firestore.collection('users').doc(_currentUser!.uid).get();
      if (mounted && userDoc.exists) {
        setState(() {
          _currentUserProfilePic = userDoc.get('profilePhotoUrl');
        });
      }
    } catch (e) {
      developer.log("Error cargando foto de perfil del usuario: $e", name: "Compartir.UserProfile");
    }
  }

  Future<void> _loadFriends() async {
    if (_currentUser == null) {
      if (mounted) setState(() => _isLoadingFriends = false);
      return;
    }
    setState(() => _isLoadingFriends = true);
    try {
      // Opción A: Amigos en una subcolección 'amigos'
      QuerySnapshot friendsSnapshot = await _firestore
          .collection('users')
          .doc(_currentUser!.uid)
          .collection('amigos')
          .get();

      List<String> friendIds = friendsSnapshot.docs.map((doc) => doc.id).toList();

      if (friendIds.isEmpty) {
        if (mounted) setState(() => _isLoadingFriends = false);
        return;
      }

      // Obtener los datos de cada amigo
      // Firestore permite un máximo de 10 condiciones 'in' en una query.
      // Si hay más de 10 amigos, se necesitarían múltiples queries o un enfoque diferente.
      // Para este ejemplo, si hay más de 10, dividimos en chunks.
      List<Friend> tempList = [];
      List<List<String>> chunkedFriendIds = [];
      for (var i = 0; i < friendIds.length; i += 10) {
        chunkedFriendIds.add(
            friendIds.sublist(i, i + 10 > friendIds.length ? friendIds.length : i + 10)
        );
      }

      for (List<String> chunk in chunkedFriendIds) {
        if (chunk.isEmpty) continue;
        QuerySnapshot usersDetailsSnapshot = await _firestore
            .collection('users')
            .where(FieldPath.documentId, whereIn: chunk)
            .get();
        tempList.addAll(usersDetailsSnapshot.docs.map((doc) => Friend.fromFirestore(doc)));
      }

      if (mounted) {
        setState(() {
          _friendsList = tempList;
          _isLoadingFriends = false;
        });
      }

    } catch (e) {
      developer.log("Error cargando lista de amigos: $e", name: "Compartir.Friends");
      if (mounted) {
        setState(() => _isLoadingFriends = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al cargar amigos: ${e.toString()}')),
        );
      }
    }
  }

  void _toggleFriendSelection(String friendId) {
    setState(() {
      if (_selectedFriendIds.contains(friendId)) {
        _selectedFriendIds.remove(friendId);
      } else {
        _selectedFriendIds.add(friendId);
      }
    });
  }

  Future<void> _sharePublication() async {
    if (_currentUser == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Debes iniciar sesión.')));
      return;
    }
    if (_selectedFriendIds.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Selecciona al menos un amigo.')));
      return;
    }

    try {
      WriteBatch batch = _firestore.batch();
      DocumentSnapshot currentUserDoc = await _firestore.collection('users').doc(_currentUser!.uid).get();
      String currentUserName = currentUserDoc.get('userName') ?? 'Alguien';

      for (String friendId in _selectedFriendIds) {
        DocumentReference sharedDocRef = _firestore
            .collection('users')
            .doc(friendId)
            .collection('publicacionesRecibidas')
            .doc(); // Firestore generará un ID único para la compartición

        batch.set(sharedDocRef, {
          'publicationIdOriginal': widget.publicationId,
          'compartidoPorUserId': _currentUser!.uid,
          'compartidoPorUserName': currentUserName,
          'timestamp': FieldValue.serverTimestamp(),
          'leido': false,
          // Opcional: puedes incluir mediaUrl y caption si quieres mostrarlos directamente
          // 'mediaUrl': widget.mediaUrl,
          // 'caption': widget.caption,
        });
      }
      await batch.commit();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Publicación compartida exitosamente!'), backgroundColor: Colors.green),
      );
      Navigator.pop(context); // Volver a la pantalla anterior
    } catch (e) {
      developer.log("Error al compartir publicación: $e", name: "Compartir.ShareAction");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al compartir: ${e.toString()}')),
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff000000),
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
            child: PageLink(
              links: [
                PageLinkInfo(
                  transition: LinkTransition.Fade,
                  ease: Curves.easeOut,
                  duration: 0.3,
                  pageBuilder: () => Home(key: const Key('HomeFromCompartir')),
                ),
              ],
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
          ),

          // Botón de "Atrás"
          Pinned.fromPins(
            Pin(size: 52.9, start: 9.1),
            Pin(size: 50.0, start: 49.0),
            child: GestureDetector(
              onTap: () => Navigator.pop(context), // Acción de volver
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
                  pageBuilder: () => Ayuda(key: const Key('AyudaFromCompartir')),
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

          // Botón de perfil del usuario actual (Dinámico)
          Pinned.fromPins(
            Pin(size: 60.0, start: 13.0),
            Pin(size: 60.0, start: 115.0),
            child: PageLink(
              links: [
                PageLinkInfo(
                  transition: LinkTransition.Fade,
                  ease: Curves.easeOut,
                  duration: 0.3,
                  pageBuilder: () => PerfilPublico(key: const Key('PerfilPublicoFromCompartir')),
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
                  child: _currentUserProfilePic != null && _currentUserProfilePic!.isNotEmpty
                      ? CachedNetworkImage(
                      imageUrl: _currentUserProfilePic!,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => const Center(
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(Color(0xff4ec8dd)),
                        ),
                      ),
                      errorWidget: (context, url, error) {
                        developer.log('Error CachedNetworkImage (Perfil en Compartir): $error, URL: $url');
                        return const Center(child: Icon(Icons.person, size: 30, color: Colors.grey));
                      })
                      : const Center(child: Icon(Icons.person, size: 30, color: Colors.grey)),
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
                  pageBuilder: () => Configuraciones(key: const Key('SettingsFromCompartir'), authService: AuthService()),
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
            Pin(size: 60.1, end: 7.6),
            Pin(size: 60.0, start: 110.0), // Ajustado start para que no solape con perfil
            child: PageLink(
              links: [
                PageLinkInfo(
                  transition: LinkTransition.Fade,
                  ease: Curves.easeOut,
                  duration: 0.3,
                  pageBuilder: () => ListadeAnimales(key: const Key('ListadeAnimalesFromCompartir')),
                ),
              ],
              child: Container(
                decoration: BoxDecoration(
                  image: const DecorationImage(
                    image: AssetImage('assets/images/listaanimales.png'),
                    fit: BoxFit.fill,
                  ),
                  borderRadius: BorderRadius.circular(10.0), // Opcional, si quieres bordes redondeados
                ),
              ),
            ),
          ),

          // Contenedor principal para la lista de amigos
          Positioned(
            top: 190.0, // Ajustar según sea necesario para que no solape con header
            left: 14.0,
            right: 14.0,
            bottom: 70.0, // Dejar espacio para el botón de "Enviar"
            child: Container(
              padding: const EdgeInsets.all(12.0),
              decoration: BoxDecoration(
                color: const Color(0xe3a0f4fe),
                borderRadius: BorderRadius.circular(20.0),
                border: Border.all(width: 1.0, color: const Color(0xe3000000)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Compartir con amigos:',
                    style: TextStyle(
                      fontFamily: 'Comic Sans MS',
                      fontSize: 18,
                      color: Color(0xff000000),
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 10),
                  // Opcional: Miniatura de la publicación
                  if (widget.mediaUrl != null && widget.mediaUrl!.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8.0),
                            child: CachedNetworkImage(
                              imageUrl: widget.mediaUrl!,
                              width: 50,
                              height: 50,
                              fit: BoxFit.cover,
                              placeholder: (context, url) => Container(color: Colors.grey[300]),
                              errorWidget: (context, url, error) => Container(color: Colors.grey[300], child: Icon(Icons.broken_image)),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              widget.caption ?? 'Publicación',
                              style: TextStyle(fontFamily: 'Comic Sans MS', fontSize: 14, color: Colors.black87),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                  const Divider(),
                  Expanded(
                    child: _isLoadingFriends
                        ? const Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Color(0xff000000))))
                        : _friendsList.isEmpty
                        ? const Center(
                      child: Text(
                        'No tienes amigos para compartir.\n¡Agrega algunos primero!',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontFamily: 'Comic Sans MS', fontSize: 16, color: Colors.black54),
                      ),
                    )
                        : ListView.builder(
                      itemCount: _friendsList.length,
                      itemBuilder: (context, index) {
                        final friend = _friendsList[index];
                        final isSelected = _selectedFriendIds.contains(friend.id);
                        return Card(
                          color: isSelected ? Colors.blue[100] : Colors.white,
                          margin: const EdgeInsets.symmetric(vertical: 4.0),
                          child: ListTile(
                            leading: CircleAvatar(
                              radius: 25,
                              backgroundColor: Colors.grey[300],
                              backgroundImage: friend.profilePhotoUrl != null && friend.profilePhotoUrl!.isNotEmpty
                                  ? CachedNetworkImageProvider(friend.profilePhotoUrl!)
                                  : null,
                              child: friend.profilePhotoUrl == null || friend.profilePhotoUrl!.isEmpty
                                  ? const Icon(Icons.person, color: Colors.white)
                                  : null,
                            ),
                            title: Text(
                              friend.userName,
                              style: const TextStyle(fontFamily: 'Comic Sans MS', fontWeight: FontWeight.bold),
                            ),
                            //subtitle: Text('En línea', style: TextStyle(fontFamily: 'Open Sans', fontSize: 10)), // Podrías añadir estado si lo tienes
                            trailing: Checkbox(
                              value: isSelected,
                              onChanged: (bool? value) {
                                _toggleFriendSelection(friend.id);
                              },
                              activeColor: const Color(0xff4ec8dd),
                            ),
                            onTap: () => _toggleFriendSelection(friend.id),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Botón de Enviar
          if (!_isLoadingFriends && _friendsList.isNotEmpty)
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 15.0, left: 20, right: 20),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xff4ec8dd),
                    padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                    textStyle: const TextStyle(fontFamily: 'Comic Sans MS', fontSize: 18, fontWeight: FontWeight.bold),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                  ),
                  onPressed: _selectedFriendIds.isNotEmpty ? _sharePublication : null, // Deshabilitar si no hay seleccionados
                  child: const Text('Enviar', style: TextStyle(color: Colors.white)),
                ),
              ),
            ),
        ],
      ),
    );
  }
}