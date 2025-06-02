import 'package:animal_health/src/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:adobe_xd/pinned.dart';
import 'package:adobe_xd/page_link.dart';
import 'dart:ui' as ui; // Para BackdropFilter
// import 'package:flutter_svg/flutter_svg.dart'; // ¡Eliminado!
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cached_network_image/cached_network_image.dart';

// Importar el modelo Animal
import '../models/animal.dart';

// Imports de Navegación
import './Home.dart';
import './Ayuda.dart';
import './EditarPerfildeAnimal.dart';
import './FuncionesdelaApp.dart';
import './Configuracion.dart';
import './ListadeAnimales.dart';

// Convertimos a StatefulWidget
class IndicedeMasaCoporal extends StatefulWidget {
  final String animalId;

  const IndicedeMasaCoporal({
    required Key key,
    required this.animalId,
  }) : super(key: key);

  @override
  _IndicedeMasaCoporalState createState() => _IndicedeMasaCoporalState();
}

class _IndicedeMasaCoporalState extends State<IndicedeMasaCoporal> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _pesoController = TextEditingController();
  final TextEditingController _largoController = TextEditingController();
  final TextEditingController _anchoController = TextEditingController();

  double? _imcResult;
  String _recommendation = '';
  Animal? _animalData;
  bool _isLoadingData = true;

  @override
  void initState() {
    super.initState();
    _loadAnimalData();
  }

  @override
  void dispose() {
    _pesoController.dispose();
    _largoController.dispose();
    _anchoController.dispose();
    super.dispose();
  }

  // Carga los datos del animal
  Future<void> _loadAnimalData() async {
    if (!mounted) return;
    setState(() {
      _isLoadingData = true;
    });

    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null || widget.animalId.isEmpty) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Error: No se puede cargar el animal.')));
        setState(() {
          _isLoadingData = false;
        });
      }
      return;
    }

    try {
      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('animals')
          .doc(widget.animalId)
          .get();

      if (doc.exists) {
        if (mounted) {
          setState(() {
            _animalData = Animal.fromFirestore(doc);
            // Pre-llenar campos si hay datos existentes
            _pesoController.text = _animalData!.peso == 0.0 ? '' : _animalData!.peso.toString();
            _largoController.text = _animalData!.largo == 0.0 ? '' : _animalData!.largo.toString();
            _anchoController.text = _animalData!.ancho == 0.0 ? '' : _animalData!.ancho.toString();
            _isLoadingData = false;
          });
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Animal no encontrado.')));
          setState(() {
            _isLoadingData = false;
          });
        }
      }
    } catch (e) {
      print("Error cargando datos del animal: $e");
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error al cargar datos del animal: $e')));
        setState(() {
          _isLoadingData = false;
        });
      }
    }
  }

  // Método para calcular el IMC del animal
  // Fórmula propuesta: Peso (kg) / (Largo (m) * Ancho (m))
  // Unidades de entrada: peso (kg), largo (cm), ancho (cm)
  void _calculateIMC() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final double? peso = double.tryParse(_pesoController.text.replaceAll(',', '.'));
    final double? largoCm = double.tryParse(_largoController.text.replaceAll(',', '.'));
    final double? anchoCm = double.tryParse(_anchoController.text.replaceAll(',', '.'));

    if (peso == null || peso <= 0 || largoCm == null || largoCm <= 0 || anchoCm == null || anchoCm <= 0) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Por favor, ingrese valores válidos y positivos para peso, largo y ancho.')),
        );
      }
      return;
    }

    // Convertir centímetros a metros para la fórmula
    final double largoM = largoCm / 100.0;
    final double anchoM = anchoCm / 100.0;

    // Calcular IMC
    final double imc = peso / (largoM * anchoM);

    String recommendation;
    // Las categorías de IMC para animales varían mucho por especie y raza.
    // Estas son recomendaciones generales para un ejemplo.
    if (imc < 20) {
      recommendation = 'Bajo peso: Considere aumentar la ingesta de alimentos y consulte a su veterinario.';
    } else if (imc >= 20 && imc < 30) {
      recommendation = 'Peso normal: Mantenga una dieta equilibrada y ejercicio regular.';
    } else if (imc >= 30 && imc < 40) {
      recommendation = 'Sobrepeso: Reduzca las porciones y aumente la actividad física. Consulte a su veterinario.';
    } else {
      recommendation = 'Obeso: Es crucial un plan de pérdida de peso bajo supervisión veterinaria. Alto riesgo de salud.';
    }

    if (mounted) {
      setState(() {
        _imcResult = imc;
        _recommendation = recommendation;
      });
    }
  }

  // --- Método para construir campos de texto con iconos (copiado de EditarPerfildeAnimal) ---
  Widget _buildTextFormFieldWithIcon({
    required TextEditingController controller,
    required String labelText,
    required String assetIconPath,
    required double iconWidth,
    required double iconHeight,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
    bool enabled = true,
  }) {
    return Container(
      height: 60,
      margin: const EdgeInsets.only(bottom: 20),
      child: Stack(
        children: [
          TextFormField(
            controller: controller,
            decoration: InputDecoration(
              labelText: labelText,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              filled: true,
              fillColor: Colors.white.withOpacity(0.95),
              contentPadding: const EdgeInsets.only(left: 50.0, right: 15.0, top: 15, bottom: 15),
              floatingLabelBehavior: FloatingLabelBehavior.auto,
            ),
            keyboardType: keyboardType,
            validator: validator,
            style: const TextStyle(fontFamily: 'Comic Sans MS', fontSize: 16),
            enabled: enabled,
          ),
          Positioned(
            left: 5,
            top: 0,
            bottom: 10,
            child: Align(
              alignment: Alignment.centerLeft,
              child: Container(
                width: iconWidth,
                height: iconHeight,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(assetIconPath),
                    fit: BoxFit.fill,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Ajustar estos valores para bajar la foto y el contenido
    // El logo está en start: 42.0 y tiene un alto de 73.0. Así que termina en 42 + 73 = 115
    const double logoBottomY = 115.0;
    const double spaceAfterLogo = 25.0; // Espacio deseado entre el logo y la foto del animal
    const double animalProfilePhotoTop = logoBottomY + spaceAfterLogo; // Nuevo top para la foto
    const double animalProfilePhotoHeight = 90.0; // Altura de la foto
    const double animalNameHeight = 20.0; // Altura aproximada para el nombre
    const double spaceAfterAnimalProfile = 15.0; // Espacio entre nombre del animal y título de funciones

    const double mainContentTop = animalProfilePhotoTop + animalProfilePhotoHeight + animalNameHeight + spaceAfterAnimalProfile;

    return Scaffold(
      backgroundColor: const Color(0xffffffff),
      body: Stack(
        children: <Widget>[
          // --- Fondo de Pantalla ---
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/Animal Health Fondo de Pantalla.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          // --- Elemento SVG 1 (Removido) ---
          // Align(
          //   alignment: Alignment(-0.267, -0.494),
          //   child: SizedBox(
          //     width: 1.0,
          //     height: 1.0,
          //     child: SvgPicture.string(_svg_a7p9a8, allowDrawingOutsideViewBox: true),
          //   ),
          // ),
          // --- Logo de la App (Navega a Home) ---
          Pinned.fromPins(
            Pin(size: 74.0, middle: 0.5), Pin(size: 73.0, start: 42.0),
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
                  image: const DecorationImage(image: AssetImage('assets/images/logo.png'), fit: BoxFit.cover),
                  borderRadius: BorderRadius.circular(15.0),
                  border: Border.all(width: 1.0, color: const Color(0xff000000)),
                ),
              ),
            ),
          ),
          // --- Elemento SVG 2 (Removido) ---
          // Pinned.fromPins(
          //   Pin(size: 50.0, start: -7.5),
          //   Pin(size: 1.0, start: 128.0),
          //   child: SvgPicture.string(_svg_i3j02g, allowDrawingOutsideViewBox: true, fit: BoxFit.fill),
          // ),
          // --- Botón de Retroceso a FuncionesdelaApp ---
          Pinned.fromPins(
            Pin(size: 52.9, start: 15.0), Pin(size: 50.0, start: 49.0),
            child: InkWell(
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => FuncionesdelaApp(
                      key: Key('FuncionesdelaApp_${widget.animalId}'),
                      animalId: widget.animalId,
                    ),
                  ),
                );
              },
              child: Container(
                  decoration: const BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage('assets/images/back.png'),
                          fit: BoxFit.fill))),
            ),
          ),
          // --- Botón de Ayuda ---
          Pinned.fromPins(
            Pin(size: 40.5, end: 15.0), Pin(size: 50.0, start: 49.0),
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
                          fit: BoxFit.fill))),
            ),
          ),
          // --- Botón de Configuración ---
          Pinned.fromPins(
            Pin(size: 47.2, end: 15.0), Pin(size: 50.0, start: 110.0),
            child: PageLink(
              links: [
                PageLinkInfo(
                  transition: LinkTransition.Fade,
                  ease: Curves.easeOut,
                  duration: 0.3,
                  pageBuilder: () =>
                      Configuraciones(key: const Key('Settings'), authService: AuthService()),
                ),
              ],
              child: Container(
                  decoration: const BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage('assets/images/settingsbutton.png'),
                          fit: BoxFit.fill))),
            ),
          ),
          // --- Botón de Lista de Animales ---
          Pinned.fromPins(
            Pin(size: 60.1, start: 15.0), Pin(size: 60.0, start: 110.0),
            child: PageLink(
              links: [
                PageLinkInfo(
                  transition: LinkTransition.Fade,
                  ease: Curves.easeOut,
                  duration: 0.3,
                  pageBuilder: () => const ListadeAnimales(key: Key('ListadeAnimales')),
                ),
              ],
              child: Container(
                  decoration: const BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage('assets/images/listaanimales.png'),
                          fit: BoxFit.fill))),
            ),
          ),

          // --- Foto de Perfil del Animal Específico y Nombre ---
          Positioned(
            top: animalProfilePhotoTop, // Nueva posición calculada
            left: 0,
            right: 0,
            child: _isLoadingData
                ? Center(
                child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(const Color(0xff4ec8dd)),
                    strokeWidth: 2.0))
                : _animalData != null
                ? Center(
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EditarPerfildeAnimal(
                        key: Key('EditarPerfilDesdeIMC_${widget.animalId}'),
                        animalId: widget.animalId,
                      ),
                    ),
                  );
                },
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 90.0,
                      height: 90.0,
                      decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(25.0),
                          border: Border.all(color: Colors.white, width: 2.5),
                          boxShadow: [
                            BoxShadow(
                                color: Colors.black.withOpacity(0.3),
                                spreadRadius: 2,
                                blurRadius: 5,
                                offset: const Offset(0, 3))
                          ]),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(22.5),
                        child: (_animalData!.fotoPerfilUrl != null &&
                            _animalData!.fotoPerfilUrl.isNotEmpty)
                            ? CachedNetworkImage(
                          imageUrl: _animalData!.fotoPerfilUrl!,
                          fit: BoxFit.cover,
                          placeholder: (context, url) => const Center(
                              child: CircularProgressIndicator(
                                  strokeWidth: 2.0)),
                          errorWidget: (context, url, error) =>
                          const Icon(Icons.pets,
                              size: 50, color: Colors.grey),
                        )
                            : const Icon(Icons.pets,
                            size: 50, color: Colors.grey),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(
                        _animalData!.nombre,
                        style: TextStyle(
                            fontFamily: 'Comic Sans MS',
                            fontSize: 16,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            shadows: [
                              Shadow(
                                  blurRadius: 1.0,
                                  color: Colors.black.withOpacity(0.5),
                                  offset: const Offset(1.0, 1.0))
                            ]),
                      ),
                    ),
                  ],
                ),
              ),
            )
                : const SizedBox.shrink(), // O un placeholder si no hay datos
          ),

          // --- Contenido Principal: Formulario y Resultados ---
          Positioned(
            top: mainContentTop,
            left: 20.0,
            right: 20.0,
            bottom: 20.0,
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 0.0, vertical: 10.0),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    // Campos de entrada
                    _buildTextFormFieldWithIcon(
                      controller: _pesoController,
                      labelText: 'Peso (kg)',
                      assetIconPath: 'assets/images/peso.png',
                      iconWidth: 40.7,
                      iconHeight: 40.0,
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      validator: (v) {
                        if (v == null || v.isEmpty) return 'Ingrese el peso';
                        final num? value = num.tryParse(v.replaceAll(',', '.'));
                        if (value == null || value <= 0) return 'Ingrese un número válido y positivo';
                        return null;
                      },
                    ),
                    _buildTextFormFieldWithIcon(
                      controller: _anchoController,
                      labelText: 'Ancho del Animal (cm)',
                      assetIconPath: 'assets/images/ancho.png',
                      iconWidth: 35.8,
                      iconHeight: 40.0,
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      validator: (v) {
                        if (v == null || v.isEmpty) return 'Ingrese el ancho';
                        final num? value = num.tryParse(v.replaceAll(',', '.'));
                        if (value == null || value <= 0) return 'Ingrese un número válido y positivo';
                        return null;
                      },
                    ),
                    _buildTextFormFieldWithIcon(
                      controller: _largoController,
                      labelText: 'Largo del Animal (cm)',
                      assetIconPath: 'assets/images/largo.png',
                      iconWidth: 35.8,
                      iconHeight: 40.0,
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      validator: (v) {
                        if (v == null || v.isEmpty) return 'Ingrese el largo';
                        final num? value = num.tryParse(v.replaceAll(',', '.'));
                        if (value == null || value <= 0) return 'Ingrese un número válido y positivo';
                        return null;
                      },
                    ),
                    const SizedBox(height: 10),
                    // Botón para calcular IMC
                    GestureDetector(
                      onTap: _calculateIMC,
                      child: Container(
                        height: 49.0,
                        decoration: BoxDecoration(
                          color: const Color(0xff4ec8dd),
                          borderRadius: BorderRadius.circular(15.0),
                          border: Border.all(width: 1.0, color: const Color(0xff000000)),
                          boxShadow: const [
                            BoxShadow(
                              color: Color(0x29000000),
                              offset: Offset(0, 3),
                              blurRadius: 6,
                            ),
                          ],
                        ),
                        alignment: Alignment.center,
                        child: const Text(
                          'Calcular IMC',
                          style: TextStyle(
                            fontFamily: 'Comic Sans MS',
                            fontSize: 20,
                            color: Color(0xff000000),
                            fontWeight: FontWeight.w700,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),

                    // --- Bloque de Resultado IMC ---
                    if (_imcResult != null)
                      _buildResultBlock(
                        title: 'Resultado IMC',
                        content: Column(
                          children: [
                            Text(
                              _imcResult!.toStringAsFixed(2), // Muestra el IMC con 2 decimales
                              style: const TextStyle(
                                fontFamily: 'Comic Sans MS',
                                fontSize: 30,
                                color: Color(0xff000000),
                                fontWeight: FontWeight.w700,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    if (_imcResult != null) const SizedBox(height: 20),

                    // --- Bloque de Recomendaciones de Alimentación ---
                    if (_imcResult != null)
                      _buildResultBlock(
                        title: 'Recomendaciones de Alimentación',
                        content: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
                          child: Text(
                            _recommendation,
                            style: const TextStyle(
                              fontFamily: 'Comic Sans MS',
                              fontSize: 16,
                              color: Color(0xff000000),
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Widget para construir los bloques de resultados estilizados
  Widget _buildResultBlock({required String title, required Widget content}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(15.0),
      decoration: BoxDecoration(
        color: const Color(0x5e4ec8dd), // Color de fondo semi-transparente
        borderRadius: BorderRadius.circular(20.0),
        border: Border.all(width: 1.0, color: const Color(0xff000000)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x29000000),
            offset: Offset(0, 3),
            blurRadius: 6,
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            title,
            style: const TextStyle(
              fontFamily: 'Comic Sans MS',
              fontSize: 18,
              color: Color(0xff000000),
              fontWeight: FontWeight.w700,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 10),
          content,
        ],
      ),
    );
  }
}

