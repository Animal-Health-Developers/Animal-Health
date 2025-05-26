import 'dart:async';
import 'package:flutter/material.dart';
import 'package:adobe_xd/pinned.dart';
import './Home.dart';
import 'package:adobe_xd/page_link.dart';
import './Ayuda.dart';
import './PerfilPublico.dart';
import './Configuracion.dart';
import './ListadeAnimales.dart';
import './CompradeProductos.dart';
import './Emergencias.dart';
import './Comunidad.dart';
import './Crearpublicaciones.dart';
import '../services/auth_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:math';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'dart:developer' as developer;
import '../models/animal.dart'; // Importa tu modelo Animal si es necesario para leer especies

// --- CONFIGURACIÓN DE API KEYS ---
const String GEMINI_API_KEY_CARE = 'AIzaSyAgv8dNt1etzPz8Lnl39e8Seb6N8B3nenc';
const String THE_DOG_API_KEY = 'live_vkA9cQvaiI3cmRM7qiNqgvFPtyApnTvGQzTtVuEK6evCT1yTzFyUIXEW2l4JPCAU';
const String THE_CAT_API_KEY = 'live_cfM38FCZX4mhnH3NqCwMXMOLWMiSygx6x8NhH3q1Uaubz3eI6pOtc1l8Ls05XzHp';
const String UNSPLASH_ACCESS_KEY = 'bmwT3dUY0JzWsIV1DqP8rhKKbQhLPMD9xThDow4TzXg';
// ---------------------------------

class CuidadosyRecomendaciones extends StatefulWidget {
  const CuidadosyRecomendaciones({
    super.key,
  });

  @override
  _CuidadosyRecomendacionesState createState() => _CuidadosyRecomendacionesState();
}

class _CuidadosyRecomendacionesState extends State<CuidadosyRecomendaciones> {
  final TextEditingController _searchController = TextEditingController();
  GenerativeModel? _geminiModelSearch;
  bool _isSearchingWithGemini = false;

  @override
  void initState() {
    super.initState();
    _initializeGeminiForSearch();
    // El contenido ahora se carga en DailyAnimalCareContent
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
    setState(() => _isSearchingWithGemini = true);
    try {
      final prompt = 'Busca información o un consejo de cuidado relevante para mascotas sobre: "$query". Proporciona una respuesta concisa y útil.';
      final response = await _geminiModelSearch!.generateContent([Content.text(prompt)]).timeout(const Duration(seconds: 20));
      developer.log("Respuesta de Gemini para búsqueda '$query' en Cuidados: ${response.text}");
      if (mounted) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Resultado para: $query'),
              content: SingleChildScrollView(child: Text(response.text ?? 'No se encontró información.')),
              actions: <Widget>[
                TextButton(child: const Text('Cerrar'), onPressed: () => Navigator.of(context).pop()),
              ],
            );
          },
        );
      }
    } catch (e) {
      developer.log("Error al buscar con Gemini en Cuidados: $e");
      String errorMessageText = "Hubo un problema al realizar la búsqueda con IA.";
      if (e is GenerativeAIException && e.message.contains('API key not valid')) {
        errorMessageText = "Error: La API Key de Gemini no es válida.";
      } else if (e.toString().contains('timeout')) {
        errorMessageText = "La búsqueda tardó demasiado. Inténtalo de nuevo.";
      }
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(errorMessageText)));
      }
    } finally {
      if (mounted) setState(() => _isSearchingWithGemini = false);
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Widget _buildNavigationButtonItem({
    required String imagePath,
    bool isHighlighted = false,
    double? fixedWidth,
    double height = 60.0,
  }) {
    double itemWidth;
    if (fixedWidth != null) itemWidth = fixedWidth;
    else {
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
        image: DecorationImage(image: AssetImage(imagePath), fit: BoxFit.fill),
        boxShadow: isHighlighted ? const [BoxShadow(color: Color(0xff9ff0fa), offset: Offset(0, 3), blurRadius: 6)] : null,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final User? currentUser = FirebaseAuth.instance.currentUser; // Para la foto de perfil

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
            Pin(size: 74.0, middle: 0.5), Pin(size: 73.0, start: 42.0),
            child: PageLink(
              links: [PageLinkInfo(pageBuilder: () => Home(key: const Key('Home')))],
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
            Pin(size: 40.5, middle: 0.8328), Pin(size: 50.0, start: 49.0),
            child: PageLink(
              links: [PageLinkInfo(pageBuilder: () => Ayuda(key: const Key('Ayuda')))],
              child: Container(decoration: const BoxDecoration(image: DecorationImage(image: AssetImage('assets/images/help.png'), fit: BoxFit.fill))),
            ),
          ),
          Pinned.fromPins(
            Pin(size: 307.0, middle: 0.5), Pin(size: 45.0, start: 150),
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xffffffff),
                borderRadius: BorderRadius.circular(5.0),
                border: Border.all(width: 1.0, color: const Color(0xff707070)),
              ),
              child: Row(
                children: [
                  Padding(padding: const EdgeInsets.symmetric(horizontal: 8.0), child: Image.asset('assets/images/busqueda1.png', width: 24.0, height: 24.0)),
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      style: const TextStyle(fontFamily: 'Comic Sans MS', fontSize: 18, color: Color(0xff000000)),
                      decoration: const InputDecoration(hintText: 'Buscar consejos o temas...', hintStyle: TextStyle(fontFamily: 'Comic Sans MS', fontSize: 18, color: Colors.grey), border: InputBorder.none, contentPadding: EdgeInsets.symmetric(vertical: 12.0)),
                      textInputAction: TextInputAction.search,
                      onSubmitted: (value) { if (!_isSearchingWithGemini) _performSearchWithGemini(value); },
                    ),
                  ),
                  _isSearchingWithGemini
                      ? const Padding(padding: EdgeInsets.all(8.0), child: SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2.0)))
                      : IconButton(icon: const Icon(Icons.search, color: Colors.black54), onPressed: () { if (!_isSearchingWithGemini) _performSearchWithGemini(_searchController.text); }),
                ],
              ),
            ),
          ),
          if (currentUser != null) // Solo mostrar si el usuario está logueado
            Pinned.fromPins(
              Pin(size: 60.0, start: 6.0), Pin(size: 60.0, middle: 0.1947), // Ajustado
              child: StreamBuilder<DocumentSnapshot>(
                stream: FirebaseFirestore.instance.collection('users').doc(currentUser.uid).snapshots(),
                builder: (context, snapshot) {
                  final profilePhotoUrl = snapshot.data?['profilePhotoUrl'] as String?;
                  return PageLink(
                    links: [PageLinkInfo(pageBuilder: () => PerfilPublico(key: const Key('PerfilPublico')))],
                    child: Container(
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(10.0), color: Colors.grey[200], border: Border.all(color: Colors.white, width: 1.5)),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8.5),
                        child: profilePhotoUrl != null && profilePhotoUrl.isNotEmpty
                            ? CachedNetworkImage(
                          imageUrl: profilePhotoUrl, fit: BoxFit.cover,
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
            Pin(size: 47.2, end: 7.6), Pin(size: 50.0, start: 49.0),
            child: PageLink(
              links: [PageLinkInfo(pageBuilder: () => Configuraciones(key: const Key('Settings'), authService: AuthService()))],
              child: Container(decoration: const BoxDecoration(image: DecorationImage(image: AssetImage('assets/images/settingsbutton.png'), fit: BoxFit.fill))),
            ),
          ),
          Pinned.fromPins(
            Pin(size: 60.1, start: 6.0), Pin(size: 60.0, start: 44.0),
            child: PageLink(
              links: [PageLinkInfo(pageBuilder: () => ListadeAnimales(key: const Key('ListadeAnimales')))],
              child: Container(decoration: const BoxDecoration(image: DecorationImage(image: AssetImage('assets/images/listaanimales.png'), fit: BoxFit.fill))),
            ),
          ),
          Pinned.fromPins(
            Pin(size: 58.5, end: 2.0), Pin(size: 60.0, start: 105.0),
            child: PageLink(
              links: [PageLinkInfo(pageBuilder: () => CompradeProductos(key: const Key('CompradeProductos')))],
              child: Container(decoration: const BoxDecoration(image: DecorationImage(image: AssetImage('assets/images/store.png'), fit: BoxFit.fill))),
            ),
          ),
          Positioned(
            top: 200.0, left: 16.0, right: 16.0, height: 60.0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                PageLink(links: [PageLinkInfo(pageBuilder: () => Home(key: const Key('Home')))], child: _buildNavigationButtonItem(imagePath: 'assets/images/noticias.png', fixedWidth: 54.3)),
                _buildNavigationButtonItem(imagePath: 'assets/images/cuidadosrecomendaciones.png', isHighlighted: true, fixedWidth: 63.0),
                PageLink(links: [PageLinkInfo(pageBuilder: () => Emergencias(key: const Key('Emergencias')))], child: _buildNavigationButtonItem(imagePath: 'assets/images/emergencias.png', fixedWidth: 65.0)),
                PageLink(links: [PageLinkInfo(pageBuilder: () => Comunidad(key: const Key('Comunidad')))], child: _buildNavigationButtonItem(imagePath: 'assets/images/comunidad.png', fixedWidth: 67.0)),
                PageLink(links: [PageLinkInfo(pageBuilder: () => Crearpublicaciones(key: const Key('Crearpublicaciones')))], child: _buildNavigationButtonItem(imagePath: 'assets/images/crearpublicacion.png', fixedWidth: 53.6)),
              ],
            ),
          ),
          Pinned.fromPins(
            Pin(start: 16.0, end: 16.0), Pin(start: 270.0, end: 16.0),
            child: DailyAnimalCareContent(), // Widget que ahora contiene la lógica de los tips
          ),
        ],
      ),
    );
  }
}

// --- DailyAnimalCareContent Widget ---
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
  GenerativeModel? _geminiModelTips;

  final String _fallbackImageUrl = 'https://images.unsplash.com/photo-1543466835-00a7907e9de1?w=500&q=60';

  // Lista de tipos de animales genéricos para mostrar si el usuario no los tiene
  final List<String> _tiposAnimalesGenericos = ['ave', 'roedor', 'reptil', 'pollo', 'cerdo', 'vaca', 'conejo'];


  @override
  void initState() {
    super.initState();
    _initializeGeminiForTips();
    _loadDailyTips();
  }

  void _initializeGeminiForTips() {
    if (GEMINI_API_KEY_CARE.isNotEmpty && GEMINI_API_KEY_CARE != 'TU_API_KEY_DE_GEMINI_AQUI') {
      _geminiModelTips = GenerativeModel(model: 'gemini-pro', apiKey: GEMINI_API_KEY_CARE);
      developer.log("Modelo Gemini para consejos inicializado en DailyAnimalCareContent.");
    } else {
      developer.log("API Key de Gemini no configurada en DailyAnimalCareContent. Los consejos de IA no se generarán.");
    }
  }

  Future<Set<String>> _getTiposAnimalesUsuario() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return {};
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('animals') // Nombre correcto de la subcolección
          .get();
      if (snapshot.docs.isEmpty) return {};
      // Extraer la especie y convertir a minúsculas para comparación
      return snapshot.docs.map((doc) {
        var data = doc.data();
        return (data['especie'] as String? ?? '').toLowerCase();
      }).toSet();
    } catch (e) {
      developer.log("Error al obtener tipos de animales del usuario: $e");
      return {};
    }
  }


  Future<String> _fetchImageFromUnsplash(String query) async {
    // Lógica de _fetchImageFromUnsplash (sin cambios, ya la tienes)
    if (UNSPLASH_ACCESS_KEY.isEmpty || UNSPLASH_ACCESS_KEY == 'TU_UNSPLASH_ACCESS_KEY') {
      developer.log("Unsplash API Key no configurada. Usando imagen de fallback para '$query'.");
      final Map<String, List<String>> sampleImageUrls = {
        'perro': ['https://images.unsplash.com/photo-1583512603805-3cc6b41f3edb?w=500'],
        'gato': ['https://images.unsplash.com/photo-1514888286974-6c03e2ca1dba?w=500'],
        'ave': ['https://images.unsplash.com/photo-1552728089-57bdde30beb3?w=500'],
        'roedor': ['https://images.unsplash.com/photo-1593628026050-39998109554e?w=500'],
        'reptil': ['https://images.unsplash.com/photo-1509247999901-638878935f59?w=500'],
        'pollo': ['https://images.unsplash.com/photo-1588422206008-45690090a411?w=500'],
        'cerdo': ['https://images.unsplash.com/photo-1516457016043-6409a4aa5d9a?w=500'],
        'vaca': ['https://images.unsplash.com/photo-1552797599-96f0a10001a8?w=500'],
        'conejo': ['https://images.unsplash.com/photo-1590900547020-17101905f89a?w=500'],
        'loro': ['https://images.unsplash.com/photo-1552728089-57bdde30beb3?w=500'],
        'hámster': ['https://images.unsplash.com/photo-1593628026050-39998109554e?w=500'],
        'iguana': ['https://images.unsplash.com/photo-1509247999901-638878935f59?w=500'],
        'pregunta': ['https://images.unsplash.com/photo-1531011074460-b0d3930c0f7a?w=500'],
        'error': ['https://images.unsplash.com/photo-1578328819058-b69f3a3b0f6b?w=500'],
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
      } else { developer.log('Error Unsplash API ($query): ${response.statusCode} - ${response.body}');}
    } catch (e) { developer.log('Excepción Unsplash API ($query): $e');}
    return _fallbackImageUrl;
  }

  Future<String> _generateTipWithGemini(String animalType, {String? breed}) async {
    // Lógica de _generateTipWithGemini (modificada para incluir raza opcional)
    if (_geminiModelTips == null) return "Consejo IA no disponible.";
    try {
      String prompt;
      if (breed != null && breed.isNotEmpty) {
        prompt = 'Escribe un consejo de cuidado breve y útil para un $animalType de raza "$breed". El consejo debe ser práctico y fácil de entender. No más de 2 frases.';
      } else {
        prompt = 'Escribe un consejo de cuidado breve y útil para un $animalType. El consejo debe ser práctico y fácil de entender. No más de 2 frases.';
      }
      final response = await _geminiModelTips!.generateContent([Content.text(prompt)]).timeout(const Duration(seconds: 15));
      developer.log("Respuesta de Gemini para $animalType (raza: $breed): ${response.text}");
      return response.text ?? "No se pudo generar un consejo de la IA.";
    } catch (e) {
      developer.log("Error al generar consejo con Gemini para $animalType (raza: $breed): $e");
      if (e is GenerativeAIException && e.message.contains('API key not valid')) return "Error: API Key de Gemini no válida.";
      return "Problema al contactar IA para consejo.";
    }
  }

  Future<void> _loadDailyTips() async {
    setState(() { isLoading = true; errorMessage = ''; });
    final todayString = DateFormat('yyyy-MM-dd').format(DateTime.now());

    try {
      final snapshot = await FirebaseFirestore.instance.collection('daily_animal_tips').doc(todayString).get();
      if (snapshot.exists && snapshot.data()?['tips'] != null) {
        final data = snapshot.data() as Map<String, dynamic>;
        // Antes de cargar desde caché, verificamos si los animales del usuario han cambiado
        final Set<String> tiposUsuarioActuales = await _getTiposAnimalesUsuario();
        final List<dynamic> tipsCacheados = data['tips'] as List;
        bool cacheValido = true;

        if (tiposUsuarioActuales.isNotEmpty) {
          for (String tipo in tiposUsuarioActuales) {
            if (!tipsCacheados.any((tip) => (tip['title'] as String? ?? '').toLowerCase().contains(tipo))) {
              cacheValido = false;
              developer.log("Cache invalidado: El usuario tiene un '$tipo' y no hay consejo en caché.");
              break;
            }
          }
        }
        // También verificamos si faltan genéricos si el usuario no tiene muchos animales
        if (cacheValido && tiposUsuarioActuales.length < 2) {
          for (String tipoGenerico in _tiposAnimalesGenericos) {
            if (!tiposUsuarioActuales.contains(tipoGenerico) && !tipsCacheados.any((tip) => (tip['title'] as String? ?? '').toLowerCase().contains(tipoGenerico))) {
              // Podríamos invalidar si queremos asegurar siempre variedad de genéricos
              // Por ahora, si hay tips personalizados y algunos genéricos, es suficiente
            }
          }
        }


        if (cacheValido) {
          setState(() {
            tips = tipsCacheados.map((tip) => AnimalCareTip.fromJson(tip as Map<String, dynamic>)).toList();
            isLoading = false;
          });
          developer.log("Consejos cargados desde Firestore para $todayString (cache validado)");
          return;
        } else {
          developer.log("Cache de Firestore para $todayString invalidado o incompleto debido a cambios en animales del usuario. Obteniendo de APIs...");
        }
      } else {
        developer.log("No hay datos en Firestore para $todayString. Obteniendo de APIs...");
      }
      await _fetchAndCachePersonalizedTips(todayString);
    } catch (e, stacktrace) {
      developer.log("Error en _loadDailyTips: $e\n$stacktrace");
      if (mounted) {
        setState(() { isLoading = false; errorMessage = 'Error al cargar los consejos.'; });
      }
    }
  }


  Future<void> _fetchAndCachePersonalizedTips(String todayString) async {
    final List<AnimalCareTip> fetchedTips = [];
    final Set<String> tiposAnimalesDelUsuario = await _getTiposAnimalesUsuario();
    final Set<String> tiposYaAgregados = {}; // Para no repetir tipos si hay varias mascotas de la misma especie

    developer.log("Tipos de animales del usuario: $tiposAnimalesDelUsuario");

    // 1. Consejos para los animales del usuario
    for (String tipoAnimal in tiposAnimalesDelUsuario) {
      if (tipoAnimal.isEmpty || tiposYaAgregados.contains(tipoAnimal)) continue;

      String consejo;
      String imageUrl;
      String fuente = 'IA Gemini / Unsplash';
      String titulo = 'Consejo para tu ${tipoAnimal.capitalize()}:';

      if (tipoAnimal == 'perro' && THE_DOG_API_KEY.isNotEmpty && THE_DOG_API_KEY != 'TU_API_KEY_DE_THE_DOG_API') {
        try {
          final dogApiResponse = await http.get(Uri.parse('https://api.thedogapi.com/v1/images/search?has_breeds=true&limit=1&breed_ids='), headers: {'x-api-key': THE_DOG_API_KEY}).timeout(const Duration(seconds: 10));
          if (dogApiResponse.statusCode == 200) {
            final List<dynamic> dogData = json.decode(dogApiResponse.body);
            if (dogData.isNotEmpty && dogData[0]['breeds'] != null && (dogData[0]['breeds'] as List).isNotEmpty) {
              final breedInfo = dogData[0]['breeds'][0];
              titulo = 'Para tu Perro (${breedInfo['name'] ?? tipoAnimal.capitalize()}):';
              consejo = 'Temperamento: ${breedInfo['temperament'] ?? 'N/A'}.\nCuidados principales: ${breedInfo['bred_for'] ?? await _generateTipWithGemini('perro', breed: breedInfo['name'])}';
              imageUrl = dogData[0]['url'] ?? await _fetchImageFromUnsplash(breedInfo['name'] ?? 'perro');
              fuente = 'The Dog API / Unsplash';
            } else {
              consejo = await _generateTipWithGemini('perro');
              imageUrl = await _fetchImageFromUnsplash('perro');
            }
          } else {
            developer.log('Error The Dog API: ${dogApiResponse.statusCode}');
            consejo = await _generateTipWithGemini('perro');
            imageUrl = await _fetchImageFromUnsplash('perro');
          }
        } catch (e) {
          developer.log('Excepción The Dog API: $e');
          consejo = await _generateTipWithGemini('perro');
          imageUrl = await _fetchImageFromUnsplash('perro');
        }
      } else if (tipoAnimal == 'gato' && THE_CAT_API_KEY.isNotEmpty && THE_CAT_API_KEY != 'TU_API_KEY_DE_THE_CAT_API') {
        try {
          final catApiResponse = await http.get(Uri.parse('https://api.thecatapi.com/v1/images/search?has_breeds=true&limit=1'), headers: {'x-api-key': THE_CAT_API_KEY}).timeout(const Duration(seconds: 10));
          if (catApiResponse.statusCode == 200) {
            final List<dynamic> catData = json.decode(catApiResponse.body);
            if (catData.isNotEmpty && catData[0]['breeds'] != null && (catData[0]['breeds'] as List).isNotEmpty) {
              final breedInfo = catData[0]['breeds'][0];
              titulo = 'Para tu Gato (${breedInfo['name'] ?? tipoAnimal.capitalize()}):';
              consejo = 'Temperamento: ${breedInfo['temperament'] ?? 'N/A'}.\nConsejo: ${await _generateTipWithGemini('gato', breed: breedInfo['name'])}';
              imageUrl = catData[0]['url'] ?? await _fetchImageFromUnsplash(breedInfo['name'] ?? 'gato');
              fuente = 'The Cat API / Unsplash';
            } else {
              consejo = await _generateTipWithGemini('gato');
              imageUrl = await _fetchImageFromUnsplash('gato');
            }
          } else {
            developer.log('Error The Cat API: ${catApiResponse.statusCode}');
            consejo = await _generateTipWithGemini('gato');
            imageUrl = await _fetchImageFromUnsplash('gato');
          }
        } catch (e) {
          developer.log('Excepción The Cat API: $e');
          consejo = await _generateTipWithGemini('gato');
          imageUrl = await _fetchImageFromUnsplash('gato');
        }
      } else { // Para otros tipos de animales del usuario, usar Gemini
        consejo = await _generateTipWithGemini(tipoAnimal);
        imageUrl = await _fetchImageFromUnsplash(tipoAnimal);
      }

      // Manejar error de API Key de Gemini
      if (consejo.contains("API Key de Gemini no válida")) {
        imageUrl = await _fetchImageFromUnsplash('error');
        fetchedTips.add(AnimalCareTip(
          title: 'Error de Configuración IA',
          description: consejo, // El mensaje de error de Gemini
          imageUrl: imageUrl,
          source: 'Sistema Gemini',
          date: todayString,
        ));
      } else {
        fetchedTips.add(AnimalCareTip(
          title: titulo,
          description: consejo,
          imageUrl: imageUrl,
          source: fuente,
          date: todayString,
        ));
      }
      tiposYaAgregados.add(tipoAnimal);
    }

    // 2. Consejos para animales genéricos que el usuario NO tiene
    for (String tipoGenerico in _tiposAnimalesGenericos) {
      if (!tiposAnimalesDelUsuario.contains(tipoGenerico) && !tiposYaAgregados.contains(tipoGenerico)) {
        String consejo = '';
        String titulo = '';
        String fuente = 'Expertos / Unsplash'; // Fuente genérica
        switch (tipoGenerico) {
          case 'ave':
            titulo = 'Cuidado General de Aves';
            consejo = 'Las aves necesitan jaulas espaciosas, juguetes para estimular su mente y una dieta variada. La interacción social es crucial para su bienestar.';
            break;
          case 'roedor':
            titulo = 'Cuidado General de Roedores';
            consejo = 'Roedores como hámsters o cobayas requieren jaulas seguras, sustrato adecuado, y ejercicio. Investiga la dieta específica para cada tipo de roedor.';
            break;
          case 'reptil':
            titulo = 'Cuidado General de Reptiles';
            consejo = 'Los reptiles necesitan terrarios con control de temperatura, humedad e iluminación UVB específica. Su dieta es muy variada; infórmate bien.';
            break;
          case 'pollo':
            titulo = 'Cuidado General de Pollos/Gallinas';
            consejo = 'Las gallinas necesitan un gallinero seguro, espacio para picotear, agua fresca y alimento balanceado. Son animales sociales y curiosos.';
            break;
          case 'cerdo':
            titulo = 'Cuidado General de Cerdos (Domésticos)';
            consejo = 'Los cerdos (especialmente mini pigs) son inteligentes y requieren estimulación mental, espacio para hozar, y una dieta controlada para evitar la obesidad.';
            break;
          case 'vaca':
            titulo = 'Cuidado General de Vacas (Pequeñas Razas/Mascotas)';
            consejo = 'Algunas razas pequeñas de vacas pueden ser mascotas y necesitan pasto, agua fresca, refugio y cuidados veterinarios regulares. Son animales de rebaño.';
            break;
          case 'conejo':
            titulo = 'Cuidado General de Conejos';
            consejo = 'Los conejos necesitan heno ilimitado, verduras frescas y una pequeña cantidad de pienso de calidad. Requieren espacio para moverse y roer.';
            break;
        }
        if (consejo.isNotEmpty) {
          fetchedTips.add(AnimalCareTip(
            title: titulo,
            description: consejo,
            imageUrl: await _fetchImageFromUnsplash(tipoGenerico),
            source: fuente,
            date: todayString,
          ));
          tiposYaAgregados.add(tipoGenerico);
        }
      }
    }
    // 3. Dato Curioso General (si aún hay espacio o para variar)
    if (fetchedTips.length < 6) { // Limitar el número total de tips para no abrumar
      try {
        final factResponse = await http.get(Uri.parse('https://uselessfacts.jsph.pl/api/v2/facts/random?language=es')).timeout(const Duration(seconds: 10));
        if (factResponse.statusCode == 200) {
          final factData = json.decode(factResponse.body);
          fetchedTips.add(AnimalCareTip(
            title: '¿Sabías que...?',
            description: factData['text'] ?? 'Los animales son seres increíbles llenos de sorpresas.',
            imageUrl: await _fetchImageFromUnsplash('pregunta'),
            source: 'Useless Facts API / Unsplash',
            date: todayString,
          ));
        }
      } catch (e) { developer.log('Excepción Useless Facts API: $e'); }
    }


    fetchedTips.shuffle(_random); // Mezclar para variedad diaria

    if (fetchedTips.isNotEmpty) {
      await FirebaseFirestore.instance.collection('daily_animal_tips').doc(todayString).set({
        'tips': fetchedTips.map((tip) => tip.toJson()).toList(),
        'date': todayString,
      });
      developer.log("Consejos personalizados y genéricos guardados en Firestore para $todayString");
    }

    if (mounted) {
      setState(() { tips = fetchedTips; isLoading = false; });
    }
  }


  @override
  Widget build(BuildContext context) {
    // (build method de _DailyAnimalCareContentState sin cambios, ya lo tienes)
    if (isLoading) {
      return const Center(child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(Color(0xff4ec8dd)),
      ));
    }

    if (errorMessage.isNotEmpty && tips.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                errorMessage,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.red, fontSize: 16, fontFamily: 'Comic Sans MS'),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _loadDailyTips,
                style: ElevatedButton.styleFrom(backgroundColor: const Color(0xff4ec8dd)),
                child: const Text('Reintentar', style: TextStyle(fontFamily: 'Comic Sans MS', color: Colors.white)),
              )
            ],
          ),
        ),
      );
    }

    if (tips.isEmpty) {
      return const Center(child: Text('No hay consejos disponibles hoy. ¡Vuelve mañana!', style: TextStyle(fontFamily: 'Comic Sans MS')));
    }

    return ListView.builder(
      padding: const EdgeInsets.only(top: 10),
      itemCount: tips.length,
      itemBuilder: (context, index) {
        final tip = tips[index];
        return _buildTipCard(tip);
      },
    );
  }

  Widget _buildTipCard(AnimalCareTip tip) {
    // (Widget _buildTipCard sin cambios, ya lo tienes)
    String displayDate;
    try {
      final DateTime parsedDate = DateFormat('yyyy-MM-dd').parse(tip.date);
      displayDate = DateFormat("d 'de' MMMM 'de' yyyy", 'es_ES').format(parsedDate);
    } catch (e) {
      displayDate = tip.date;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: const Color(0xe3a0f4fe),
        borderRadius: BorderRadius.circular(9.0),
        border: Border.all(width: 1.0, color: const Color(0xe3000000)),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), spreadRadius: 1, blurRadius: 3, offset: const Offset(0, 2))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(12.0, 12.0, 12.0, 8.0),
            child: Text(tip.title, style: const TextStyle(fontFamily: 'Comic Sans MS', fontSize: 20, color: Color(0xff000000), fontWeight: FontWeight.w700)),
          ),
          if (tip.imageUrl.isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: CachedNetworkImage(
                    imageUrl: tip.imageUrl, width: double.infinity, height: 200, fit: BoxFit.cover,
                    placeholder: (context, url) => Container(height: 200, color: Colors.grey[300], child: const Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Color(0xff4ec8dd))))),
                    errorWidget: (context, url, error) {
                      developer.log('Error cargando imagen para Tip: $url, Error: $error');
                      return Container(height: 200, color: Colors.grey[200], child: Center(child: Icon(Icons.broken_image, color: Colors.grey[400], size: 50)));
                    }
                ),
              ),
            ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Text(tip.description, style: const TextStyle(fontFamily: 'Comic Sans MS', fontSize: 16, color: Color(0xff333333))),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(12.0, 4.0, 12.0, 12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(child: Text('Fuente: ${tip.source}', style: const TextStyle(fontFamily: 'Comic Sans MS', fontSize: 13, color: Color(0xff555555)), overflow: TextOverflow.ellipsis)),
                const SizedBox(width: 8),
                Text(displayDate, style: const TextStyle(fontFamily: 'Comic Sans MS', fontSize: 13, color: Color(0xff555555))),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// --- AnimalCareTip Class ---
class AnimalCareTip {
  // (Clase AnimalCareTip sin cambios, ya la tienes)
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

// Extensión para capitalizar la primera letra de un String
extension StringExtension on String {
  String capitalize() {
    if (this.isEmpty) {
      return "";
    }
    return "${this[0].toUpperCase()}${this.substring(1).toLowerCase()}";
  }
}