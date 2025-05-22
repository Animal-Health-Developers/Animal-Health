import 'package:flutter/material.dart';
import 'package:adobe_xd/pinned.dart';
import './Home.dart';
import 'package:adobe_xd/page_link.dart';
import './Ayuda.dart';
import './PerfilPublico.dart';
import './chatconamigos.dart'; // Asumo que esta pantalla existe
// import 'dart:ui' as ui; // No se está usando ui.ImageFilter directamente aquí
import './AmigosenLInea.dart'; // Para navegar a Amigos en Línea
import './Comunidad.dart';    // Para navegar a Solicitudes (Comunidad)
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
const String GEMINI_API_KEY_CONTACTS = 'AIzaSyAgv8dNt1etzPz8Lnl39e8Seb6N8B3nenc'; // TU API KEY DE GEMINI AQUÍ
// ---------------------------------

// Modelo simple para un contacto/amigo
class Contact {
  final String id;
  final String name;
  final String profilePicUrl;
  final bool isOnline; // Podrías usar esto para el estado

  Contact({required this.id, required this.name, required this.profilePicUrl, this.isOnline = false});
}


class Contactos extends StatefulWidget {
  const Contactos({
    Key? key,
  }) : super(key: key);

  @override
  _ContactosState createState() => _ContactosState();
}

class _ContactosState extends State<Contactos> {
  final TextEditingController _searchController = TextEditingController();
  GenerativeModel? _geminiModel;
  bool _isSearchingWithGemini = false;

  List<Contact> _allContacts = []; // Lista completa de contactos (simulada)
  List<Contact> _filteredContacts = []; // Lista filtrada para la búsqueda local

  @override
  void initState() {
    super.initState();
    _initializeGemini();
    _loadContacts();
    _searchController.addListener(_filterContactsLocal);
  }

  void _initializeGemini() {
    if (GEMINI_API_KEY_CONTACTS.isNotEmpty && GEMINI_API_KEY_CONTACTS != 'TU_API_KEY_DE_GEMINI_AQUI') {
      try {
        _geminiModel = GenerativeModel(
          model: 'gemini-1.5-flash-latest',
          apiKey: GEMINI_API_KEY_CONTACTS,
        );
        developer.log("Modelo Gemini inicializado en Contactos.");
      } catch (e) {
        developer.log("Error inicializando modelo Gemini en Contactos: $e");
      }
    } else {
      developer.log("API Key de Gemini no configurada en Contactos. La búsqueda con IA no funcionará.");
    }
  }

  void _loadContacts() {
    // Simulación de carga de contactos. En una app real, esto vendría de Firestore.
    // Dejaremos la lista vacía para cumplir el requisito inicial.
    // Para probar, puedes descomentar y añadir datos:
    /*
    if (mounted) {
      setState(() {
        _allContacts = [
          Contact(id: '1', name: 'Kitty Amiga', profilePicUrl: 'assets/images/kitty.jpg', isOnline: true),
          Contact(id: '2', name: 'Donut Amigo', profilePicUrl: 'assets/images/donut.jpg', isOnline: false),
          Contact(id: '3', name: 'Winter Amigo', profilePicUrl: 'assets/images/winter.jpg', isOnline: true),
          Contact(id: '4', name: 'Max El Perro', profilePicUrl: 'https://via.placeholder.com/150/24f355', isOnline: false),
          Contact(id: '5', name: 'Luna La Gata', profilePicUrl: 'https://via.placeholder.com/150/f66b97', isOnline: true),
        ];
        _filteredContacts = _allContacts;
      });
    }
    */
    if (mounted) {
      setState(() {
        _allContacts = []; // Asegurar que esté vacía al inicio
        _filteredContacts = _allContacts;
      });
    }
  }

  void _filterContactsLocal() {
    final query = _searchController.text.toLowerCase();
    if (mounted) {
      setState(() {
        if (query.isEmpty) {
          _filteredContacts = _allContacts;
        } else {
          _filteredContacts = _allContacts.where((contact) {
            return contact.name.toLowerCase().contains(query);
          }).toList();
        }
      });
    }
  }

  Future<void> _performSearchWithGemini(String query) async {
    if (query.isEmpty) {
      _filterContactsLocal();
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
      setState(() { _isSearchingWithGemini = true; });
    }
    try {
      final prompt = 'Busca información sobre "$query" en el contexto de una comunidad de mascotas o perfiles de usuarios. Proporciona una breve descripción o sugerencia.';
      final content = [Content.text(prompt)];
      final response = await _geminiModel!.generateContent(content).timeout(const Duration(seconds: 20));
      developer.log("Respuesta de Gemini para búsqueda en Contactos '$query': ${response.text}");
      if (mounted) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Información adicional sobre: $query'),
              content: SingleChildScrollView(child: Text(response.text ?? 'No se encontró información adicional.')),
              actions: <Widget>[
                TextButton(child: const Text('Cerrar'), onPressed: () => Navigator.of(context).pop()),
              ],
            );
          },
        );
      }
    } catch (e) {
      developer.log("Error al buscar en Contactos con Gemini: $e");
      String errorMessageText = "Hubo un problema al realizar la búsqueda con IA.";
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
      if (mounted) { setState(() { _isSearchingWithGemini = false; }); }
    }
  }


  @override
  void dispose() {
    _searchController.removeListener(_filterContactsLocal);
    _searchController.dispose();
    super.dispose();
  }

  // Método para construir los items de la barra de navegación
  Widget _buildNavigationButtonItem({
    required String imagePath,
    bool isHighlighted = false,
    double? fixedWidth,
    double height = 60.0,
  }) {
    double itemWidth;
    if (fixedWidth != null) {
      itemWidth = fixedWidth;
    } else {
      if (imagePath.contains('noticias')) itemWidth = 54.3;
      else if (imagePath.contains('cuidadosrecomendaciones')) itemWidth = 63.0;
      else if (imagePath.contains('emergencias')) itemWidth = 65.0;
      else if (imagePath.contains('comunidad')) itemWidth = 67.0;
      else if (imagePath.contains('crearpublicacion')) itemWidth = 53.6;
      else itemWidth = 60.0;
    }

    return Container(
      width: itemWidth,
      height: height,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(imagePath),
          fit: BoxFit.fill,
        ),
        boxShadow: isHighlighted
            ? const [BoxShadow(color: Color(0xff9dedf9), offset: Offset(0, 3), blurRadius: 6)] // Color de Comunidad
            : null,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const double navBarTopPosition = 200.0;
    const double navBarHeight = 60.0;
    const double spaceBelowNavBar = 20.0;
    final double topOffsetForContentBlock = navBarTopPosition + navBarHeight + spaceBelowNavBar;

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

          //Barra de busqueda
          Pinned.fromPins(
            Pin(size: 307.0, middle: 0.5),
            Pin(size: 45.0, start: 150.0),
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
                        hintText: 'Buscar contactos...',
                        hintStyle: TextStyle(fontFamily: 'Comic Sans MS', fontSize: 18, color: Colors.grey),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(vertical: 12.0),
                      ),
                      textInputAction: TextInputAction.search,
                    ),
                  ),
                  if (_isSearchingWithGemini)
                    const Padding(padding: EdgeInsets.all(8.0), child: SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2.0)))
                  else
                    IconButton(
                        icon: const Icon(Icons.search, color: Colors.black54),
                        tooltip: "Buscar con IA",
                        onPressed: () {
                          if (!_isSearchingWithGemini) _performSearchWithGemini(_searchController.text);
                        }
                    ),
                ],
              ),
            ),
          ),

          //Mini foto de perfil
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

          // --- NUEVA SECCIÓN DE BOTONES DE NAVEGACIÓN ---
          Positioned(
            top: navBarTopPosition,
            left: 16.0,
            right: 16.0,
            height: navBarHeight,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                PageLink(
                  links: [PageLinkInfo(pageBuilder: () => const Home(key: Key('Home')))],
                  child: _buildNavigationButtonItem(
                    imagePath: 'assets/images/noticias.png',
                    fixedWidth: 54.3,
                  ),
                ),
                PageLink(
                  links: [PageLinkInfo(pageBuilder: () => const CuidadosyRecomendaciones(key: Key('CuidadosyRecomendaciones')))],
                  child: _buildNavigationButtonItem(
                    imagePath: 'assets/images/cuidadosrecomendaciones.png',
                    fixedWidth: 63.0,
                  ),
                ),
                PageLink(
                  links: [PageLinkInfo(pageBuilder: () => const Emergencias(key: Key('Emergencias')))],
                  child: _buildNavigationButtonItem(
                    imagePath: 'assets/images/emergencias.png',
                    fixedWidth: 65.0,
                  ),
                ),
                PageLink( // Enlace a Comunidad, ya que "Contactos" es subsección
                  links: [PageLinkInfo(pageBuilder: () => const Comunidad(key: Key('Comunidad')))],
                  child: _buildNavigationButtonItem(
                    imagePath: 'assets/images/comunidad.png',
                    isHighlighted: true, // Resaltar comunidad
                    fixedWidth: 67.0,
                  ),
                ),
                PageLink(
                  links: [PageLinkInfo(pageBuilder: () => const Crearpublicaciones(key: Key('Crearpublicaciones')))],
                  child: _buildNavigationButtonItem(
                    imagePath: 'assets/images/crearpublicacion.png',
                    fixedWidth: 53.6,
                  ),
                ),
              ],
            ),
          ),
          // --- FIN DE NUEVA SECCIÓN DE BOTONES DE NAVEGACIÓN ---

          // BLOQUE DE "SOLICITUDES", "EN LÍNEA", "CONTACTOS" Y LISTA DE CONTACTOS
          Positioned(
            top: topOffsetForContentBlock,
            left: 14.0,
            right: 14.0,
            bottom: 20.0,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Expanded(child: _buildCommunityTabButton('Solicitudes', false, () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const Comunidad(key: Key('Comunidad')))))),
                    const SizedBox(width: 10),
                    Expanded(child: _buildCommunityTabButton('En línea', false, () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const AmigosenLInea(key: Key('AmigosenLInea')))))),
                    const SizedBox(width: 10),
                    Expanded(child: _buildCommunityTabButton('Contactos', true, () {})),
                  ],
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(10.0),
                    decoration: BoxDecoration(
                      color: const Color(0xe3a0f4fe),
                      borderRadius: BorderRadius.circular(20.0),
                      border: Border.all(width: 1.0, color: const Color(0xe3000000)),
                    ),
                    child: _allContacts.isEmpty && _searchController.text.isEmpty
                        ? const Center(
                      child: Padding(
                        padding: EdgeInsets.all(20.0),
                        child: Text(
                          'Aún no tienes contactos. ¡Empieza a conectar!',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontFamily: 'Comic Sans MS', fontSize: 16, color: Colors.black54),
                        ),
                      ),
                    )
                        : _filteredContacts.isEmpty && _searchController.text.isNotEmpty
                        ? Center(
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Text(
                          'No se encontraron contactos con "${_searchController.text}".',
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontFamily: 'Comic Sans MS', fontSize: 16, color: Colors.black54),
                        ),
                      ),
                    )
                        : ListView.builder(
                      itemCount: _filteredContacts.length,
                      itemBuilder: (context, index) {
                        final contact = _filteredContacts[index];
                        return _buildContactItem(
                          contact: contact,
                          onChat: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => chatconamigos(
                                  key: Key('chatconamigos_${contact.id}'),
                                  // friendId: contact.id, // Pasa el ID del contacto si tu chat lo necesita
                                ),
                              ),
                            );
                            developer.log('Abrir chat con ${contact.name}');
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

  Widget _buildContactItem({
    required Contact contact,
    required VoidCallback onChat,
  }) {
    bool isAsset = contact.profilePicUrl.startsWith('assets/');
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
            backgroundImage: isAsset ? AssetImage(contact.profilePicUrl) as ImageProvider : CachedNetworkImageProvider(contact.profilePicUrl),
            onBackgroundImageError: isAsset ? null : (exception, stackTrace) {
              developer.log('Error cargando imagen de red para contacto: ${contact.profilePicUrl}, $exception');
            },
            backgroundColor: Colors.grey[200],
            child: isAsset ? null : (
                (CachedNetworkImageProvider(contact.profilePicUrl) as CachedNetworkImageProvider)
                    .obtainKey(const ImageConfiguration())
                    .then((resolvedKey) {})
                    .catchError((Object error, StackTrace stackTrace) {
                  developer.log('Fallback a icono por error en backgroundImage de contacto: ${contact.profilePicUrl}');
                  return const Icon(Icons.person_outline, size: 30, color: Colors.grey);
                }) == null ? const Icon(Icons.person_outline, size: 30, color: Colors.grey) : null
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              contact.name,
              style: const TextStyle(fontFamily: 'Comic Sans MS', fontSize: 16, fontWeight: FontWeight.bold),
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