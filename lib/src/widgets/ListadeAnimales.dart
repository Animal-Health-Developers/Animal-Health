import 'package:flutter/material.dart';
import 'package:adobe_xd/pinned.dart';
import '../services/auth_service.dart';
import './Home.dart';
import 'package:adobe_xd/page_link.dart';
import './Ayuda.dart';
import './PerfilPublico.dart';
import './Configuracion.dart';
import './CrearPerfildeAnimales.dart';
import './EditarPerfildeAnimal.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ListadeAnimales extends StatefulWidget {
  const ListadeAnimales({Key? key}) : super(key: key);

  @override
  _ListadeAnimalesState createState() => _ListadeAnimalesState();
}

class _ListadeAnimalesState extends State<ListadeAnimales> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  // Tamaños fijos para la tarjeta y la imagen
  static const double cardWidth = 160.0;
  static const double cardHeight = 200.0;
  static const double imageSize = 120.0;

  Widget _buildPlaceholder() {
    return Container(
      width: imageSize,
      height: imageSize,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: Colors.white.withOpacity(0.7),
        border: Border.all(color: Colors.white, width: 2),
      ),
      child: Icon(Icons.pets, size: 40, color: Colors.blueGrey),
    );
  }

  Widget _buildErrorPlaceholder() {
    return Container(
      width: imageSize,
      height: imageSize,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: Colors.white.withOpacity(0.7),
        border: Border.all(color: Colors.red, width: 2),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error, size: 30, color: Colors.red),
          Text('Error', style: TextStyle(fontSize: 10, color: Colors.red)),
        ],
      ),
    );
  }

  Future<String?> _getFreshDownloadUrl(String url) async {
    try {
      final uri = Uri.parse(url);
      final path = uri.path.split('/o/').last.split('?').first;
      final decodedPath = Uri.decodeFull(path);

      final ref = _storage.ref(decodedPath);
      return await ref.getDownloadURL();
    } catch (e) {
      print('Error al obtener nueva URL: $e');
      return null;
    }
  }

  Widget _buildAnimalImage(String? imageUrl) {
    if (imageUrl == null || imageUrl.isEmpty) {
      return _buildPlaceholder();
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(15),
      child: CachedNetworkImage(
        imageUrl: imageUrl,
        width: imageSize,
        height: imageSize,
        fit: BoxFit.cover,
        placeholder: (context, url) => _buildPlaceholder(),
        errorWidget: (context, url, error) {
          print('Error al cargar imagen (intentando nueva URL): $error');
          return FutureBuilder<String?>(
            future: _getFreshDownloadUrl(url),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return _buildPlaceholder();
              }
              if (snapshot.hasData && snapshot.data != null) {
                return ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: CachedNetworkImage(
                    imageUrl: snapshot.data!,
                    width: imageSize,
                    height: imageSize,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => _buildPlaceholder(),
                    errorWidget: (context, url, error) {
                      print('Error persistente al cargar imagen: $error');
                      return _buildErrorPlaceholder();
                    },
                  ),
                );
              }
              return _buildErrorPlaceholder();
            },
          );
        },
      ),
    );
  }

  Future<void> _eliminarAnimal(String animalId, BuildContext context) async {
    try {
      final userId = _auth.currentUser?.uid;
      if (userId == null) return;

      final confirm = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Confirmar eliminación'),
          content: const Text('¿Estás seguro de que quieres eliminar este animal?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Eliminar', style: TextStyle(color: Colors.red)),
            ),
          ],
        ),
      );

      if (confirm == true) {
        await _firestore
            .collection('users')
            .doc(userId)
            .collection('animals')
            .doc(animalId)
            .delete();

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Animal eliminado correctamente'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error al eliminar: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Widget _buildAnimalItem(DocumentSnapshot animal, String userId) {
    try {
      final data = animal.data() as Map<String, dynamic>;
      final fotoUrl = data['fotoPerfilUrl'] ?? '';
      final nombre = data['nombre'] ?? 'Sin nombre';
      final especie = data['especie'] ?? 'Sin especie';

      return SizedBox(
        width: cardWidth,
        height: cardHeight,
        child: GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => EditarPerfildeAnimal(
                  key: Key('EditarPerfildeAnimal_${animal.id}'),
                  animalId: animal.id,
                ),
              ),
            );
          },
          child: Card(
            elevation: 3,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
              side: BorderSide(color: Colors.white, width: 2),
            ),
            color: const Color(0x7a54d1e0),
            child: Stack(
              children: [
                // Contenido centrado
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildAnimalImage(fotoUrl),
                      const SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: Text(
                          nombre,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontFamily: 'Comic Sans MS',
                            fontSize: 18,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        especie,
                        style: const TextStyle(
                          fontFamily: 'Comic Sans MS',
                          fontSize: 14,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),

                // Botón de opciones en esquina superior derecha
                Positioned(
                  top: 5,
                  right: 5,
                  child: PopupMenuButton<String>(
                    icon: Icon(Icons.more_vert, size: 20, color: Colors.black.withOpacity(0.6)),
                    itemBuilder: (context) => [
                      const PopupMenuItem<String>(
                        value: 'editar',
                        child: Text('Editar perfil'),
                      ),
                      const PopupMenuItem<String>(
                        value: 'eliminar',
                        child: Text('Eliminar perfil'),
                      ),
                    ],
                    onSelected: (value) {
                      if (value == 'eliminar') {
                        _eliminarAnimal(animal.id, context);
                      } else if (value == 'editar') {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => EditarPerfildeAnimal(
                              key: Key('EditarPerfildeAnimal_${animal.id}'),
                              animalId: animal.id,
                            ),
                          ),
                        );
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    } catch (e) {
      print('Error al construir ítem de animal: $e');
      return SizedBox(
        width: cardWidth,
        height: cardHeight,
        child: Card(
          color: Colors.red.withOpacity(0.3),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          child: const Center(
            child: Text(
              'Error al cargar',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final userId = _auth.currentUser?.uid;

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
            Pin(size: 52.9, start: 9.1),
            Pin(size: 50.0, start: 49.0),
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
            Pin(size: 60.0, start: 13.0),
            Pin(size: 60.0, start: 115.0),
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
          Positioned(
            top: 120,
            left: 0,
            right: 0,
            bottom: 0,
            child: Column(
              children: [
                Container(
                  width: 229.0,
                  height: 35.0,
                  margin: const EdgeInsets.only(top: 10, bottom: 20),
                  decoration: BoxDecoration(
                    color: const Color(0xe3a0f4fe),
                    borderRadius: BorderRadius.circular(10.0),
                    border: Border.all(
                      width: 1.0,
                      color: const Color(0xe3000000),
                    ),
                  ),
                  child: const Center(
                    child: Text(
                      'Lista de Animales',
                      style: TextStyle(
                        fontFamily: 'Comic Sans MS',
                        fontSize: 20,
                        color: Color(0xff000000),
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: StreamBuilder<QuerySnapshot>(
                    stream: userId != null
                        ? _firestore
                        .collection('users')
                        .doc(userId)
                        .collection('animals')
                        .snapshots()
                        : Stream.empty(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      if (snapshot.hasError) {
                        return Center(
                          child: Text(
                            'Error: ${snapshot.error}',
                            style: const TextStyle(
                              fontFamily: 'Comic Sans MS',
                              fontSize: 16,
                              color: Colors.white,
                            ),
                          ),
                        );
                      }
                      final animals = snapshot.data?.docs;
                      if (animals?.isEmpty ?? true) {
                        return const Center(
                          child: Text(
                            'No hay animales registrados',
                            style: TextStyle(
                              fontFamily: 'Comic Sans MS',
                              fontSize: 20,
                              color: Colors.white,
                            ),
                          ),
                        );
                      }
                      return GridView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 15,
                          mainAxisSpacing: 15,
                          childAspectRatio: cardWidth / cardHeight,
                        ),
                        itemCount: animals?.length ?? 0,
                        itemBuilder: (context, index) {
                          return _buildAnimalItem(animals![index], userId!);
                        },
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 20.0, top: 10),
                  child: Column(
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CrearPerfildeAnimal(
                                key: const Key('CrearPerfildeAnimal'),
                              ),
                            ),
                          );
                        },
                        child: Container(
                          width: 127.3,
                          height: 120.0,
                          decoration: const BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage('assets/images/crearperfilanimal.png'),
                              fit: BoxFit.fill,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Container(
                        width: 135.0,
                        height: 35.0,
                        decoration: BoxDecoration(
                          color: const Color(0xe3a0f4fe),
                          borderRadius: BorderRadius.circular(10.0),
                          border: Border.all(
                            width: 1.0,
                            color: const Color(0xe3000000),
                          ),
                        ),
                        child: const Center(
                          child: Text(
                            'Crear Perfil',
                            style: TextStyle(
                              fontFamily: 'Comic Sans MS',
                              fontSize: 17,
                              color: Color(0xff000000),
                              fontWeight: FontWeight.w700,
                            ),
                          ),
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
}