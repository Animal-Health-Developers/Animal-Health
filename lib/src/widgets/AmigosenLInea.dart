import 'package:flutter/material.dart';
import 'package:adobe_xd/pinned.dart';
import './Home.dart';
import 'package:adobe_xd/page_link.dart';
import './Ayuda.dart';
import './PerfilPublico.dart';
import './chatconamigos.dart'; // Asumo que esta pantalla existe
import 'dart:ui' as ui;
import './Contactos.dart';
import './Comunidad.dart';
import './Configuracion.dart';
import './ListadeAnimales.dart';
import './CompradeProductos.dart';
import './CuidadosyRecomendaciones.dart';
import './Emergencias.dart';
import './Crearpublicaciones.dart';
// import 'package:flutter_svg/flutter_svg.dart'; // No se usa _svg_pp4nt ni _svg_guxmqh
import '../services/auth_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Para Firestore
import 'package:firebase_auth/firebase_auth.dart';   // Para FirebaseAuth
import 'package:cached_network_image/cached_network_image.dart'; // Para imágenes de perfil
import 'package:google_generative_ai/google_generative_ai.dart'; // Para Gemini
import 'dart:developer' as developer; // Para logging

// --- CONFIGURACIÓN DE API KEYS ---
const String GEMINI_API_KEY_ONLINE_FRIENDS = 'AIzaSyAgv8dNt1etzPz8Lnl39e8Seb6N8B3nenc'; // TU API KEY DE GEMINI AQUÍ
// ---------------------------------


class AmigosenLInea extends StatefulWidget { // Convertido a StatefulWidget
  const AmigosenLInea({ // Constructor actualizado
    Key? key,
  }) : super(key: key);

  @override
  _AmigosenLIneaState createState() => _AmigosenLIneaState();
}

class _AmigosenLIneaState extends State<AmigosenLInea> {
  final TextEditingController _searchController = TextEditingController();
  GenerativeModel? _geminiModel;
  bool _isSearching = false;

  // Lista simulada de amigos en línea (estará vacía inicialmente)
  // En una app real, esto vendría de Firestore o de un servicio de presencia.
  List<Map<String, String>> _onlineFriends = [];

  @override
  void initState() {
    super.initState();
    _initializeGemini();
    _loadOnlineFriends(); // Cargar amigos en línea (simulado por ahora)
  }

  void _initializeGemini() {
    if (GEMINI_API_KEY_ONLINE_FRIENDS.isNotEmpty && GEMINI_API_KEY_ONLINE_FRIENDS != 'TU_API_KEY_DE_GEMINI_AQUI') {
      try {
        _geminiModel = GenerativeModel(
          model: 'gemini-1.5-flash-latest',
          apiKey: GEMINI_API_KEY_ONLINE_FRIENDS,
        );
        developer.log("Modelo Gemini inicializado en AmigosenLinea.");
      } catch (e) {
        developer.log("Error inicializando modelo Gemini en AmigosenLinea: $e");
      }
    } else {
      developer.log("API Key de Gemini no configurada en AmigosenLinea. La búsqueda con IA no funcionará.");
    }
  }

  // Simulación de carga de amigos en línea
  void _loadOnlineFriends() {
    // Por ahora, la dejamos vacía.
    // Para probar, podrías añadir datos aquí temporalmente:
    // setState(() {
    //   _onlineFriends = [
    //     {'name': 'Kitty', 'status': 'En línea', 'profilePicUrl': 'assets/images/kitty.jpg'},
    //     {'name': 'Donut', 'status': 'En línea', 'profilePicUrl': 'assets/images/donut.jpg'},
    //   ];
    // });
  }

  Future<void> _performSearch(String query) async {
    if (query.isEmpty) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Por favor, ingresa un término de búsqueda')),
        );
      }
      return;
    }
    if (_geminiModel == null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('La búsqueda con IA no está disponible.')),
        );
      }
      return;
    }
    if (mounted) {
      setState(() { _isSearching = true; });
    }
    try {
      final prompt = 'Busca usuarios o amigos con el nombre o tema: "$query" en una comunidad de mascotas. Proporciona una breve descripción o sugerencia.';
      final content = [Content.text(prompt)];
      final response = await _geminiModel!.generateContent(content).timeout(const Duration(seconds: 20));
      developer.log("Respuesta de Gemini para búsqueda en AmigosenLinea '$query': ${response.text}");
      if (mounted) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Resultado de búsqueda: $query'),
              content: SingleChildScrollView(child: Text(response.text ?? 'No se encontró información relevante.')),
              actions: <Widget>[
                TextButton(child: const Text('Cerrar'), onPressed: () => Navigator.of(context).pop()),
              ],
            );
          },
        );
      }
    } catch (e) {
      developer.log("Error al buscar en AmigosenLinea con Gemini: $e");
      String errorMessageText = "Hubo un problema al realizar la búsqueda.";
      if (e is GenerativeAIException) {
        if (e.message.contains('API key not valid')) {
          errorMessageText = "Error: La API Key de Gemini no es válida.";
        } else if (e.message.contains('quota')) {
          errorMessageText = "Cuota de API de Gemini alcanzada.";
        } else if (e.message.contains('not found for API version v1') || e.message.contains('not supported for generateContent')) {
          errorMessageText = "Error: El modelo de IA no es compatible.";
        }
      } else if (e.toString().contains('timeout')) {
        errorMessageText = "La búsqueda tardó demasiado.";
      }
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(errorMessageText)));
      }
    } finally {
      if (mounted) { setState(() { _isSearching = false; }); }
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double statusBarHeight = MediaQuery.of(context).padding.top;
    final double navBarCenterY = MediaQuery.of(context).size.height * 0.2712;
    final double navBarBottomY = navBarCenterY + 30;
    final double topOffsetForContentBlock = navBarBottomY + 20;

    return Scaffold(
      backgroundColor: const Color(0xff4ec8dd),
      body: Stack(
        children: <Widget>[
          // Fondo de pantalla
          Positioned.fill(
            child: Image.asset(
              'assets/images/Animal Health Fondo de Pantalla.png',
              fit: BoxFit.cover,
            ),
          ),

          // Logo
          Pinned.fromPins(
            Pin(size: 74.0, middle: 0.5),
            Pin(size: 73.0, start: 42.0),
            child: PageLink(
              links: [PageLinkInfo(pageBuilder: () => const Home(key: Key('Home')))],
              child: Container(
                decoration: BoxDecoration(
                  image: const DecorationImage(image: AssetImage('assets/images/logo.png'), fit: BoxFit.cover),
                  borderRadius: BorderRadius.circular(15.0),
                  border: Border.all(width: 1.0, color: const Color(0xff000000)),
                ),
              ),
            ),
          ),

          // Botón de ayuda
          Pinned.fromPins(
            Pin(size: 40.5, middle: 0.8328),
            Pin(size: 50.0, start: 49.0),
            child: PageLink(
              links: [PageLinkInfo(pageBuilder: () => const Ayuda(key: Key('Ayuda')))],
              child: Container(
                decoration: const BoxDecoration(
                  image: DecorationImage(image: AssetImage('assets/images/help.png'), fit: BoxFit.fill),
                ),
              ),
            ),
          ),

          //Barra de busqueda (POSICIÓN CENTRADA Y FUNCIONAL)
          Pinned.fromPins(
            Pin(size: 307.0, middle: 0.5), // CENTRADO
            Pin(size: 45.0, middle: 0.1995),
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xffffffff),
                borderRadius: BorderRadius.circular(5.0),
                border: Border.all(width: 1.0, color: const Color(0xff707070)),
              ),
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Image.asset('assets/images/busqueda1.png', width: 24.0, height: 24.0),
                  ),
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      style: const TextStyle(fontFamily: 'Comic Sans MS', fontSize: 18, color: Color(0xff000000)),
                      decoration: const InputDecoration(
                        hintText: 'Buscar amigos...',
                        hintStyle: TextStyle(fontFamily: 'Comic Sans MS', fontSize: 18, color: Colors.grey),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.only(left: 4, right: 4, top: 12, bottom: 12),
                      ),
                      textInputAction: TextInputAction.search,
                      onSubmitted: (value) { if (!_isSearching) _performSearch(value); },
                    ),
                  ),
                  if (_isSearching)
                    const Padding(padding: EdgeInsets.all(8.0), child: SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2.0)))
                  else
                    IconButton(icon: const Icon(Icons.search, color: Colors.black54), onPressed: () { if (!_isSearching) _performSearch(_searchController.text); }),
                ],
              ),
            ),
          ),

          //Mini foto de perfil (DINÁMICA)
          Pinned.fromPins(
            Pin(size: 60.0, start: 6.0),
            Pin(size: 60.0, middle: 0.1947),
            child: StreamBuilder<DocumentSnapshot>(
              stream: FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser?.uid).snapshots(),
              builder: (context, snapshot) {
                final profilePhotoUrl = snapshot.data?['profilePhotoUrl'] as String?;
                return PageLink(
                  links: [PageLinkInfo(pageBuilder: () => PerfilPublico(key: Key('PerfilPublico')))],
                  child: Container(
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(10.0), color: Colors.grey[200]),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10.0),
                      child: profilePhotoUrl != null && profilePhotoUrl.isNotEmpty
                          ? CachedNetworkImage(
                        imageUrl: profilePhotoUrl,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => const Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Color(0xff4ec8dd)))),
                        errorWidget: (context, url, error) => const Icon(Icons.person, size: 30, color: Colors.grey),
                      )
                          : const Icon(Icons.person, size: 30, color: Colors.grey),
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
              links: [PageLinkInfo(pageBuilder: () => Configuraciones(key: const Key('Settings'), authService: AuthService()))],
              child: Container(decoration: const BoxDecoration(image: DecorationImage(image: AssetImage('assets/images/settingsbutton.png'), fit: BoxFit.fill))),
            ),
          ),
          // Botón de lista de animales
          Pinned.fromPins(
            Pin(size: 60.1, start: 6.0),
            Pin(size: 60.0, start: 44.0),
            child: PageLink(
              links: [PageLinkInfo(pageBuilder: () => const ListadeAnimales(key: Key('ListadeAnimales')))],
              child: Container(decoration: const BoxDecoration(image: DecorationImage(image: AssetImage('assets/images/listaanimales.png'), fit: BoxFit.fill))),
            ),
          ),
          // Botón de tienda
          Pinned.fromPins(
            Pin(size: 58.5, end: 2.0),
            Pin(size: 60.0, start: 105.0),
            child: PageLink(
              links: [PageLinkInfo(pageBuilder: () => const CompradeProductos(key: Key('CompradeProductos')))],
              child: Container(decoration: const BoxDecoration(image: DecorationImage(image: AssetImage('assets/images/store.png'), fit: BoxFit.fill))),
            ),
          ),
          // Botón de noticias
          Pinned.fromPins(
            Pin(size: 54.3, start: 24.0),
            Pin(size: 60.0, middle: 0.2712),
            child: PageLink(
              links: [PageLinkInfo(pageBuilder: () => const Home(key: Key('Home')))],
              child: Container(decoration: const BoxDecoration(image: DecorationImage(image: AssetImage('assets/images/noticias.png'), fit: BoxFit.fill))),
            ),
          ),
          // Botón de cuidados y recomendaciones
          Align(
            alignment: const Alignment(-0.459, -0.458),
            child: PageLink(
              links: [PageLinkInfo(pageBuilder: () => const CuidadosyRecomendaciones(key: Key('CuidadosyRecomendaciones')))],
              child: Container(width: 63.0, height: 60.0, decoration: const BoxDecoration(image: DecorationImage(image: AssetImage('assets/images/cuidadosrecomendaciones.png'), fit: BoxFit.fill))),
            ),
          ),
          // Botón de emergencias
          Align(
            alignment: const Alignment(0.0, -0.458),
            child: PageLink(
              links: [PageLinkInfo(pageBuilder: () => const Emergencias(key: Key('Emergencias')))],
              child: Container(width: 65.0, height: 60.0, decoration: const BoxDecoration(image: DecorationImage(image: AssetImage('assets/images/emergencias.png'), fit: BoxFit.fill))),
            ),
          ),
          // Botón de comunidad (resaltado)
          Align(
            alignment: const Alignment(0.477, -0.458),
            child: PageLink( // Enlace a Comunidad, ya que esta es la pantalla de "Amigos en Línea" que es una subsección
              links: [PageLinkInfo(pageBuilder: () => const Comunidad(key: Key('Comunidad')))],
              child: Container(
                width: 67.0, height: 60.0,
                decoration: BoxDecoration(
                  image: const DecorationImage(image: AssetImage('assets/images/comunidad.png'), fit: BoxFit.fill),
                  boxShadow: [BoxShadow(color: const Color(0xff9dedf9), offset: const Offset(0, 3), blurRadius: 6)],
                ),
              ),
            ),
          ),
          // Botón de crear publicación
          Pinned.fromPins(
            Pin(size: 53.6, end: 20.3),
            Pin(size: 60.0, middle: 0.2712),
            child: PageLink(
              links: [PageLinkInfo(pageBuilder: () => const Crearpublicaciones(key: Key('Crearpublicaciones')))],
              child: Container(decoration: const BoxDecoration(image: DecorationImage(image: AssetImage('assets/images/crearpublicacion.png'), fit: BoxFit.fill))),
            ),
          ),
          // BLOQUE DE "SOLICITUDES", "EN LÍNEA", "CONTACTOS" Y LISTA DE AMIGOS EN LÍNEA
          Positioned(
            top: topOffsetForContentBlock,
            left: 14.0,
            right: 14.0,
            bottom: 20.0, // Añadir un poco de padding inferior para que no se pegue al borde
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Fila para "Solicitudes", "En línea", "Contactos"
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Expanded(child: _buildCommunityTabButton('Solicitudes', false, () {
                      // Navegar a la pantalla de Comunidad (que muestra solicitudes)
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const Comunidad(key: Key('Comunidad'))));
                    })),
                    const SizedBox(width: 10),
                    Expanded(child: _buildCommunityTabButton('En línea', true, () {})), // "En línea" es la pestaña actual
                    const SizedBox(width: 10),
                    Expanded(child: _buildCommunityTabButton('Contactos', false, () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Contactos(key: const Key('Contactos')))))),
                  ],
                ),
                const SizedBox(height: 20),

                // Contenedor para la lista de amigos en línea
                Expanded( // Usar Expanded para que la lista ocupe el espacio restante
                  child: Container(
                    padding: const EdgeInsets.all(10.0),
                    decoration: BoxDecoration(
                      color: const Color(0xe3a0f4fe),
                      borderRadius: BorderRadius.circular(20.0),
                      border: Border.all(width: 1.0, color: const Color(0xe3000000)),
                    ),
                    child: _onlineFriends.isEmpty
                        ? const Center(
                      child: Padding(
                        padding: EdgeInsets.all(20.0),
                        child: Text(
                          'No hay amigos en línea en este momento.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: 'Comic Sans MS',
                            fontSize: 16,
                            color: Colors.black54,
                          ),
                        ),
                      ),
                    )
                        : ListView.builder(
                      itemCount: _onlineFriends.length,
                      itemBuilder: (context, index) {
                        final friend = _onlineFriends[index];
                        return _buildOnlineFriendItem(
                          name: friend['name']!,
                          status: friend['status']!, // Aunque siempre será "En línea" aquí
                          profilePicUrl: friend['profilePicUrl']!,
                          onChat: () {
                            // Lógica para abrir chat
                            Navigator.push(context, MaterialPageRoute(builder: (context) => chatconamigos(key: const Key('chatconamigos') /*, friendId: friend['id'] */)));
                            developer.log('Abrir chat con ${friend['name']}');
                          },
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCommunityTabButton(String title, bool isSelected, VoidCallback onPressed) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        decoration: BoxDecoration(
          color: const Color(0xe3a0f4fe),
          borderRadius: BorderRadius.circular(10.0),
          border: Border.all(width: 1.0, color: const Color(0xe3000000)),
          boxShadow: isSelected
              ? [const BoxShadow(color: Color(0xe31b0ed9), offset: Offset(0, 3), blurRadius: 6)]
              : [],
        ),
        child: Text(
          title,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontFamily: 'Comic Sans MS',
            fontSize: 15,
            color: Color(0xff000000),
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }

  Widget _buildOnlineFriendItem({
    required String name,
    required String status,
    required String profilePicUrl,
    required VoidCallback onChat,
  }) {
    // Determinar si la URL es de assets o de red
    bool isAsset = profilePicUrl.startsWith('assets/');

    return Container(
      margin: const EdgeInsets.only(bottom: 15.0),
      padding: const EdgeInsets.all(10.0),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.8),
        borderRadius: BorderRadius.circular(15.0),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundImage: isAsset ? AssetImage(profilePicUrl) as ImageProvider : NetworkImage(profilePicUrl),
            backgroundColor: Colors.grey[200],
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(fontFamily: 'Comic Sans MS', fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Text(
                  status,
                  style: const TextStyle(fontFamily: 'Comic Sans MS', fontSize: 12, color: Colors.green, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: onChat,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0x7a54d1e0),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
            ),
            child: const Text('Mensaje', style: TextStyle(fontFamily: 'Comic Sans MS', fontSize: 12, color: Colors.black)),
          ),
        ],
      ),
    );
  }
}