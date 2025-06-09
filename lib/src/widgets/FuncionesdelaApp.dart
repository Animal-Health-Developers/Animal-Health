import 'package:flutter/material.dart';
import 'package:adobe_xd/pinned.dart';
import 'package:adobe_xd/page_link.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cached_network_image/cached_network_image.dart';

// Imports de Navegación y Servicios
import '../services/auth_service.dart';
import './Home.dart';
import './Ayuda.dart';
import './EditarPerfildeAnimal.dart';
import './VisitasalVeterinario.dart';
import './CarnetdeVacunacion.dart';
import './Tratamientomedico.dart';
import './HistoriaClnica.dart';
import './IndicedeMasaCoporal.dart';
import './Configuracion.dart';
import './ListadeAnimales.dart';
import '../models/animal.dart'; // Importar el modelo Animal

// --- Clase FuncionesdelaApp ---
class FuncionesdelaApp extends StatefulWidget {
  final String animalId;

  const FuncionesdelaApp({
    required Key key,
    required this.animalId,
  }) : super(key: key);

  @override
  _FuncionesdelaAppState createState() => _FuncionesdelaAppState();
}

// --- Estado de FuncionesdelaApp ---
class _FuncionesdelaAppState extends State<FuncionesdelaApp> {

  // --- Widget Builder para Botones de Función ---
  Widget _buildFunctionButton({
    required String assetImagePath,
    required String label,
    required VoidCallback onTap,
    double imageWidth = 100.0,
    double imageHeight = 100.0,
    required String tooltipMessage, // Nuevo parámetro para el Tooltip
  }) {
    return Tooltip( // Envuelve con Tooltip
      message: tooltipMessage,
      child: GestureDetector(
        onTap: onTap,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 178.0,
              height: 130.0,
              padding: const EdgeInsets.only(top: 10),
              decoration: BoxDecoration(
                color: const Color(0x994ec8dd),
                borderRadius: BorderRadius.circular(20.0),
                border: Border.all(width: 1.0, color: const Color(0xff707070)),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x29000000),
                    offset: Offset(0, 3),
                    blurRadius: 6,
                  ),
                ],
              ),
              child: Center(
                child: Image.asset(
                  assetImagePath,
                  width: imageWidth,
                  height: imageHeight,
                  fit: BoxFit.contain,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: const TextStyle(
                fontFamily: 'Comic Sans MS',
                fontSize: 15,
                color: Color(0xff000000),
                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  // --- Método Build Principal ---
  @override
  Widget build(BuildContext context) {
    final User? currentUser = FirebaseAuth.instance.currentUser;

    // Ajustar estos valores para bajar la foto y el contenido
    // El logo está en start: 42.0 y tiene un alto de 73.0. Así que termina en 42 + 73 = 115
    const double logoBottomY = 115.0;
    const double spaceAfterLogo = 25.0; // Espacio deseado entre el logo y la foto del animal
    const double animalProfilePhotoTop = logoBottomY + spaceAfterLogo; // Nuevo top para la foto
    const double animalProfilePhotoHeight = 90.0; // Altura de la foto
    const double animalNameHeight = 20.0; // Altura aproximada para el nombre
    const double spaceAfterAnimalProfile = 15.0; // Espacio entre nombre del animal y título de funciones

    const double titleFunctionsTop = animalProfilePhotoTop + animalProfilePhotoHeight + animalNameHeight + spaceAfterAnimalProfile;


    return Scaffold(
      backgroundColor: const Color(0xff4ec8dd),
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
          // --- Logo de la App (Navega a Home) ---
          Pinned.fromPins(
            Pin(size: 74.0, middle: 0.5), Pin(size: 73.0, start: 42.0),
            child: Tooltip( // Tooltip añadido
              message: 'Ir a Inicio',
              child: PageLink(
                links: [
                  PageLinkInfo(
                    transition: LinkTransition.Fade,
                    ease: Curves.easeOut,
                    duration: 0.3,
                    pageBuilder: () => Home(key: const Key('Home_From_Funciones')),
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
          ),
          // --- Botón de Retroceso ---
          Pinned.fromPins(
            Pin(size: 52.9, start: 15.0), Pin(size: 50.0, start: 49.0),
            child: Tooltip( // Tooltip añadido
              message: 'Volver a la pantalla anterior',
              child: InkWell(
                onTap: () => Navigator.of(context).pop(),
                child: Container(decoration: const BoxDecoration(image: DecorationImage(image: AssetImage('assets/images/back.png'), fit: BoxFit.fill))),
              ),
            ),
          ),
          // --- Botón de Ayuda ---
          Pinned.fromPins(
            Pin(size: 40.5, end: 15.0), Pin(size: 50.0, start: 49.0),
            child: Tooltip( // Tooltip añadido
              message: 'Ayuda y Soporte',
              child: PageLink(
                links: [PageLinkInfo(pageBuilder: () => Ayuda(key: const Key('Ayuda')))],
                child: Container(decoration: const BoxDecoration(image: DecorationImage(image: AssetImage('assets/images/help.png'), fit: BoxFit.fill))),
              ),
            ),
          ),
          // --- Iconos Laterales (Configuración y Lista General de Animales) ---
          Pinned.fromPins(
            Pin(size: 47.2, end: 15.0), Pin(size: 50.0, start: 110.0), // Mantenerlos relativos al top o ajustar si es necesario
            child: Tooltip( // Tooltip añadido
              message: 'Configuración de la Aplicación',
              child: PageLink(
                links: [
                  PageLinkInfo(
                    pageBuilder: () => Configuraciones(key: const Key('Settings_From_Funciones'), authService: AuthService()),
                  ),
                ],
                child: Container(decoration: const BoxDecoration(image: DecorationImage(image: AssetImage('assets/images/settingsbutton.png'), fit: BoxFit.fill))),
              ),
            ),
          ),
          Pinned.fromPins(
            Pin(size: 60.1, start: 15.0), Pin(size: 60.0, start: 110.0), // Mantenerlos relativos al top o ajustar
            child: Tooltip( // Tooltip añadido
              message: 'Ver todos mis animales',
              child: PageLink(
                links: [
                  PageLinkInfo(
                    pageBuilder: () => const ListadeAnimales(key: Key('ListadeAnimales_From_Funciones')),
                  ),
                ],
                child: Container(decoration: const BoxDecoration(image: DecorationImage(image: AssetImage('assets/images/listaanimales.png'), fit: BoxFit.fill))),
              ),
            ),
          ),

          // --- Foto de Perfil del Animal Específico ---
          Positioned(
            top: animalProfilePhotoTop, // Nueva posición calculada
            left: 0, // Para que el Column interior pueda centrar su contenido
            right: 0,
            child: currentUser != null && widget.animalId.isNotEmpty
                ? StreamBuilder<DocumentSnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('users')
                  .doc(currentUser.uid)
                  .collection('animals')
                  .doc(widget.animalId)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircleAvatar(radius: 45, backgroundColor: Colors.grey[300], child: const CircularProgressIndicator(strokeWidth: 2.0, valueColor: AlwaysStoppedAnimation<Color>(Color(0xff4ec8dd)))));
                }
                if (snapshot.hasError) {
                  print("Error obteniendo datos del animal: ${snapshot.error}");
                  return Center(child: CircleAvatar(radius: 45, backgroundColor: Colors.red[100], child: Icon(Icons.error_outline, size: 50, color: Colors.red[700])));
                }
                if (!snapshot.hasData || !snapshot.data!.exists) {
                  print("Documento del animal (ID: ${widget.animalId}) no encontrado.");
                  return Center(child: CircleAvatar(radius: 45, backgroundColor: Colors.grey[200], child: Icon(Icons.pets, size: 50, color: Colors.grey[400])));
                }

                Animal animalData;
                try {
                  animalData = Animal.fromFirestore(snapshot.data!);
                } catch (e) {
                  print("Error al deserializar datos del animal (ID: ${widget.animalId}): $e. Data: ${snapshot.data!.data()}");
                  return Center(child: CircleAvatar(radius: 45, backgroundColor: Colors.orange[100], child: Icon(Icons.report_problem_outlined, size: 50, color: Colors.orange[700])));
                }

                return Center( // Centrar el Column que contiene la foto y el nombre
                  child: Tooltip( // Tooltip para la foto de perfil del animal
                    message: 'Editar perfil de ${animalData.nombre}',
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => EditarPerfildeAnimal(
                              key: Key('EditarPerfilDesdeFunciones_${widget.animalId}'),
                              animalId: widget.animalId,
                            ),
                          ),
                        );
                      },
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 90.0, height: 90.0,
                            decoration: BoxDecoration(
                                color: Colors.grey[300],
                                borderRadius: BorderRadius.circular(25.0), // Bordes redondeados
                                border: Border.all(color: Colors.white, width: 2.5),
                                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.3), spreadRadius: 2, blurRadius: 5, offset: const Offset(0,3))]
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(22.5), // ClipRRect para que la imagen se adapte a los bordes redondeados
                              child: (animalData.fotoPerfilUrl.isNotEmpty)
                                  ? CachedNetworkImage(
                                  imageUrl: animalData.fotoPerfilUrl, fit: BoxFit.cover,
                                  placeholder: (context, url) => const Center(child: CircularProgressIndicator(strokeWidth: 2.0)),
                                  errorWidget: (context, url, error) => Icon(Icons.pets, size: 50, color: Colors.grey[600]))
                                  : Icon(Icons.pets, size: 50, color: Colors.grey[600]),
                            ),
                          ),
                          if (animalData.nombre.isNotEmpty)
                            Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Text(
                                animalData.nombre,
                                style: const TextStyle(
                                    fontFamily: 'Comic Sans MS',
                                    fontSize: 16,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    shadows: [Shadow(blurRadius: 1.0, color: Colors.black, offset: Offset(1.0,1.0))] // Usar const Color(0xff000000) si quieres ser más específico, pero Colors.black es constante por defecto.
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            )
                : Center( // Placeholder si no hay usuario o animalId
                child: Tooltip(
                    message: currentUser == null ? "Usuario no autenticado" : "ID de animal no válido",
                    child: CircleAvatar(radius: 45, backgroundColor: Colors.grey[200], child: const Icon(Icons.error_outline, size: 50, color: Colors.grey))
                )
            ),
          ),

          // --- Contenido Principal: Botones de Funciones ---
          Positioned(
            top: titleFunctionsTop, // Nueva posición calculada para el título y la cuadrícula
            left: 0,
            right: 0,
            bottom: 0,
            child: Column(
              children: [
                // --- Título "Funciones de Animal Health" ---
                Container(
                  width: 300.0,
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  margin: const EdgeInsets.only(bottom: 25.0),
                  decoration: BoxDecoration(
                    color: const Color(0xe3a0f4fe),
                    borderRadius: BorderRadius.circular(10.0),
                    border: Border.all(width: 1.0, color: const Color(0xe3000000)),
                  ),
                  child: const Text(
                    'Funciones de Animal Health',
                    style: TextStyle(fontFamily: 'Comic Sans MS', fontSize: 20, color: Color(0xff000000), fontWeight: FontWeight.w700),
                    textAlign: TextAlign.center,
                  ),
                ),
                // --- Cuadrícula de Botones de Función ---
                Expanded(
                  child: GridView.count(
                    crossAxisCount: 2,
                    childAspectRatio: 178 / (130 + 21 + 16), // (ancho de botón) / (altura de imagen + altura de texto + espacio)
                    mainAxisSpacing: 20.0,
                    crossAxisSpacing: 20.0,
                    padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                    children: <Widget>[
                      _buildFunctionButton(
                        assetImagePath: 'assets/images/visitasveterinario.png',
                        label: 'Visitas al Veterinario',
                        tooltipMessage: 'Gestionar historial de visitas al veterinario', // Tooltip para este botón
                        onTap: () {
                          if (widget.animalId.isNotEmpty) {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => VisitasalVeterinario(key: const Key('VisitasVet'), animalId: widget.animalId)));
                          }
                        },
                      ),
                      _buildFunctionButton(
                        assetImagePath: 'assets/images/carnetvacunacion.png',
                        label: 'Carnet de Vacunación',
                        tooltipMessage: 'Ver y editar el carnet de vacunación', // Tooltip para este botón
                        onTap: () {
                          if (widget.animalId.isNotEmpty) {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => CarnetdeVacunacion(key: const Key('CarnetVac'), animalId: widget.animalId)));
                          }
                        },
                      ),
                      _buildFunctionButton(
                        assetImagePath: 'assets/images/medicamentos.png',
                        label: 'Medicamentos',
                        tooltipMessage: 'Registrar y gestionar tratamientos médicos', // Tooltip para este botón
                        onTap: () {
                          if (widget.animalId.isNotEmpty) {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => Tratamientomedico(key: const Key('TratMed'), animalId: widget.animalId)));
                          }
                        },
                      ),
                      _buildFunctionButton(
                        assetImagePath: 'assets/images/historiaclinica.png',
                        label: 'Historia Clínica',
                        tooltipMessage: 'Acceder a la historia clínica completa', // Tooltip para este botón
                        onTap: () {
                          if (widget.animalId.isNotEmpty) {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => HistoriaClinica(key: const Key('HistClin'), animalId: widget.animalId)));
                          }
                        },
                      ),
                      _buildFunctionButton(
                        assetImagePath: 'assets/images/indicedemasa.png',
                        label: 'Índice de Masa',
                        tooltipMessage: 'Calcular el índice de masa corporal (IMC)', // Tooltip para este botón
                        onTap: () {
                          if (widget.animalId.isNotEmpty) {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => IndicedeMasaCoporal(key: const Key('IMC'), animalId: widget.animalId)));
                          }
                        },
                      ),
                    ],
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