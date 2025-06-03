import 'package:animal_health/src/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:adobe_xd/pinned.dart';

import './Home.dart';
import 'package:adobe_xd/page_link.dart';
import './Ayuda.dart';
import './EditarPerfildeAnimal.dart';
import './FuncionesdelaApp.dart';
import './Configuracion.dart';
import './ListadeAnimales.dart';
import './CrearVisitasVet.dart';
// Core functionality imports
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart'; // Para formatear fechas
import 'dart:developer' as developer; // Para logs más detallados

// NEW IMPORTS FOR NOTIFICATIONS (copied from Tratamientomedico.dart)
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:flutter_native_timezone/flutter_native_timezone.dart';

// Importación para el modelo Animal
import '../models/animal.dart';

// Define constantes para estilos comunes de la aplicación
const Color APP_PRIMARY_COLOR = Color(0xff4ec8dd);
const Color APP_BACKGROUND_COLOR = Color(0xff4ec8dd);
const Color APP_TEXT_COLOR = Color(0xff000000);
const Color CARD_BACKGROUND_COLOR = Color(0xe3a0f4fe); // Color de fondo de las tarjetas y formularios
const String APP_FONT_FAMILY = 'Comic Sans MS';

// Extension para oscurecer colores (copied from Tratamientomedico.dart)
extension ColorExtension on Color {
  Color darken([double amount = .1]) {
    assert(amount >= 0 && amount <= 1);
    final hsl = HSLColor.fromColor(this);
    final hslDark = hsl.withLightness((hsl.lightness - amount).clamp(0.0, 1.0));
    return hslDark.toColor();
  }
}

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

  // Notification plugin instance (copied from Tratamientomedico.dart)
  late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  String _animalName = 'tu animal'; // Default name for notifications

  @override
  void initState() {
    super.initState();
    _initNotifications();
    _loadAnimalName();
  }

  // Initialize local notifications (copied from Tratamientomedico.dart)
  Future<void> _initNotifications() async {
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('app_icon'); // Asegúrate de tener este 'app_icon' en drawable

    const DarwinInitializationSettings initializationSettingsIOS =
    DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const InitializationSettings initializationSettings =
    InitializationSettings(
        android: initializationSettingsAndroid,
        iOS: initializationSettingsIOS);

    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onDidReceiveNotificationResponse: (NotificationResponse notificationResponse) async {
          developer.log('Notification tapped: ${notificationResponse.payload}');
          // Aquí podrías añadir lógica para navegar a la app o a una pantalla específica.
        });

    tz.initializeTimeZones();
    try {
      final String currentTimeZone = await FlutterNativeTimezone.getLocalTimezone();
      tz.setLocalLocation(tz.getLocation(currentTimeZone));
    } catch (e) {
      developer.log("No se pudo establecer la zona horaria local: $e. Volviendo a UTC.");
      tz.setLocalLocation(tz.getLocation('UTC'));
    }
  }

  // Load animal name for notifications (copied from Tratamientomedico.dart)
  Future<void> _loadAnimalName() async {
    final User? currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null || widget.animalId.isEmpty) return;

    try {
      DocumentSnapshot doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser.uid)
          .collection('animals')
          .doc(widget.animalId)
          .get();
      if (doc.exists) {
        if (mounted) {
          setState(() {
            _animalName = Animal.fromFirestore(doc).nombre;
          });
        }
      }
    } catch (e) {
      developer.log("Error loading animal name for notification: $e");
    }
  }


  // Function to toggle reminder status for a visit (NEW)
  Future<void> _toggleVisitReminderStatus(
      String visitId,
      bool currentIsReminder,
      Map<String, dynamic> visitData,
      ) async {
    final User? currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error: Usuario no autenticado.', style: TextStyle(fontFamily: APP_FONT_FAMILY))),
        );
      }
      return;
    }

    final String userId = currentUser.uid;
    final int notificationId = visitId.hashCode; // Unique ID for notification

    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('animals')
          .doc(widget.animalId)
          .collection('visits')
          .doc(visitId)
          .update({'isReminder': !currentIsReminder});

      if (!currentIsReminder) { // Reminder was OFF, now turning ON
        DateTime visitDateTime;
        if (visitData['fecha'] is Timestamp) {
          visitDateTime = (visitData['fecha'] as Timestamp).toDate();
        } else if (visitData['fecha'] is String) {
          visitDateTime = DateTime.tryParse(visitData['fecha']) ?? DateTime.now();
        } else {
          visitDateTime = DateTime.now();
        }

        TimeOfDay visitTime;
        if (visitData['hora'] is String) {
          try {
            // Asume el formato de hora que showTimePicker devuelve, ej. "10:30 AM" o "14:00"
            // Intenta parsear como HH:mm (24h) o h:mm a (12h)
            final parsedTime = DateFormat('HH:mm').parse(visitData['hora']); // First try 24h format
            visitTime = TimeOfDay.fromDateTime(parsedTime);
          } catch (_) {
            try {
              final parsedTime = DateFormat('h:mm a').parse(visitData['hora']); // Then try 12h format
              visitTime = TimeOfDay.fromDateTime(parsedTime);
            } catch (e) {
              developer.log("Error parsing visit time string: ${visitData['hora']} - $e. Using current time.");
              visitTime = TimeOfDay.now(); // Fallback
            }
          }
        } else {
          visitTime = TimeOfDay.fromDateTime(visitDateTime); // Fallback to time from DateTime
        }


        // Schedule reminder for the visit's date and time
        DateTime scheduledTime = DateTime(
          visitDateTime.year,
          visitDateTime.month,
          visitDateTime.day,
          visitTime.hour,
          visitTime.minute,
        );

        // If the scheduled time is in the past, schedule it for the next day at the same time
        if (scheduledTime.isBefore(DateTime.now())) {
          scheduledTime = scheduledTime.add(const Duration(days: 1));
        }

        final String notificationTitle = 'Recordatorio de Visita para $_animalName';
        final String notificationBody =
            '${visitData['centroAtencionNombre'] ?? 'Centro Desconocido'} el ${DateFormat('dd/MM/yyyy').format(visitDateTime)} a las ${visitTime.format(context)}.';

        await flutterLocalNotificationsPlugin.zonedSchedule(
          notificationId,
          notificationTitle,
          notificationBody,
          tz.TZDateTime.from(scheduledTime, tz.local),
          const NotificationDetails(
            android: AndroidNotificationDetails(
              'daily_visit_channel', // New channel for visit reminders
              'Recordatorios de Visita Diaria',
              channelDescription: 'Recordatorios diarios para visitas veterinarias de tus animales.',
              importance: Importance.high,
              priority: Priority.high,
              ticker: 'Visita Veterinaria',
              playSound: true,
              enableVibration: true,
            ),
            iOS: DarwinNotificationDetails(
              sound: 'defaultCritical',
              presentAlert: true,
              presentBadge: true,
              presentSound: true,
            ),
          ),
          androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
          matchDateTimeComponents: DateTimeComponents.time, // Schedule daily reminder at this time
        );

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Recordatorio de visita para "${visitData['centroAtencionNombre'] ?? 'este centro'}" activado. Recibirás una notificación a las ${visitTime.format(context)} cada día.',
                style: const TextStyle(fontFamily: APP_FONT_FAMILY),
              ),
              backgroundColor: Colors.blue,
            ),
          );
        }
        developer.log('Scheduled daily notification with ID: $notificationId for visit: ${visitData['centroAtencionNombre']} starting at ${scheduledTime.toIso8601String()}');
      } else { // Reminder was ON, now turning OFF
        await flutterLocalNotificationsPlugin.cancel(notificationId);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Recordatorio de visita para "${visitData['centroAtencionNombre'] ?? 'este centro'}" desactivado.',
                style: const TextStyle(fontFamily: APP_FONT_FAMILY),
              ),
              backgroundColor: Colors.redAccent,
            ),
          );
        }
        developer.log('Canceled notification with ID: $notificationId for visit: ${visitData['centroAtencionNombre']}');
      }
    } catch (e) {
      developer.log("Error toggling visit reminder status: $e");
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al actualizar recordatorio de visita: $e', style: const TextStyle(fontFamily: APP_FONT_FAMILY)),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
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
          backgroundColor: CARD_BACKGROUND_COLOR,
          title: const Text('Confirmar Eliminación', style: TextStyle(fontFamily: APP_FONT_FAMILY, color: Colors.black)),
          content: const Text('¿Estás seguro de que quieres eliminar esta visita? Esta acción no se puede deshacer.', style: TextStyle(fontFamily: APP_FONT_FAMILY, color: Colors.black)),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancelar', style: TextStyle(fontFamily: APP_FONT_FAMILY, color: Colors.grey)),
              onPressed: () {
                Navigator.of(dialogContext).pop(false);
              },
            ),
            TextButton(
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              child: const Text('Eliminar', style: TextStyle(fontFamily: APP_FONT_FAMILY)),
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

        // Cancel associated notification (if any)
        await flutterLocalNotificationsPlugin.cancel(visitId.hashCode);

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Visita eliminada correctamente.', style: TextStyle(fontFamily: APP_FONT_FAMILY)), backgroundColor: Colors.green),
          );
        }
      } catch (e) {
        developer.log('Error al eliminar la visita: $e');
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error al eliminar la visita: $e', style: const TextStyle(fontFamily: APP_FONT_FAMILY)), backgroundColor: Colors.red),
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

    // Determine reminder status
    bool isReminderActive = visitData['isReminder'] == true;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
      width: 404.0,
      decoration: BoxDecoration(
        color: CARD_BACKGROUND_COLOR,
        borderRadius: BorderRadius.circular(20.0),
        border: Border.all(width: 1.0, color: const Color(0xe3000000)),
      ),
      padding: const EdgeInsets.all(20),
      child: Stack(
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              _buildInfoRow(iconPath: 'assets/images/fechavisita.png', iconWidth: 35.2, iconHeight: 40.0, text: 'Fecha: $formattedDate', tooltipMessage: 'Fecha de la visita'),
              const SizedBox(height: 10),
              _buildInfoRow(iconPath: 'assets/images/horavisita.png', iconWidth: 35.2, iconHeight: 40.0, text: 'Hora: $formattedTime', tooltipMessage: 'Hora de la visita'),
              const SizedBox(height: 10),
              _buildInfoRow(
                iconPath: 'assets/images/centrodeatencion.png',
                iconWidth: 35.2,
                iconHeight: 40.0,
                text: 'Centro: ${visitData['centroAtencionNombre'] ?? 'N/A'}\n${fullAddress.isNotEmpty ? fullAddress : 'Dirección no disponible'}',
                maxLines: 3,
                tooltipMessage: 'Centro de atención y dirección',
              ),
              const SizedBox(height: 10),
              _buildInfoRow(iconPath: 'assets/images/veterinario.png', iconWidth: 35.2, iconHeight: 40.0, text: 'Veterinario: ${visitData['veterinarioNombre'] ?? 'N/A'}', tooltipMessage: 'Nombre del veterinario'),
              const SizedBox(height: 10),
              _buildInfoRow(iconPath: 'assets/images/diagnostico.png', iconWidth: 35.2, iconHeight: 40.0, text: 'Diagnóstico: ${visitData['diagnostico'] ?? 'N/A'}', maxLines: 5, tooltipMessage: 'Diagnóstico de la visita'),
              const SizedBox(height: 10),
              _buildInfoRow(iconPath: 'assets/images/tratamiento.png', iconWidth: 35.2, iconHeight: 40.0, text: 'Tratamiento: ${visitData['tratamiento'] ?? 'N/A'}', maxLines: 5, tooltipMessage: 'Tratamiento aplicado'),
              const SizedBox(height: 10),
              _buildInfoRow(iconPath: 'assets/images/medicamentos.png', iconWidth: 35.2, iconHeight: 40.0, text: 'Medicamentos: ${visitData['medicamentos'] ?? 'N/A'}', maxLines: 5, tooltipMessage: 'Medicamentos recetados'),
              const SizedBox(height: 10),
              _buildInfoRow(iconPath: 'assets/images/observaciones.png', iconWidth: 35.2, iconHeight: 40.0, text: 'Observaciones: ${visitData['observaciones'] ?? 'N/A'}', maxLines: 5, tooltipMessage: 'Observaciones adicionales'),
              const SizedBox(height: 10),
              _buildInfoRow(iconPath: 'assets/images/costo.png', iconWidth: 35.2, iconHeight: 40.0, text: 'Costo: \$${(visitData['costo'] as num?)?.toStringAsFixed(2) ?? '0.00'}', tooltipMessage: 'Costo de la visita'),
              const SizedBox(height: 20),
              // Moved the reminder button here, at the bottom-center of the card
              Align(
                alignment: Alignment.center,
                child: _buildActionButton(
                  iconPath: 'assets/images/recordatorio.png', // New reminder icon
                  label: 'Recordatorio',
                  isActive: isReminderActive,
                  onTap: () => _toggleVisitReminderStatus(visitId, isReminderActive, visitData),
                  activeGlowColor: Colors.purple.shade200, // A nice glow color for reminders
                  imageSize: 120.0, // Set to 120x120px as requested
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
    required String tooltipMessage, // Nuevo parámetro para el Tooltip
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Tooltip( // Tooltip para el icono del campo de información
          message: tooltipMessage,
          child: Container(
            width: iconWidth,
            height: iconHeight,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(iconPath),
                fit: BoxFit.fill,
              ),
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              fontFamily: APP_FONT_FAMILY,
              fontSize: 16,
              color: APP_TEXT_COLOR,
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

  // Widget auxiliar para construir botones de acción con icono y texto (copied from Tratamientomedico.dart)
  Widget _buildActionButton({
    required String iconPath,
    required String label,
    required bool isActive,
    required VoidCallback onTap,
    Color activeGlowColor = Colors.white,
    double imageSize = 70.0, // Default to 70 for consistency, can be overridden
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: imageSize,
            height: imageSize,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(iconPath),
                fit: BoxFit.fill,
              ),
              borderRadius: BorderRadius.circular(10.0),
              boxShadow: isActive
                  ? [
                BoxShadow(
                  color: activeGlowColor.withOpacity(0.8),
                  blurRadius: 8.0,
                  spreadRadius: 3.0,
                  offset: const Offset(0, 0),
                ),
                BoxShadow(
                  color: activeGlowColor.withOpacity(0.4),
                  blurRadius: 15.0,
                  spreadRadius: 8.0,
                  offset: const Offset(0, 0),
                ),
              ]
                  : [],
              border: isActive
                  ? Border.all(color: activeGlowColor, width: 2.0)
                  : Border.all(color: Colors.transparent, width: 0.0),
            ),
          ),
          const SizedBox(height: 5),
          Text(
            label,
            style: TextStyle(
              fontFamily: APP_FONT_FAMILY,
              fontSize: 16,
              color: isActive ? activeGlowColor.darken(0.3) : APP_TEXT_COLOR,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    final User? currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser == null) {
      return Scaffold(
        backgroundColor: APP_BACKGROUND_COLOR,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.person_off, size: 80, color: Colors.white),
              const SizedBox(height: 20),
              const Text(
                'Usuario no autenticado. Por favor, inicia sesión.',
                style: TextStyle(fontFamily: APP_FONT_FAMILY, fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => Home(key: const Key('Home_VisitasNoUser'))),
                      (Route<dynamic> route) => false,
                ),
                style: ElevatedButton.styleFrom(backgroundColor: CARD_BACKGROUND_COLOR, foregroundColor: Colors.black),
                child: const Text('Ir a Inicio', style: TextStyle(fontFamily: APP_FONT_FAMILY, fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ),
      );
    }

    if (widget.animalId.isEmpty) {
      return Scaffold(
        backgroundColor: APP_BACKGROUND_COLOR,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.pets, size: 80, color: Colors.white),
              const SizedBox(height: 20),
              const Text(
                'No se ha seleccionado un animal. Por favor, selecciona uno.',
                style: TextStyle(fontFamily: APP_FONT_FAMILY, fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => const ListadeAnimales(key: Key('ListaAnimales_VisitasNoAnimalId'))),
                      (Route<dynamic> route) => false,
                ),
                style: ElevatedButton.styleFrom(backgroundColor: CARD_BACKGROUND_COLOR, foregroundColor: Colors.black),
                child: const Text('Ver mis Animales', style: TextStyle(fontFamily: APP_FONT_FAMILY, fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ),
      );
    }

    final String currentUserId = currentUser!.uid;

    return Scaffold(
      backgroundColor: APP_BACKGROUND_COLOR,
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
            child: Tooltip( // Tooltip añadido
              message: 'Ir a Inicio',
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
          ),
          // --- Botón de Retroceso a FuncionesdelaApp (con reemplazo) ---
          Pinned.fromPins(
            Pin(size: 52.9, start: 9.1),
            Pin(size: 50.0, start: 49.0),
            child: Tooltip( // Tooltip añadido
              message: 'Volver a Funciones del Animal',
              child: GestureDetector(
                onTap: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => FuncionesdelaApp(key: const Key('Funciones_BackFromVisitas'), animalId: widget.animalId),
                    ),
                  );
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
          ),
          // --- Botón de Ayuda ---
          Pinned.fromPins(
            Pin(size: 40.5, end: 7.6 + 47.2 + 5.0),
            Pin(size: 50.0, start: 49.0),
            child: Tooltip( // Tooltip añadido
              message: 'Ayuda y Soporte',
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
          ),
          // --- Botón de Configuración ---
          Pinned.fromPins(
            Pin(size: 47.2, end: 7.6),
            Pin(size: 50.0, start: 49.0),
            child: Tooltip( // Tooltip añadido
              message: 'Configuraciones de la Aplicación',
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
                  .doc(currentUserId)
                  .collection('animals')
                  .doc(widget.animalId)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircleAvatar(radius: 45, backgroundColor: Colors.grey[300], child: const CircularProgressIndicator(strokeWidth: 2.0, valueColor: AlwaysStoppedAnimation<Color>(APP_PRIMARY_COLOR))));
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
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    if (mounted && _animalName != animalData.nombre) {
                      setState(() {
                        _animalName = animalData.nombre;
                      });
                    }
                  });
                } catch (e) {
                  developer.log("Error al deserializar datos del animal (ID: ${widget.animalId}): $e. Data: ${snapshot.data!.data()}");
                  return Center(child: CircleAvatar(radius: 45, backgroundColor: Colors.orange[100], child: Icon(Icons.report_problem_outlined, size: 50, color: Colors.orange[700])));
                }

                return Center(
                  child: Tooltip( // Tooltip añadido para la foto de perfil
                    message: 'Ver perfil de ${animalData.nombre}',
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
                                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.3), spreadRadius: 2, blurRadius: 5, offset: const Offset(0,3))]
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
                                style: const TextStyle(
                                    fontFamily: APP_FONT_FAMILY,
                                    fontSize: 16,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    shadows: [Shadow(blurRadius: 1.0, color: Colors.black, offset: Offset(1.0,1.0))]
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
                : Center(
                child: Tooltip(
                    message: currentUser == null ? "Usuario no autenticado" : "ID de animal no válido",
                    child: CircleAvatar(radius: 45, backgroundColor: Colors.grey[200], child: const Icon(Icons.error_outline, size: 50, color: Colors.grey))
                )
            ),
          ),

          // --- Botón de Funciones (Posición ajustada) ---
          Pinned.fromPins(
            Pin(size: 62.7, start: 6.7),
            Pin(size: 70.0, start: navButtonRowTop),
            child: Tooltip( // Tooltip añadido
              message: 'Volver a Funciones del Animal',
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
          ),

          // --- Botón de Lista de Animales (ya existente) ---
          Pinned.fromPins(
            Pin(size: 60.1, end: 7.6),
            Pin(size: 60.0, start: navButtonRowTop),
            child: Tooltip( // Tooltip añadido
              message: 'Ver todos mis animales',
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
                      color: CARD_BACKGROUND_COLOR,
                      borderRadius: BorderRadius.circular(10.0),
                      border: Border.all(width: 1.0, color: const Color(0xe3000000)),
                    ),
                    child: const Center(
                      child: Text(
                        'Visitas al Veterinario',
                        style: TextStyle(
                          fontFamily: APP_FONT_FAMILY,
                          fontSize: 20,
                          color: APP_TEXT_COLOR,
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
                        .doc(currentUserId)
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
                              'No hay visitas registradas para este animal.\nPulsa "Crear Visita" para añadir una.',
                              style: TextStyle(fontFamily: APP_FONT_FAMILY, fontSize: 18, color: Colors.black87),
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
                      child: Tooltip( // Tooltip añadido al botón de crear visita
                        message: 'Añadir una nueva visita veterinaria',
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
                              setState(() {}); // Forzar recarga si se creó una visita
                            }
                          },
                          child: Column(
                            mainAxisSize: MainAxisSize.min, // Asegura que la columna ocupe el mínimo espacio
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
                                  fontFamily: APP_FONT_FAMILY,
                                  fontSize: 20,
                                  color: APP_TEXT_COLOR,
                                  fontWeight: FontWeight.w700,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
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
  String? _selectedAddressType;
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
    _initializeControllers();
    _loadAnimalData();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isTimeControllerTextSet) {
      if (_selectedTime != null) {
        _timeController.text = _selectedTime!.format(context);
      }
      _isTimeControllerTextSet = true;
    }
  }

  void _initializeControllers() {
    if (widget.visitData['fecha'] is Timestamp) {
      _selectedDate = (widget.visitData['fecha'] as Timestamp).toDate();
    } else if (widget.visitData['fecha'] is String) {
      _selectedDate = DateTime.tryParse(widget.visitData['fecha']);
    } else {
      _selectedDate = DateTime.now();
    }

    if (_selectedDate != null) {
      final String? timeString = widget.visitData['hora'] as String?;
      if (timeString != null && timeString.isNotEmpty) {
        try {
          final tempTimeOfDay = TimeOfDay.fromDateTime(DateFormat.jm().parse(timeString));
          _selectedTime = tempTimeOfDay;
        } catch (e) {
          developer.log("Error al parsear el string de hora '$timeString': $e. Usando hora de la fecha.");
          _selectedTime = TimeOfDay.fromDateTime(_selectedDate!);
        }
      } else {
        _selectedTime = TimeOfDay.fromDateTime(_selectedDate!);
      }
    } else {
      _selectedDate = DateTime.now();
      _selectedTime = TimeOfDay.now();
    }

    _diagnosticoController = TextEditingController(text: widget.visitData['diagnostico'] ?? '');
    _tratamientoController = TextEditingController(text: widget.visitData['tratamiento'] ?? '');
    _medicamentosController = TextEditingController(text: widget.visitData['medicamentos'] ?? '');
    _observacionesController = TextEditingController(text: widget.visitData['observaciones'] ?? '');
    _costoController = TextEditingController(text: (widget.visitData['costo'] as num?)?.toStringAsFixed(2) ?? '0.00');
    _veterinarianNameController = TextEditingController(text: widget.visitData['veterinarioNombre'] ?? '');

    _centerNameController = TextEditingController(text: widget.visitData['centroAtencionNombre'] ?? '');
    _selectedAddressType = widget.visitData['centroAtencionTipoVia'];
    _addressNumberController = TextEditingController(text: widget.visitData['centroAtencionNumeroVia'] ?? '');
    _addressComplementController = TextEditingController(text: widget.visitData['centroAtencionComplemento'] ?? '');

    _dateController = TextEditingController(text: _selectedDate != null ? DateFormat('dd/MM/yyyy').format(_selectedDate!) : '');
    _timeController = TextEditingController();

    _currentLocationString = widget.visitData['centroAtencionCoordenadas'] ?? 'No disponible';
  }

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
              primary: APP_PRIMARY_COLOR,
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

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime ?? TimeOfDay.now(),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: const ColorScheme.light(
              primary: APP_PRIMARY_COLOR,
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

      await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('animals')
          .doc(widget.animalId)
          .collection('visits')
          .doc(widget.visitId)
          .update({
        'fecha': visitDateTime,
        'hora': _selectedTime!.format(context),
        'centroAtencionNombre': _centerNameController.text.trim(),
        'centroAtencionTipoVia': _selectedAddressType,
        'centroAtencionNumeroVia': _addressNumberController.text.trim(),
        'centroAtencionComplemento': _addressComplementController.text.trim(),
        'centroAtencionDireccionCompleta': _buildFullAddress(),
        'veterinarioNombre': _veterinarianNameController.text.trim(),
        'diagnostico': _diagnosticoController.text.trim(),
        'tratamiento': _tratamientoController.text.trim(),
        'medicamentos': _medicamentosController.text.trim(),
        'observaciones': _observacionesController.text.trim(),
        'costo': double.tryParse(_costoController.text.trim().replaceAll(',', '.')) ?? 0.0,
        'lastUpdated': FieldValue.serverTimestamp(),
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Visita actualizada con éxito!')));
        Navigator.pop(context, true);
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
    required String tooltipMessage, // Nuevo parámetro para el Tooltip
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
            style: const TextStyle(fontFamily: APP_FONT_FAMILY, fontSize: 15, color: Colors.black87),
            decoration: InputDecoration(
              labelText: label,
              labelStyle: const TextStyle(fontFamily: APP_FONT_FAMILY, color: Colors.black54, fontSize: 15),
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
            padding: const EdgeInsets.only(left: iconLeftPadding),
            child: Tooltip( // Tooltip para el icono del campo de formulario
              message: tooltipMessage,
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
          ),
        ],
      ),
    );
  }

  void _showLargeImage(String imageUrl) {
    Widget imageWidget = CachedNetworkImage(
      imageUrl: imageUrl,
      fit: BoxFit.contain,
      placeholder: (context, url) => const Center(
          child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(APP_PRIMARY_COLOR))),
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
    final double headerHeight = animalPhotoSize + animalNameHeight + spaceAfterAnimalPhoto;
    final double mainContentTopPadding = AppBar().preferredSize.height + headerHeight + 20;

    return FractionallySizedBox(
      heightFactor: 0.92,
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20.0),
          topRight: Radius.circular(20.0),
        ),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            title: const Text('Editar Visita Veterinaria', style: TextStyle(fontFamily: APP_FONT_FAMILY, color: Colors.white)),
            backgroundColor: APP_PRIMARY_COLOR,
            elevation: 1,
            automaticallyImplyLeading: false,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20.0),
                topRight: Radius.circular(20.0),
              ),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.close, color: Colors.white),
                onPressed: () => Navigator.of(context).pop(),
              )
            ],
          ),
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

              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: _isLoading
                    ? Center(child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(APP_PRIMARY_COLOR)),
                ))
                    : _animalData != null
                    ? Center(
                  child: Tooltip( // Tooltip para la foto del animal en el modal
                    message: 'Ver perfil de ${_animalData!.nombre}',
                    child: GestureDetector(
                      onTap: (_animalData!.fotoPerfilUrl != null && _animalData!.fotoPerfilUrl!.isNotEmpty)
                          ? () => _showLargeImage(_animalData!.fotoPerfilUrl!)
                          : null,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: animalPhotoSize, height: animalPhotoSize,
                            margin: const EdgeInsets.only(top: 20.0),
                            decoration: BoxDecoration(
                                color: Colors.grey[300],
                                borderRadius: BorderRadius.circular(25.0),
                                border: Border.all(color: Colors.white, width: 2.5),
                                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.3), spreadRadius: 2, blurRadius: 5, offset: const Offset(0,3))]
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
                                style: const TextStyle(
                                    fontFamily: APP_FONT_FAMILY,
                                    fontSize: 16,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    shadows: [Shadow(blurRadius: 1.0, color: Colors.black, offset: Offset(1.0,1.0))]
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                )
                    : const SizedBox.shrink(),
              ),

              Positioned(
                top: mainContentTopPadding,
                left: 20,
                right: 20,
                bottom: 0,
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 0.0),
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: CARD_BACKGROUND_COLOR.withOpacity(0.95),
                    borderRadius: BorderRadius.circular(20.0),
                    border: Border.all(width: 1.5, color: APP_PRIMARY_COLOR),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x29000000),
                        offset: Offset(0, 3),
                        blurRadius: 6,
                      ),
                    ],
                  ),
                  child: Form(
                    key: _formKey,
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          const Text(
                            'Detalles de la Visita',
                            style: TextStyle(
                              fontFamily: APP_FONT_FAMILY,
                              fontSize: 20,
                              color: APP_TEXT_COLOR,
                              fontWeight: FontWeight.w700,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const Divider(color: APP_PRIMARY_COLOR, thickness: 1.0, height: 25),
                          _buildFormField(
                            controller: _dateController,
                            label: 'Fecha de la Visita',
                            iconAsset: 'assets/images/fechavisita.png',
                            readOnly: true,
                            onTap: () => _selectDate(context),
                            suffixIcon: const Icon(Icons.calendar_today, color: Colors.grey),
                            tooltipMessage: 'Seleccionar la fecha de la visita',
                          ),
                          _buildFormField(
                            controller: _timeController,
                            label: 'Hora de la Visita',
                            iconAsset: 'assets/images/horavisita.png',
                            readOnly: true,
                            onTap: () => _selectTime(context),
                            suffixIcon: const Icon(Icons.access_time, color: Colors.grey),
                            tooltipMessage: 'Seleccionar la hora de la visita',
                          ),
                          _buildFormField(
                            controller: _centerNameController,
                            label: 'Nombre del Centro de Atención',
                            iconAsset: 'assets/images/centrodeatencion.png',
                            validator: (v) => v!.isEmpty ? 'Ingrese el nombre del centro de atención' : null,
                            tooltipMessage: 'Nombre del centro o clínica veterinaria',
                          ),
                          Container(
                            margin: const EdgeInsets.only(bottom: 18.0),
                            child: Stack(
                              alignment: Alignment.centerLeft,
                              children: [
                                Tooltip( // Tooltip para el DropdownButtonFormField de Tipo de Vía
                                  message: 'Seleccionar el tipo de vía (calle, carrera, etc.)',
                                  child: DropdownButtonFormField<String>(
                                    decoration: InputDecoration(
                                      labelText: 'Tipo de Vía',
                                      labelStyle: const TextStyle(fontFamily: APP_FONT_FAMILY, color: Colors.black54, fontSize: 15),
                                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.0), borderSide: BorderSide(color: Colors.grey.shade400)),
                                      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12.0), borderSide: BorderSide(color: Colors.grey.shade500)),
                                      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12.0), borderSide: BorderSide(color: Theme.of(context).primaryColor, width: 1.5)),
                                      filled: true,
                                      fillColor: Colors.white.withOpacity(0.9),
                                      contentPadding: const EdgeInsets.only(left: 55.0, right: 10.0, top: 18, bottom: 18),
                                    ),
                                    hint: Text('Seleccione el tipo de vía', style: TextStyle(fontFamily: APP_FONT_FAMILY, color: Colors.grey[600], fontSize: 15)),
                                    value: _selectedAddressType,
                                    isExpanded: true,
                                    icon: const Icon(Icons.arrow_drop_down, color: APP_PRIMARY_COLOR),
                                    style: const TextStyle(fontFamily: APP_FONT_FAMILY, color: Colors.black87, fontSize: 15),
                                    dropdownColor: Colors.white,
                                    items: const ['Calle', 'Carrera', 'Avenida', 'Diagonal', 'Transversal', 'Circular', 'Autopista', 'Vereda', 'Kilómetro'].map<DropdownMenuItem<String>>((String value) {
                                      return DropdownMenuItem<String>(value: value, child: Text(value));
                                    }).toList(),
                                    onChanged: (String? newValue) {
                                      setState(() {
                                        _selectedAddressType = newValue;
                                      });
                                    },
                                    validator: (value) => value == null ? 'Seleccione el tipo de vía' : null,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 10.0),
                                  child: Tooltip( // Tooltip para el icono de Ubicación
                                    message: 'Icono de Ubicación',
                                    child: Image.asset('assets/images/ubicacion.png', width: 42, height: 42, fit: BoxFit.contain),
                                  ),
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
                            tooltipMessage: 'Número de la calle o vía',
                          ),
                          _buildFormField(
                            controller: _addressComplementController,
                            label: 'Números Complementarios (Ej: # 114-35)',
                            iconAsset: 'assets/images/#.png',
                            tooltipMessage: 'Complemento de la dirección (ej: # 114-35)',
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 18.0),
                            child: Tooltip( // Tooltip para el campo de Coordenadas GPS
                              message: 'Coordenadas GPS de la ubicación (no editable)',
                              child: InputDecorator(
                                decoration: InputDecoration(
                                    labelText: 'Coordenadas GPS',
                                    labelStyle: const TextStyle(fontFamily: APP_FONT_FAMILY, color: Colors.black54, fontSize: 15),
                                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.0), borderSide: BorderSide(color: Colors.grey.shade400)),
                                    enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12.0), borderSide: BorderSide(color: Colors.grey.shade500)),
                                    filled: true,
                                    fillColor: Colors.grey[200],
                                    contentPadding: const EdgeInsets.only(left: 55.0, top: 18, bottom: 18, right: 15),
                                    prefixIconConstraints: const BoxConstraints(minWidth: 52, minHeight: 52),
                                    prefixIcon: Padding(
                                      padding: const EdgeInsets.only(left: 10.0, right:0.0),
                                      child: Tooltip( // Tooltip para el icono de Coordenadas
                                        message: 'Icono de Coordenadas',
                                        child: Image.asset('assets/images/coordenada.png', width: 42, height: 42, fit: BoxFit.contain),
                                      ),
                                    )
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 1.0),
                                  child: Text(_currentLocationString, style: const TextStyle(fontFamily: APP_FONT_FAMILY, fontSize: 15, color: Colors.black87)),
                                ),
                              ),
                            ),
                          ),
                          _buildFormField(
                            controller: _veterinarianNameController,
                            label: 'Nombre del Veterinario',
                            iconAsset: 'assets/images/veterinario.png',
                            validator: (v) => v!.isEmpty ? 'Ingrese nombre del veterinario' : null,
                            tooltipMessage: 'Nombre del veterinario que atendió al animal',
                          ),
                          _buildFormField(
                            controller: _diagnosticoController,
                            label: 'Diagnóstico',
                            iconAsset: 'assets/images/diagnostico.png',
                            maxLines: 3,
                            validator: (v) => v!.isEmpty ? 'Ingrese diagnóstico' : null,
                            tooltipMessage: 'Diagnóstico de la condición del animal',
                          ),
                          _buildFormField(
                            controller: _tratamientoController,
                            label: 'Tratamiento',
                            iconAsset: 'assets/images/tratamiento.png',
                            maxLines: 3,
                            validator: (v) => v!.isEmpty ? 'Ingrese tratamiento' : null,
                            tooltipMessage: 'Tratamiento recetado para el animal',
                          ),
                          _buildFormField(
                            controller: _medicamentosController,
                            label: 'Medicamentos',
                            iconAsset: 'assets/images/medicamentos.png',
                            maxLines: 3,
                            tooltipMessage: 'Medicamentos y dosis prescritas',
                          ),
                          _buildFormField(
                            controller: _observacionesController,
                            label: 'Observaciones',
                            iconAsset: 'assets/images/observaciones.png',
                            maxLines: 3,
                            tooltipMessage: 'Cualquier observación adicional relevante',
                          ),
                          _buildFormField(
                            controller: _costoController,
                            label: 'Costo (\$)',
                            iconAsset: 'assets/images/costo.png',
                            keyboardType: const TextInputType.numberWithOptions(decimal: true),
                            validator: (v) => v!.isEmpty ? 'Ingrese costo' : (double.tryParse(v.replaceAll(',', '.')) == null ? 'Número inválido' : null),
                            tooltipMessage: 'Costo total de la visita',
                          ),
                          const SizedBox(height: 20),
                          Tooltip( // Tooltip para el botón de guardar cambios
                            message: 'Guardar los cambios de la visita',
                            child: GestureDetector(
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
                          ),
                          const SizedBox(height: 30),
                        ],
                      ),
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