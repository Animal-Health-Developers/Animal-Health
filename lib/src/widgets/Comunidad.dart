import 'package:flutter/material.dart';
import 'package:adobe_xd/pinned.dart';
import './Home.dart';
import 'package:adobe_xd/page_link.dart';
import './Ayuda.dart';
import './PerfilPublico.dart';
import './AmigosenLInea.dart';
import './Contactos.dart';
// import 'dart:ui' as ui; // No se está usando ui.ImageFilter directamente aquí
import './Configuracion.dart';
import './ListadeAnimales.dart';
import './CompradeProductos.dart';
import './CuidadosyRecomendaciones.dart';
import './Emergencias.dart';
import './Crearpublicaciones.dart';
import '../services/auth_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'dart:developer' as developer;

// --- CONFIGURACIÓN DE API KEYS ---
// ¡¡¡ADVERTENCIA!!! NO SUBAS ESTA CLAVE A REPOSITORIOS PÚBLICOS NI LA DISTRIBUYAS.
const String GEMINI_API_KEY_COMMUNITY = 'AIzaSyAgv8dNt1etzPz8Lnl39e8Seb6N8B3nenc'; // TU API KEY DE GEMINI AQUÍ
// ---------------------------------

class Comunidad extends StatefulWidget {
  const Comunidad({
    Key? key,
  }) : super(key: key);

  @override
  _ComunidadState createState() => _ComunidadState();
}

class _ComunidadState extends State<Comunidad> {
  final TextEditingController _searchController = TextEditingController();
  GenerativeModel? _geminiModel;
  bool _isSearching = false;

  List<Map<String, String>> _friendRequests = [];

  @override
  void initState() {
    super.initState();
    _initializeGemini();
    _loadFriendRequests();
  }

  void _initializeGemini() {
    if (GEMINI_API_KEY_COMMUNITY.isNotEmpty && GEMINI_API_KEY_COMMUNITY != 'TU_API_KEY_DE_GEMINI_AQUI') {
      try {
        _geminiModel = GenerativeModel(
          model: 'gemini-1.5-flash-latest',
          apiKey: GEMINI_API_KEY_COMMUNITY,
        );
        developer.log("Modelo Gemini inicializado en Comunidad.");
      } catch (e) {
        developer.log("Error inicializando modelo Gemini en Comunidad: $e");
      }
    } else {
      developer.log("API Key de Gemini no configurada en Comunidad. La búsqueda con IA no funcionará.");
    }
  }

  void _loadFriendRequests() {
    // Simulación: En una app real, cargarías esto desde Firestore
    // Por ahora, la dejamos vacía.
    // Para probar, puedes añadir datos aquí temporalmente:
    /*
    if (mounted) {
      setState(() {
        _friendRequests = [
          {'id': 'user123', 'name': 'Usuario Prueba 1', 'time': 'Hace 1 día', 'profilePicUrl': 'https://via.placeholder.com/150/92c952'},
          {'id': 'user456', 'name': 'Otro Usuario', 'time': 'Hace 2 horas', 'profilePicUrl': 'https://via.placeholder.com/150/771796'},
        ];
      });
    }
    */
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
      final prompt = 'Busca usuarios, grupos o temas relevantes para una comunidad de amantes de las mascotas sobre: "$query". Proporciona una breve descripción o sugerencia.';
      final content = [Content.text(prompt)];
      final response = await _geminiModel!.generateContent(content).timeout(const Duration(seconds: 20));
      developer.log("Respuesta de Gemini para búsqueda en Comunidad '$query': ${response.text}");
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
      developer.log("Error al buscar en Comunidad con Gemini: $e");
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
    final double topOffsetForCommunityBlock = navBarBottomY + 20;

    return Scaffold(
      backgroundColor: const Color(0xff4ec8dd),
      body: Stack(
        children: <Widget>[
          Positioned.fill(
            child: Image.asset(
              'assets/images/Animal Health Fondo de Pantalla.png',
              fit: BoxFit.cover,
            ),
          ),
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
          Pinned.fromPins(
            Pin(size: 307.0, middle: 0.5),
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
                        hintText: 'Buscar en comunidad...',
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
          Pinned.fromPins(
            Pin(size: 60.0, start: 6.0),
            Pin(size: 60.0, middle: 0.1947),
            child: StreamBuilder<DocumentSnapshot>(
              stream: FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser?.uid).snapshots(),
              builder: (context, snapshot) {
                final profilePhotoUrl = snapshot.data?['profilePhotoUrl'] as String?;
                return PageLink(
                  links: [PageLinkInfo(pageBuilder: () => PerfilPublico(key: const Key('PerfilPublico')))],
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
          Pinned.fromPins(
            Pin(size: 47.2, end: 7.6),
            Pin(size: 50.0, start: 49.0),
            child: PageLink(
              links: [PageLinkInfo(pageBuilder: () => Configuraciones(key: const Key('Settings'), authService: AuthService()))],
              child: Container(decoration: const BoxDecoration(image: DecorationImage(image: AssetImage('assets/images/settingsbutton.png'), fit: BoxFit.fill))),
            ),
          ),
          Pinned.fromPins(
            Pin(size: 60.1, start: 6.0),
            Pin(size: 60.0, start: 44.0),
            child: PageLink(
              links: [PageLinkInfo(pageBuilder: () => const ListadeAnimales(key: Key('ListadeAnimales')))],
              child: Container(decoration: const BoxDecoration(image: DecorationImage(image: AssetImage('assets/images/listaanimales.png'), fit: BoxFit.fill))),
            ),
          ),
          Pinned.fromPins(
            Pin(size: 58.5, end: 2.0),
            Pin(size: 60.0, start: 105.0),
            child: PageLink(
              links: [PageLinkInfo(pageBuilder: () => const CompradeProductos(key: Key('CompradeProductos')))],
              child: Container(decoration: const BoxDecoration(image: DecorationImage(image: AssetImage('assets/images/store.png'), fit: BoxFit.fill))),
            ),
          ),
          Pinned.fromPins(
            Pin(size: 54.3, start: 24.0),
            Pin(size: 60.0, middle: 0.2712),
            child: PageLink(
              links: [PageLinkInfo(pageBuilder: () => const Home(key: Key('Home')))],
              child: Container(decoration: const BoxDecoration(image: DecorationImage(image: AssetImage('assets/images/noticias.png'), fit: BoxFit.fill))),
            ),
          ),
          Align(
            alignment: const Alignment(-0.459, -0.458),
            child: PageLink(
              links: [PageLinkInfo(pageBuilder: () => const CuidadosyRecomendaciones(key: Key('CuidadosyRecomendaciones')))],
              child: Container(width: 63.0, height: 60.0, decoration: const BoxDecoration(image: DecorationImage(image: AssetImage('assets/images/cuidadosrecomendaciones.png'), fit: BoxFit.fill))),
            ),
          ),
          Align(
            alignment: const Alignment(0.0, -0.458),
            child: PageLink(
              links: [PageLinkInfo(pageBuilder: () => const Emergencias(key: Key('Emergencias')))],
              child: Container(width: 65.0, height: 60.0, decoration: const BoxDecoration(image: DecorationImage(image: AssetImage('assets/images/emergencias.png'), fit: BoxFit.fill))),
            ),
          ),
          Align(
            alignment: const Alignment(0.477, -0.458),
            child: Container(
              width: 67.0, height: 60.0,
              decoration: BoxDecoration(
                image: const DecorationImage(image: AssetImage('assets/images/comunidad.png'), fit: BoxFit.fill),
                boxShadow: [BoxShadow(color: const Color(0xff9dedf9), offset: const Offset(0, 3), blurRadius: 6)],
              ),
            ),
          ),
          Pinned.fromPins(
            Pin(size: 53.6, end: 20.3),
            Pin(size: 60.0, middle: 0.2712),
            child: PageLink(
              links: [PageLinkInfo(pageBuilder: () => const Crearpublicaciones(key: Key('Crearpublicaciones')))],
              child: Container(decoration: const BoxDecoration(image: DecorationImage(image: AssetImage('assets/images/crearpublicacion.png'), fit: BoxFit.fill))),
            ),
          ),

          Positioned(
            top: topOffsetForCommunityBlock,
            left: 14.0,
            right: 14.0,
            bottom: 20.0,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Expanded(child: _buildCommunityTabButton('Solicitudes', true, () {})),
                    const SizedBox(width: 10),
                    Expanded(child: _buildCommunityTabButton('En línea', false, () {
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const AmigosenLInea(key: Key('AmigosenLInea'))));
                    })),
                    const SizedBox(width: 10),
                    Expanded(child: _buildCommunityTabButton('Contactos', false, () {
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const Contactos(key: Key('Contactos'))));
                    })),
                  ],
                ),
                const SizedBox(height: 20),
                Expanded( // ESTE ES EL CAMBIO PRINCIPAL
                  child: Container(
                    padding: const EdgeInsets.all(10.0),
                    decoration: BoxDecoration(
                      color: const Color(0xe3a0f4fe),
                      borderRadius: BorderRadius.circular(20.0),
                      border: Border.all(width: 1.0, color: const Color(0xe3000000)),
                    ),
                    child: _friendRequests.isEmpty
                        ? const Center(
                      child: Padding(
                        padding: EdgeInsets.all(20.0),
                        child: Text(
                          'No tienes solicitudes de amistad pendientes.',
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
                      itemCount: _friendRequests.length,
                      itemBuilder: (context, index) {
                        final request = _friendRequests[index];
                        return _buildFriendRequestItem(
                          name: request['name']!,
                          time: request['time']!,
                          profilePicUrl: request['profilePicUrl']!,
                          onConfirm: () {
                            developer.log('Confirmar amistad con ${request['name']}');
                            if (mounted) {
                              setState(() {
                                _friendRequests.removeAt(index);
                              });
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Solicitud de ${request['name']} aceptada.')));
                            }
                          },
                          onDelete: () {
                            developer.log('Eliminar solicitud de ${request['name']}');
                            if (mounted) {
                              setState(() {
                                _friendRequests.removeAt(index);
                              });
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Solicitud de ${request['name']} eliminada.')));
                            }
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

  Widget _buildFriendRequestItem({
    required String name,
    required String time,
    required String profilePicUrl,
    required VoidCallback onConfirm,
    required VoidCallback onDelete,
  }) {
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
            backgroundImage: NetworkImage(profilePicUrl),
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
                  time,
                  style: const TextStyle(fontFamily: 'Comic Sans MS', fontSize: 12, color: Colors.black54),
                ),
              ],
            ),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: 30,
                child: ElevatedButton(
                  onPressed: onConfirm,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0x7a54d1e0),
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
                  ),
                  child: const Text('Confirmar', style: TextStyle(fontFamily: 'Comic Sans MS', fontSize: 12, color: Colors.black)),
                ),
              ),
              const SizedBox(height: 5),
              SizedBox(
                height: 30,
                child: OutlinedButton(
                  onPressed: onDelete,
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: Colors.grey.shade400),
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
                  ),
                  child: const Text('Eliminar', style: TextStyle(fontFamily: 'Comic Sans MS', fontSize: 12, color: Colors.black54)),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}