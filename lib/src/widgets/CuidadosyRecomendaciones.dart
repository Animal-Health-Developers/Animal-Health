import 'dart:async';

import 'package:flutter/material.dart';
import 'package:adobe_xd/pinned.dart';
import './Home.dart'; // Asegúrate que estas rutas sean correctas
import 'package:adobe_xd/page_link.dart';
import './Ayuda.dart';
import './PerfilPublico.dart';
import './Configuracion.dart';
import './ListadeAnimales.dart';
import './CompradeProductos.dart';
import './Emergencias.dart';
import './Comunidad.dart';
import './Crearpublicaciones.dart';
import '../services/auth_service.dart'; // Asegúrate que esta ruta sea correcta
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:math';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'dart:developer' as developer; // Para logging

// --- CONFIGURACIÓN DE API KEYS ---
// PARA PRODUCCIÓN, USA UN BACKEND (CLOUD FUNCTIONS) PARA MANEJAR ESTA CLAVE.
const String GEMINI_API_KEY_CARE = 'AIzaSyAgv8dNt1etzPz8Lnl39e8Seb6N8B3nenc'; // TU API KEY DE GEMINI AQUÍ (puede ser la misma que en Home)

const String THE_DOG_API_KEY = 'live_vkA9cQvaiI3cmRM7qiNqgvFPtyApnTvGQzTtVuEK6evCT1yTzFyUIXEW2l4JPCAU';
const String THE_CAT_API_KEY = 'live_cfM38FCZX4mhnH3NqCwMXMOLWMiSygx6x8NhH3q1Uaubz3eI6pOtc1l8Ls05XzHp';
const String UNSPLASH_ACCESS_KEY = 'bmwT3dUY0JzWsIV1DqP8rhKKbQhLPMD9xThDow4TzXg';
// ---------------------------------

class CuidadosyRecomendaciones extends StatefulWidget { // Convertido a StatefulWidget
  const CuidadosyRecomendaciones({
    super.key,
  });

  @override
  _CuidadosyRecomendacionesState createState() => _CuidadosyRecomendacionesState();
}

class _CuidadosyRecomendacionesState extends State<CuidadosyRecomendaciones> { // Estado
  final TextEditingController _searchController = TextEditingController();
  GenerativeModel? _geminiModelSearch; // Modelo de Gemini para la búsqueda
  bool _isSearchingWithGemini = false;

  @override
  void initState() {
    super.initState();
    _initializeGeminiForSearch();
  }

  void _initializeGeminiForSearch() {
    if (GEMINI_API_KEY_CARE.isNotEmpty && GEMINI_API_KEY_CARE != 'TU_API_KEY_DE_GEMINI_AQUI') {
      _geminiModelSearch = GenerativeModel(
        model: 'gemini-pro',
        apiKey: GEMINI_API_KEY_CARE,
      );
      developer.log("Modelo Gemini para búsqueda inicializado en CuidadosyRecomendaciones.");
    } else {
      developer.log("API Key de Gemini no configurada en CuidadosyRecomendaciones. La búsqueda con IA no funcionará.");
    }
  }

  Future<void> _performSearchWithGemini(String query) async {
    if (query.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, ingresa un término de búsqueda')),
      );
      return;
    }

    if (_geminiModelSearch == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('La búsqueda con IA no está disponible.')),
      );
      return;
    }

    setState(() {
      _isSearchingWithGemini = true;
    });

    try {
      final prompt = 'Busca información o un consejo de cuidado relevante para mascotas sobre: "$query". Proporciona una respuesta concisa y útil. Si es un animal, menciona algún dato curioso o consejo de cuidado principal. Si es un producto o servicio, describe brevemente su utilidad para mascotas.';
      final content = [Content.text(prompt)];
      final response = await _geminiModelSearch!.generateContent(content).timeout(const Duration(seconds: 20));

      developer.log("Respuesta de Gemini para búsqueda '$query' en Cuidados: ${response.text}");

      if (mounted) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Resultado para: $query'),
              content: SingleChildScrollView(child: Text(response.text ?? 'No se encontró información.')),
              actions: <Widget>[
                TextButton(
                  child: const Text('Cerrar'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      }
    } catch (e) {
      developer.log("Error al buscar con Gemini en Cuidados: $e");
      String errorMessageText = "Hubo un problema al realizar la búsqueda con IA.";
      if (e is GenerativeAIException && e.message.contains('API key not valid')) {
        errorMessageText = "Error: La API Key de Gemini no es válida. Por favor, verifica la configuración.";
      } else if (e.toString().contains('timeout')) {
        errorMessageText = "La búsqueda tardó demasiado en responder. Inténtalo de nuevo.";
      }
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(errorMessageText)),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSearchingWithGemini = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // Método para construir los items de la barra de navegación (copiado y adaptado de Home)
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
      // Fallback si no se provee ancho específico
      if (imagePath.contains('noticias')) itemWidth = 54.3;
      else if (imagePath.contains('cuidadosrecomendaciones')) itemWidth = 63.0;
      else if (imagePath.contains('emergencias')) itemWidth = 65.0;
      else if (imagePath.contains('comunidad')) itemWidth = 67.0;
      else if (imagePath.contains('crearpublicacion')) itemWidth = 53.6;
      else itemWidth = 60.0; // Default
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
            ? const [BoxShadow(color: Color(0xff9ff0fa), offset: Offset(0, 3), blurRadius: 6)] // Mismo color de Home para consistencia
            : null,
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff4ec8dd),
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

          // Barra de búsqueda (AHORA FUNCIONAL)
          Pinned.fromPins(
            Pin(size: 307.0, middle: 0.5), // Centrado
            Pin(size: 45.0, start: 150), // Posición vertical fija desde arriba (similar a Home)
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
                    child: Image.asset(
                      'assets/images/busqueda1.png',
                      width: 24.0,
                      height: 24.0,
                    ),
                  ),
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      style: const TextStyle(
                        fontFamily: 'Comic Sans MS',
                        fontSize: 18,
                        color: Color(0xff000000),
                      ),
                      decoration: const InputDecoration(
                        hintText: 'Buscar consejos o temas...',
                        hintStyle: TextStyle(
                          fontFamily: 'Comic Sans MS',
                          fontSize: 18,
                          color: Colors.grey,
                        ),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(vertical: 12.0),
                      ),
                      textInputAction: TextInputAction.search,
                      onSubmitted: (value) {
                        if (!_isSearchingWithGemini) {
                          _performSearchWithGemini(value);
                        }
                      },
                    ),
                  ),
                  if (_isSearchingWithGemini)
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2.0),
                      ),
                    )
                  else
                    IconButton(
                      icon: const Icon(Icons.search, color: Colors.black54),
                      onPressed: () {
                        if (!_isSearchingWithGemini) {
                          _performSearchWithGemini(_searchController.text);
                        }
                      },
                    ),
                ],
              ),
            ),
          ),


          // Foto de perfil del usuario
          Pinned.fromPins(
            Pin(size: 60.0, start: 6.0),
            Pin(size: 60.0, middle: 0.1947), // Manteniendo su posición original relativa
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
                      pageBuilder: () => PerfilPublico(key: const Key('PerfilPublico')),
                    ),
                  ],
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      color: Colors.grey[200],
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
              links: [
                PageLinkInfo(
                  transition: LinkTransition.Fade,
                  ease: Curves.easeOut,
                  duration: 0.3,
                  pageBuilder: () => Configuraciones(key: const Key('Settings'), authService: AuthService()),
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
            Pin(size: 60.1, start: 6.0),
            Pin(size: 60.0, start: 44.0),
            child: PageLink(
              links: [
                PageLinkInfo(
                  transition: LinkTransition.Fade,
                  ease: Curves.easeOut,
                  duration: 0.3,
                  pageBuilder: () => ListadeAnimales(key: const Key('ListadeAnimales')),
                ),
              ],
              child: Container(
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/listaanimales.png'),
                    fit: BoxFit.fill,
                  ),
                ),
              ),
            ),
          ),

          // Botón de tienda
          Pinned.fromPins(
            Pin(size: 58.5, end: 2.0),
            Pin(size: 60.0, start: 105.0),
            child: PageLink(
              links: [
                PageLinkInfo(
                  transition: LinkTransition.Fade,
                  ease: Curves.easeOut,
                  duration: 0.3,
                  pageBuilder: () => CompradeProductos(key: const Key('CompradeProductos')),
                ),
              ],
              child: Container(
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/store.png'),
                    fit: BoxFit.fill,
                  ),
                ),
              ),
            ),
          ),

          // --- NUEVA SECCIÓN DE BOTONES DE NAVEGACIÓN ---
          Positioned(
            top: 200.0, // Posición vertical fija desde la parte superior (igual que en Home)
            left: 16.0,  // Margen izquierdo para la fila
            right: 16.0, // Margen derecho para la fila
            height: 60.0, // Altura de los botones
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween, // Distribuye el espacio entre los botones
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                // Botón de noticias
                PageLink(
                  links: [
                    PageLinkInfo(
                      transition: LinkTransition.Fade,
                      ease: Curves.easeOut,
                      duration: 0.3,
                      pageBuilder: () => Home(key: const Key('Home')),
                    ),
                  ],
                  child: _buildNavigationButtonItem(
                    imagePath: 'assets/images/noticias.png',
                    fixedWidth: 54.3,
                  ),
                ),

                // Botón de cuidados y recomendaciones (resaltado, ya que estamos en esta pantalla)
                // No necesita PageLink a sí mismo
                _buildNavigationButtonItem(
                  imagePath: 'assets/images/cuidadosrecomendaciones.png',
                  isHighlighted: true, // Resaltado
                  fixedWidth: 63.0,
                ),

                // Botón de emergencias
                PageLink(
                  links: [
                    PageLinkInfo(
                      transition: LinkTransition.Fade,
                      ease: Curves.easeOut,
                      duration: 0.3,
                      pageBuilder: () => Emergencias(key: const Key('Emergencias')),
                    ),
                  ],
                  child: _buildNavigationButtonItem(
                    imagePath: 'assets/images/emergencias.png',
                    fixedWidth: 65.0,
                  ),
                ),

                // Botón de comunidad
                PageLink(
                  links: [
                    PageLinkInfo(
                      transition: LinkTransition.Fade,
                      ease: Curves.easeOut,
                      duration: 0.3,
                      pageBuilder: () => Comunidad(key: const Key('Comunidad')),
                    ),
                  ],
                  child: _buildNavigationButtonItem(
                    imagePath: 'assets/images/comunidad.png',
                    fixedWidth: 67.0,
                  ),
                ),

                // Botón de crear publicación
                PageLink(
                  links: [
                    PageLinkInfo(
                      transition: LinkTransition.Fade,
                      ease: Curves.easeOut,
                      duration: 0.3,
                      pageBuilder: () => Crearpublicaciones(key: const Key('Crearpublicaciones')),
                    ),
                  ],
                  child: _buildNavigationButtonItem(
                    imagePath: 'assets/images/crearpublicacion.png',
                    fixedWidth: 53.6,
                  ),
                ),
              ],
            ),
          ),
          // --- FIN DE NUEVA SECCIÓN DE BOTONES DE NAVEGACIÓN ---

          // Contenido dinámico de cuidados y recomendaciones
          Pinned.fromPins(
            Pin(start: 16.0, end: 16.0),
            Pin(start: 270.0, end: 16.0), // Ajustado start para estar debajo de los botones de navegación
            // 200 (top botones) + 60 (alto botones) + 10 (espacio) = 270
            child: DailyAnimalCareContent(), // El widget interno que maneja la lista de consejos
          ),
        ],
      ),
    );
  }
}

class DailyAnimalCareContent extends StatefulWidget {
  const DailyAnimalCareContent({super.key});

  @override
  _DailyAnimalCareContentState createState() => _DailyAnimalCareContentState();
}

class _DailyAnimalCareContentState extends State<DailyAnimalCareContent> {
  List<AnimalCareTip> tips = [];
  bool isLoading = true;
  String errorMessage = '';
  final Random _random = Random();
  GenerativeModel? _geminiModelTips; // Modelo de Gemini para generar consejos

  final String _fallbackImageUrl = 'https://images.unsplash.com/photo-1543466835-00a7907e9de1?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8Mnx8ZG9nfGVufDB8fDB8fHww&auto=format&fit=crop&w=500&q=60';

  @override
  void initState() {
    super.initState();
    _initializeGeminiForTips();
    _loadDailyTips();
  }

  void _initializeGeminiForTips() { // Renombrado para claridad
    if (GEMINI_API_KEY_CARE.isNotEmpty && GEMINI_API_KEY_CARE != 'TU_API_KEY_DE_GEMINI_AQUI') {
      _geminiModelTips = GenerativeModel(
        model: 'gemini-pro',
        apiKey: GEMINI_API_KEY_CARE,
      );
      developer.log("Modelo Gemini para consejos inicializado en DailyAnimalCareContent.");
    } else {
      developer.log("API Key de Gemini no configurada en DailyAnimalCareContent. Los consejos de IA no se generarán.");
    }
  }

  Future<String> _fetchImageFromUnsplash(String query) async {
    if (UNSPLASH_ACCESS_KEY.isEmpty || UNSPLASH_ACCESS_KEY == 'TU_UNSPLASH_ACCESS_KEY') {
      developer.log("Unsplash API Key no configurada. Usando imagen de fallback para '$query'.");
      final Map<String, List<String>> sampleImageUrls = {
        'ave': ['https://images.unsplash.com/photo-1552728089-57bdde30beb3?w=500'],
        'roedor': ['https://images.unsplash.com/photo-1593628026050-39998109554e?w=500'],
        'reptil': ['https://images.unsplash.com/photo-1509247999901-638878935f59?w=500'],
        'pollo': ['https://images.unsplash.com/photo-1588422206008-45690090a411?w=500'],
        'cerdo': ['https://images.unsplash.com/photo-1516457016043-6409a4aa5d9a?w=500'],
        'vaca': ['https://images.unsplash.com/photo-1552797599-96f0a10001a8?w=500'],
        'conejo': ['https://images.unsplash.com/photo-1590900547020-17101905f89a?w=500'],
        'pregunta': ['https://images.unsplash.com/photo-1531011074460-b0d3930c0f7a?w=500'],
        'error': ['https://images.unsplash.com/photo-1578328819058-b69f3a3b0f6b?w=500'], // Imagen para errores
        'loro': ['https://images.unsplash.com/photo-1552728089-57bdde30beb3?w=500'],
        'hámster': ['https://images.unsplash.com/photo-1593628026050-39998109554e?w=500'],
        'iguana': ['https://images.unsplash.com/photo-1509247999901-638878935f59?w=500'],
        'cerdo miniatura': ['https://images.unsplash.com/photo-1516457016043-6409a4aa5d9a?w=500'],
        'vaca pequeña': ['https://images.unsplash.com/photo-1552797599-96f0a10001a8?w=500'],
      };
      final lowerQuery = query.toLowerCase();
      if (sampleImageUrls.containsKey(lowerQuery) && sampleImageUrls[lowerQuery]!.isNotEmpty) {
        return sampleImageUrls[lowerQuery]![0];
      }
      return _fallbackImageUrl;
    }

    final encodedQuery = Uri.encodeComponent(query);
    final url = Uri.parse('https://api.unsplash.com/search/photos?query=$encodedQuery&per_page=1&orientation=landscape&client_id=$UNSPLASH_ACCESS_KEY');

    try {
      final response = await http.get(url).timeout(const Duration(seconds: 10));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['results'] != null && (data['results'] as List).isNotEmpty) {
          return data['results'][0]['urls']['regular'] as String? ?? _fallbackImageUrl;
        }
      } else {
        developer.log('Error Unsplash API ($query): ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      developer.log('Excepción al llamar a Unsplash API ($query): $e');
    }
    return _fallbackImageUrl;
  }

  Future <String> _generateTipWithGemini(String animalType) async {
    if (_geminiModelTips == null) {
      developer.log("Modelo Gemini no disponible para generar consejo.");
      return "Consejo no disponible en este momento.";
    }
    try {
      final prompt = 'Escribe un consejo de cuidado breve y útil para un $animalType. El consejo debe ser práctico y fácil de entender para un dueño de mascota. No más de 2 frases.';
      final content = [Content.text(prompt)];
      final response = await _geminiModelTips!.generateContent(content).timeout(const Duration(seconds: 15));
      developer.log("Respuesta de Gemini para $animalType: ${response.text}");
      return response.text ?? "No se pudo generar un consejo de la IA en este momento.";
    } catch (e) {
      developer.log("Error al generar consejo con Gemini para $animalType: $e");
      if (e is GenerativeAIException && e.message.contains('API key not valid')) {
        return "Error: La API Key de Gemini no es válida. Por favor, verifica la configuración.";
      }
      return "Hubo un problema al contactar con la IA para generar un consejo.";
    }
  }


  Future<void> _loadDailyTips() async {
    setState(() {
      isLoading = true;
      errorMessage = '';
    });

    try {
      final todayString = DateFormat('yyyy-MM-dd').format(DateTime.now());
      final snapshot = await FirebaseFirestore.instance
          .collection('daily_animal_tips')
          .doc(todayString)
          .get();

      if (snapshot.exists && snapshot.data()?['tips'] != null) {
        final data = snapshot.data() as Map<String, dynamic>;
        setState(() {
          tips = (data['tips'] as List)
              .map((tip) => AnimalCareTip.fromJson(tip as Map<String, dynamic>))
              .toList();
          isLoading = false;
        });
        developer.log("Consejos cargados desde Firestore para $todayString");
      } else {
        developer.log("No hay datos en Firestore para $todayString o están incompletos. Obteniendo de APIs...");
        await _fetchAndCacheTips(todayString);
      }
    } catch (e, stacktrace) {
      developer.log("Error en _loadDailyTips: $e\n$stacktrace");
      setState(() {
        isLoading = false;
        errorMessage = 'Error al cargar los consejos. Intenta nuevamente más tarde.';
      });
    }
  }

  Future<void> _fetchAndCacheTips(String todayString) async {
    try {
      final List<AnimalCareTip> fetchedTips = [];

      // --- Perros ---
      if (THE_DOG_API_KEY.isNotEmpty && THE_DOG_API_KEY != 'TU_API_KEY_DE_THE_DOG_API') {
        try {
          final dogApiResponse = await http.get(
            Uri.parse('https://api.thedogapi.com/v1/images/search?has_breeds=true&limit=1'),
            headers: {'x-api-key': THE_DOG_API_KEY},
          ).timeout(const Duration(seconds: 10));

          if (dogApiResponse.statusCode == 200) {
            final List<dynamic> dogData = json.decode(dogApiResponse.body);
            if (dogData.isNotEmpty && dogData[0]['breeds'] != null && (dogData[0]['breeds'] as List).isNotEmpty) {
              final breedInfo = dogData[0]['breeds'][0];
              fetchedTips.add(AnimalCareTip(
                title: 'Consejo Canino: ${breedInfo['name'] ?? 'Perro'}',
                description: 'Temperamento: ${breedInfo['temperament'] ?? 'N/A'}.\nVida: ${breedInfo['life_span'] ?? 'N/A'}.',
                imageUrl: dogData[0]['url'] ?? await _fetchImageFromUnsplash('perro'), // Fallback con Unsplash
                source: 'The Dog API',
                date: todayString,
              ));
            }
          } else { developer.log('Error The Dog API: ${dogApiResponse.statusCode}'); }
        } catch (e) { developer.log('Excepción The Dog API: $e'); }
      }

      // --- Gatos ---
      if (THE_CAT_API_KEY.isNotEmpty && THE_CAT_API_KEY != 'TU_API_KEY_DE_THE_CAT_API') {
        try {
          final catApiResponse = await http.get(
            Uri.parse('https://api.thecatapi.com/v1/images/search?has_breeds=true&limit=1'),
            headers: {'x-api-key': THE_CAT_API_KEY},
          ).timeout(const Duration(seconds: 10));
          if (catApiResponse.statusCode == 200) {
            final List<dynamic> catData = json.decode(catApiResponse.body);
            if (catData.isNotEmpty && catData[0]['breeds'] != null && (catData[0]['breeds'] as List).isNotEmpty) {
              final breedInfo = catData[0]['breeds'][0];
              fetchedTips.add(AnimalCareTip(
                title: 'Consejo Felino: ${breedInfo['name'] ?? 'Gato'}',
                description: 'Temperamento: ${breedInfo['temperament'] ?? 'N/A'}.\nOrigen: ${breedInfo['origin'] ?? 'N/A'}.',
                imageUrl: catData[0]['url'] ?? await _fetchImageFromUnsplash('gato'), // Fallback con Unsplash
                source: 'The Cat API',
                date: todayString,
              ));
            }
          } else { developer.log('Error The Cat API: ${catApiResponse.statusCode}'); }
        } catch (e) { developer.log('Excepción The Cat API: $e'); }
      }

      // --- Consejo de IA con Gemini (para un animal aleatorio) ---
      if (_geminiModelTips != null) {
        final List<String> animalTypesForGemini = ['perro', 'gato', 'pájaro', 'hámster', 'conejo', 'tortuga'];
        final randomAnimalForGemini = animalTypesForGemini[_random.nextInt(animalTypesForGemini.length)];
        String geminiTipText = await _generateTipWithGemini(randomAnimalForGemini);
        String geminiImageUrl = await _fetchImageFromUnsplash(randomAnimalForGemini);

        if (geminiTipText.contains("API Key de Gemini no es válida")) {
          geminiImageUrl = await _fetchImageFromUnsplash('error');
          fetchedTips.add(AnimalCareTip(
            title: 'Error de Configuración IA',
            description: geminiTipText,
            imageUrl: geminiImageUrl,
            source: 'Sistema Gemini',
            date: todayString,
          ));
        } else {
          fetchedTips.add(AnimalCareTip(
            title: 'Consejo IA para: ${randomAnimalForGemini.replaceFirst(randomAnimalForGemini[0], randomAnimalForGemini[0].toUpperCase())}',
            description: geminiTipText,
            imageUrl: geminiImageUrl,
            source: 'IA Gemini / Unsplash',
            date: todayString,
          ));
        }
      }


      // --- Aves (Texto estático, imagen de Unsplash) ---
      fetchedTips.add(AnimalCareTip(
        title: 'Cuidado de Aves: Loros y Periquitos',
        description: 'Las aves como loros y periquitos necesitan jaulas espaciosas, juguetes para estimular su inteligencia y una dieta variada que incluya frutas, verduras y semillas de calidad. La interacción social es crucial.',
        imageUrl: await _fetchImageFromUnsplash('loro'),
        source: 'Unsplash / Expertos en Aves',
        date: todayString,
      ));

      // --- Roedores (Texto estático, imagen de Unsplash) ---
      fetchedTips.add(AnimalCareTip(
        title: 'Cuidado de Roedores: Hámsters y Cobayas',
        description: 'Los roedores como hámsters y cobayas requieren jaulas seguras con sustrato adecuado, ruedas o espacio para ejercicio y escondites. Su dieta se basa en alimento comercial específico, complementado con heno (para cobayas) y pequeñas porciones de frutas y verduras frescas.',
        imageUrl: await _fetchImageFromUnsplash('hámster'),
        source: 'Unsplash / Amantes de Roedores',
        date: todayString,
      ));

      // --- Reptiles (Texto estático, imagen de Unsplash) ---
      fetchedTips.add(AnimalCareTip(
        title: 'Cuidado de Reptiles: Iguanas y Geckos',
        description: 'Reptiles como iguanas y geckos necesitan terrarios con control de temperatura y humedad, así como iluminación UVB adecuada para su especie. Su dieta varía (herbívoros, insectívoros). Investiga bien sus necesidades específicas.',
        imageUrl: await _fetchImageFromUnsplash('iguana'),
        source: 'Unsplash / Herpetólogos',
        date: todayString,
      ));

      // --- Animales de Granja Domésticos (Texto estático, imagen de Unsplash) ---
      final List<Map<String, String>> farmAnimalInfo = [
        {'name': 'Pollos/Gallinas', 'query': 'pollo', 'desc': 'Las gallinas necesitan un gallinero seguro, espacio para picotear, agua fresca y alimento balanceado. Son animales sociales.'},
        {'name': 'Cerdos (miniatura)', 'query': 'cerdo miniatura', 'desc': 'Los minicerdos son inteligentes y requieren estimulación mental, espacio para hozar y una dieta controlada. Necesitan socialización.'},
        {'name': 'Vacas (pequeñas razas)', 'query': 'vaca pequeña', 'desc': 'Algunas razas pequeñas de vacas pueden ser mascotas. Necesitan pasto, agua, refugio y cuidados veterinarios. Son animales de rebaño.'},
        {'name': 'Conejos', 'query': 'conejo', 'desc': 'Los conejos necesitan heno ilimitado, verduras frescas y pienso. Requieren jaulas espaciosas o áreas seguras para ejercicio y roer.'},
      ];
      final selectedFarmAnimalData = farmAnimalInfo[_random.nextInt(farmAnimalInfo.length)];
      fetchedTips.add(AnimalCareTip(
        title: 'Cuidado de Granja: ${selectedFarmAnimalData['name']}',
        description: selectedFarmAnimalData['desc']!,
        imageUrl: await _fetchImageFromUnsplash(selectedFarmAnimalData['query']!),
        source: 'Unsplash / Granja Amiga',
        date: todayString,
      ));


      // --- Dato Curioso General ---
      try {
        final factResponse = await http.get(Uri.parse('https://uselessfacts.jsph.pl/api/v2/facts/random?language=es'))
            .timeout(const Duration(seconds: 10));
        if (factResponse.statusCode == 200) {
          final factData = json.decode(factResponse.body);
          fetchedTips.add(AnimalCareTip(
            title: '¿Sabías que...?',
            description: factData['text'] ?? 'Un dato curioso sobre el mundo.',
            imageUrl: await _fetchImageFromUnsplash('pregunta'),
            source: 'Useless Facts API / Unsplash',
            date: todayString,
          ));
        } else { developer.log('Error Useless Facts API: ${factResponse.statusCode}'); }
      } catch (e) { developer.log('Excepción Useless Facts API: $e'); }


      fetchedTips.shuffle(_random);

      if (fetchedTips.isNotEmpty) {
        await FirebaseFirestore.instance
            .collection('daily_animal_tips')
            .doc(todayString)
            .set({
          'tips': fetchedTips.map((tip) => tip.toJson()).toList(),
          'date': todayString,
        });
        developer.log("Consejos (con IA y Unsplash) guardados en Firestore para $todayString");
      }

      if (mounted) { // Verificar si el widget sigue montado antes de llamar a setState
        setState(() {
          tips = fetchedTips;
          isLoading = false;
        });
      }

    } catch (e, stacktrace) {
      developer.log("Error en _fetchAndCacheTips: $e\n$stacktrace");
      if (mounted) { // Verificar si el widget sigue montado
        setState(() {
          isLoading = false;
          errorMessage = 'Error al obtener consejos actualizados.';
          if (tips.isEmpty) { // Solo añadir el consejo de error si no hay ninguno
            tips.add(AnimalCareTip(
              title: 'Error de Conexión',
              description: 'No pudimos cargar nuevos consejos. Por favor, revisa tu conexión e inténtalo más tarde.',
              imageUrl: _fallbackImageUrl,
              source: 'Sistema',
              date: todayString,
            ));
          }
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(Color(0xff4ec8dd)),
      ));
    }

    if (errorMessage.isNotEmpty && tips.isEmpty) { // Mostrar error solo si no hay tips y hay mensaje de error
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column( // Para poder añadir un botón de reintento si se desea
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                errorMessage,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.red, fontSize: 16, fontFamily: 'Comic Sans MS'),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _loadDailyTips, // Reintentar cargar
                style: ElevatedButton.styleFrom(backgroundColor: const Color(0xff4ec8dd)),
                child: const Text('Reintentar', style: TextStyle(fontFamily: 'Comic Sans MS', color: Colors.white)),
              )
            ],
          ),
        ),
      );
    }

    if (tips.isEmpty) { // Si después de todo no hay tips (y no es un error que se maneje arriba)
      return const Center(child: Text('No hay consejos disponibles hoy. ¡Vuelve mañana!', style: TextStyle(fontFamily: 'Comic Sans MS')));
    }

    return ListView.builder(
      padding: const EdgeInsets.only(top: 10), // Espacio superior para la lista
      itemCount: tips.length,
      itemBuilder: (context, index) {
        final tip = tips[index];
        return _buildTipCard(tip);
      },
    );
  }

  Widget _buildTipCard(AnimalCareTip tip) {
    String displayDate;
    try {
      final DateTime parsedDate = DateFormat('yyyy-MM-dd').parse(tip.date);
      // Asegúrate de tener inicializado el locale 'es_ES' en tu main.dart:
      // await initializeDateFormatting('es_ES', null);
      displayDate = DateFormat("d 'de' MMMM 'de' yyyy", 'es_ES').format(parsedDate);
    } catch (e) {
      developer.log('Error al formatear la fecha: ${tip.date} - $e. Asegúrate de inicializar el locale "es_ES".');
      displayDate = tip.date; // Fallback
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: const Color(0xe3a0f4fe),
        borderRadius: BorderRadius.circular(9.0),
        border: Border.all(width: 1.0, color: const Color(0xe3000000)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(12.0, 12.0, 12.0, 8.0),
            child: Text(
              tip.title,
              style: const TextStyle(
                fontFamily: 'Comic Sans MS',
                fontSize: 20,
                color: Color(0xff000000),
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          if (tip.imageUrl.isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: CachedNetworkImage(
                    imageUrl: tip.imageUrl,
                    width: double.infinity,
                    height: 200,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Container(
                      height: 200,
                      color: Colors.grey[300],
                      child: const Center(
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(Color(0xff4ec8dd)),
                        ),
                      ),
                    ),
                    errorWidget: (context, url, error) {
                      developer.log('Error cargando imagen para Tip: $url, Error: $error');
                      return Container(
                        height: 200,
                        color: Colors.grey[200],
                        child: Center(
                          child: Icon(Icons.broken_image, color: Colors.grey[400], size: 50),
                        ),
                      );
                    }
                ),
              ),
            ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Text(
              tip.description,
              style: const TextStyle(
                fontFamily: 'Comic Sans MS',
                fontSize: 16,
                color: Color(0xff333333),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(12.0, 4.0, 12.0, 12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    'Fuente: ${tip.source}',
                    style: const TextStyle(
                      fontFamily: 'Comic Sans MS',
                      fontSize: 13,
                      color: Color(0xff555555),
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  displayDate,
                  style: const TextStyle(
                    fontFamily: 'Comic Sans MS',
                    fontSize: 13,
                    color: Color(0xff555555),
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

class AnimalCareTip {
  final String title;
  final String description;
  final String imageUrl;
  final String source;
  final String date;

  AnimalCareTip({
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.source,
    required this.date,
  });

  factory AnimalCareTip.fromJson(Map<String, dynamic> json) {
    return AnimalCareTip(
      title: json['title'] as String? ?? 'Sin Título',
      description: json['description'] as String? ?? 'Sin Descripción',
      imageUrl: json['imageUrl'] as String? ?? '',
      source: json['source'] as String? ?? 'Desconocida',
      date: json['date'] as String? ?? DateFormat('yyyy-MM-dd').format(DateTime.now()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'imageUrl': imageUrl,
      'source': source,
      'date': date,
    };
  }
}