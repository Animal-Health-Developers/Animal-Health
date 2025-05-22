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
import './Emergencias.dart';
import './Comunidad.dart';
import './Crearpublicaciones.dart';
import './Atragantamiento.dart';
import './Fracturas.dart';
import './GolpedeCalor.dart';
import './Heridas.dart';
import './Intoxicacion.dart';
import './Picaduras.dart';
import './Alergias.dart';
import './ViasRespiratorias.dart';
// import 'package:flutter_svg/flutter_svg.dart'; // No se usa SvgPicture.string directamente
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cached_network_image/cached_network_image.dart';
// import 'package:google_generative_ai/google_generative_ai.dart'; // Si necesitas búsqueda con IA aquí
import 'dart:developer' as developer;

// Modelo para los problemas de primeros auxilios
class FirstAidProblem {
  final String name;
  final String iconAsset;
  final Widget targetPage;
  final String keyPrefix; // Para generar una Key única

  FirstAidProblem({
    required this.name,
    required this.iconAsset,
    required this.targetPage,
    required this.keyPrefix,
  });
}

class PrimerosAuxilios extends StatefulWidget { // Convertido a StatefulWidget
  const PrimerosAuxilios({
    required Key key,
  }) : super(key: key);

  @override
  _PrimerosAuxiliosState createState() => _PrimerosAuxiliosState();
}

class _PrimerosAuxiliosState extends State<PrimerosAuxilios> {
  // Lista de problemas de primeros auxilios
  final List<FirstAidProblem> _firstAidProblems = [
    FirstAidProblem(name: 'ALERGIAS', iconAsset: 'assets/images/alergias.png', targetPage: Alergias(key: Key('AlergiasPage')), keyPrefix: 'Alergias'),
    FirstAidProblem(name: 'ATRAGANTAMIENTO', iconAsset: 'assets/images/atragantamiento.png', targetPage: Atragantamiento(key: Key('AtragantamientoPage')), keyPrefix: 'Atragantamiento'),
    FirstAidProblem(name: 'FRACTURAS', iconAsset: 'assets/images/fracturas.png', targetPage: Fracturas(key: Key('FracturasPage')), keyPrefix: 'Fracturas'),
    FirstAidProblem(name: 'GOLPE DE CALOR', iconAsset: 'assets/images/golpecalor.png', targetPage: GolpedeCalor(key: Key('GolpedeCalorPage')), keyPrefix: 'GolpedeCalor'),
    FirstAidProblem(name: 'HERIDAS', iconAsset: 'assets/images/heridas.png', targetPage: Heridas(key: Key('HeridasPage')), keyPrefix: 'Heridas'),
    FirstAidProblem(name: 'INTOXICACIÓN', iconAsset: 'assets/images/intoxicacion.png', targetPage: Intoxicacion(key: Key('IntoxicacionPage')), keyPrefix: 'Intoxicacion'),
    FirstAidProblem(name: 'PICADURAS', iconAsset: 'assets/images/picadura.png', targetPage: Picaduras(key: Key('PicadurasPage')), keyPrefix: 'Picaduras'),
    FirstAidProblem(name: 'VIAS RESPIRATORIAS', iconAsset: 'assets/images/vias respiratorias.png', targetPage: ViasRespiratorias(key: Key('ViasRespiratoriasPage')), keyPrefix: 'ViasRespiratorias'),
    // Asegúrate de que los nombres de los assets coincidan con tus archivos
  ];

  // Para la barra de búsqueda (opcional)
  // final TextEditingController _searchController = TextEditingController();
  // bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    // _initializeGemini(); // Si vas a implementar búsqueda con IA
  }

  // void _initializeGemini() { ... }
  // Future<void> _performSearch(String query) { ... }

  @override
  void dispose() {
    // _searchController.dispose();
    super.dispose();
  }

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
            ? const [BoxShadow(color: Color(0xffa3f0fb), offset: Offset(0, 3), blurRadius: 6)]
            : null,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const double navBarTopPosition = 200.0;
    const double navBarHeight = 60.0;
    const double spaceBelowNavBar = 20.0; // Espacio entre la barra de nav y el contenido
    final double topOffsetForContent = navBarTopPosition + navBarHeight + spaceBelowNavBar;

    return Scaffold(
      backgroundColor: const Color(0xff4ec8dd),
      body: Stack(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: const AssetImage('assets/images/Animal Health Fondo de Pantalla.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Pinned.fromPins(
            Pin(size: 74.0, middle: 0.5),
            Pin(size: 73.0, start: 42.0),
            child: PageLink(
              links: [PageLinkInfo(pageBuilder: () => Home(key: Key('Home')))],
              child: Container(
                decoration: BoxDecoration(
                  image: DecorationImage(image: const AssetImage('assets/images/logo.png'), fit: BoxFit.cover),
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
              links: [PageLinkInfo(pageBuilder: () => Ayuda(key: Key('Ayuda')))],
              child: Container(
                decoration: BoxDecoration(image: DecorationImage(image: const AssetImage('assets/images/help.png'), fit: BoxFit.fill)),
              ),
            ),
          ),
          // Barra de búsqueda (opcional, puedes hacerla funcional)
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
                  const Expanded(
                    child: TextField(
                      // controller: _searchController,
                      style: TextStyle(fontFamily: 'Comic Sans MS', fontSize: 18, color: Color(0xff000000)),
                      decoration: InputDecoration(
                        hintText: 'Buscar en primeros auxilios...',
                        hintStyle: TextStyle(fontFamily: 'Comic Sans MS', fontSize: 18, color: Colors.grey),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(vertical: 12.0),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Foto de perfil
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
          // Botones de Configuración, Lista de Animales, Tienda
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
          // Barra de navegación principal
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
                  links: [PageLinkInfo(pageBuilder: () => Home(key: const Key('Home')))],
                  child: _buildNavigationButtonItem(imagePath: 'assets/images/noticias.png', fixedWidth: 54.3),
                ),
                PageLink(
                  links: [PageLinkInfo(pageBuilder: () => CuidadosyRecomendaciones(key: const Key('CuidadosyRecomendaciones')))],
                  child: _buildNavigationButtonItem(imagePath: 'assets/images/cuidadosrecomendaciones.png', fixedWidth: 63.0),
                ),
                PageLink(
                  links: [PageLinkInfo(pageBuilder: () => const Emergencias(key: Key('Emergencias')))],
                  child: _buildNavigationButtonItem(imagePath: 'assets/images/emergencias.png', isHighlighted: true, fixedWidth: 65.0),
                ),
                PageLink(
                  links: [PageLinkInfo(pageBuilder: () => Comunidad(key: const Key('Comunidad')))],
                  child: _buildNavigationButtonItem(imagePath: 'assets/images/comunidad.png', fixedWidth: 67.0),
                ),
                PageLink(
                  links: [PageLinkInfo(pageBuilder: () => Crearpublicaciones(key: const Key('Crearpublicaciones')))],
                  child: _buildNavigationButtonItem(imagePath: 'assets/images/crearpublicacion.png', fixedWidth: 53.6),
                ),
              ],
            ),
          ),
          // Contenido de Primeros Auxilios
          Positioned(
            top: topOffsetForContent,
            left: 30.0, // Márgenes laterales para el contenido
            right: 30.0,
            bottom: 20.0, // Espacio en la parte inferior
            child: Column(
              children: [
                // Título "PRIMEROS AUXILIOS"
                Container(
                  width: 200.0, // Ancho ajustado para el título
                  margin: const EdgeInsets.only(bottom: 20.0),
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  decoration: BoxDecoration(
                    color: const Color(0xe3a0f4fe),
                    borderRadius: BorderRadius.circular(10.0),
                    border: Border.all(width: 1.0, color: const Color(0xe3000000)),
                  ),
                  child: const Text(
                    'PRIMEROS AUXILIOS',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontFamily: 'Comic Sans MS', fontSize: 20, color: Color(0xff000000), fontWeight: FontWeight.w700),
                  ),
                ),
                // Lista de problemas
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color(0x99FFFFFF), // Fondo semi-transparente para la lista
                      borderRadius: BorderRadius.circular(15.0),
                      border: Border.all(color: Colors.grey.shade300, width: 0.5),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 5.0),
                    child: ListView.builder(
                      itemCount: _firstAidProblems.length,
                      itemBuilder: (context, index) {
                        final problem = _firstAidProblems[index];
                        return Card( // Usar Card para un mejor aspecto visual de cada item
                          elevation: 2.0,
                          margin: const EdgeInsets.symmetric(vertical: 6.0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.0),
                            side: BorderSide(color: const Color(0xff000000), width: 0.5),
                          ),
                          color: const Color(0xffffffff), // Color original del botón
                          child: ExpansionTile(
                            key: PageStorageKey<String>('${problem.keyPrefix}_expansion_tile'), // Key para mantener estado
                            leading: Image.asset(
                              problem.iconAsset,
                              width: 40.0, // Tamaño del icono
                              height: 40.0,
                              fit: BoxFit.contain,
                            ),
                            title: Text(
                              problem.name,
                              style: const TextStyle(
                                fontFamily: 'Comic Sans MS',
                                fontSize: 18, // Tamaño de fuente ligeramente ajustado
                                color: Color(0xff000000),
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                                child: SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Color(0xff4ec8dd).withOpacity(0.8),
                                      padding: EdgeInsets.symmetric(vertical: 12),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10.0),
                                      ),
                                    ),
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(builder: (context) => problem.targetPage),
                                      );
                                    },
                                    child: Text(
                                      'Ver más sobre ${problem.name}',
                                      style: TextStyle(
                                        fontFamily: 'Comic Sans MS',
                                        fontSize: 15,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
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
}