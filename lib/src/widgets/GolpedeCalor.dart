import 'package:flutter/material.dart';
import 'package:adobe_xd/pinned.dart';
import 'package:adobe_xd/page_link.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cached_network_image/cached_network_image.dart';

import './Home.dart';
import './Ayuda.dart';
import './PerfilPublico.dart';
import './SolucionAEMERGENCIAS.dart';
import './Configuracion.dart';
import './ListadeAnimales.dart'; // Para la selección de animales
import './CompradeProductos.dart';
import './CuidadosyRecomendaciones.dart';
import './Emergencias.dart';
import './Comunidad.dart';
import './Crearpublicaciones.dart';
import '../services/auth_service.dart';
import '../models/animal.dart'; // Asegúrate que la ruta a tu clase Animal sea correcta

// Ya no se usa SvgPicture.string ni ui.ImageFilter si los elementos son estándar
// import 'package:flutter_svg/flutter_svg.dart';
// import 'dart:ui' as ui;

class GolpedeCalor extends StatefulWidget {
  final Animal? animalPreseleccionado;

  const GolpedeCalor({
    Key? key,
    this.animalPreseleccionado,
  }) : super(key: key);

  @override
  _GolpedeCalorState createState() => _GolpedeCalorState();
}

class _GolpedeCalorState extends State<GolpedeCalor> {
  final TextEditingController _sintomasController = TextEditingController();
  final TextEditingController _descripcionSituacionController = TextEditingController(); // Nuevo para "Descripción"
  final GlobalKey<ScaffoldMessengerState> _scaffoldMessengerKey =
  GlobalKey<ScaffoldMessengerState>();

  Animal? _animalSeleccionado;

  @override
  void initState() {
    super.initState();
    _animalSeleccionado = widget.animalPreseleccionado;
  }

  @override
  void dispose() {
    _sintomasController.dispose();
    _descripcionSituacionController.dispose();
    super.dispose();
  }

  Future<void> _navegarParaSeleccionarAnimal() async {
    final Animal? animalEscogido = await Navigator.push<Animal?>(
      context,
      MaterialPageRoute(
        builder: (context) => const ListadeAnimales(
          key: Key('seleccionAnimalParaGolpeCalor'),
          isSelectionMode: true,
        ),
      ),
    );

    if (animalEscogido != null) {
      setState(() {
        _animalSeleccionado = animalEscogido;
      });
    }
  }

  Future<void> _guardarGolpeDeCalor() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      _mostrarSnackbar("Error: Debes iniciar sesión para guardar.", Colors.red);
      return;
    }

    if (_animalSeleccionado == null) {
      _mostrarSnackbar("Por favor, selecciona un animal primero.", Colors.orange);
      return;
    }

    if (_sintomasController.text.trim().isEmpty ||
        _descripcionSituacionController.text.trim().isEmpty) {
      _mostrarSnackbar(
          "Por favor, completa todos los campos sobre el golpe de calor.", Colors.orange);
      return;
    }

    try {
      final golpeCalorData = {
        'sintomasObservados': _sintomasController.text.trim(),
        'descripcionSituacion': _descripcionSituacionController.text.trim(), // Cómo ocurrió, dónde estaba, etc.
        'timestamp': FieldValue.serverTimestamp(),
        'animalId': _animalSeleccionado!.id,
        'animalNombre': _animalSeleccionado!.nombre,
      };

      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('animals')
          .doc(_animalSeleccionado!.id)
          .collection('registros_golpes_calor') // Nueva subcolección
          .add(golpeCalorData);

      _mostrarSnackbar(
          "Registro de golpe de calor para ${_animalSeleccionado!.nombre} guardado con éxito.",
          Colors.green);
      _sintomasController.clear();
      _descripcionSituacionController.clear();
    } catch (e) {
      _mostrarSnackbar("Error al guardar la información: $e", Colors.red);
    }
  }

  void _mostrarSnackbar(String message, Color backgroundColor) {
    _scaffoldMessengerKey.currentState?.showSnackBar(
      SnackBar(
        content: Text(message, style: TextStyle(fontFamily: 'Comic Sans MS')),
        backgroundColor: backgroundColor,
        duration: Duration(seconds: 3),
      ),
    );
  }

  Widget _buildNavigationButtonItem({
    required String imagePath,
    bool isHighlighted = false,
    double? fixedWidth,
    double height = 60.0,
    required VoidCallback onPressed,
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

    return InkWell(
      onTap: onPressed,
      child: Container(
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
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const double navBarTopPosition = 200.0;
    const double navBarHeight = 60.0;
    const double spaceBelowNavBar = 20.0;
    final double topOffsetForContent = navBarTopPosition + navBarHeight + spaceBelowNavBar;
    final User? currentUserAuth = FirebaseAuth.instance.currentUser;

    return Scaffold(
      key: _scaffoldMessengerKey,
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
            Pin(size: 40.5, middle: 0.8328),
            Pin(size: 50.0, start: 49.0),
            child: PageLink(
              links: [PageLinkInfo(pageBuilder: () => Ayuda(key: const Key('Ayuda')))],
              child: Container(
                decoration: const BoxDecoration(image: DecorationImage(image: AssetImage('assets/images/help.png'), fit: BoxFit.fill)),
              ),
            ),
          ),
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
                      style: TextStyle(fontFamily: 'Comic Sans MS', fontSize: 18, color: Color(0xff000000)),
                      decoration: InputDecoration(
                        hintText: '¿Qué estás buscando?',
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
          if (currentUserAuth != null)
            Pinned.fromPins(
              Pin(size: 60.0, start: 6.0),
              Pin(size: 60.0, middle: 0.1947),
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
                              print("Error cargando foto de perfil del usuario (GolpeCalor): $error");
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
          Positioned(
            top: navBarTopPosition,
            left: 16.0,
            right: 16.0,
            height: navBarHeight,
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
          Positioned(
            top: topOffsetForContent,
            left: 20.0,
            right: 20.0,
            bottom: 20.0,
            child: Container(
              padding: const EdgeInsets.all(15.0),
              decoration: BoxDecoration(
                color: const Color(0xcc54d1e0),
                borderRadius: BorderRadius.circular(20.0),
                border: Border.all(width: 1.0, color: const Color(0x87000000)),
                boxShadow: const [BoxShadow(color: Color(0x40000000), offset: Offset(0, 3), blurRadius: 6)],
              ),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset('assets/images/golpecalor.png', width: 45.0, height: 45.0),
                        const SizedBox(width: 10),
                        const Text(
                          'GOLPE DE CALOR',
                          style: TextStyle(fontFamily: 'Comic Sans MS', fontSize: 20, color: Color(0xff000000), fontWeight: FontWeight.w700),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20.0),
                    _animalSeleccionado == null
                        ? ElevatedButton.icon(
                      icon: const Icon(Icons.pets, color: Colors.black),
                      label: const Text('Seleccionar Animal', style: TextStyle(fontFamily: 'Comic Sans MS', color: Colors.black, fontSize: 16)),
                      onPressed: _navegarParaSeleccionarAnimal,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white.withOpacity(0.9),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10), side: const BorderSide(color: Color(0xff707070))),
                      ),
                    )
                        : Card(
                      elevation: 2,
                      color: Colors.white.withOpacity(0.95),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0), side: const BorderSide(color: Color(0xff707070))),
                      child: ListTile(
                        leading: CircleAvatar(
                          radius: 25,
                          backgroundImage: _animalSeleccionado!.fotoPerfilUrl.isNotEmpty ? CachedNetworkImageProvider(_animalSeleccionado!.fotoPerfilUrl) : null,
                          child: _animalSeleccionado!.fotoPerfilUrl.isEmpty ? const Icon(Icons.pets, size: 25) : null,
                        ),
                        title: Text("Mascota: ${_animalSeleccionado!.nombre}", style: const TextStyle(fontFamily: 'Comic Sans MS', fontWeight: FontWeight.bold, fontSize: 16)),
                        subtitle: Text(_animalSeleccionado!.especie, style: const TextStyle(fontFamily: 'Comic Sans MS', fontSize: 14)),
                        trailing: IconButton(
                          icon: const Icon(Icons.edit_note, color: Color(0xff4ec8dd), size: 28),
                          tooltip: 'Cambiar animal',
                          onPressed: _navegarParaSeleccionarAnimal,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20.0),
                    const Text( // Campo para los síntomas que ya tenías
                      'SÍNTOMAS OBSERVADOS:',
                      style: TextStyle(fontFamily: 'Comic Sans MS', fontSize: 17, color: Color(0xff000000), fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(height: 8.0),
                    TextField(
                      controller: _sintomasController,
                      maxLines: 3, // Ajustar según necesidad
                      decoration: InputDecoration(
                        hintText: 'Ej: Jadeo excesivo, encías rojas o pálidas, debilidad, vómitos, diarrea, temperatura alta...',
                        hintStyle: TextStyle(fontFamily: 'Comic Sans MS', fontSize: 15, color: Colors.grey.shade700),
                        filled: true,
                        fillColor: Colors.white.withOpacity(0.9),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0), borderSide: const BorderSide(color: Color(0xff707070))),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
                      ),
                      style: const TextStyle(fontFamily: 'Comic Sans MS', fontSize: 16),
                    ),
                    const SizedBox(height: 20.0),
                    const Text( // Campo para la descripción de la situación
                      'DESCRIPCIÓN DE LA SITUACIÓN:',
                      style: TextStyle(fontFamily: 'Comic Sans MS', fontSize: 17, color: Color(0xff000000), fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(height: 8.0),
                    TextField(
                      controller: _descripcionSituacionController,
                      maxLines: 4, // Ajustar según necesidad
                      decoration: InputDecoration(
                        hintText: 'Describe cómo y dónde ocurrió. Ej: Dejado en el coche al sol, ejercicio intenso en día caluroso, sin acceso a sombra o agua...',
                        hintStyle: TextStyle(fontFamily: 'Comic Sans MS', fontSize: 15, color: Colors.grey.shade700),
                        filled: true,
                        fillColor: Colors.white.withOpacity(0.9),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0), borderSide: const BorderSide(color: Color(0xff707070))),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
                      ),
                      style: const TextStyle(fontFamily: 'Comic Sans MS', fontSize: 16),
                    ),
                    const SizedBox(height: 25.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xffffffff),
                            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                            textStyle: const TextStyle(fontFamily: 'Comic Sans MS', fontSize: 17, color: Colors.black),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0), side: const BorderSide(color: Colors.black)),
                            foregroundColor: Colors.black,
                          ),
                          onPressed: _guardarGolpeDeCalor,
                          child: const Text('Guardar'),
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xffffffff),
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                            textStyle: const TextStyle(fontFamily: 'Comic Sans MS', fontSize: 17, color: Colors.black),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0), side: const BorderSide(color: Colors.black)),
                            foregroundColor: Colors.black,
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => SolucionAEMERGENCIAS(key: const Key('SolucionAEMERGENCIAS_GolpeCalor'), descripcionDelProblema: '',)),
                            );
                          },
                          child: const Text('Ver Soluciones'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10.0),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}