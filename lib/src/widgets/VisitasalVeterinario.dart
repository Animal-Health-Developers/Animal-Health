// lib/src/widgets/VisitasalVeterinario.dart
import 'package:animal_health/src/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:adobe_xd/pinned.dart';
import './Home.dart';
import 'package:adobe_xd/page_link.dart';
import './Ayuda.dart';
import './EditarPerfildeAnimal.dart';
import './Configuracion.dart';
import './ListadeAnimales.dart';

// Nuevos imports para la funcionalidad
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cached_network_image/cached_network_image.dart'; // Para mostrar imagen desde URL
import 'package:intl/intl.dart'; // Para formatear la fecha

// Importamos la nueva pantalla para crear visitas
import 'CrearVisitasVet.dart';
import 'FuncionesdelaApp.dart';
import '../models/animal.dart'; // Importación para el modelo Animal

class VisitasalVeterinario extends StatefulWidget {
  final String animalId;

  const VisitasalVeterinario({
    required Key key,
    required this.animalId,
  }) : super(key: key);

  @override
  _VisitasalVeterinarioState createState() => _VisitasalVeterinarioState();
}

class _VisitasalVeterinarioState extends State<VisitasalVeterinario> {
  // Eliminadas: bool _isLoadingAnimal = true;
  // Eliminada: bool _isVeterinarian = false;

  // Constantes de posicionamiento
  static const double logoBottomY = 115.0;
  static const double spaceAfterLogo = 25.0;
  static const double animalProfilePhotoTop = logoBottomY + spaceAfterLogo;
  static const double animalProfilePhotoHeight = 90.0;
  static const double animalNameApproxHeight = 20.0;
  static const double spaceAfterAnimalProfile = 15.0;

  static const double mainContentTop = animalProfilePhotoTop + animalProfilePhotoHeight + animalNameApproxHeight + spaceAfterAnimalProfile;

  static const double navButtonRowTop = 110.0;

  @override
  void initState() {
    super.initState();
    // Eliminada la llamada a _loadAnimalDataAndCheckRole()
  }

  // Eliminado el método _loadAnimalDataAndCheckRole()

  void _showLargeImage(String imageUrl) {
    Widget imageWidget = CachedNetworkImage(
      imageUrl: imageUrl,
      fit: BoxFit.contain,
      placeholder: (context, url) => const Center(
          child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xff4ec8dd)))),
      errorWidget: (context, url, error) =>
      const Icon(Icons.error, size: 100, color: Colors.grey),
    );

    showDialog(
      context: context,
      useSafeArea: false,
      builder: (BuildContext context) {
        return GestureDetector(
          onTap: () => Navigator.of(context).pop(),
          child: Dialog(
            backgroundColor: Colors.transparent,
            insetPadding: EdgeInsets.zero,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  width: double.infinity,
                  height: double.infinity,
                  color: Colors.black.withOpacity(0.9),
                  child: imageWidget,
                ),
                Positioned(
                  top: MediaQuery.of(context).padding.top + 10,
                  right: 10,
                  child: IconButton(
                    icon: const Icon(Icons.close, color: Colors.white, size: 30),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildVisitCard(Map<String, dynamic> visitData) {
    DateTime visitDateTime;
    if (visitData['fecha'] is Timestamp) {
      visitDateTime = (visitData['fecha'] as Timestamp).toDate();
    } else if (visitData['fecha'] is String) {
      visitDateTime = DateTime.tryParse(visitData['fecha']) ?? DateTime.now();
    } else {
      visitDateTime = DateTime.now();
    }

    final String formattedDate = DateFormat('dd/MM/yyyy').format(visitDateTime);
    final String formattedTime = visitData['hora'] ?? 'N/A';

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
      width: 404.0,
      decoration: BoxDecoration(
        color: const Color(0xe3a0f4fe),
        borderRadius: BorderRadius.circular(20.0),
        border: Border.all(width: 1.0, color: const Color(0xe3000000)),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          _buildInfoRow(iconPath: 'assets/images/fecha.png', iconWidth: 35.2, iconHeight: 40.0, text: 'Fecha: $formattedDate'),
          const SizedBox(height: 10),
          _buildInfoRow(iconPath: 'assets/images/hora.png', iconWidth: 35.2, iconHeight: 40.0, text: 'Hora: $formattedTime'),
          const SizedBox(height: 10),
          _buildInfoRow(iconPath: 'assets/images/ubicacion.png', iconWidth: 35.2, iconHeight: 40.0, text: 'Centro: ${visitData['centroAtencionNombre'] ?? 'N/A'}\n${visitData['centroAtencionDireccion'] ?? ''}', maxLines: 3),
          const SizedBox(height: 10),
          _buildInfoRow(iconPath: 'assets/images/veterinario.png', iconWidth: 35.2, iconHeight: 40.0, text: 'Veterinario: ${visitData['veterinarioNombre'] ?? 'N/A'}'),
          const SizedBox(height: 10),
          _buildInfoRow(iconPath: 'assets/images/diagnostico.png', iconWidth: 35.2, iconHeight: 40.0, text: 'Diagnóstico: ${visitData['diagnostico'] ?? 'N/A'}', maxLines: 5),
          const SizedBox(height: 10),
          _buildInfoRow(iconPath: 'assets/images/tratamiento.png', iconWidth: 35.2, iconHeight: 40.0, text: 'Tratamiento: ${visitData['tratamiento'] ?? 'N/A'}', maxLines: 5),
          const SizedBox(height: 10),
          _buildInfoRow(iconPath: 'assets/images/medicamentos.png', iconWidth: 35.2, iconHeight: 40.0, text: 'Medicamentos: ${visitData['medicamentos'] ?? 'N/A'}', maxLines: 5),
          const SizedBox(height: 10),
          _buildInfoRow(iconPath: 'assets/images/observaciones.png', iconWidth: 35.2, iconHeight: 40.0, text: 'Observaciones: ${visitData['observaciones'] ?? 'N/A'}', maxLines: 5),
          const SizedBox(height: 10),
          _buildInfoRow(iconPath: 'assets/images/costo.png', iconWidth: 35.2, iconHeight: 40.0, text: 'Costo: \$${(visitData['costo'] as num?)?.toStringAsFixed(2) ?? '0.00'}'),
          const SizedBox(height: 20),
          if (visitData['isReminder'] == true)
            Align(
              alignment: Alignment.center,
              child: Column(
                children: [
                  const Text(
                    'Recordatorio',
                    style: TextStyle(fontFamily: 'Comic Sans MS', fontSize: 20, color: Color(0xff000000), fontWeight: FontWeight.w700),
                    textAlign: TextAlign.center,
                    softWrap: false,
                  ),
                  const SizedBox(height: 8),
                  Container(
                    width: 93.6,
                    height: 120.0,
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/images/recordarvisita.png'),
                        fit: BoxFit.fill,
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

  Widget _buildInfoRow({
    required String iconPath,
    required double iconWidth,
    required double iconHeight,
    required String text,
    int maxLines = 1,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: iconWidth,
          height: iconHeight,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(iconPath),
              fit: BoxFit.fill,
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              fontFamily: 'Comic Sans MS',
              fontSize: 16,
              color: Color(0xff000000),
              fontWeight: FontWeight.w700,
            ),
            softWrap: true,
            maxLines: maxLines,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final User? currentUser = FirebaseAuth.instance.currentUser;

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
                  image: const DecorationImage(image: AssetImage('assets/images/logo.png'), fit: BoxFit.cover),
                  borderRadius: BorderRadius.circular(15.0),
                  border: Border.all(width: 1.0, color: const Color(0xff000000)),
                ),
              ),
            ),
          ),
          // --- Botón de Retroceso a ListadeAnimales (con pop para volver a la pantalla anterior) ---
          Pinned.fromPins(
            Pin(size: 52.9, start: 9.1),
            Pin(size: 50.0, start: 49.0),
            child: GestureDetector(
              onTap: () {
                Navigator.of(context).pop();
              },
              child: Container(
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/back.png'),
                    fit: BoxFit.fill,
                  ),
                ),
              ),
            ),
          ),
          // --- Botón de Ayuda ---
          Pinned.fromPins(
            Pin(size: 40.5, end: 7.6 + 47.2 + 5.0),
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
          // --- Botón de Configuración ---
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

          // --- Foto de Perfil del Animal Específico (Con funcionalidad de ver en grande) ---
          Positioned(
            top: animalProfilePhotoTop,
            left: 0,
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
                  return Center(child: CircleAvatar(radius: 45, backgroundColor: Colors.grey[300], child: CircularProgressIndicator(strokeWidth: 2.0, valueColor: AlwaysStoppedAnimation<Color>(const Color(0xff4ec8dd)))));
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

                return Center(
                  child: GestureDetector(
                    onTap: (animalData.fotoPerfilUrl != null && animalData.fotoPerfilUrl!.isNotEmpty)
                        ? () => _showLargeImage(animalData.fotoPerfilUrl!)
                        : null,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 90.0, height: 90.0,
                          decoration: BoxDecoration(
                              color: Colors.grey[300],
                              borderRadius: BorderRadius.circular(25.0),
                              border: Border.all(color: Colors.white, width: 2.5),
                              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.3), spreadRadius: 2, blurRadius: 5, offset: Offset(0,3))]
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(22.5),
                            child: (animalData.fotoPerfilUrl != null && animalData.fotoPerfilUrl!.isNotEmpty)
                                ? CachedNetworkImage(
                                imageUrl: animalData.fotoPerfilUrl!, fit: BoxFit.cover,
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
                              style: TextStyle(
                                  fontFamily: 'Comic Sans MS',
                                  fontSize: 16,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  shadows: [Shadow(blurRadius: 1.0, color: Colors.black.withOpacity(0.5), offset: Offset(1.0,1.0))]
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                );
              },
            )
                : Center(
                child: Tooltip(
                    message: currentUser == null ? "Usuario no autenticado" : "ID de animal no válido",
                    child: CircleAvatar(radius: 45, backgroundColor: Colors.grey[200], child: Icon(Icons.error_outline, size: 50, color: Colors.grey[400]))
                )
            ),
          ),


          // --- Botón de Funciones (Posición ajustada) ---
          Pinned.fromPins(
            Pin(size: 62.7, start: 6.7),
            Pin(size: 70.0, start: navButtonRowTop),
            child: PageLink(
              links: [
                PageLinkInfo(
                  duration: 0.3,
                  pageBuilder: () => FuncionesdelaApp(
                    key: const Key('FuncionesdelaApp'),
                    animalId: widget.animalId,
                  ),
                ),
              ],
              child: Container(
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/funciones.png'),
                    fit: BoxFit.fill,
                  ),
                ),
              ),
            ),
          ),

          // --- Botón de Lista de Animales (ya existente) ---
          Pinned.fromPins(
            Pin(size: 60.1, end: 7.6),
            Pin(size: 60.0, start: navButtonRowTop),
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
                    fit: BoxFit.fill,
                  ),
                ),
              ),
            ),
          ),


          // --- Título y Lista de Visitas (Ahora scrollable con el botón de crear visita) ---
          Positioned(
            top: mainContentTop,
            left: 0,
            right: 0,
            bottom: 0,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    width: 229.0,
                    height: 35.0,
                    margin: const EdgeInsets.only(bottom: 20),
                    decoration: BoxDecoration(
                      color: const Color(0xe3a0f4fe),
                      borderRadius: BorderRadius.circular(10.0),
                      border: Border.all(width: 1.0, color: const Color(0xe3000000)),
                    ),
                    child: const Center(
                      child: Text(
                        'Visitas al Veterinario',
                        style: TextStyle(
                          fontFamily: 'Comic Sans MS',
                          fontSize: 20,
                          color: Color(0xff000000),
                          fontWeight: FontWeight.w700,
                        ),
                        textAlign: TextAlign.center,
                        softWrap: false,
                      ),
                    ),
                  ),

                  // El StreamBuilder de visitas ahora no tiene condiciones de carga o rol externas
                  StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('users')
                        .doc(FirebaseAuth.instance.currentUser?.uid)
                        .collection('animals')
                        .doc(widget.animalId)
                        .collection('visits')
                        .orderBy('fecha', descending: true)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: Padding(
                            padding: EdgeInsets.all(20.0),
                            child: CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          ),
                        );
                      }
                      if (snapshot.hasError) {
                        return Center(
                          child: Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Text('Error: ${snapshot.error}', style: const TextStyle(color: Colors.red)),
                          ),
                        );
                      }
                      if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                        return const Center(
                          child: Padding(
                            padding: EdgeInsets.all(20.0),
                            child: Text(
                              'No hay visitas registradas para este animal.',
                              style: TextStyle(fontFamily: 'Comic Sans MS', fontSize: 18, color: Colors.black87),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        );
                      }

                      return ListView.builder(
                        itemCount: snapshot.data!.docs.length,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          var visitData = snapshot.data!.docs[index].data() as Map<String, dynamic>;
                          return _buildVisitCard(visitData);
                        },
                      );
                    },
                  ),
                  // --- Botón "Crear Visita" (con icono visitavet.png), siempre visible ---
                  Padding(
                    padding: const EdgeInsets.only(bottom: 20.0, top: 20.0),
                    child: SizedBox(
                      width: 152.0,
                      height: 149.0,
                      child: GestureDetector(
                        onTap: () async {
                          final result = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CrearVisitaVeterinariaScreen(
                                key: const Key('CrearVisitaFromScrollableButton'),
                                animalId: widget.animalId,
                              ),
                            ),
                          );
                          if (result == true) {
                            setState(() {}); // Recargar si se creó una nueva visita
                          }
                        },
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Image.asset(
                              'assets/images/visitavet.png',
                              width: 120.0,
                              height: 120.0,
                              fit: BoxFit.fill,
                            ),
                            const Text(
                              'Crear Visita',
                              style: TextStyle(
                                fontFamily: 'Comic Sans MS',
                                fontSize: 20,
                                color: Color(0xff000000),
                                fontWeight: FontWeight.w700,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
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