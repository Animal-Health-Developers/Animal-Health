import 'package:flutter/material.dart';
import 'package:adobe_xd/pinned.dart';
import 'package:adobe_xd/page_link.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:google_generative_ai/google_generative_ai.dart'; // Importar Gemini
import 'dart:developer' as developer; // Para logging

import './Home.dart';
import './Ayuda.dart';
import './PerfilPublico.dart';
import './Configuracion.dart';
import './ListadeAnimales.dart';
import './CompradeProductos.dart';
import './CuidadosyRecomendaciones.dart';
import './Emergencias.dart';
import './Comunidad.dart';
import './Crearpublicaciones.dart';
import '../services/auth_service.dart';

// --- CONFIGURACIÓN DE API KEYS ---
// ASEGÚRATE DE TENER ESTA API KEY CONFIGURADA Y SEGURA (preferiblemente en backend)
const String GEMINI_API_KEY_SOLUCIONES = 'AIzaSyAgv8dNt1etzPz8Lnl39e8Seb6N8B3nenc'; // Reemplaza con tu API Key

class SolucionAEMERGENCIAS extends StatefulWidget {
  final String descripcionDelProblema; // Descripción del problema pasado desde la pantalla anterior
  final String? nombreAnimal; // Opcional: Nombre del animal
  final String? especieAnimal; // Opcional: Especie del animal

  const SolucionAEMERGENCIAS({
    Key? key,
    required this.descripcionDelProblema,
    this.nombreAnimal,
    this.especieAnimal,
  }) : super(key: key);

  @override
  _SolucionAEMERGENCIASState createState() => _SolucionAEMERGENCIASState();
}

class _SolucionAEMERGENCIASState extends State<SolucionAEMERGENCIAS> {
  String _solucionGenerada = "Generando solución de primeros auxilios...";
  bool _isLoadingSolucion = true;
  String _errorMessage = '';
  GenerativeModel? _geminiModel;

  @override
  void initState() {
    super.initState();
    _initializeAndGenerateSolution();
  }

  void _initializeAndGenerateSolution() {
    if (GEMINI_API_KEY_SOLUCIONES.isNotEmpty && GEMINI_API_KEY_SOLUCIONES != 'TU_API_KEY_DE_GEMINI_AQUI') {
      _geminiModel = GenerativeModel(
        model: 'gemini-pro', // Puedes probar 'gemini-1.5-flash' para respuestas más rápidas si está disponible
        apiKey: GEMINI_API_KEY_SOLUCIONES,
        // Opciones de seguridad para filtrar contenido dañino (ajusta según necesidad)
        safetySettings: [
          SafetySetting(HarmCategory.harassment, HarmBlockThreshold.medium),
          SafetySetting(HarmCategory.hateSpeech, HarmBlockThreshold.medium),
          SafetySetting(HarmCategory.sexuallyExplicit, HarmBlockThreshold.medium),
          SafetySetting(HarmCategory.dangerousContent, HarmBlockThreshold.medium),
        ],
      );
      developer.log("Modelo Gemini para soluciones inicializado.");
      _generarSolucionPrimerosAuxilios();
    } else {
      developer.log("API Key de Gemini no configurada para SolucionAEMERGENCIAS.");
      if (mounted) {
        setState(() {
          _isLoadingSolucion = false;
          _errorMessage = "La función de IA no está disponible en este momento (Error de configuración).";
          _solucionGenerada = "No se pudo generar la solución debido a un error de configuración.";
        });
      }
    }
  }

  Future<void> _generarSolucionPrimerosAuxilios() async {
    if (_geminiModel == null) return;

    setState(() {
      _isLoadingSolucion = true;
      _errorMessage = '';
    });

    String animalInfo = "";
    if (widget.nombreAnimal != null && widget.nombreAnimal!.isNotEmpty) {
      animalInfo += " para mi mascota ${widget.nombreAnimal!}";
    }
    if (widget.especieAnimal != null && widget.especieAnimal!.isNotEmpty) {
      animalInfo += (animalInfo.isEmpty ? " para mi " : ", un/una ") + "${widget.especieAnimal!}";
    }


    // Prompt cuidadosamente elaborado
    final prompt = """
    Eres un asistente virtual de primeros auxilios para mascotas.
    Un dueño de mascota necesita ayuda urgente. Su mascota${animalInfo.isNotEmpty ? animalInfo : ''} presenta el siguiente problema:
    "${widget.descripcionDelProblema}"

    Por favor, proporciona una guía de primeros auxilios paso a paso, clara y concisa.
    Prioriza la seguridad del animal y del dueño.
    Incluye los siguientes puntos importantes:
    1.  Pasos inmediatos que el dueño puede tomar ANTES de llegar al veterinario.
    2.  Qué NO hacer en esta situación.
    3.  Señales de advertencia que indican que se debe buscar atención veterinaria INMEDIATAMENTE.
    4.  Un recordatorio ENFÁTICO de que estos consejos son solo para primeros auxilios y NO REEMPLAZAN la consulta con un veterinario profesional, y que debe llevar a su mascota al veterinario lo antes posible.

    Formatea la respuesta de manera legible, usando viñetas o numeración para los pasos.
    Evita dar diagnósticos definitivos, enfócate en la acción de primeros auxilios.
    No recomiendes medicamentos específicos a menos que sea algo extremadamente común y seguro como agua oxigenada para inducir el vómito BAJO CIERTAS CONDICIONES MUY ESPECÍFICAS (y siempre con la advertencia de consultar al veterinario primero si es posible).
    Si la situación es claramente una emergencia vital que requiere atención veterinaria inmediata sin pasos previos (ej. hemorragia masiva incontrolable), indícalo directamente.
    """;

    try {
      final content = [Content.text(prompt)];
      final response = await _geminiModel!.generateContent(content).timeout(const Duration(seconds: 45)); // Aumentar timeout

      developer.log("Respuesta de Gemini para solución de emergencia: ${response.text}");

      if (mounted) {
        setState(() {
          _solucionGenerada = response.text ?? "No se pudo generar una solución. Por favor, consulta a un veterinario inmediatamente.";
          _isLoadingSolucion = false;
        });
      }
    } catch (e) {
      developer.log("Error al generar solución con Gemini: $e");
      String errorMessageText = "Hubo un problema al generar la guía de primeros auxilios.";
      if (e is GenerativeAIException) {
        if (e.message.contains('API key not valid')) {
          errorMessageText = "Error: La API Key de Gemini no es válida. Verifica la configuración.";
        } else if (e.message.contains('candidate.safetyRatings')) {
          errorMessageText = "La IA no pudo generar una respuesta debido a filtros de seguridad. Intenta reformular la descripción del problema.";
        }
      } else if (e.toString().contains('timeout')) {
        errorMessageText = "La IA tardó demasiado en responder. Inténtalo de nuevo o consulta a un veterinario directamente.";
      }
      if (mounted) {
        setState(() {
          _solucionGenerada = "No se pudo generar la guía. $errorMessageText\n\nPOR FAVOR, CONTACTA A TU VETERINARIO DE INMEDIATO.";
          _isLoadingSolucion = false;
          _errorMessage = errorMessageText;
        });
      }
    }
  }


  Widget _buildNavigationButtonItem({
    required String imagePath,
    bool isHighlighted = false,
    double? fixedWidth,
    double height = 60.0,
    required VoidCallback onPressed,
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
    return InkWell(
      onTap: onPressed,
      child: Container(
        width: itemWidth,
        height: height,
        decoration: BoxDecoration(
          image: DecorationImage(image: AssetImage(imagePath), fit: BoxFit.fill),
          boxShadow: isHighlighted ? const [BoxShadow(color: Color(0xffa3f0fb), offset: Offset(0, 3), blurRadius: 6)] : null,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const double navBarTopPosition = 200.0;
    const double navBarHeight = 60.0;
    const double spaceBelowNavBar = 20.0; // Espacio después de la barra de nav antes del contenido
    final double topOffsetForContent = navBarTopPosition + navBarHeight + spaceBelowNavBar;
    final User? currentUserAuth = FirebaseAuth.instance.currentUser;

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
          Pinned.fromPins( // Barra de búsqueda (decorativa aquí)
            Pin(size: 307.0, middle: 0.5), Pin(size: 45.0, start: 135.0),
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xffffffff),
                borderRadius: BorderRadius.circular(5.0),
                border: Border.all(width: 1.0, color: const Color(0xff707070)),
              ),
              child: Row(
                children: [
                  Padding(padding: const EdgeInsets.symmetric(horizontal: 8.0), child: Image.asset('assets/images/busqueda1.png', width: 24.0, height: 24.0)),
                  const Expanded(
                    child: TextField(
                      enabled: false, // Deshabilitada
                      style: TextStyle(fontFamily: 'Comic Sans MS', fontSize: 18, color: Color(0xff000000)),
                      decoration: InputDecoration(hintText: 'Soluciones de Emergencia', hintStyle: TextStyle(fontFamily: 'Comic Sans MS', fontSize: 18, color: Colors.grey), border: InputBorder.none, contentPadding: EdgeInsets.symmetric(vertical: 12.0)),
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (currentUserAuth != null)
            Pinned.fromPins(
              Pin(size: 60.0, start: 6.0), Pin(size: 60.0, start: 115.0),
              child: StreamBuilder<DocumentSnapshot>(
                stream: FirebaseFirestore.instance.collection('users').doc(currentUserAuth.uid).snapshots(),
                builder: (context, snapshot) {
                  String? profilePhotoUrl;
                  if (snapshot.hasData && snapshot.data!.exists) {
                    final userData = snapshot.data!.data() as Map<String, dynamic>;
                    profilePhotoUrl = userData['profilePhotoUrl'] as String?;
                  }
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
                          errorWidget: (context, url, error) => const Icon(Icons.person, size: 35, color: Colors.grey),
                        )
                            : const Icon(Icons.person, size: 35, color: Colors.grey),
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
              links: [PageLinkInfo(pageBuilder: () => const ListadeAnimales(key: Key('ListadeAnimales')))],
              child: Container(decoration: const BoxDecoration(image: DecorationImage(image: AssetImage('assets/images/listaanimales.png'), fit: BoxFit.fill))),
            ),
          ),
          Pinned.fromPins(
            Pin(size: 58.5, end: 2.0), Pin(size: 60.0, start: 105.0),
            child: PageLink(
              links: [PageLinkInfo(pageBuilder: () => const CompradeProductos(key: Key('CompradeProductos')))],
              child: Container(decoration: const BoxDecoration(image: DecorationImage(image: AssetImage('assets/images/store.png'), fit: BoxFit.fill))),
            ),
          ),
          Positioned(
            top: navBarTopPosition, left: 16.0, right: 16.0, height: navBarHeight,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                _buildNavigationButtonItem(imagePath: 'assets/images/noticias.png', fixedWidth: 54.3, onPressed: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Home(key: const Key('Home'))))),
                _buildNavigationButtonItem(imagePath: 'assets/images/cuidadosrecomendaciones.png', fixedWidth: 63.0, onPressed: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => CuidadosyRecomendaciones(key: const Key('CuidadosyRecomendaciones'))))),
                _buildNavigationButtonItem(imagePath: 'assets/images/emergencias.png', isHighlighted: true, fixedWidth: 65.0, onPressed: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const Emergencias(key: Key('Emergencias'))))),
                _buildNavigationButtonItem(imagePath: 'assets/images/comunidad.png', fixedWidth: 67.0, onPressed: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Comunidad(key: const Key('Comunidad'))))),
                _buildNavigationButtonItem(imagePath: 'assets/images/crearpublicacion.png', fixedWidth: 53.6, onPressed: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Crearpublicaciones(key: const Key('Crearpublicaciones'))))),
              ],
            ),
          ),
          // Contenido de Soluciones de Emergencia
          Positioned(
            top: topOffsetForContent, // Debajo de la barra de nav y otros elementos superiores
            left: 15.0,
            right: 15.0,
            bottom: 20.0, // Espacio en la parte inferior
            child: Container(
              padding: const EdgeInsets.all(15.0),
              decoration: BoxDecoration(
                color: const Color(0xcc54d1e0), // Fondo semi-transparente
                borderRadius: BorderRadius.circular(20.0),
                border: Border.all(width: 1.0, color: const Color(0x87000000)),
                boxShadow: const [BoxShadow(color: Color(0x40000000), offset: Offset(0, 3), blurRadius: 6)],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Container( // Título "Siga los siguientes pasos..."
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    margin: const EdgeInsets.only(bottom: 15),
                    decoration: BoxDecoration(
                      color: const Color(0xe3a0f4fe),
                      borderRadius: BorderRadius.circular(10.0),
                      border: Border.all(width: 1.0, color: const Color(0xe3000000)),
                    ),
                    child: const Text(
                      'Guía de Primeros Auxilios (IA)',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontFamily: 'Comic Sans MS', fontSize: 20, color: Color(0xff000000), fontWeight: FontWeight.w700),
                    ),
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(8.0),
                      child: _isLoadingSolucion
                          ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.white)),
                            SizedBox(height: 15),
                            Text("Consultando a la IA...", style: TextStyle(fontFamily: 'Comic Sans MS', fontSize: 16, color: Colors.white70)),
                          ],
                        ),
                      )
                          : Text(
                        _solucionGenerada,
                        style: TextStyle(fontFamily: 'Comic Sans MS', fontSize: 16, color: Colors.black87, height: 1.5),
                      ),
                    ),
                  ),
                  if (_errorMessage.isNotEmpty && !_isLoadingSolucion)
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: Text(
                        "Advertencia: $_errorMessage",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontFamily: 'Comic Sans MS', fontSize: 14, color: Colors.red.shade900, fontWeight: FontWeight.bold),
                      ),
                    ),
                  Padding( // Advertencia importante
                    padding: const EdgeInsets.only(top: 15.0, bottom: 5.0),
                    child: Text(
                      "IMPORTANTE: Esta guía es generada por IA y NO REEMPLAZA el consejo de un veterinario profesional. En caso de emergencia, contacta a tu veterinario de inmediato.",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontFamily: 'Comic Sans MS', fontSize: 13, color: Colors.black, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}