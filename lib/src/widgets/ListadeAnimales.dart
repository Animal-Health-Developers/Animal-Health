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
import '../models/animal.dart'; // Asegúrate que esta ruta sea correcta

class ListadeAnimales extends StatefulWidget {
  final bool isSelectionMode;

  const ListadeAnimales({
    Key? key,
    this.isSelectionMode = false,
  }) : super(key: key);

  @override
  _ListadeAnimalesState createState() => _ListadeAnimalesState();
}

class _ListadeAnimalesState extends State<ListadeAnimales> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

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
      // Extraer el path correcto sin el token de descarga si está presente
      final pathSegments = uri.pathSegments;
      String filePath = '';
      bool foundO = false;
      for (String segment in pathSegments) {
        if (foundO) {
          filePath += (filePath.isEmpty ? '' : '/') + segment;
        }
        if (segment == 'o') {
          foundO = true;
        }
      }
      final decodedPath = Uri.decodeComponent(filePath); // Usar decodeComponent

      if (decodedPath.isEmpty) {
        print('Error: No se pudo decodificar la ruta de Storage desde la URL: $url');
        return null;
      }

      final ref = _storage.ref(decodedPath);
      return await ref.getDownloadURL();
    } catch (e) {
      print('Error al obtener nueva URL para "$url": $e');
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
          print('Error al cargar imagen de animal (URL original: $url): $error. Intentando obtener nueva URL...');
          return FutureBuilder<String?>(
            future: _getFreshDownloadUrl(url), // Intenta obtener una nueva URL
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return _buildPlaceholder(); // Muestra placeholder mientras espera
              }
              if (snapshot.hasData && snapshot.data != null && snapshot.data!.isNotEmpty) {
                print('Nueva URL obtenida para imagen de animal: ${snapshot.data}');
                return ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: CachedNetworkImage(
                    imageUrl: snapshot.data!,
                    width: imageSize,
                    height: imageSize,
                    fit: BoxFit.cover,
                    placeholder: (context, newUrl) => _buildPlaceholder(),
                    errorWidget: (context, newUrl, newError) {
                      print('Error persistente al cargar imagen de animal (Nueva URL: $newUrl): $newError');
                      return _buildErrorPlaceholder();
                    },
                  ),
                );
              }
              print('No se pudo obtener una nueva URL o la URL obtenida es inválida para: $url');
              return _buildErrorPlaceholder(); // Si no se pudo obtener o es inválida
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
            TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancelar')),
            TextButton(onPressed: () => Navigator.pop(context, true), child: const Text('Eliminar', style: TextStyle(color: Colors.red))),
          ],
        ),
      );
      if (confirm == true) {
        // Primero intentar eliminar la foto de Firebase Storage si existe
        DocumentSnapshot animalDoc = await _firestore.collection('users').doc(userId).collection('animals').doc(animalId).get();
        if (animalDoc.exists) {
          Animal animalToDelete = Animal.fromFirestore(animalDoc);
          if (animalToDelete.fotoPerfilUrl.isNotEmpty) {
            try {
              final photoRef = _storage.refFromURL(animalToDelete.fotoPerfilUrl);
              await photoRef.delete();
              print('Foto de perfil del animal eliminada de Storage: ${animalToDelete.fotoPerfilUrl}');
            } catch (e) {
              print('Error al eliminar foto de perfil del animal de Storage: $e. El documento se eliminará de todas formas.');
              // Continuar con la eliminación del documento incluso si la foto no se puede borrar (podría no existir o error de permisos)
            }
          }
        }
        // Eliminar el documento de Firestore
        await _firestore.collection('users').doc(userId).collection('animals').doc(animalId).delete();
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Animal eliminado correctamente'), backgroundColor: Colors.green));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error al eliminar el animal: $e'), backgroundColor: Colors.red));
    }
  }

  Widget _buildAnimalItem(DocumentSnapshot animalDoc, String userId) {
    try {
      final Animal animalObjeto = Animal.fromFirestore(animalDoc);
      final fotoUrl = animalObjeto.fotoPerfilUrl;
      final nombre = animalObjeto.nombre;
      final especie = animalObjeto.especie;

      return SizedBox(
        width: cardWidth,
        height: cardHeight,
        child: GestureDetector(
          onTap: () {
            if (widget.isSelectionMode) {
              Navigator.pop(context, animalObjeto);
            } else {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EditarPerfildeAnimal(
                    key: Key('EditarPerfildeAnimal_${animalDoc.id}'),
                    animalId: animalDoc.id,
                  ),
                ),
              );
            }
          },
          child: Card(
            elevation: 3,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15), side: BorderSide(color: Colors.white, width: 2)),
            color: const Color(0x7a54d1e0),
            child: Stack(
              children: [
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildAnimalImage(fotoUrl),
                      const SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: Text(nombre, textAlign: TextAlign.center, style: const TextStyle(fontFamily: 'Comic Sans MS', fontSize: 18, color: Colors.black, fontWeight: FontWeight.bold), maxLines: 1, overflow: TextOverflow.ellipsis),
                      ),
                      const SizedBox(height: 4),
                      Text(especie, style: const TextStyle(fontFamily: 'Comic Sans MS', fontSize: 14, color: Colors.black)),
                    ],
                  ),
                ),
                if (!widget.isSelectionMode)
                  Positioned(
                    top: 5,
                    right: 5,
                    child: PopupMenuButton<String>(
                      icon: Icon(Icons.more_vert, size: 20, color: Colors.black.withOpacity(0.6)),
                      itemBuilder: (context) => [
                        const PopupMenuItem<String>(value: 'editar', child: Text('Editar perfil')),
                        const PopupMenuItem<String>(value: 'eliminar', child: Text('Eliminar perfil')),
                      ],
                      onSelected: (value) {
                        if (value == 'eliminar') {
                          _eliminarAnimal(animalDoc.id, context);
                        } else if (value == 'editar') {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => EditarPerfildeAnimal(
                                key: Key('EditarPerfildeAnimal_${animalDoc.id}'),
                                animalId: animalDoc.id,
                              ),
                            ),
                          );
                        }
                      },
                    ),
                  ),
                if (widget.isSelectionMode)
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Icon(Icons.check_circle_outline, color: Theme.of(context).primaryColorDark, size: 28),
                  ),
              ],
            ),
          ),
        ),
      );
    } catch (e) {
      print('Error al construir ítem de animal (ID: ${animalDoc.id}): $e. Data: ${animalDoc.data()}');
      return SizedBox(
        width: cardWidth,
        height: cardHeight,
        child: Card(
          color: Colors.red.withOpacity(0.3),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          child: const Center(child: Text('Error al cargar datos', style: TextStyle(color: Colors.white, fontSize: 12))),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final User? currentUser = _auth.currentUser;
    final String? userId = currentUser?.uid;

    return Scaffold(
      backgroundColor: const Color(0xff4ec8dd),
      body: Stack(
        children: <Widget>[
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(image: AssetImage('assets/images/Animal Health Fondo de Pantalla.png'), fit: BoxFit.cover),
            ),
          ),
          Pinned.fromPins(
            Pin(size: 74.0, middle: 0.5),
            Pin(size: 73.0, start: 42.0),
            child: PageLink(
              links: [PageLinkInfo(transition: LinkTransition.Fade, ease: Curves.easeOut, duration: 0.3, pageBuilder: () => Home(key: const Key('Home')))],
              child: Container(
                decoration: BoxDecoration(
                  image: const DecorationImage(image: AssetImage('assets/images/logo.png'), fit: BoxFit.cover),
                  borderRadius: BorderRadius.circular(15.0),
                  border: Border.all(width: 1.0, color: const Color(0xff000000)),
                ),
              ),
            ),
          ),
          Pinned.fromPins(
            Pin(size: 52.9, start: 9.1),
            Pin(size: 50.0, start: 49.0),
            child: widget.isSelectionMode
                ? InkWell(
              onTap: () => Navigator.pop(context),
              child: Container(decoration: const BoxDecoration(image: DecorationImage(image: AssetImage('assets/images/back.png'), fit: BoxFit.fill))),
            )
                : PageLink(
              links: [PageLinkInfo(transition: LinkTransition.Fade, ease: Curves.easeOut, duration: 0.3, pageBuilder: () => Home(key: const Key('Home')))],
              child: Container(decoration: const BoxDecoration(image: DecorationImage(image: AssetImage('assets/images/back.png'), fit: BoxFit.fill))),
            ),
          ),
          Pinned.fromPins(
            Pin(size: 40.5, middle: 0.8328),
            Pin(size: 50.0, start: 49.0),
            child: PageLink(
              links: [PageLinkInfo(transition: LinkTransition.Fade, ease: Curves.easeOut, duration: 0.3, pageBuilder: () => Ayuda(key: const Key('Ayuda')))],
              child: Container(decoration: const BoxDecoration(image: DecorationImage(image: AssetImage('assets/images/help.png'), fit: BoxFit.fill))),
            ),
          ),
          if (!widget.isSelectionMode && userId != null)
            Pinned.fromPins(
              Pin(size: 60.0, start: 13.0),
              Pin(size: 60.0, start: 115.0),
              child: StreamBuilder<DocumentSnapshot>(
                stream: _firestore.collection('users').doc(userId).snapshots(),
                builder: (context, snapshot) {
                  String? profilePhotoUrl;
                  if (snapshot.hasData && snapshot.data!.exists) {
                    final userData = snapshot.data!.data() as Map<String, dynamic>;
                    profilePhotoUrl = userData['profilePhotoUrl'] as String?;
                  }
                  return PageLink(
                    links: [PageLinkInfo(pageBuilder: () => PerfilPublico(key: const Key('PerfilPublico')))],
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0),
                          color: Colors.grey[200],
                          border: Border.all(color: Colors.white, width: 1.5)
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8.5),
                        child: profilePhotoUrl != null && profilePhotoUrl.isNotEmpty
                            ? CachedNetworkImage(
                            imageUrl: profilePhotoUrl,
                            fit: BoxFit.cover,
                            placeholder: (context, url) => const Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Color(0xff4ec8dd)))),
                            errorWidget: (context, url, error) {
                              print("Error cargando foto de perfil del usuario (URL: $url): $error");
                              return const Icon(Icons.person, size: 35, color: Colors.grey);
                            }
                        )
                            : const Icon(Icons.person, size: 35, color: Colors.grey),
                      ),
                    ),
                  );
                },
              ),
            ),
          if (!widget.isSelectionMode) ...[
            Pinned.fromPins(
              Pin(size: 47.2, end: 7.6),
              Pin(size: 50.0, start: 49.0),
              child: PageLink(
                links: [PageLinkInfo(transition: LinkTransition.Fade, ease: Curves.easeOut, duration: 0.3, pageBuilder: () => Configuraciones(key: const Key('Settings'), authService: AuthService()))],
                child: Container(decoration: const BoxDecoration(image: DecorationImage(image: AssetImage('assets/images/settingsbutton.png'), fit: BoxFit.fill))),
              ),
            ),
          ],
          Positioned(
            top: widget.isSelectionMode ? 100 : 120,
            left: 0,
            right: 0,
            bottom: 0,
            child: Column(
              children: [
                Container(
                  width: widget.isSelectionMode ? 280.0 : 229.0,
                  height: 35.0,
                  margin: EdgeInsets.only(top: 10, bottom: widget.isSelectionMode ? 15 : 20),
                  decoration: BoxDecoration(
                    color: const Color(0xe3a0f4fe),
                    borderRadius: BorderRadius.circular(10.0),
                    border: Border.all(width: 1.0, color: const Color(0xe3000000)),
                  ),
                  child: Center(
                    child: Text(
                      widget.isSelectionMode ? 'Selecciona un Animal' : 'Lista de Animales',
                      style: const TextStyle(fontFamily: 'Comic Sans MS', fontSize: 20, color: Color(0xff000000), fontWeight: FontWeight.w700),
                    ),
                  ),
                ),
                Expanded(
                  child: userId == null
                      ? Center(
                    child: Text(
                      'Inicia sesión para ver tus animales.',
                      style: TextStyle(fontFamily: 'Comic Sans MS', fontSize: 18, color: Colors.white),
                    ),
                  )
                      : StreamBuilder<QuerySnapshot>(
                    stream: _firestore.collection('users').doc(userId).collection('animals').orderBy('nombre').snapshots(), // Ordenar por nombre
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      if (snapshot.hasError) {
                        print("Error en StreamBuilder de animales: ${snapshot.error}");
                        return Center(
                          child: Text('Error al cargar animales. Revisa la consola.', style: const TextStyle(fontFamily: 'Comic Sans MS', fontSize: 16, color: Colors.white)),
                        );
                      }
                      final animalDocs = snapshot.data?.docs;
                      if (animalDocs?.isEmpty ?? true) {
                        return Center(
                          child: Text(
                            widget.isSelectionMode ? 'No hay animales para seleccionar.' : 'No hay animales registrados',
                            textAlign: TextAlign.center,
                            style: const TextStyle(fontFamily: 'Comic Sans MS', fontSize: 20, color: Colors.white),
                          ),
                        );
                      }
                      return GridView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, crossAxisSpacing: 15, mainAxisSpacing: 15, childAspectRatio: cardWidth / cardHeight),
                        itemCount: animalDocs?.length ?? 0,
                        itemBuilder: (context, index) {
                          return _buildAnimalItem(animalDocs![index], userId);
                        },
                      );
                    },
                  ),
                ),
                if (!widget.isSelectionMode)
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
                              image: DecorationImage(image: AssetImage('assets/images/crearperfilanimal.png'), fit: BoxFit.fill),
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
                            border: Border.all(width: 1.0, color: const Color(0xe3000000)),
                          ),
                          child: const Center(
                            child: Text(
                              'Crear Perfil',
                              style: TextStyle(fontFamily: 'Comic Sans MS', fontSize: 17, color: Color(0xff000000), fontWeight: FontWeight.w700),
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