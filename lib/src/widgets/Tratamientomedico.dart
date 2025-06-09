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

// Core functionality imports
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart'; // Para formatear fechas
import 'dart:developer' as developer; // Para logs más detallados

// NEW IMPORTS FOR NOTIFICATIONS
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

// Extension para oscurecer colores
extension ColorExtension on Color {
  Color darken([double amount = .1]) {
    assert(amount >= 0 && amount <= 1);
    final hsl = HSLColor.fromColor(this);
    final hslDark = hsl.withLightness((hsl.lightness - amount).clamp(0.0, 1.0));
    return hslDark.toColor();
  }
}

// --- Modelo de Tratamiento Médico (Integrado en el mismo archivo) ---
class MedicalTreatment {
  final String id; // ID del documento en Firestore
  final String medicineName;
  final String dose;
  final String duration; // Ej: "1 semana", "10 días"
  final String veterinarian;
  final DateTime startDate;
  final DateTime? endDate; // Opcional, si la duración es fija o indefinida
  final String? notes; // Notas adicionales (opcional)
  final bool isReminderEnabled; // Para futuras funcionalidades de recordatorios
  final bool isSupplied; // Para marcar si una dosis/tratamiento ha sido suministrada

  MedicalTreatment({
    this.id = '', // Por defecto vacío para nuevos tratamientos antes de ser guardados
    required this.medicineName,
    required this.dose,
    required this.duration,
    required this.veterinarian,
    required this.startDate,
    this.endDate,
    this.notes,
    this.isReminderEnabled = false, // Valor por defecto
    this.isSupplied = false, // Valor por defecto
  });

  // Convierte un objeto MedicalTreatment a un mapa para guardar en Firestore
  Map<String, dynamic> toMap() {
    return {
      'medicineName': medicineName,
      'dose': dose,
      'duration': duration,
      'veterinarian': veterinarian,
      'startDate': Timestamp.fromDate(startDate), // Guarda la fecha como Timestamp
      'endDate': endDate != null ? Timestamp.fromDate(endDate!) : null,
      'notes': notes,
      'isReminderEnabled': isReminderEnabled,
      'isSupplied': isSupplied,
      'createdAt': FieldValue.serverTimestamp(), // Marca de tiempo de creación
    };
  }

  // Crea un objeto MedicalTreatment desde un DocumentSnapshot de Firestore
  factory MedicalTreatment.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return MedicalTreatment(
      id: doc.id, // Asigna el ID del documento
      medicineName: data['medicineName'] ?? 'Sin Nombre',
      dose: data['dose'] ?? 'Sin Dosis',
      duration: data['duration'] ?? 'Sin Duración',
      veterinarian: data['veterinarian'] ?? 'Desconocido',
      startDate: (data['startDate'] as Timestamp).toDate(), // Convierte Timestamp a DateTime
      endDate: (data['endDate'] as Timestamp?)?.toDate(), // Puede ser nulo
      notes: data['notes'],
      isReminderEnabled: data['isReminderEnabled'] ?? false,
      isSupplied: data['isSupplied'] ?? false,
    );
  }

  // Método para crear una copia del objeto con valores modificados (útil para inmutabilidad)
  MedicalTreatment copyWith({
    String? id,
    String? medicineName,
    String? dose,
    String? duration,
    String? veterinarian,
    DateTime? startDate,
    DateTime? endDate,
    String? notes,
    bool? isReminderEnabled,
    bool? isSupplied,
  }) {
    return MedicalTreatment(
      id: id ?? this.id,
      medicineName: medicineName ?? this.medicineName,
      dose: dose ?? this.dose,
      duration: duration ?? this.duration,
      veterinarian: veterinarian ?? this.veterinarian,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      notes: notes ?? this.notes,
      isReminderEnabled: isReminderEnabled ?? this.isReminderEnabled,
      isSupplied: isSupplied ?? this.isSupplied,
    );
  }
}

// --- Clase Principal Tratamientomedico ---
class Tratamientomedico extends StatefulWidget {
  final String animalId;

  const Tratamientomedico({
    required Key key,
    required this.animalId,
  }) : super(key: key);

  @override
  _TratamientomedicoState createState() => _TratamientomedicoState();
}

class _TratamientomedicoState extends State<Tratamientomedico> {
  final User? currentUser = FirebaseAuth.instance.currentUser;

  late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  String _animalName = 'tu animal'; // Nombre por defecto para notificaciones

  @override
  void initState() {
    super.initState();
    _initNotifications();
    _loadAnimalName();
  }

  // Inicializar notificaciones locales
  Future<void> _initNotifications() async {
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('app_icon');

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

  // Cargar el nombre del animal para notificaciones
  Future<void> _loadAnimalName() async {
    if (currentUser == null || widget.animalId.isEmpty) return;

    try {
      DocumentSnapshot doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser!.uid)
          .collection('animals')
          .doc(widget.animalId)
          .get();
      if (doc.exists) {
        setState(() {
          _animalName = Animal.fromFirestore(doc).nombre;
        });
      }
    } catch (e) {
      developer.log("Error loading animal name for notification: $e");
    }
  }

  // Constantes de posicionamiento para elementos de la UI
  static const double logoBottomY = 115.0;
  static const double spaceAfterLogo = 25.0;
  static const double animalProfilePhotoTop = logoBottomY + spaceAfterLogo;
  static const double animalProfilePhotoHeight = 90.0;
  static const double animalNameHeight = 20.0;
  static const double spaceAfterAnimalProfile = 15.0;
  static const double titleContentTop = animalProfilePhotoTop + animalProfilePhotoHeight + animalNameHeight + spaceAfterAnimalProfile;

  // Método para cambiar el estado de suministrado
  Future<void> _toggleSuppliedStatus(MedicalTreatment treatment) async {
    if (currentUser == null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error: Usuario no autenticado.', style: TextStyle(fontFamily: APP_FONT_FAMILY))),
        );
      }
      return;
    }

    final String userId = currentUser!.uid;
    final String animalId = widget.animalId;

    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('animals')
          .doc(animalId)
          .collection('treatments')
          .doc(treatment.id)
          .update({'isSupplied': !treatment.isSupplied});

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Tratamiento "${treatment.medicineName}" marcado como ${!treatment.isSupplied ? 'suministrado' : 'pendiente'}',
              style: const TextStyle(fontFamily: APP_FONT_FAMILY),
            ),
            backgroundColor: !treatment.isSupplied ? Colors.green : Colors.orange,
          ),
        );
      }
    } catch (e) {
      developer.log("Error toggling supplied status: $e");
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al actualizar estado: $e', style: const TextStyle(fontFamily: APP_FONT_FAMILY)),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  // Método para cambiar el estado del recordatorio y programar/cancelar notificaciones
  Future<void> _toggleReminderStatus(MedicalTreatment treatment) async {
    if (currentUser == null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error: Usuario no autenticado.', style: TextStyle(fontFamily: APP_FONT_FAMILY))),
        );
      }
      return;
    }

    final String userId = currentUser!.uid;
    final String animalId = widget.animalId;
    final int notificationId = treatment.id.hashCode;

    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('animals')
          .doc(animalId)
          .collection('treatments')
          .doc(treatment.id)
          .update({'isReminderEnabled': !treatment.isReminderEnabled});

      if (!treatment.isReminderEnabled) { // Si el recordatorio estaba APAGADO, ahora se enciende
        DateTime reminderStart = treatment.startDate;
        if (reminderStart.isBefore(DateTime.now())) {
          reminderStart = DateTime.now();
        }

        DateTime scheduledTime = DateTime(
          reminderStart.year,
          reminderStart.month,
          reminderStart.day,
          9, // 9 AM
          0,
          0,
        );

        if (scheduledTime.isBefore(DateTime.now())) {
          scheduledTime = scheduledTime.add(const Duration(days: 1));
        }

        final String notificationTitle = 'Recordatorio: Medicamento para $_animalName';
        final String notificationBody = '${treatment.medicineName} - Dosis: ${treatment.dose}. Duración: ${treatment.duration}';

        await flutterLocalNotificationsPlugin.zonedSchedule(
          notificationId,
          notificationTitle,
          notificationBody,
          tz.TZDateTime.from(scheduledTime, tz.local),
          const NotificationDetails(
            android: AndroidNotificationDetails(
              'daily_treatment_channel',
              'Recordatorios de Tratamiento Diario',
              channelDescription: 'Recordatorios diarios para la administración de medicamentos a tus animales.',
              importance: Importance.high,
              priority: Priority.high,
              ticker: 'ticker',
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
          matchDateTimeComponents: DateTimeComponents.time,
        );

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Recordatorio para "${treatment.medicineName}" activado. Recibirás una notificación a las ${DateFormat('HH:mm').format(scheduledTime)} cada día.',
                style: const TextStyle(fontFamily: APP_FONT_FAMILY),
              ),
              backgroundColor: Colors.blue,
            ),
          );
        }
        developer.log('Scheduled daily notification with ID: $notificationId for treatment: ${treatment.medicineName} starting at ${scheduledTime.toIso8601String()}');

      } else { // Si el recordatorio estaba ENCENDIDO, ahora se apaga
        await flutterLocalNotificationsPlugin.cancel(notificationId);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Recordatorio para "${treatment.medicineName}" desactivado.',
                style: const TextStyle(fontFamily: APP_FONT_FAMILY),
              ),
              backgroundColor: Colors.redAccent,
            ),
          );
        }
        developer.log('Canceled notification with ID: $notificationId for treatment: ${treatment.medicineName}');
      }
    } catch (e) {
      developer.log("Error toggling reminder status: $e");
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al actualizar recordatorio: $e', style: const TextStyle(fontFamily: APP_FONT_FAMILY)),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  // Método para eliminar un tratamiento
  Future<void> _deleteTreatment(String treatmentId) async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Usuario no autenticado. Por favor, inicie sesión.', style: TextStyle(fontFamily: APP_FONT_FAMILY))),
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
          content: const Text('¿Estás seguro de que quieres eliminar este tratamiento? Esta acción no se puede deshacer.', style: TextStyle(fontFamily: APP_FONT_FAMILY, color: Colors.black)),
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
            .collection('treatments')
            .doc(treatmentId)
            .delete();

        await flutterLocalNotificationsPlugin.cancel(treatmentId.hashCode);

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Tratamiento eliminado correctamente.', style: TextStyle(fontFamily: APP_FONT_FAMILY)), backgroundColor: Colors.green),
          );
        }
      } catch (e) {
        developer.log('Error al eliminar el tratamiento: $e');
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error al eliminar el tratamiento: $e', style: const TextStyle(fontFamily: APP_FONT_FAMILY)), backgroundColor: Colors.red),
          );
        }
      }
    }
  }

  // Mostrar Modal de Edición de Tratamiento
  Future<void> _showEditTreatmentModal(MedicalTreatment treatment) async {
    final result = await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext modalContext) {
        return _EditarTratamientoMedicoModalWidget(
          key: Key('edit_treatment_modal_${treatment.id}'),
          animalId: widget.animalId,
          initialTreatment: treatment, // Pasar los datos del tratamiento para edición
        );
      },
    );

    if (result == true) {
      setState(() {});
    }
  }

  // Mostrar Modal de Creación de Tratamiento
  Future<void> _showCreateTreatmentModal() async {
    final result = await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext modalContext) {
        return _EditarTratamientoMedicoModalWidget(
          key: const Key('create_treatment_modal'),
          animalId: widget.animalId,
          initialTreatment: null, // Null indica que es modo de creación
        );
      },
    );

    if (result == true) {
      setState(() {});
    }
  }

  // Método para construir una tarjeta individual de tratamiento médico (ACTUALIZADO con posicionamiento de botones)
  Widget _buildTreatmentCard(BuildContext context, MedicalTreatment treatment) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
      decoration: BoxDecoration(
        color: CARD_BACKGROUND_COLOR.withOpacity(0.9),
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
      padding: const EdgeInsets.all(16.0),
      child: Stack(
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Align(
                alignment: Alignment.center,
                child: Text(
                  treatment.medicineName,
                  style: const TextStyle(
                    fontFamily: APP_FONT_FAMILY,
                    fontSize: 22,
                    color: APP_TEXT_COLOR,
                    fontWeight: FontWeight.w700,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const Divider(color: APP_PRIMARY_COLOR, thickness: 1.5, height: 20),
              _buildInfoRow('Dosis:', treatment.dose),
              _buildInfoRow('Duración:', treatment.duration),
              _buildInfoRow('Veterinario:', treatment.veterinarian),
              _buildInfoRow('Inicio:', DateFormat('dd/MM/yyyy').format(treatment.startDate)),
              if (treatment.endDate != null)
                _buildInfoRow('Fin:', DateFormat('dd/MM/yyyy').format(treatment.endDate!)),
              if (treatment.notes != null && treatment.notes!.isNotEmpty)
                _buildInfoRow('Notas:', treatment.notes!),
              const SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildActionButton(
                    iconPath: 'assets/images/recordatorio.png',
                    label: 'Recordatorio',
                    isActive: treatment.isReminderEnabled,
                    onTap: () => _toggleReminderStatus(treatment),
                    activeGlowColor: Colors.deepPurpleAccent.shade100,
                    tooltipMessage: treatment.isReminderEnabled ? 'Desactivar recordatorio' : 'Activar recordatorio diario',
                  ),
                  _buildActionButton(
                    iconPath: 'assets/images/suministrado.png',
                    label: 'Suministrado',
                    isActive: treatment.isSupplied,
                    onTap: () => _toggleSuppliedStatus(treatment),
                    activeGlowColor: Colors.lightGreenAccent,
                    tooltipMessage: treatment.isSupplied ? 'Marcar como pendiente' : 'Marcar como suministrado',
                  ),
                ],
              ),
            ],
          ),
          Positioned( // Posicionamiento de botones de editar y eliminar
            top: -4,
            right: 0,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Image.asset(
                    'assets/images/editar.png',
                    height: 40,
                    width: 40,
                  ),
                  tooltip: 'Editar tratamiento',
                  onPressed: () => _showEditTreatmentModal(treatment),
                ),
                IconButton(
                  icon: Image.asset(
                    'assets/images/eliminar.png',
                    height: 40,
                    width: 40,
                  ),
                  tooltip: 'Eliminar tratamiento',
                  onPressed: () => _deleteTreatment(treatment.id),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Widget auxiliar para construir una fila de información (label y valor)
  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontFamily: APP_FONT_FAMILY,
              fontSize: 17,
              color: APP_TEXT_COLOR,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontFamily: APP_FONT_FAMILY,
                fontSize: 17,
                color: APP_TEXT_COLOR,
              ),
              softWrap: true,
            ),
          ),
        ],
      ),
    );
  }

  // Widget auxiliar para construir botones de acción con icono y texto
  Widget _buildActionButton({
    required String iconPath,
    required String label,
    required bool isActive,
    required VoidCallback onTap,
    Color activeGlowColor = Colors.white,
    double imageSize = 70.0, // Default to 70 for consistency, can be overridden
    required String tooltipMessage, // Added tooltip message
  }) {
    return Tooltip( // Tooltip para el botón de acción
      message: tooltipMessage,
      child: GestureDetector(
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
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
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
                  MaterialPageRoute(builder: (context) => Home(key: const Key('Home_TratamientoNoUser'))),
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
                  MaterialPageRoute(builder: (context) => const ListadeAnimales(key: Key('ListaAnimales_TratamientoNoAnimalId'))),
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
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/Animal Health Fondo de Pantalla.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
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
                    pageBuilder: () => Home(key: const Key('Home_From_Tratamiento')),
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
          Pinned.fromPins(
            Pin(size: 52.9, start: 15.0), Pin(size: 50.0, start: 49.0),
            child: Tooltip( // Tooltip añadido
              message: 'Volver a Funciones del Animal',
              child: InkWell(
                onTap: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => FuncionesdelaApp(key: const Key('Funciones_BackFromTratamiento'), animalId: widget.animalId),
                    ),
                  );
                },
                child: Container(decoration: const BoxDecoration(image: DecorationImage(image: AssetImage('assets/images/back.png'), fit: BoxFit.fill))),
              ),
            ),
          ),
          Pinned.fromPins(
            Pin(size: 40.5, end: 15.0), Pin(size: 50.0, start: 49.0),
            child: Tooltip( // Tooltip añadido
              message: 'Ayuda y Soporte',
              child: PageLink(
                links: [PageLinkInfo(pageBuilder: () => Ayuda(key: const Key('Ayuda_From_Tratamiento')))],
                child: Container(decoration: const BoxDecoration(image: DecorationImage(image: AssetImage('assets/images/help.png'), fit: BoxFit.fill))),
              ),
            ),
          ),
          Pinned.fromPins(
            Pin(size: 47.2, end: 15.0), Pin(size: 50.0, start: 110.0),
            child: Tooltip( // Tooltip añadido
              message: 'Configuraciones de la Aplicación',
              child: PageLink(
                links: [
                  PageLinkInfo(
                    pageBuilder: () => Configuraciones(key: const Key('Settings_From_Tratamiento'), authService: AuthService()),
                  ),
                ],
                child: Container(decoration: const BoxDecoration(image: DecorationImage(image: AssetImage('assets/images/settingsbutton.png'), fit: BoxFit.fill))),
              ),
            ),
          ),
          Pinned.fromPins(
            Pin(size: 60.1, start: 15.0), Pin(size: 60.0, start: 110.0),
            child: Tooltip( // Tooltip añadido
              message: 'Ver todos mis animales',
              child: PageLink(
                links: [
                  PageLinkInfo(
                    pageBuilder: () => const ListadeAnimales(key: Key('ListadeAnimales_From_Tratamiento')),
                  ),
                ],
                child: Container(decoration: const BoxDecoration(image: DecorationImage(image: AssetImage('assets/images/listaanimales.png'), fit: BoxFit.fill))),
              ),
            ),
          ),

          Positioned(
            top: animalProfilePhotoTop,
            left: 0,
            right: 0,
            child: StreamBuilder<DocumentSnapshot>(
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
                    message: 'Editar perfil de ${animalData.nombre}',
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => EditarPerfildeAnimal(
                              key: Key('EditarPerfilDesdeTratamiento_${widget.animalId}'),
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
                                borderRadius: BorderRadius.circular(25.0),
                                border: Border.all(color: Colors.white, width: 2.5),
                                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.3), spreadRadius: 2, blurRadius: 5, offset: const Offset(0,3))]
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(22.5),
                              child: (animalData.fotoPerfilUrl.isNotEmpty)
                                  ? CachedNetworkImage(
                                imageUrl: animalData.fotoPerfilUrl, fit: BoxFit.cover,
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
            ),
          ),

          Positioned(
            top: titleContentTop,
            left: 0,
            right: 0,
            bottom: 0,
            child: SingleChildScrollView(
              padding: const EdgeInsets.only(bottom: 50.0), // Padding adicional para evitar el overflow inferior
              child: Column(
                children: <Widget>[
                  Container(
                    width: 300.0,
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    margin: const EdgeInsets.only(bottom: 25.0),
                    decoration: BoxDecoration(
                      color: CARD_BACKGROUND_COLOR,
                      borderRadius: BorderRadius.circular(10.0),
                      border: Border.all(width: 1.0, color: const Color(0xe3000000)),
                    ),
                    child: const Text(
                      'Tratamiento Médico',
                      style: TextStyle(fontFamily: APP_FONT_FAMILY, fontSize: 20, color: APP_TEXT_COLOR, fontWeight: FontWeight.w700),
                      textAlign: TextAlign.center,
                    ),
                  ),

                  StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('users')
                        .doc(currentUserId)
                        .collection('animals')
                        .doc(widget.animalId)
                        .collection('treatments')
                        .orderBy('startDate', descending: true)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.white)));
                      }
                      if (snapshot.hasError) {
                        developer.log("Error fetching treatments: ${snapshot.error}");
                        return Center(
                          child: Text('Error al cargar tratamientos: ${snapshot.error}', style: const TextStyle(fontFamily: APP_FONT_FAMILY, color: Colors.white, fontSize: 16)),
                        );
                      }
                      if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                        return const Center(
                          child: Padding(
                            padding: EdgeInsets.all(20.0),
                            child: Text('No hay tratamientos médicos registrados para este animal.\nPulsa "Crear Nuevo Tratamiento" para añadir uno.',
                                textAlign: TextAlign.center,
                                style: TextStyle(fontFamily: APP_FONT_FAMILY, color: Colors.white, fontSize: 16)),
                          ),
                        );
                      }

                      final treatments = snapshot.data!.docs
                          .map((doc) => MedicalTreatment.fromFirestore(doc))
                          .toList();

                      return ListView.builder(
                        padding: const EdgeInsets.symmetric(vertical: 10.0),
                        itemCount: treatments.length,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          return _buildTreatmentCard(context, treatments[index]);
                        },
                      );
                    },
                  ),

                  Padding(
                    padding: const EdgeInsets.only(bottom: 20.0, top: 20.0),
                    child: SizedBox(
                      width: 152.0,
                      child: Tooltip( // Tooltip añadido al botón de crear tratamiento
                        message: 'Crear un nuevo tratamiento médico',
                        child: GestureDetector(
                          onTap: _showCreateTreatmentModal,
                          child: Column(
                            mainAxisSize: MainAxisSize.min, // Asegura que la columna ocupe el mínimo espacio
                            children: [
                              Image.asset(
                                'assets/images/nuevotratamiento.png',
                                width: 120.0,
                                height: 120.0,
                                fit: BoxFit.fill,
                              ),
                              const Text(
                                'Crear Nuevo Tratamiento',
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

// --- Clase del Modal de Edición/Creación de Tratamiento (Integrado en el mismo archivo) ---
class _EditarTratamientoMedicoModalWidget extends StatefulWidget {
  final String animalId;
  final MedicalTreatment? initialTreatment; // Null para creación, provisto para edición

  const _EditarTratamientoMedicoModalWidget({
    required Key key,
    required this.animalId,
    this.initialTreatment,
  }) : super(key: key);

  @override
  _EditarTratamientoMedicoModalWidgetState createState() => _EditarTratamientoMedicoModalWidgetState();
}

class _EditarTratamientoMedicoModalWidgetState extends State<_EditarTratamientoMedicoModalWidget> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _medicineNameController;
  late TextEditingController _doseController;
  late TextEditingController _durationController;
  late TextEditingController _veterinarianController;
  late TextEditingController _notesController;
  late TextEditingController _startDateController;
  late TextEditingController _endDateController;

  DateTime? _selectedStartDate;
  DateTime? _selectedEndDate;

  bool _isLoadingAnimalData = true;
  bool _isSaving = false;

  Animal? _animalData; // ESTA es la variable correcta para el animal en este modal.

  @override
  void initState() {
    super.initState();
    _initializeControllers();
    _loadAnimalData();
  }

  void _initializeControllers() {
    final treatment = widget.initialTreatment;

    _medicineNameController = TextEditingController(text: treatment?.medicineName ?? '');
    _doseController = TextEditingController(text: treatment?.dose ?? '');
    _durationController = TextEditingController(text: treatment?.duration ?? '');
    _veterinarianController = TextEditingController(text: treatment?.veterinarian ?? '');
    _notesController = TextEditingController(text: treatment?.notes ?? '');

    _selectedStartDate = treatment?.startDate ?? DateTime.now();
    _selectedEndDate = treatment?.endDate;

    _startDateController = TextEditingController(text: DateFormat('dd/MM/yyyy').format(_selectedStartDate!));
    _endDateController = TextEditingController(text: _selectedEndDate != null ? DateFormat('dd/MM/yyyy').format(_selectedEndDate!) : '');
  }

  Future<void> _loadAnimalData() async {
    setState(() {
      _isLoadingAnimalData = true;
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
          _animalData = Animal.fromFirestore(animalDoc); // Aquí se asigna a _animalData
        } else {
          developer.log("Documento del animal con ID ${widget.animalId} no encontrado.");
        }
      } else {
        developer.log("Usuario no autenticado o animalId vacío.");
      }
    } catch (e) {
      developer.log("Error cargando datos del animal para editar tratamiento: $e");
    } finally {
      if (mounted) {
        setState(() {
          _isLoadingAnimalData = false;
        });
      }
    }
  }

  Future<void> _selectDate(BuildContext context, {required bool isStartDateField}) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: isStartDateField ? (_selectedStartDate ?? DateTime.now()) : (_selectedEndDate ?? _selectedStartDate ?? DateTime.now()),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: const ColorScheme.light(
              primary: APP_PRIMARY_COLOR,
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ), dialogTheme: DialogThemeData(backgroundColor: Colors.white),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        if (isStartDateField) {
          _selectedStartDate = picked;
          _startDateController.text = DateFormat('dd/MM/yyyy').format(picked);
          if (_selectedEndDate != null && _selectedEndDate!.isBefore(_selectedStartDate!)) {
            _selectedEndDate = _selectedStartDate;
            _endDateController.text = DateFormat('dd/MM/yyyy').format(_selectedEndDate!);
          }
        } else {
          if (_selectedStartDate != null && picked.isBefore(_selectedStartDate!)) {
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('La fecha de fin no puede ser anterior a la fecha de inicio.', style: TextStyle(fontFamily: APP_FONT_FAMILY)), backgroundColor: Colors.red),
              );
            }
            return;
          }
          _selectedEndDate = picked;
          _endDateController.text = DateFormat('dd/MM/yyyy').format(picked);
        }
      });
    }
  }

  Future<void> _upsertTreatment() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_selectedStartDate == null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Por favor, seleccione la fecha de inicio del tratamiento.', style: TextStyle(fontFamily: APP_FONT_FAMILY))));
      }
      return;
    }

    if (!mounted) return;
    setState(() {
      _isSaving = true;
    });

    try {
      final userId = FirebaseAuth.instance.currentUser?.uid;
      if (userId == null) {
        if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Usuario no autenticado. Por favor, inicie sesión.', style: TextStyle(fontFamily: APP_FONT_FAMILY))));
        Navigator.pop(context);
        return;
      }

      final MedicalTreatment treatmentToSave = MedicalTreatment(
        id: widget.initialTreatment?.id ?? '',
        medicineName: _medicineNameController.text.trim(),
        dose: _doseController.text.trim(),
        duration: _durationController.text.trim(),
        veterinarian: _veterinarianController.text.trim(),
        startDate: _selectedStartDate!,
        endDate: _selectedEndDate,
        notes: _notesController.text.trim().isEmpty ? null : _notesController.text.trim(),
        isReminderEnabled: widget.initialTreatment?.isReminderEnabled ?? false,
        isSupplied: widget.initialTreatment?.isSupplied ?? false,
      );

      if (widget.initialTreatment == null) {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(userId)
            .collection('animals')
            .doc(widget.animalId)
            .collection('treatments')
            .add(treatmentToSave.toMap());
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Tratamiento creado con éxito!', style: TextStyle(fontFamily: APP_FONT_FAMILY)), backgroundColor: Colors.green));
          Navigator.pop(context, true);
        }
      } else {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(userId)
            .collection('animals')
            .doc(widget.animalId)
            .collection('treatments')
            .doc(widget.initialTreatment!.id)
            .update(treatmentToSave.toMap());
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Tratamiento actualizado con éxito!', style: TextStyle(fontFamily: APP_FONT_FAMILY)), backgroundColor: Colors.green));
          Navigator.pop(context, true);
        }
      }
    } catch (e) {
      developer.log("Error al guardar/actualizar tratamiento: $e");
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error al guardar/actualizar tratamiento: $e', style: const TextStyle(fontFamily: APP_FONT_FAMILY)), backgroundColor: Colors.red));
    } finally {
      if (mounted) {
        setState(() {
        _isSaving = false;
      });
      }
    }
  }

  @override
  void dispose() {
    _medicineNameController.dispose();
    _doseController.dispose();
    _durationController.dispose();
    _veterinarianController.dispose();
    _notesController.dispose();
    _startDateController.dispose();
    _endDateController.dispose();
    super.dispose();
  }

  // --- _buildFormField CON EL PARÁMETRO tooltipMessage ---
  Widget _buildFormField({
    required TextEditingController controller,
    required String labelText,
    required String iconAsset, // Parámetro para la ruta del icono
    required String tooltipMessage, // <--- AÑADIDO ESTE PARÁMETRO FALTANTE
    String? Function(String?)? validator,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
    bool readOnly = false,
    VoidCallback? onTap,
    Widget? suffixIcon,
  }) {
    const double iconSize = 40.0;
    const double iconLeftPadding = 10.0;
    const double textFieldLeftPadding = iconLeftPadding + iconSize + 10.0;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Stack(
        alignment: Alignment.centerLeft,
        children: [
          TextFormField(
            controller: controller,
            keyboardType: keyboardType,
            maxLines: maxLines,
            readOnly: readOnly,
            onTap: onTap,
            style: const TextStyle(fontFamily: APP_FONT_FAMILY, color: APP_TEXT_COLOR),
            decoration: InputDecoration(
              labelText: labelText,
              labelStyle: const TextStyle(fontFamily: APP_FONT_FAMILY, color: Colors.black54),
              filled: true,
              fillColor: readOnly ? Colors.grey[200] : Colors.white.withOpacity(0.92),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.0), borderSide: BorderSide.none),
              enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12.0), borderSide: BorderSide(color: Colors.grey.shade500)),
              focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12.0), borderSide: const BorderSide(color: APP_PRIMARY_COLOR, width: 2.0)),
              errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12.0), borderSide: BorderSide(color: Colors.redAccent[700]!, width: 1.5)),
              focusedErrorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12.0), borderSide: BorderSide(color: Colors.redAccent[700]!, width: 2.0)),
              contentPadding: EdgeInsets.only(left: textFieldLeftPadding, top: maxLines > 1 ? 16 : 12, bottom: maxLines > 1 ? 16 : 12, right: 16),
              suffixIcon: suffixIcon,
              floatingLabelBehavior: FloatingLabelBehavior.auto,
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
            title: Text(
              widget.initialTreatment == null ? 'Crear Nuevo Tratamiento' : 'Editar Tratamiento',
              style: const TextStyle(fontFamily: APP_FONT_FAMILY, color: Colors.white),
            ),
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
                child: _isLoadingAnimalData
                    ? Center(child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(APP_PRIMARY_COLOR)),
                ))
                    : _animalData != null
                    ? Center(
                  child: Tooltip( // Tooltip para la foto del animal en el modal
                    message: 'Ver perfil de ${_animalData!.nombre}',
                    child: GestureDetector(
                      onTap: (_animalData!.fotoPerfilUrl.isNotEmpty)
                          ? () => _showLargeImage(_animalData!.fotoPerfilUrl)
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
                              child: (_animalData!.fotoPerfilUrl.isNotEmpty)
                                  ? CachedNetworkImage(
                                imageUrl: _animalData!.fotoPerfilUrl, fit: BoxFit.cover,
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
                          Text(
                            widget.initialTreatment == null ? 'Ingresar Datos del Tratamiento' : 'Editar Datos del Tratamiento',
                            style: const TextStyle(
                              fontFamily: APP_FONT_FAMILY,
                              fontSize: 20,
                              color: APP_TEXT_COLOR,
                              fontWeight: FontWeight.w700,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const Divider(color: APP_PRIMARY_COLOR, thickness: 1.0, height: 25),
                          _buildFormField(
                            controller: _medicineNameController,
                            labelText: 'Nombre del Medicamento',
                            iconAsset: 'assets/images/nombremedicamento.png',
                            validator: (value) => value == null || value.isEmpty ? 'Campo requerido' : null,
                            tooltipMessage: 'Nombre del medicamento a registrar',
                          ),
                          _buildFormField(
                            controller: _doseController,
                            labelText: 'Dosis (ej: 30mL cada 8 horas)',
                            iconAsset: 'assets/images/dosismedicamentos.png',
                            validator: (value) => value == null || value.isEmpty ? 'Campo requerido' : null,
                            tooltipMessage: 'Dosis y frecuencia del medicamento',
                          ),
                          _buildFormField(
                            controller: _durationController,
                            labelText: 'Duración del Tratamiento (ej: 1 semana)',
                            iconAsset: 'assets/images/duracion.png',
                            validator: (value) => value == null || value.isEmpty ? 'Campo requerido' : null,
                            tooltipMessage: 'Duración total del tratamiento',
                          ),
                          _buildFormField(
                            controller: _veterinarianController,
                            labelText: 'Veterinario Recetante',
                            iconAsset: 'assets/images/veterinario.png',
                            validator: (value) => value == null || value.isEmpty ? 'Campo requerido' : null,
                            tooltipMessage: 'Nombre del veterinario que recetó el tratamiento',
                          ),
                          _buildFormField(
                            controller: _startDateController,
                            labelText: 'Fecha de Inicio',
                            iconAsset: 'assets/images/fechamedicamentos.png',
                            readOnly: true,
                            onTap: () => _selectDate(context, isStartDateField: true),
                            suffixIcon: const Icon(Icons.calendar_today, color: Colors.grey),
                            tooltipMessage: 'Seleccionar la fecha de inicio del tratamiento',
                          ),
                          _buildFormField(
                            controller: _endDateController,
                            labelText: 'Fecha de Fin (Opcional)',
                            iconAsset: 'assets/images/fechamedicamentos.png',
                            readOnly: true,
                            onTap: () => _selectDate(context, isStartDateField: false),
                            suffixIcon: const Icon(Icons.calendar_today, color: Colors.grey),
                            tooltipMessage: 'Seleccionar la fecha de fin del tratamiento (opcional)',
                          ),
                          _buildFormField(
                            controller: _notesController,
                            labelText: 'Notas Adicionales (Opcional)',
                            iconAsset: 'assets/images/notas.png',
                            maxLines: 3,
                            keyboardType: TextInputType.multiline,
                            tooltipMessage: 'Notas o comentarios adicionales sobre el tratamiento',
                          ),
                          const SizedBox(height: 20),
                          _isSaving
                              ? const CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(APP_PRIMARY_COLOR))
                              : Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Expanded(
                                // CORREGIDO: Envuelto en Tooltip
                                child: Tooltip(
                                  message: 'Cancelar y cerrar el formulario',
                                  child: ElevatedButton.icon(
                                    onPressed: () => Navigator.of(context).pop(false),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.grey,
                                      foregroundColor: Colors.white,
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                      padding: const EdgeInsets.symmetric(vertical: 12),
                                    ),
                                    icon: const Icon(Icons.cancel_outlined, size: 24),
                                    label: const Text('Cancelar', style: TextStyle(fontFamily: APP_FONT_FAMILY, fontSize: 16)),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 15),
                              Expanded(
                                // CORREGIDO: Envuelto en Tooltip
                                child: Tooltip(
                                  message: 'Guardar los cambios del tratamiento',
                                  child: ElevatedButton.icon(
                                    onPressed: _upsertTreatment,
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.green,
                                      foregroundColor: Colors.white,
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                      padding: const EdgeInsets.symmetric(vertical: 12),
                                    ),
                                    icon: const Icon(Icons.save_outlined, size: 24),
                                    label: const Text('Guardar', style: TextStyle(fontFamily: APP_FONT_FAMILY, fontSize: 16)),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10), // REDUCIDO para evitar overflow
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