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
import 'dart:developer' as developer; // Para logs más detallados

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
  }

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

  Future<void> _deleteVisit(String visitId) async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Usuario no autenticado. Por favor, inicie sesión.', style: TextStyle(fontFamily: 'Comic Sans MS'))),
        );
      }
      return;
    }

    bool? confirmDelete = await showDialog<bool>(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          backgroundColor: const Color(0xe3a0f4fe),
          title: const Text('Confirmar Eliminación', style: TextStyle(fontFamily: 'Comic Sans MS', color: Colors.black)),
          content: const Text('¿Estás seguro de que quieres eliminar esta visita? Esta acción no se puede deshacer.', style: TextStyle(fontFamily: 'Comic Sans MS', color: Colors.black)),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancelar', style: TextStyle(fontFamily: 'Comic Sans MS', color: Colors.grey)),
              onPressed: () {
                Navigator.of(dialogContext).pop(false);
              },
            ),
            TextButton(
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              child: const Text('Eliminar', style: TextStyle(fontFamily: 'Comic Sans MS')),
              onPressed: () {
                Navigator.of(dialogContext).pop(true);
              },
            ),
          ],
        );
      },
    );

    if (confirmDelete == true) {
      try {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(currentUser.uid)
            .collection('animals')
            .doc(widget.animalId)
            .collection('visits')
            .doc(visitId)
            .delete();

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Visita eliminada correctamente.', style: TextStyle(fontFamily: 'Comic Sans MS')), backgroundColor: Colors.green),
          );
        }
      } catch (e) {
        developer.log('Error al eliminar la visita: $e');
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error al eliminar la visita: $e', style: const TextStyle(fontFamily: 'Comic Sans MS')), backgroundColor: Colors.red),
          );
        }
      }
    }
  }

  Future<void> _showEditVisitModal(String visitId, Map<String, dynamic> visitData) async {
    final result = await showModalBottomSheet(
      context: context,
      isScrollControlled: true, // Esto es clave para que el modal ocupe casi toda la pantalla
      backgroundColor: Colors.transparent, // Permite que el ClipRRect del modal tenga un fondo transparente
      builder: (BuildContext modalContext) {
        return _EditarVisitaVeterinariaModalWidget(
          key: Key('edit_visit_modal_${visitId}'),
          animalId: widget.animalId,
          visitId: visitId,
          visitData: visitData,
        );
      },
    );

    if (result == true) {
      // Si el modal devuelve true (éxito al guardar), forzamos una actualización de la UI
      setState(() {});
    }
  }

  Widget _buildVisitCard(Map<String, dynamic> visitData, String visitId) {
    DateTime visitDateTime;
    if (visitData['fecha'] is Timestamp) {
      visitDateTime = (visitData['fecha'] as Timestamp).toDate();
    } else if (visitData['fecha'] is String) {
      visitDateTime = DateTime.tryParse(visitData['fecha']) ?? DateTime.now();
    } else {
      visitDateTime = DateTime.now();
    }

    final String formattedDate = DateFormat('dd/MM/yyyy').format(visitDateTime);
    final String formattedTime = visitData['hora'] is String ? visitData['hora'] : TimeOfDay.fromDateTime(visitDateTime).format(context);

    String fullAddress = visitData['centroAtencionDireccionCompleta'] ?? '';
    if (fullAddress.isEmpty) {
      String? tipoVia = visitData['centroAtencionTipoVia'];
      String? numeroVia = visitData['centroAtencionNumeroVia'];
      String? complemento = visitData['centroAtencionComplemento'];
      if (tipoVia != null && numeroVia != null) {
        fullAddress = '$tipoVia $numeroVia';
        if (complemento != null && complemento.isNotEmpty) {
          fullAddress += ' - $complemento';
        }
      }
    }

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
      width: 404.0,
      decoration: BoxDecoration(
        color: const Color(0xe3a0f4fe),
        borderRadius: BorderRadius.circular(20.0),
        border: Border.all(width: 1.0, color: const Color(0xe3000000)),
      ),
      padding: const EdgeInsets.all(20),
      child: Stack(
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              _buildInfoRow(iconPath: 'assets/images/fechavisita.png', iconWidth: 35.2, iconHeight: 40.0, text: 'Fecha: $formattedDate'),
              const SizedBox(height: 10),
              _buildInfoRow(iconPath: 'assets/images/horavisita.png', iconWidth: 35.2, iconHeight: 40.0, text: 'Hora: $formattedTime'),
              const SizedBox(height: 10),
              _buildInfoRow(
                iconPath: 'assets/images/centrodeatencion.png',
                iconWidth: 35.2,
                iconHeight: 40.0,
                text: 'Centro: ${visitData['centroAtencionNombre'] ?? 'N/A'}\n${fullAddress.isNotEmpty ? fullAddress : 'Dirección no disponible'}',
                maxLines: 3,
              ),
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
          Positioned(
            top: 0,
            right: 0,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Image.asset(
                    'assets/images/editar.png', // Asegúrate de tener este icono
                    height: 35,
                    width: 35,
                  ),
                  tooltip: 'Editar visita',
                  onPressed: () => _showEditVisitModal(visitId, visitData),
                ),
                IconButton(
                  icon: Image.asset(
                    'assets/images/eliminar.png', // Asegúrate de tener este icono
                    height: 35,
                    width: 35,
                  ),
                  tooltip: 'Eliminar visita',
                  onPressed: () => _deleteVisit(visitId),
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
                  developer.log("Error obteniendo datos del animal: ${snapshot.error}");
                  return Center(child: CircleAvatar(radius: 45, backgroundColor: Colors.red[100], child: Icon(Icons.error_outline, size: 50, color: Colors.red[700])));
                }
                if (!snapshot.hasData || !snapshot.data!.exists) {
                  developer.log("Documento del animal (ID: ${widget.animalId}) no encontrado.");
                  return Center(child: CircleAvatar(radius: 45, backgroundColor: Colors.grey[200], child: Icon(Icons.pets, size: 50, color: Colors.grey[400])));
                }

                Animal animalData;
                try {
                  animalData = Animal.fromFirestore(snapshot.data!);
                } catch (e) {
                  developer.log("Error al deserializar datos del animal (ID: ${widget.animalId}): $e. Data: ${snapshot.data!.data()}");
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
                              errorWidget: (context, url, error) => Icon(Icons.pets, size: 50, color: Colors.grey[600]),
                            )
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
                        developer.log('Error al cargar visitas: ${snapshot.error}');
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
                          var doc = snapshot.data!.docs[index];
                          var visitData = doc.data() as Map<String, dynamic>;
                          var visitId = doc.id;
                          return _buildVisitCard(visitData, visitId);
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
                            setState(() {});
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


// INICIO DEL WIDGET DE MODAL DE EDICIÓN DE VISITAS ANIDADO

class _EditarVisitaVeterinariaModalWidget extends StatefulWidget {
  final String animalId;
  final String visitId;
  final Map<String, dynamic> visitData; // Datos de la visita a editar

  const _EditarVisitaVeterinariaModalWidget({
    required Key key,
    required this.animalId,
    required this.visitId,
    required this.visitData,
  }) : super(key: key);

  @override
  __EditarVisitaVeterinariaModalWidgetState createState() => __EditarVisitaVeterinariaModalWidgetState();
}

class __EditarVisitaVeterinariaModalWidgetState extends State<_EditarVisitaVeterinariaModalWidget> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _diagnosticoController;
  late TextEditingController _tratamientoController;
  late TextEditingController _medicamentosController;
  late TextEditingController _observacionesController;
  late TextEditingController _costoController;
  late TextEditingController _veterinarianNameController;
  late TextEditingController _centerNameController;
  String? _selectedAddressType; // ESTO FUE LO QUE FALTABA DECLARAR Y LA CAUSA DEL ERROR
  late TextEditingController _addressNumberController;
  late TextEditingController _addressComplementController;

  late TextEditingController _dateController;
  late TextEditingController _timeController;

  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;

  bool _isLoading = true; // Para la carga inicial de datos del animal
  bool _isSaving = false; // Para el estado de guardado

  String _currentLocationString = "N/A"; // Coordenadas GPS (solo para mostrar, no editar)

  Animal? _animalData; // Para almacenar los datos del animal para mostrar en el encabezado

  bool _isTimeControllerTextSet = false; // Nuevo flag para controlar la inicialización del texto de hora

  @override
  void initState() {
    super.initState();
    // La inicialización de controladores que NO dependen de `context` puede ir aquí.
    // Los que sí dependen de `context` se inicializan en `didChangeDependencies`.
    _initializeControllers();
    _loadAnimalData();
  }

  // Se llama después de initState y también cuando las dependencias cambian.
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Solo inicializamos el texto del controlador de hora si no se ha hecho antes.
    if (!_isTimeControllerTextSet) {
      if (_selectedTime != null) {
        _timeController.text = _selectedTime!.format(context);
      }
      _isTimeControllerTextSet = true;
    }
  }

  // Método para inicializar todos los TextEditingController y variables de estado
  void _initializeControllers() {
    // 1. Inicializar _selectedDate y _selectedTime a partir de widget.visitData
    if (widget.visitData['fecha'] is Timestamp) {
      _selectedDate = (widget.visitData['fecha'] as Timestamp).toDate();
    } else if (widget.visitData['fecha'] is String) {
      _selectedDate = DateTime.tryParse(widget.visitData['fecha']);
    } else {
      _selectedDate = DateTime.now(); // Fallback si no hay fecha válida
    }

    if (_selectedDate != null) {
      final String? timeString = widget.visitData['hora'] as String?;
      if (timeString != null && timeString.isNotEmpty) {
        // Intenta parsear la hora. Asumimos un formato común como "HH:mm" o "h:mm AM/PM"
        // Este parseo es un poco más robusto pero aún puede fallar con formatos inusuales.
        // Si el formato de hora almacenado es ambiguo, considera guardar hora y minuto como enteros.
        try {
          final tempTimeOfDay = TimeOfDay.fromDateTime(DateFormat.jm().parse(timeString));
          _selectedTime = tempTimeOfDay;
        } catch (e) {
          developer.log("Error al parsear el string de hora '$timeString': $e. Usando hora de la fecha.");
          _selectedTime = TimeOfDay.fromDateTime(_selectedDate!); // Fallback
        }
      } else {
        _selectedTime = TimeOfDay.fromDateTime(_selectedDate!); // Fallback
      }
    } else {
      // Si _selectedDate es nulo, inicializar con valores por defecto
      _selectedDate = DateTime.now();
      _selectedTime = TimeOfDay.now();
    }

    // 2. Inicializar TextEditingControllers con los valores pre-existentes
    _diagnosticoController = TextEditingController(text: widget.visitData['diagnostico'] ?? '');
    _tratamientoController = TextEditingController(text: widget.visitData['tratamiento'] ?? '');
    _medicamentosController = TextEditingController(text: widget.visitData['medicamentos'] ?? '');
    _observacionesController = TextEditingController(text: widget.visitData['observaciones'] ?? '');
    // Asegurarse de que el costo sea un string válido con 2 decimales
    _costoController = TextEditingController(text: (widget.visitData['costo'] as num?)?.toStringAsFixed(2) ?? '0.00');
    _veterinarianNameController = TextEditingController(text: widget.visitData['veterinarioNombre'] ?? '');

    _centerNameController = TextEditingController(text: widget.visitData['centroAtencionNombre'] ?? '');
    _selectedAddressType = widget.visitData['centroAtencionTipoVia']; // Asignar el tipo de vía directamente
    _addressNumberController = TextEditingController(text: widget.visitData['centroAtencionNumeroVia'] ?? '');
    _addressComplementController = TextEditingController(text: widget.visitData['centroAtencionComplemento'] ?? '');

    // Inicializar el controlador de fecha (no depende de `context` para el texto)
    _dateController = TextEditingController(text: _selectedDate != null ? DateFormat('dd/MM/yyyy').format(_selectedDate!) : '');

    // Inicializar el controlador de hora, pero su texto se setea en `didChangeDependencies`
    _timeController = TextEditingController();

    _currentLocationString = widget.visitData['centroAtencionCoordenadas'] ?? 'No disponible';
  }

  // Carga los datos del animal para mostrar su foto y nombre en el modal
  Future<void> _loadAnimalData() async {
    setState(() {
      _isLoading = true;
    });
    try {
      final userId = FirebaseAuth.instance.currentUser?.uid;
      if (userId != null && widget.animalId.isNotEmpty) {
        final animalDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(userId)
            .collection('animals')
            .doc(widget.animalId)
            .get();
        if (animalDoc.exists) {
          _animalData = Animal.fromFirestore(animalDoc);
        } else {
          developer.log("Documento del animal con ID ${widget.animalId} no encontrado.");
        }
      } else {
        developer.log("Usuario no autenticado o animalId vacío.");
      }
    } catch (e) {
      developer.log("Error cargando datos del animal para editar visita: $e");
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  // Selector de fecha (similar al de CrearVisitasVet)
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xff4ec8dd),
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
            dialogBackgroundColor: Colors.white,
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        _dateController.text = DateFormat('dd/MM/yyyy').format(picked);
      });
    }
  }

  // Selector de hora (similar al de CrearVisitasVet)
  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime ?? TimeOfDay.now(),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xff4ec8dd),
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
            dialogBackgroundColor: Colors.white,
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _selectedTime) {
      setState(() {
        _selectedTime = picked;
        _timeController.text = picked.format(context);
      });
    }
  }

  // Función para construir la dirección completa (reutilizada de CrearVisitasVet)
  String _buildFullAddress() {
    String fullAddress = "";
    if (_selectedAddressType != null && _addressNumberController.text.isNotEmpty) {
      fullAddress = "${_selectedAddressType} ${_addressNumberController.text}";
      if (_addressComplementController.text.isNotEmpty) {
        fullAddress += " - ${_addressComplementController.text}";
      }
    }
    return fullAddress.trim();
  }

  // Lógica para actualizar la visita en Firestore
  Future<void> _updateVisit() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    if (_selectedDate == null || _selectedTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Por favor, seleccione la fecha y hora de la visita.')));
      return;
    }
    if (_centerNameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Por favor, ingrese el nombre del centro de atención.')));
      return;
    }
    if (_selectedAddressType == null || _addressNumberController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Por favor, ingrese la dirección completa del centro de atención.')));
      return;
    }

    if (!mounted) return;
    setState(() {
      _isSaving = true;
    });

    try {
      final userId = FirebaseAuth.instance.currentUser?.uid;
      if (userId == null) {
        if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Usuario no autenticado. Por favor, inicie sesión.')));
        Navigator.pop(context);
        return;
      }

      final visitDateTime = DateTime(
        _selectedDate!.year,
        _selectedDate!.month,
        _selectedDate!.day,
        _selectedTime!.hour,
        _selectedTime!.minute,
      );

      // Actualizar el documento existente en Firestore
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('animals')
          .doc(widget.animalId)
          .collection('visits')
          .doc(widget.visitId) // Especificamos el documento a actualizar
          .update({ // Usamos update en lugar de add
        'fecha': visitDateTime,
        'hora': _selectedTime!.format(context),
        'centroAtencionNombre': _centerNameController.text.trim(),
        'centroAtencionTipoVia': _selectedAddressType,
        'centroAtencionNumeroVia': _addressNumberController.text.trim(),
        'centroAtencionComplemento': _addressComplementController.text.trim(),
        'centroAtencionDireccionCompleta': _buildFullAddress(),
        // Las coordenadas GPS no se actualizan aquí, se mantienen las originales
        'veterinarioNombre': _veterinarianNameController.text.trim(),
        'diagnostico': _diagnosticoController.text.trim(),
        'tratamiento': _tratamientoController.text.trim(),
        'medicamentos': _medicamentosController.text.trim(),
        'observaciones': _observacionesController.text.trim(),
        'costo': double.tryParse(_costoController.text.trim().replaceAll(',', '.')) ?? 0.0,
        'lastUpdated': FieldValue.serverTimestamp(), // Añadir un timestamp de última actualización
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Visita actualizada con éxito!')));
        Navigator.pop(context, true); // Cerramos el modal indicando éxito
      }
    } catch (e) {
      developer.log("Error al actualizar visita: $e");
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error al actualizar visita: $e')));
    } finally {
      if (mounted) setState(() {
        _isSaving = false;
      });
    }
  }

  @override
  void dispose() {
    _diagnosticoController.dispose();
    _tratamientoController.dispose();
    _medicamentosController.dispose();
    _observacionesController.dispose();
    _costoController.dispose();
    _veterinarianNameController.dispose();
    _centerNameController.dispose();
    _addressNumberController.dispose();
    _addressComplementController.dispose();
    _dateController.dispose();
    _timeController.dispose();
    super.dispose();
  }

  // Helper para construir campos de formulario (reutilizado de CrearVisitasVet)
  Widget _buildFormField({
    required TextEditingController controller,
    required String label,
    required String iconAsset,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
    bool readOnly = false,
    VoidCallback? onTap,
    int? maxLines = 1,
    Widget? suffixIcon,
  }) {
    const double iconSize = 42.0;
    const double iconLeftPadding = 10.0;
    const double textFieldLeftPadding = iconLeftPadding + iconSize + 10.0;

    return Container(
      margin: const EdgeInsets.only(bottom: 18.0),
      child: Stack(
        alignment: Alignment.centerLeft,
        children: [
          TextFormField(
            controller: controller,
            readOnly: readOnly,
            onTap: onTap,
            keyboardType: keyboardType,
            maxLines: maxLines,
            style: const TextStyle(fontFamily: 'Comic Sans MS', fontSize: 15, color: Colors.black87),
            decoration: InputDecoration(
              labelText: label,
              labelStyle: const TextStyle(fontFamily: 'Comic Sans MS', color: Colors.black54, fontSize: 15),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.0), borderSide: BorderSide(color: Colors.grey.shade400)),
              enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12.0), borderSide: BorderSide(color: Colors.grey.shade500)),
              focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12.0), borderSide: BorderSide(color: Theme.of(context).primaryColor, width: 1.5)),
              filled: true,
              fillColor: readOnly ? Colors.grey[200] : Colors.white.withOpacity(0.9),
              contentPadding: EdgeInsets.only(left: textFieldLeftPadding, top: maxLines! > 1 ? 18 : 18, bottom: maxLines > 1 ? 18 : 18, right: 15),
              floatingLabelBehavior: FloatingLabelBehavior.auto,
              suffixIcon: suffixIcon,
            ),
            validator: validator,
          ),
          Padding(
            padding: EdgeInsets.only(left: iconLeftPadding),
            child: Image.asset(
              iconAsset,
              width: iconSize,
              height: iconSize,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) {
                developer.log("Error cargando icono de formulario: $iconAsset, $error");
                return Icon(Icons.error_outline, color: Colors.red, size: iconSize - 10);
              },
            ),
          ),
        ],
      ),
    );
  }

  // Función para mostrar imagen grande (reutilizada de VisitasalVeterinario)
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

  @override
  Widget build(BuildContext context) {
    const double animalPhotoSize = 90.0;
    const double animalNameHeight = 20.0;
    const double spaceAfterAnimalPhoto = 20.0;
    // La altura que ocupa la foto del animal y su nombre dentro del modal
    final double headerHeight = animalPhotoSize + animalNameHeight + spaceAfterAnimalPhoto;
    // Posición superior del formulario principal, dejando espacio para el AppBar y el encabezado del animal
    final double mainContentTopPadding = AppBar().preferredSize.height + headerHeight + 20; // 20 es un margen adicional

    return FractionallySizedBox(
      heightFactor: 0.92, // Ocupar 92% de la altura de la pantalla
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20.0),
          topRight: Radius.circular(20.0),
        ),
        child: Scaffold(
          backgroundColor: Colors.transparent, // Fondo transparente para que se vea la imagen de fondo
          appBar: AppBar(
            title: const Text('Editar Visita Veterinaria', style: TextStyle(fontFamily: 'Comic Sans MS', color: Colors.white)),
            backgroundColor: const Color(0xff4ec8dd),
            elevation: 1,
            automaticallyImplyLeading: false, // No mostrar el botón de retroceso por defecto de AppBar
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20.0),
                topRight: Radius.circular(20.0),
              ),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.close, color: Colors.white),
                onPressed: () => Navigator.of(context).pop(), // Botón para cerrar el modal
              )
            ],
          ),
          body: Stack(
            children: <Widget>[
              // Imagen de fondo (reutilizada de tus pantallas)
              Container(
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/Animal Health Fondo de Pantalla.png'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),

              // Foto y Nombre del Animal (similar a CrearVisitasVet)
              Positioned(
                // Posicionado justo debajo del AppBar del modal
                top: 0,
                left: 0,
                right: 0,
                child: _isLoading
                    ? Center(child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(const Color(0xff4ec8dd))),
                ))
                    : _animalData != null
                    ? Center(
                  child: GestureDetector(
                    onTap: (_animalData!.fotoPerfilUrl != null && _animalData!.fotoPerfilUrl!.isNotEmpty)
                        ? () => _showLargeImage(_animalData!.fotoPerfilUrl!)
                        : null,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: animalPhotoSize, height: animalPhotoSize,
                          margin: const EdgeInsets.only(top: 20.0), // Margen desde el AppBar del modal
                          decoration: BoxDecoration(
                              color: Colors.grey[300],
                              borderRadius: BorderRadius.circular(25.0),
                              border: Border.all(color: Colors.white, width: 2.5),
                              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.3), spreadRadius: 2, blurRadius: 5, offset: Offset(0,3))]
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(22.5),
                            child: (_animalData!.fotoPerfilUrl != null && _animalData!.fotoPerfilUrl!.isNotEmpty)
                                ? CachedNetworkImage(
                              imageUrl: _animalData!.fotoPerfilUrl!, fit: BoxFit.cover,
                              placeholder: (context, url) => const Center(child: CircularProgressIndicator(strokeWidth: 2.0)),
                              errorWidget: (context, url, error) => Icon(Icons.pets, size: 50, color: Colors.grey[600]),
                            )
                                : const Icon(Icons.pets, size: 50, color: Colors.grey),
                          ),
                        ),
                        if (_animalData!.nombre.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Text(
                              _animalData!.nombre,
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
                )
                    : const SizedBox.shrink(), // O un placeholder mientras carga
              ),

              // Área de contenido principal para el formulario
              Positioned(
                top: mainContentTopPadding, // Posición superior ajustada debajo de la foto del animal y el AppBar
                left: 20,
                right: 20,
                bottom: 0, // Ocupar todo el espacio restante hacia abajo
                child: Form(
                  key: _formKey,
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 0),
                    child: Column(
                      children: [
                        const SizedBox(height: 10),

                        // Título del formulario
                        Container(
                          width: 229.0,
                          height: 35.0,
                          decoration: BoxDecoration(
                            color: const Color(0xe3a0f4fe),
                            borderRadius: BorderRadius.circular(10.0),
                            border: Border.all(width: 1.0, color: const Color(0xe3000000)),
                          ),
                          child: const Center(
                            child: Text(
                              'Detalles de la Visita',
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
                        const SizedBox(height: 30),

                        // Selector de fecha
                        _buildFormField(
                          controller: _dateController,
                          label: 'Fecha de la Visita',
                          iconAsset: 'assets/images/fechavisita.png',
                          readOnly: true,
                          onTap: () => _selectDate(context),
                          suffixIcon: const Icon(Icons.calendar_today, color: Colors.grey),
                        ),

                        // Selector de hora
                        _buildFormField(
                          controller: _timeController,
                          label: 'Hora de la Visita',
                          iconAsset: 'assets/images/horavisita.png',
                          readOnly: true,
                          onTap: () => _selectTime(context),
                          suffixIcon: const Icon(Icons.access_time, color: Colors.grey),
                        ),

                        // Campo: Nombre del Centro de Atención
                        _buildFormField(
                          controller: _centerNameController,
                          label: 'Nombre del Centro de Atención',
                          iconAsset: 'assets/images/centrodeatencion.png',
                          validator: (v) => v!.isEmpty ? 'Ingrese el nombre del centro de atención' : null,
                        ),

                        // Bloque de Dirección Estructurada para el Centro de Atención
                        Container(
                          margin: const EdgeInsets.only(bottom: 18.0),
                          child: Stack(
                            alignment: Alignment.centerLeft,
                            children: [
                              DropdownButtonFormField<String>(
                                decoration: InputDecoration(
                                  labelText: 'Tipo de Vía',
                                  labelStyle: const TextStyle(fontFamily: 'Comic Sans MS', color: Colors.black54, fontSize: 15),
                                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.0), borderSide: BorderSide(color: Colors.grey.shade400)),
                                  enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12.0), borderSide: BorderSide(color: Colors.grey.shade500)),
                                  focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12.0), borderSide: BorderSide(color: Theme.of(context).primaryColor, width: 1.5)),
                                  filled: true,
                                  fillColor: Colors.white.withOpacity(0.9),
                                  contentPadding: const EdgeInsets.only(left: 55.0, right: 10.0, top: 18, bottom: 18),
                                ),
                                hint: Text('Seleccione el tipo de vía', style: TextStyle(fontFamily: 'Comic Sans MS', color: Colors.grey[600], fontSize: 15)),
                                value: _selectedAddressType,
                                isExpanded: true,
                                icon: const Icon(Icons.arrow_drop_down, color: Color(0xff4ec8dd)),
                                style: const TextStyle(fontFamily: 'Comic Sans MS', color: Colors.black87, fontSize: 15),
                                dropdownColor: Colors.white,
                                items: ['Calle', 'Carrera', 'Avenida', 'Diagonal', 'Transversal', 'Circular', 'Autopista', 'Vereda', 'Kilómetro'].map<DropdownMenuItem<String>>((String value) {
                                  return DropdownMenuItem<String>(value: value, child: Text(value));
                                }).toList(),
                                onChanged: (String? newValue) {
                                  setState(() {
                                    _selectedAddressType = newValue;
                                  });
                                },
                                validator: (value) => value == null ? 'Seleccione el tipo de vía' : null,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 10.0),
                                child: Image.asset('assets/images/ubicacion.png', width: 42, height: 42, fit: BoxFit.contain),
                              ),
                            ],
                          ),
                        ),
                        _buildFormField(
                          controller: _addressNumberController,
                          label: 'Número de Vía (Ej: 74)',
                          iconAsset: 'assets/images/calle.png',
                          keyboardType: TextInputType.number,
                          validator: (v) => v!.isEmpty ? 'Ingrese el número de vía' : null,
                        ),
                        _buildFormField(
                          controller: _addressComplementController,
                          label: 'Números Complementarios (Ej: # 114-35)',
                          iconAsset: 'assets/images/#.png',
                        ),

                        // Coordenadas GPS (solo para mostrar, no para editar)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 18.0),
                          child: InputDecorator(
                            decoration: InputDecoration(
                                labelText: 'Coordenadas GPS',
                                labelStyle: const TextStyle(fontFamily: 'Comic Sans MS', color: Colors.black54, fontSize: 15),
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.0), borderSide: BorderSide(color: Colors.grey.shade400)),
                                enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12.0), borderSide: BorderSide(color: Colors.grey.shade500)),
                                filled: true,
                                fillColor: Colors.grey[200], // Fondo gris para solo lectura
                                contentPadding: const EdgeInsets.only(left: 55.0, top: 18, bottom: 18, right: 15),
                                prefixIconConstraints: const BoxConstraints(minWidth: 52, minHeight: 52),
                                prefixIcon: Padding(
                                  padding: const EdgeInsets.only(left: 10.0, right:0.0),
                                  child: Image.asset('assets/images/coordenada.png', width: 42, height: 42, fit: BoxFit.contain),
                                )
                            ),
                            child: Padding(
                              padding: const EdgeInsets.only(top: 1.0),
                              child: Text(_currentLocationString, style: const TextStyle(fontFamily: 'Comic Sans MS', fontSize: 15, color: Colors.black87)),
                            ),
                          ),
                        ),

                        // Campo de texto para el nombre del Veterinario
                        _buildFormField(
                          controller: _veterinarianNameController,
                          label: 'Nombre del Veterinario',
                          iconAsset: 'assets/images/veterinario.png',
                          validator: (v) => v!.isEmpty ? 'Ingrese nombre del veterinario' : null,
                        ),

                        // Campos de texto para la visita
                        _buildFormField(
                          controller: _diagnosticoController,
                          label: 'Diagnóstico',
                          iconAsset: 'assets/images/diagnostico.png',
                          maxLines: 3,
                          validator: (v) => v!.isEmpty ? 'Ingrese diagnóstico' : null,
                        ),
                        _buildFormField(
                          controller: _tratamientoController,
                          label: 'Tratamiento',
                          iconAsset: 'assets/images/tratamiento.png',
                          maxLines: 3,
                          validator: (v) => v!.isEmpty ? 'Ingrese tratamiento' : null,
                        ),
                        _buildFormField(
                          controller: _medicamentosController,
                          label: 'Medicamentos',
                          iconAsset: 'assets/images/medicamentos.png',
                          maxLines: 3,
                        ),
                        _buildFormField(
                          controller: _observacionesController,
                          label: 'Observaciones',
                          iconAsset: 'assets/images/observaciones.png',
                          maxLines: 3,
                        ),
                        _buildFormField(
                          controller: _costoController,
                          label: 'Costo (\$)',
                          iconAsset: 'assets/images/costo.png',
                          keyboardType: TextInputType.numberWithOptions(decimal: true),
                          validator: (v) => v!.isEmpty ? 'Ingrese costo' : (double.tryParse(v.replaceAll(',', '.')) == null ? 'Número inválido' : null),
                        ),
                        const SizedBox(height: 20),

                        // Botón para guardar cambios
                        GestureDetector(
                          onTap: _isSaving ? null : _updateVisit,
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              Image.asset(
                                'assets/images/visitavet.png',
                                width: 120.0,
                                height: 120.0,
                                fit: BoxFit.fill,
                              ),
                              if (_isSaving) const CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.white)),
                            ],
                          ),
                        ),
                        const SizedBox(height: 30), // Espacio al final del scroll
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}