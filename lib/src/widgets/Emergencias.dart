import 'package:flutter/material.dart';
import 'package:adobe_xd/pinned.dart';
import '../services/auth_service.dart';
import './Home.dart';
import 'package:adobe_xd/page_link.dart';
import './Ayuda.dart';
import './PerfilPublico.dart';
import './Configuracion.dart';
import './ListadeAnimales.dart';
import './CompradeProductos.dart';
import './CuidadosyRecomendaciones.dart';
import './Comunidad.dart';
import './Crearpublicaciones.dart';
import './GoogleMaps.dart';
import 'dart:ui' as ui;
import './PrimerosAuxilios.dart';
import './ServiciodeAmbulancia.dart';
import './AtencionenCasa.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'dart:developer' as developer;

// --- CONFIGURACIÓN DE API KEYS ---
// ¡¡¡ADVERTENCIA!!! NO SUBAS ESTA CLAVE A REPOSITORIOS PÚBLICOS NI LA DISTRIBUYAS.
// PARA PRODUCCIÓN, USA UN BACKEND (CLOUD FUNCTIONS) PARA MANEJAR ESTA CLAVE.
const String GEMINI_API_KEY_EMERGENCIES = 'AIzaSyAgv8dNt1etzPz8Lnl39e8Seb6N8B3nenc'; // TU API KEY DE GEMINI AQUÍ
// ---------------------------------


class Emergencias extends StatefulWidget {
  const Emergencias({
    Key? key,
  }) : super(key: key);

  @override
  _EmergenciasState createState() => _EmergenciasState();
}

class _EmergenciasState extends State<Emergencias> {
  final TextEditingController _searchController = TextEditingController();
  GenerativeModel? _geminiModel;
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    _initializeGemini();
    // _listAvailableModels(); // Descomenta para depurar modelos disponibles
  }

  // // Solo para depuración, puedes quitar esto después
  // Future<void> _listAvailableModels() async {
  //   if (GEMINI_API_KEY_EMERGENCIES.isNotEmpty && GEMINI_API_KEY_EMERGENCIES != 'TU_API_KEY_DE_GEMINI_AQUI') {
  //     try {
  //       developer.log("Intentando listar modelos...");
  //       final models = await GenerativeModel.listModels(apiKey: GEMINI_API_KEY_EMERGENCIES);
  //       if (models.isEmpty) {
  //         developer.log("No se encontraron modelos listados.");
  //       }
  //       for (final m in models) {
  //         if (m.supportedGenerationMethods.contains('generateContent')) {
  //              developer.log('Modelo disponible para generateContent: ${m.name} - ${m.displayName}');
  //         } else {
  //              developer.log('Modelo (no soporta generateContent): ${m.name} - ${m.displayName} - Soportado: ${m.supportedGenerationMethods}');
  //         }
  //       }
  //     } catch (e) {
  //       developer.log('Error listando modelos: $e');
  //     }
  //   } else {
  //     developer.log("API Key de Gemini no configurada para listar modelos.");
  //   }
  // }

  void _initializeGemini() {
    if (GEMINI_API_KEY_EMERGENCIES.isNotEmpty && GEMINI_API_KEY_EMERGENCIES != 'TU_API_KEY_DE_GEMINI_AQUI') {
      try {
        _geminiModel = GenerativeModel(
          model: 'gemini-1.5-flash-latest', // Modelo actualizado y recomendado
          apiKey: GEMINI_API_KEY_EMERGENCIES,
        );
        developer.log("Modelo Gemini inicializado en Emergencias con 'gemini-1.5-flash-latest'.");
      } catch (e) {
        developer.log("Error inicializando modelo Gemini en Emergencias: $e");
      }
    } else {
      developer.log("API Key de Gemini no configurada en Emergencias. La búsqueda con IA no funcionará.");
    }
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
          const SnackBar(content: Text('La búsqueda con IA no está disponible en este momento.')),
        );
      }
      developer.log("Intento de búsqueda pero el modelo Gemini no está inicializado o falló al inicializar.");
      return;
    }
    if (mounted) {
      setState(() { _isSearching = true; });
    }
    try {
      final prompt = 'Busca información de emergencia o primeros auxilios para mascotas sobre: "$query". Proporciona una respuesta clara, concisa y accionable. Si es una condición, describe síntomas y qué hacer. Si es un procedimiento, explica los pasos básicos.';
      final content = [Content.text(prompt)];
      final response = await _geminiModel!.generateContent(content).timeout(const Duration(seconds: 25));

      developer.log("Respuesta de Gemini para búsqueda de emergencia '$query': ${response.text}");

      if (mounted) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Información de Emergencia para: $query'),
              content: SingleChildScrollView(child: Text(response.text ?? 'No se encontró información.')),
              actions: <Widget>[
                TextButton(child: const Text('Cerrar'), onPressed: () => Navigator.of(context).pop()),
              ],
            );
          },
        );
      }
    } catch (e) {
      developer.log("Error al buscar emergencia con Gemini: $e");
      String errorMessageText = "Hubo un problema al realizar la búsqueda de emergencia.";
      if (e is GenerativeAIException) {
        if (e.message.contains('API key not valid')) {
          errorMessageText = "Error: La API Key de Gemini no es válida. Por favor, verifica la configuración.";
        } else if (e.message.contains('quota')) {
          errorMessageText = "Se ha alcanzado la cuota de la API de Gemini. Inténtalo más tarde.";
        } else if (e.message.contains('not found for API version v1') || e.message.contains('not supported for generateContent')) {
          errorMessageText = "Error: El modelo de IA no está disponible o no es compatible. Intenta con otro modelo o revisa la consola de Google Cloud.";
        }
      } else if (e.toString().contains('timeout')) {
        errorMessageText = "La búsqueda tardó demasiado en responder. Inténtalo de nuevo.";
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
    // Posición Y de la barra de navegación (noticias, cuidados, etc.)
    // Asumiendo que middle: 0.2712 es el centro de esa barra de 60px de alto.
    final double navBarCenterY = MediaQuery.of(context).size.height * 0.2712;
    final double navBarBottomY = navBarCenterY + 30; // 30 es la mitad de la altura de la barra de navegación
    final double topOffsetForEmergencyButtons = navBarBottomY + 20; // 20 unidades de espacio

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

          //Barra de busqueda (POSICIÓN CENTRADA)
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
                        hintText: 'Buscar emergencia...',
                        hintStyle: TextStyle(fontFamily: 'Comic Sans MS', fontSize: 18, color: Colors.grey),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.only(left: 4, right: 4, top: 12, bottom: 12), // Ajuste fino
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
          // Botón de noticias
          Pinned.fromPins(
            Pin(size: 54.3, start: 24.0),
            Pin(size: 60.0, middle: 0.2712), // Este es el 'middle' de la barra de navegación
            child: PageLink(
              links: [PageLinkInfo(pageBuilder: () => const Home(key: Key('Home')))],
              child: Container(decoration: const BoxDecoration(image: DecorationImage(image: AssetImage('assets/images/noticias.png'), fit: BoxFit.fill))),
            ),
          ),
          // Botón de cuidados y recomendaciones
          Align(
            alignment: const Alignment(-0.459, -0.458), // Estos Alignments son relativos al centro de la pantalla
            child: PageLink(
              links: [PageLinkInfo(pageBuilder: () => const CuidadosyRecomendaciones(key: Key('CuidadosyRecomendaciones')))],
              child: Container(width: 63.0, height: 60.0, decoration: const BoxDecoration(image: DecorationImage(image: AssetImage('assets/images/cuidadosrecomendaciones.png'), fit: BoxFit.fill))),
            ),
          ),
          // Botón de emergencias (resaltado)
          Align(
            alignment: const Alignment(0.0, -0.458),
            child: Container(
              width: 65.0, height: 60.0,
              decoration: BoxDecoration(
                image: const DecorationImage(image: AssetImage('assets/images/emergencias.png'), fit: BoxFit.fill),
                boxShadow: [BoxShadow(color: const Color(0xffa3f0fb), offset: const Offset(0, 3), blurRadius: 6)],
              ),
            ),
          ),
          // Botón de comunidad
          Align(
            alignment: const Alignment(0.477, -0.458),
            child: PageLink(
              links: [PageLinkInfo(pageBuilder: () => Comunidad(key: Key('Comunidad')))],
              child: Container(width: 67.0, height: 60.0, decoration: const BoxDecoration(image: DecorationImage(image: AssetImage('assets/images/comunidad.png'), fit: BoxFit.fill))),
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

          //BOTONES DE EMERGENCIAS
          Positioned(
            top: topOffsetForEmergencyButtons,
            left: 30.0,
            right: 30.0,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: double.infinity,
                  margin: const EdgeInsets.only(bottom: 20.0),
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  decoration: BoxDecoration(
                    color: const Color(0xe3a0f4fe),
                    borderRadius: BorderRadius.circular(10.0),
                    border: Border.all(width: 1.0, color: const Color(0xe3000000)),
                  ),
                  child: const Text(
                    'Servicios de Emergencias',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontFamily: 'Comic Sans MS', fontSize: 20, color: Color(0xff000000), fontWeight: FontWeight.w700),
                  ),
                ),
                GridView.count(
                  crossAxisCount: 2,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  mainAxisSpacing: 20.0,
                  crossAxisSpacing: 20.0,
                  childAspectRatio: 0.8, // Ajustado para dar más altura (ancho / alto)
                  // Un valor más cercano a 0.75 podría ser necesario si el texto es largo
                  children: <Widget>[
                    _buildEmergencyButton(
                      context: context,
                      imagePath: 'assets/images/maps.png',
                      label: 'Veterinarias cercanas',
                      targetPage: () => const GoogleMaps(key: Key('GoogleMaps')),
                    ),
                    _buildEmergencyButton(
                      context: context,
                      imagePath: 'assets/images/auxilios.png',
                      label: 'Primeros Auxilios',
                      targetPage: () => const PrimerosAuxilios(key: Key('PrimerosAuxilios')),
                    ),
                    _buildEmergencyButton(
                      context: context,
                      imagePath: 'assets/images/ambulancia.png',
                      label: 'Servicio de Ambulancia',
                      targetPage: () => const ServiciodeAmbulancia(key: Key('ServiciodeAmbulancia')),
                    ),
                    _buildEmergencyButton(
                      context: context,
                      imagePath: 'assets/images/atencioncasa.png',
                      label: 'Atención en Casa',
                      targetPage: () => const AtencionenCasa(key: Key('AtencionenCasa')),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmergencyButton({
    required BuildContext context,
    required String imagePath,
    required String label,
    required Widget Function() targetPage,
  }) {
    return PageLink(
      links: [
        PageLinkInfo(
          transition: LinkTransition.Fade,
          ease: Curves.easeOut,
          duration: 0.3,
          pageBuilder: targetPage,
        ),
      ],
      child: ClipRect(
        child: BackdropFilter(
          filter: ui.ImageFilter.blur(sigmaX: 2.0, sigmaY: 2.0),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0), // Padding interno ajustado
            decoration: BoxDecoration(
              color: const Color(0x5e4ec8dd),
              borderRadius: BorderRadius.circular(20.0),
              border: Border.all(width: 1.0, color: const Color(0xff707070)),
              boxShadow: const [BoxShadow(color: Color(0x29000000), offset: Offset(0, 3), blurRadius: 6)],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround, // Distribuye el espacio
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                // La imagen tomará el espacio disponible gracias a Flexible/Expanded
                // y se ajustará con BoxFit.contain
                Expanded( // Usar Expanded para que la imagen se escale
                  flex: 3, // Dar más proporción a la imagen
                  child: Padding(
                    padding: const EdgeInsets.all(4.0), // Pequeño padding alrededor de la imagen
                    child: Image.asset(
                      imagePath,
                      fit: BoxFit.contain, // Asegura que toda la imagen sea visible
                    ),
                  ),
                ),
                // const SizedBox(height: 4), // Espacio entre imagen y texto
                Expanded( // Usar Expanded para el texto también
                  flex: 2, // Menor proporción para el texto
                  child: Text(
                    label,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontFamily: 'Comic Sans MS',
                      fontSize: 13.5, // Ajustar según sea necesario
                      color: Color(0xff000000),
                      fontWeight: FontWeight.w700,
                    ),
                    maxLines: 2, // Permitir hasta 2 líneas
                    overflow: TextOverflow.ellipsis, // Añadir '...' si el texto es muy largo
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}