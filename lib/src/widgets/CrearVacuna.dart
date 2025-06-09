import 'package:flutter/material.dart';
import 'package:adobe_xd/pinned.dart';
import 'package:adobe_xd/page_link.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Importar Firestore
import 'package:firebase_auth/firebase_auth.dart';     // Importar FirebaseAuth
import 'package:cached_network_image/cached_network_image.dart'; // Para imágenes de red
import 'package:intl/intl.dart'; // Para formatear fechas

// Imports de Navegación y Servicios
import '../services/auth_service.dart';
import './Home.dart';
import './Ayuda.dart';
import './EditarPerfildeAnimal.dart';
import './Configuracion.dart';
import './ListadeAnimales.dart';
import './CarnetdeVacunacion.dart'; // Para volver a esta pantalla
import '../models/animal.dart'; // Importar el modelo Animal
import '../models/carnetvacunacion.dart'; // Importar el modelo CarnetVacunacion

// --- CrearVacuna Class (StatefulWidget) ---
class CrearVacuna extends StatefulWidget {
  final String animalId;

  const CrearVacuna({
    required Key key,
    required this.animalId,
  }) : super(key: key);

  @override
  _CrearVacunaState createState() => _CrearVacunaState();
}

// --- _CrearVacunaState Class ---
class _CrearVacunaState extends State<CrearVacuna> {
  final _formKey = GlobalKey<FormState>();
  final User? currentUser = FirebaseAuth.instance.currentUser;

  // Controladores para los campos del formulario de vacuna
  final TextEditingController _nombreVacunaController = TextEditingController();
  final TextEditingController _loteController = TextEditingController();
  final TextEditingController _veterinarioController = TextEditingController();
  final TextEditingController _numeroDosisController = TextEditingController();
  DateTime _fechaVacunacion = DateTime.now();
  DateTime _proximaDosis = DateTime.now().add(const Duration(days: 365)); // Por defecto un año después

  // Constantes de posicionamiento, reutilizadas para consistencia
  static const double logoBottomY = 115.0;
  static const double spaceAfterLogo = 25.0;
  static const double animalProfilePhotoTop = logoBottomY + spaceAfterLogo;
  static const double animalProfilePhotoHeight = 90.0;
  static const double animalNameHeight = 20.0;
  static const double spaceAfterAnimalProfile = 15.0;
  static const double titleFormTop = animalProfilePhotoTop + animalProfilePhotoHeight + animalNameHeight + spaceAfterAnimalProfile;


  // Método para seleccionar fecha
  Future<void> _selectDate(BuildContext context, {required bool isVaccinationDate}) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: isVaccinationDate ? _fechaVacunacion : _proximaDosis,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101), // Fecha máxima razonable
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xff4ec8dd),
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
        if (isVaccinationDate) {
          _fechaVacunacion = picked;
        } else {
          _proximaDosis = picked;
        }
      });
    }
  }

  // Método para guardar la vacuna
  Future<void> _guardarVacuna() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      if (currentUser == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Usuario no autenticado.')),
        );
        return;
      }

      if (widget.animalId.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('ID del animal no válido. No se puede guardar la vacuna.')),
        );
        return;
      }

      try {
        final newVaccine = CarnetVacunacion(
          nombreVacuna: _nombreVacunaController.text,
          fechaVacunacion: _fechaVacunacion,
          lote: _loteController.text,
          veterinario: _veterinarioController.text,
          numeroDosis: int.tryParse(_numeroDosisController.text) ?? 1,
          proximaDosis: _proximaDosis,
        );

        await FirebaseFirestore.instance
            .collection('users')
            .doc(currentUser!.uid) // current user ya es seguro aquí
            .collection('animals')
            .doc(widget.animalId)
            .collection('vaccinations') // Subcolección de vacunas
            .add(newVaccine.toMap()); // Guarda el mapa de la vacuna (ahora con Timestamps)

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Vacuna guardada exitosamente.')),
        );

        // Navegar de vuelta a CarnetdeVacunacion para el mismo animal
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => CarnetdeVacunacion(
              key: const Key('CarnetVacFromCrear'),
              animalId: widget.animalId,
            ),
          ),
        );
      } catch (e) {
        print("Error al guardar vacuna: $e");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al guardar la vacuna: $e')),
        );
      }
    }
  }

  @override
  void dispose() {
    _nombreVacunaController.dispose();
    _loteController.dispose();
    _veterinarioController.dispose();
    _numeroDosisController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Si llegamos hasta aquí y currentUser es nulo o animalId es vacío,
    // es un estado no esperado ya que el flujo de navegación debería evitarlo.
    // Podemos mostrar un mensaje de error o redirigir.
    if (currentUser == null) {
      return Scaffold(
        backgroundColor: const Color(0xff4ec8dd),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.person_off, size: 80, color: Colors.white),
              const SizedBox(height: 20),
              const Text(
                'Usuario no autenticado. Por favor, inicia sesión.',
                style: TextStyle(fontFamily: 'Comic Sans MS', fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => Home(key: const Key('Home_CrearVacunaNoUser'))),
                      (Route<dynamic> route) => false,
                ),
                style: ElevatedButton.styleFrom(backgroundColor: const Color(0xe3a0f4fe), foregroundColor: Colors.black),
                child: const Text('Ir a Inicio', style: TextStyle(fontFamily: 'Comic Sans MS', fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ),
      );
    }

    if (widget.animalId.isEmpty) {
      return Scaffold(
        backgroundColor: const Color(0xff4ec8dd),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.pets, size: 80, color: Colors.white),
              const SizedBox(height: 20),
              const Text(
                'No se ha seleccionado un animal. Por favor, selecciona uno.',
                style: TextStyle(fontFamily: 'Comic Sans MS', fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => const ListadeAnimales(key: Key('ListaAnimales_CrearVacunaNoAnimalId'))),
                      (Route<dynamic> route) => false,
                ),
                style: ElevatedButton.styleFrom(backgroundColor: const Color(0xe3a0f4fe), foregroundColor: Colors.black),
                child: const Text('Ver mis Animales', style: TextStyle(fontFamily: 'Comic Sans MS', fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ),
      );
    }

    // Aquí currentUserId es definitivamente no nulo
    final String currentUserId = currentUser!.uid;


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
                    pageBuilder: () => Home(key: const Key('Home_From_CrearVacuna')),
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
          // --- Botón de Retroceso (Vuelve a CarnetdeVacunacion para este animal) ---
          Pinned.fromPins(
            Pin(size: 52.9, start: 15.0), Pin(size: 50.0, start: 49.0),
            child: Tooltip( // Tooltip añadido
              message: 'Volver al Carnet de Vacunación',
              child: InkWell(
                onTap: () => Navigator.pop(context), // Vuelve a CarnetdeVacunacion
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
                links: [PageLinkInfo(pageBuilder: () => Ayuda(key: const Key('Ayuda_From_CrearVacuna')))],
                child: Container(decoration: const BoxDecoration(image: DecorationImage(image: AssetImage('assets/images/help.png'), fit: BoxFit.fill))),
              ),
            ),
          ),
          // --- Iconos Laterales (Configuración y Lista General de Animales) ---
          Pinned.fromPins(
            Pin(size: 47.2, end: 15.0), Pin(size: 50.0, start: 110.0),
            child: Tooltip( // Tooltip añadido
              message: 'Configuraciones de la Aplicación',
              child: PageLink(
                links: [
                  PageLinkInfo(
                    pageBuilder: () => Configuraciones(key: const Key('Settings_From_CrearVacuna'), authService: AuthService()),
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
                    pageBuilder: () => const ListadeAnimales(key: Key('ListadeAnimales_From_CrearVacuna')),
                  ),
                ],
                child: Container(decoration: const BoxDecoration(image: DecorationImage(image: AssetImage('assets/images/listaanimales.png'), fit: BoxFit.fill))),
              ),
            ),
          ),

          // --- Foto de Perfil y Nombre del Animal (Reutilizado de CarnetdeVacunacion) ---
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

                return Center(
                  child: Tooltip( // Tooltip añadido para la foto de perfil
                    message: 'Ver perfil de ${animalData.nombre}',
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => EditarPerfildeAnimal(
                              key: Key('EditarPerfilDesdeCrearVacuna_${widget.animalId}'),
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
                                    fontFamily: 'Comic Sans MS',
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

          // --- Título "Agregar Vacuna" y Formulario ---
          Positioned(
            top: titleFormTop,
            left: 0,
            right: 0,
            bottom: 0,
            child: Column(
              children: <Widget>[
                // Título
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
                    'Agregar Vacuna',
                    style: TextStyle(fontFamily: 'Comic Sans MS', fontSize: 20, color: Color(0xff000000), fontWeight: FontWeight.w700),
                    textAlign: TextAlign.center,
                  ),
                ),
                // Formulario
                Expanded(
                  child: Form(
                    key: _formKey,
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Column(
                        children: [
                          // Nombre de Vacuna
                          _buildFormField(
                            controller: _nombreVacunaController,
                            labelText: 'Nombre de Vacuna',
                            iconPath: 'assets/images/nombrevacuna.png', // Reutilizando icono si es adecuado
                            validator: (value) => value == null || value.isEmpty ? 'Por favor ingrese el nombre de la vacuna' : null,
                            keyboardType: TextInputType.text,
                            tooltipMessage: 'Nombre de la vacuna a registrar', // Tooltip
                          ),
                          const SizedBox(height: 20),

                          // Fecha de Vacunación
                          _buildDateField(
                            labelText: 'Fecha de Vacunación',
                            date: _fechaVacunacion,
                            iconPath: 'assets/images/edad.png', // Reutilizando icono
                            onTap: () => _selectDate(context, isVaccinationDate: true),
                            tooltipMessage: 'Fecha en que se aplicó la vacuna', // Tooltip
                          ),
                          const SizedBox(height: 20),

                          // Próxima Dosis
                          _buildDateField(
                            labelText: 'Próxima Dosis',
                            date: _proximaDosis,
                            iconPath: 'assets/images/edad.png', // Reutilizando icono
                            onTap: () => _selectDate(context, isVaccinationDate: false),
                            tooltipMessage: 'Fecha estimada para la próxima dosis de la vacuna', // Tooltip
                          ),
                          const SizedBox(height: 20),

                          // Lote
                          _buildFormField(
                            controller: _loteController,
                            labelText: 'Lote',
                            iconPath: 'assets/images/lote.png', // Asegúrate de tener este icono o usa uno genérico
                            validator: (value) => value == null || value.isEmpty ? 'Por favor ingrese el lote' : null,
                            keyboardType: TextInputType.text,
                            tooltipMessage: 'Número de lote de la vacuna', // Tooltip
                          ),
                          const SizedBox(height: 20),

                          // Número de Dosis
                          _buildFormField(
                            controller: _numeroDosisController,
                            labelText: 'Número de Dosis',
                            iconPath: 'assets/images/dosis.png', // Asegúrate de tener este icono o usa uno genérico
                            validator: (value) {
                              if (value == null || value.isEmpty) return 'Por favor ingrese el número de dosis';
                              if (int.tryParse(value) == null || int.parse(value) <= 0) return 'Ingrese un número válido (mayor a 0)';
                              return null;
                            },
                            keyboardType: TextInputType.number,
                            tooltipMessage: 'Número de dosis aplicada (ej: 1, 2, 3)', // Tooltip
                          ),
                          const SizedBox(height: 20),

                          // Veterinario
                          _buildFormField(
                            controller: _veterinarioController,
                            labelText: 'Veterinario',
                            iconPath: 'assets/images/veterinario.png', // Asegúrate de tener este icono o usa uno genérico
                            validator: (value) => value == null || value.isEmpty ? 'Por favor ingrese el nombre del veterinario' : null,
                            keyboardType: TextInputType.text,
                            tooltipMessage: 'Nombre del veterinario que aplicó la vacuna', // Tooltip
                          ),
                          const SizedBox(height: 30),

                          // Botón Guardar Vacuna
                          Tooltip( // Tooltip para el botón de guardar vacuna
                            message: 'Guardar nueva vacuna',
                            child: GestureDetector(
                              onTap: _guardarVacuna,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Image.asset(
                                    'assets/images/agregarvacuna.png', // Reutilizando el icono de agregar vacuna
                                    width: 120.0,
                                    height: 120.0,
                                    fit: BoxFit.fill,
                                  ),
                                  const Text(
                                    'Guardar Vacuna',
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
                          const SizedBox(height: 30), // Espacio al final
                        ],
                      ),
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

  // --- Widgets Reutilizables para el Formulario (ACTUALIZADOS con Tooltips) ---

  Widget _buildFormField({
    required TextEditingController controller,
    required String labelText,
    required String iconPath,
    required String tooltipMessage, // Nuevo parámetro para el Tooltip
    String? Function(String?)? validator,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return SizedBox(
      height: 60, // Ajusta la altura si es necesario
      child: Stack(
        children: [
          TextFormField(
            controller: controller,
            keyboardType: keyboardType,
            decoration: InputDecoration(
              labelText: labelText,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.0)),
              filled: true,
              fillColor: Colors.white,
              contentPadding: const EdgeInsets.only(left: 50.0, top: 15, bottom: 15),
            ),
            validator: validator,
            style: const TextStyle(fontFamily: 'Comic Sans MS', fontSize: 16), // Consistencia de estilo
          ),
          Positioned(
            left: 5,
            top: 0,
            bottom: 10, // Alinea el icono verticalmente
            child: Align(
              alignment: Alignment.centerLeft,
              child: Tooltip( // Tooltip para el icono
                message: tooltipMessage,
                child: Container(
                  width: 40.0, // Tamaño del icono
                  height: 40.0, // Tamaño del icono
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(iconPath),
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDateField({
    required String labelText,
    required DateTime date,
    required String iconPath,
    required VoidCallback onTap,
    required String tooltipMessage, // Nuevo parámetro para el Tooltip
  }) {
    return SizedBox(
      height: 60,
      child: Stack(
        children: [
          Tooltip( // Tooltip para el campo de fecha completo
            message: tooltipMessage,
            child: InkWell(
              onTap: onTap,
              child: InputDecorator(
                decoration: InputDecoration(
                  labelText: labelText,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.0)),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.only(left: 50.0, top: 15, bottom: 15),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      DateFormat('dd/MM/yyyy').format(date),
                      style: const TextStyle(fontFamily: 'Comic Sans MS', fontSize: 16), // Ajusta el tamaño de fuente y aplica fuente
                    ),
                    const Icon(Icons.arrow_drop_down),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            left: 5,
            top: 0,
            bottom: 10, // Alinea el icono verticalmente
            child: Align(
              alignment: Alignment.centerLeft,
              child: Tooltip( // Tooltip para el icono de la fecha
                message: tooltipMessage, // Reutiliza el mensaje del campo completo
                child: Container(
                  width: 40.0,
                  height: 40.0,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(iconPath),
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}