import 'package:animal_health/src/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:adobe_xd/pinned.dart';
import './Home.dart';
import 'package:adobe_xd/page_link.dart';
import './Ayuda.dart';
import './EditarPerfildeAnimal.dart';
import './FuncionesdelaApp.dart'; // Importante para la navegación de regreso
import './Configuracion.dart';
import './ListadeAnimales.dart';
// import 'package:flutter_svg/flutter_svg.dart'; // No se usó en la implementación final
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart'; // Para formatear fechas
import '../models/animal.dart';


// Define constantes para estilos comunes de la aplicación
const Color APP_PRIMARY_COLOR = Color(0xff4ec8dd);
const Color APP_BACKGROUND_COLOR = Color(0xff4ec8dd);
const Color APP_TEXT_COLOR = Color(0xff000000);
const Color CARD_BACKGROUND_COLOR = Color(0xe3a0f4fe); // Color de fondo de las tarjetas y formularios
const String APP_FONT_FAMILY = 'Comic Sans MS';

// --- Modelo de Tratamiento Médico ---
// Define una estructura de datos para un tratamiento médico.
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
  final bool isSupplied; // Para marcar si una dosis/tratamiento ha sido suministrado

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
  bool _showTreatmentForm = false; // Estado para controlar la visibilidad del formulario

  // Constantes de posicionamiento para elementos de la UI
  static const double logoBottomY = 115.0;
  static const double spaceAfterLogo = 25.0;
  static const double animalProfilePhotoTop = logoBottomY + spaceAfterLogo;
  static const double animalProfilePhotoHeight = 90.0;
  static const double animalNameHeight = 20.0;
  static const double spaceAfterAnimalProfile = 15.0;
  static const double titleContentTop = animalProfilePhotoTop + animalProfilePhotoHeight + animalNameHeight + spaceAfterAnimalProfile;


  // Método para alternar la visibilidad del formulario de creación de tratamiento
  void _toggleTreatmentForm() {
    setState(() {
      _showTreatmentForm = !_showTreatmentForm;
    });
  }

  // Método para construir una tarjeta individual de tratamiento médico
  Widget _buildTreatmentCard(BuildContext context, MedicalTreatment treatment) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
      elevation: 5, // Sombra para un efecto elevado
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0), // Esquinas redondeadas
        side: const BorderSide(width: 1.5, color: APP_PRIMARY_COLOR), // Borde distintivo
      ),
      color: CARD_BACKGROUND_COLOR.withOpacity(0.9), // Color de fondo semitransparente
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
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
            const Divider(color: APP_PRIMARY_COLOR, thickness: 1.5, height: 20), // Separador
            _buildInfoRow('Dosis:', treatment.dose),
            _buildInfoRow('Duración:', treatment.duration),
            _buildInfoRow('Veterinario:', treatment.veterinarian),
            _buildInfoRow('Inicio:', DateFormat('dd/MM/yyyy').format(treatment.startDate)),
            if (treatment.endDate != null) // Mostrar fecha de fin si existe
              _buildInfoRow('Fin:', DateFormat('dd/MM/yyyy').format(treatment.endDate!)),
            if (treatment.notes != null && treatment.notes!.isNotEmpty) // Mostrar notas si existen
              _buildInfoRow('Notas:', treatment.notes!),
            const SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                // Botón/Indicador de Recordatorio
                _buildActionButton(
                  iconPath: 'assets/images/recordatorio.png', // Asegúrate de tener estas imágenes
                  label: 'Recordatorio',
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Función de recordatorio para ${treatment.medicineName} (¡por implementar!)')),
                    );
                  },
                ),
                // Botón/Indicador de Suministrado
                _buildActionButton(
                  iconPath: 'assets/images/suministrado.png', // Asegúrate de tener estas imágenes
                  label: 'Suministrado',
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Marcar como suministrado para ${treatment.medicineName} (¡por implementar!)')),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
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
          Expanded( // Expanded para que el valor ocupe el resto del espacio
            child: Text(
              value,
              style: const TextStyle(
                fontFamily: APP_FONT_FAMILY,
                fontSize: 17,
                color: APP_TEXT_COLOR,
              ),
              softWrap: true, // Permite que el texto se ajuste en varias líneas
            ),
          ),
        ],
      ),
    );
  }

  // Widget auxiliar para construir botones de acción con icono y texto
  Widget _buildActionButton({required String iconPath, required String label, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 70.0,
            height: 70.0,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(iconPath),
                fit: BoxFit.fill,
              ),
            ),
          ),
          const SizedBox(height: 5),
          Text(
            label,
            style: const TextStyle(
              fontFamily: APP_FONT_FAMILY,
              fontSize: 16,
              color: APP_TEXT_COLOR,
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
    // Manejo de casos si el usuario no está autenticado o el animalId es inválido
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
                      (Route<dynamic> route) => false, // Elimina todas las rutas anteriores
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

    final String currentUserId = currentUser!.uid; // currentUserId ya es seguro aquí

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
            Pin(size: 74.0, middle: 0.5), Pin(size: 73.0, start: 42.0),
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
          // --- Botón de Retroceso (Vuelve a FuncionesdelaApp para el mismo animal) ---
          Pinned.fromPins(
            Pin(size: 52.9, start: 15.0), Pin(size: 50.0, start: 49.0),
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
          // --- Botón de Ayuda ---
          Pinned.fromPins(
            Pin(size: 40.5, end: 15.0), Pin(size: 50.0, start: 49.0),
            child: PageLink(
              links: [PageLinkInfo(pageBuilder: () => Ayuda(key: const Key('Ayuda_From_Tratamiento')))],
              child: Container(decoration: const BoxDecoration(image: DecorationImage(image: AssetImage('assets/images/help.png'), fit: BoxFit.fill))),
            ),
          ),
          // --- Iconos Laterales (Configuración y Lista General de Animales) ---
          Pinned.fromPins(
            Pin(size: 47.2, end: 15.0), Pin(size: 50.0, start: 110.0),
            child: PageLink(
              links: [
                PageLinkInfo(
                  pageBuilder: () => Configuraciones(key: const Key('Settings_From_Tratamiento'), authService: AuthService()),
                ),
              ],
              child: Container(decoration: const BoxDecoration(image: DecorationImage(image: AssetImage('assets/images/settingsbutton.png'), fit: BoxFit.fill))),
            ),
          ),
          Pinned.fromPins(
            Pin(size: 60.1, start: 15.0), Pin(size: 60.0, start: 110.0),
            child: PageLink(
              links: [
                PageLinkInfo(
                  pageBuilder: () => const ListadeAnimales(key: Key('ListadeAnimales_From_Tratamiento')),
                ),
              ],
              child: Container(decoration: const BoxDecoration(image: DecorationImage(image: AssetImage('assets/images/listaanimales.png'), fit: BoxFit.fill))),
            ),
          ),

          // --- Foto de Perfil y Nombre del Animal (sección dinámica) ---
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
                );
              },
            ),
          ),

          // --- Contenido Principal: Título, Botón de Formulario y Lista/Formulario ---
          Positioned(
            top: titleContentTop, // Posición calculada
            left: 0,
            right: 0,
            bottom: 0,
            child: Column(
              children: <Widget>[
                // Título "Tratamiento Médico"
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
                // Botón para desplegar/cerrar el formulario
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                  child: ElevatedButton.icon(
                    onPressed: _toggleTreatmentForm, // Llama al método para alternar
                    style: ElevatedButton.styleFrom(
                      backgroundColor: APP_PRIMARY_COLOR,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      elevation: 5,
                    ),
                    icon: Icon(_showTreatmentForm ? Icons.close : Icons.add_circle_outline, size: 28),
                    label: Text(
                      _showTreatmentForm ? 'Cerrar Formulario' : 'Crear Nuevo Tratamiento',
                      style: const TextStyle(fontFamily: APP_FONT_FAMILY, fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                // El formulario de creación se muestra u oculta aquí
                if (_showTreatmentForm)
                  Expanded(
                    child: _CreateTreatmentForm(
                      key: const Key('create_treatment_form'),
                      animalId: widget.animalId,
                      onTreatmentSaved: () {
                        setState(() {
                          _showTreatmentForm = false; // Oculta el formulario después de guardar
                        });
                      },
                      onCancel: () {
                        setState(() {
                          _showTreatmentForm = false; // Oculta el formulario si se cancela
                        });
                      },
                    ),
                  )
                else // Si el formulario no está visible, muestra la lista de tratamientos
                  Expanded(
                    child: StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('users')
                          .doc(currentUserId)
                          .collection('animals')
                          .doc(widget.animalId)
                          .collection('treatments') // Subcolección de tratamientos
                          .orderBy('startDate', descending: true) // Ordenar por fecha de inicio
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.white)));
                        }
                        if (snapshot.hasError) {
                          print("Error fetching treatments: ${snapshot.error}");
                          return Center(
                            child: Text('Error al cargar tratamientos: ${snapshot.error}', style: const TextStyle(fontFamily: APP_FONT_FAMILY, color: Colors.white, fontSize: 16)),
                          );
                        }
                        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                          return const Center(
                            child: Text('No hay tratamientos médicos registrados para este animal.\nPulsa "Crear Nuevo Tratamiento" para añadir uno.',
                                textAlign: TextAlign.center,
                                style: TextStyle(fontFamily: APP_FONT_FAMILY, color: Colors.white, fontSize: 16)),
                          );
                        }

                        // Mapea los documentos de Firestore a objetos MedicalTreatment
                        final treatments = snapshot.data!.docs
                            .map((doc) => MedicalTreatment.fromFirestore(doc))
                            .toList();

                        return ListView.builder(
                          padding: const EdgeInsets.symmetric(vertical: 10.0),
                          itemCount: treatments.length,
                          itemBuilder: (context, index) {
                            return _buildTreatmentCard(context, treatments[index]);
                          },
                        );
                      },
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

// --- Clase del Formulario de Creación de Tratamiento ---
// Esta es una clase interna y privada, por lo que su nombre empieza con '_'.
class _CreateTreatmentForm extends StatefulWidget {
  final String animalId;
  final VoidCallback onTreatmentSaved; // Callback para notificar que se guardó
  final VoidCallback onCancel; // Callback para notificar que se canceló

  const _CreateTreatmentForm({
    required Key key,
    required this.animalId,
    required this.onTreatmentSaved,
    required this.onCancel,
  }) : super(key: key);

  @override
  __CreateTreatmentFormState createState() => __CreateTreatmentFormState();
}

class __CreateTreatmentFormState extends State<_CreateTreatmentForm> {
  final _formKey = GlobalKey<FormState>(); // Clave global para validar el formulario
  final User? currentUser = FirebaseAuth.instance.currentUser;

  // Controladores para los campos de texto del formulario
  final TextEditingController _medicineNameController = TextEditingController();
  final TextEditingController _doseController = TextEditingController();
  final TextEditingController _durationController = TextEditingController();
  final TextEditingController _veterinarianController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();
  DateTime _startDate = DateTime.now(); // Fecha de inicio por defecto hoy
  DateTime? _endDate; // Fecha de fin opcional

  bool _isSaving = false; // Estado para mostrar un indicador de carga al guardar

  @override
  void dispose() {
    // Liberar los controladores cuando el widget se destruye
    _medicineNameController.dispose();
    _doseController.dispose();
    _durationController.dispose();
    _veterinarianController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  // Método para seleccionar una fecha usando un DatePicker
  Future<void> _selectDate(BuildContext context, {required bool isStartDate}) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: isStartDate ? _startDate : (_endDate ?? _startDate), // Fecha inicial
      firstDate: DateTime(2000), // Fecha mínima permitida
      lastDate: DateTime(2101), // Fecha máxima permitida
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor: APP_PRIMARY_COLOR, // Color principal
            colorScheme: const ColorScheme.light(primary: APP_PRIMARY_COLOR),
            buttonTheme: const ButtonThemeData(textTheme: ButtonTextTheme.primary),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        if (isStartDate) {
          _startDate = picked;
        } else {
          _endDate = picked;
        }
      });
    }
  }

  // Método para guardar el tratamiento en Firestore
  Future<void> _saveTreatment() async {
    if (_formKey.currentState!.validate()) { // Valida todos los campos del formulario
      _formKey.currentState!.save();

      if (currentUser == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Usuario no autenticado.')),
        );
        return;
      }

      setState(() {
        _isSaving = true; // Activa el indicador de carga
      });

      try {
        // Crea un nuevo objeto MedicalTreatment con los datos del formulario
        final newTreatment = MedicalTreatment(
          medicineName: _medicineNameController.text.trim(),
          dose: _doseController.text.trim(),
          duration: _durationController.text.trim(),
          veterinarian: _veterinarianController.text.trim(),
          startDate: _startDate,
          endDate: _endDate,
          notes: _notesController.text.trim().isEmpty ? null : _notesController.text.trim(),
          // isReminderEnabled y isSupplied pueden ser configurados por defecto o con checkboxes en el futuro
        );

        // Guarda el tratamiento en la subcolección 'treatments' del animal específico
        await FirebaseFirestore.instance
            .collection('users')
            .doc(currentUser!.uid)
            .collection('animals')
            .doc(widget.animalId)
            .collection('treatments')
            .add(newTreatment.toMap()); // Usa el método toMap() del modelo

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Tratamiento guardado exitosamente.', style: TextStyle(fontFamily: APP_FONT_FAMILY)), backgroundColor: Colors.green),
        );
        widget.onTreatmentSaved(); // Llama al callback para notificar a la clase padre
      } catch (e) {
        print("Error al guardar tratamiento: $e");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al guardar el tratamiento: $e', style: const TextStyle(fontFamily: APP_FONT_FAMILY)), backgroundColor: Colors.red),
        );
      } finally {
        setState(() {
          _isSaving = false; // Desactiva el indicador de carga
        });
      }
    }
  }

  // Widget auxiliar para construir un campo de texto genérico del formulario
  Widget _buildFormField({
    required TextEditingController controller,
    required String labelText,
    String? Function(String?)? validator,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        maxLines: maxLines,
        style: const TextStyle(fontFamily: APP_FONT_FAMILY, color: APP_TEXT_COLOR),
        decoration: InputDecoration(
          labelText: labelText,
          labelStyle: const TextStyle(fontFamily: APP_FONT_FAMILY, color: Colors.black54),
          filled: true,
          fillColor: Colors.white.withOpacity(0.92), // Fondo del campo
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.0), borderSide: BorderSide.none),
          focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12.0), borderSide: const BorderSide(color: APP_PRIMARY_COLOR, width: 2.0)), // Borde cuando está enfocado
          errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12.0), borderSide: BorderSide(color: Colors.redAccent[700]!, width: 1.5)), // Borde con error
          focusedErrorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12.0), borderSide: BorderSide(color: Colors.redAccent[700]!, width: 2.0)), // Borde con error y enfocado
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: maxLines > 1 ? 16 : 12),
          errorStyle: TextStyle(fontFamily: APP_FONT_FAMILY, color: Colors.red[600], fontWeight: FontWeight.w600, fontSize: 13),
        ),
        validator: validator, // Asigna la función de validación
      ),
    );
  }

  // Widget auxiliar para construir un campo de selección de fecha
  Widget _buildDateField({
    required String labelText,
    required DateTime date,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: InkWell( // Hace que el campo sea interactivo al tocarlo
        onTap: onTap,
        child: InputDecorator( // Permite decorar un campo de entrada que no es un TextFormField
          decoration: InputDecoration(
            labelText: labelText,
            labelStyle: const TextStyle(fontFamily: APP_FONT_FAMILY, color: Colors.black54),
            filled: true,
            fillColor: Colors.white.withOpacity(0.92),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.0), borderSide: BorderSide.none),
            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12.0), borderSide: const BorderSide(color: APP_PRIMARY_COLOR, width: 2.0)),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                DateFormat('dd/MM/yyyy').format(date), // Formatea la fecha para mostrar
                style: const TextStyle(fontFamily: APP_FONT_FAMILY, fontSize: 16, color: APP_TEXT_COLOR),
              ),
              const Icon(Icons.calendar_today, color: APP_PRIMARY_COLOR), // Icono de calendario
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 15.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: CARD_BACKGROUND_COLOR.withOpacity(0.95), // Fondo del formulario
        borderRadius: BorderRadius.circular(20.0),
        border: Border.all(width: 1.5, color: APP_PRIMARY_COLOR),
        boxShadow: const [ // Sombra para un efecto 3D
          BoxShadow(
            color: Color(0x29000000),
            offset: Offset(0, 3),
            blurRadius: 6,
          ),
        ],
      ),
      child: Form(
        key: _formKey, // Asigna la clave global al formulario
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min, // Ajusta la altura del contenido a lo necesario
            children: <Widget>[
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
              const Divider(color: APP_PRIMARY_COLOR, thickness: 1.0, height: 25), // Separador
              _buildFormField(
                controller: _medicineNameController,
                labelText: 'Nombre del Medicamento',
                validator: (value) => value == null || value.isEmpty ? 'Campo requerido' : null,
              ),
              _buildFormField(
                controller: _doseController,
                labelText: 'Dosis (ej: 30mL cada 8 horas)',
                validator: (value) => value == null || value.isEmpty ? 'Campo requerido' : null,
              ),
              _buildFormField(
                controller: _durationController,
                labelText: 'Duración del Tratamiento (ej: 1 semana)',
                validator: (value) => value == null || value.isEmpty ? 'Campo requerido' : null,
              ),
              _buildFormField(
                controller: _veterinarianController,
                labelText: 'Veterinario Recetante',
                validator: (value) => value == null || value.isEmpty ? 'Campo requerido' : null,
              ),
              _buildDateField(
                labelText: 'Fecha de Inicio',
                date: _startDate,
                onTap: () => _selectDate(context, isStartDate: true),
              ),
              _buildDateField(
                labelText: 'Fecha de Fin (Opcional)',
                date: _endDate ?? DateTime.now(), // Muestra la fecha actual si _endDate es nulo
                onTap: () => _selectDate(context, isStartDate: false),
              ),
              _buildFormField(
                controller: _notesController,
                labelText: 'Notas Adicionales (Opcional)',
                maxLines: 3, // Permite múltiples líneas
                keyboardType: TextInputType.multiline,
              ),
              const SizedBox(height: 20),
              _isSaving // Si está guardando, muestra un indicador de progreso
                  ? const CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(APP_PRIMARY_COLOR))
                  : Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: widget.onCancel, // Botón de cancelar
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
                  const SizedBox(width: 15), // Espacio entre botones
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: _saveTreatment, // Botón de guardar
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
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}