// lib/src/widgets/CrearVisitaVeterinariaScreen.dart
import 'package:flutter/material.dart';
import 'package:adobe_xd/pinned.dart';
import 'package:adobe_xd/page_link.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

// NEW IMPORTS FOR LOCATION AND IMAGE CACHING
import 'package:geolocator/geolocator.dart'; // Para geolocalización
import 'package:cached_network_image/cached_network_image.dart'; // Para cargar y cachear imágenes
import '../models/animal.dart'; // Asume que Animal está en lib/src/models/animal.dart

// Importa tus pantallas existentes
import './Home.dart';
import './Ayuda.dart';
import './Configuracion.dart';
import './ListadeAnimales.dart';
import '../services/auth_service.dart'; // Si Auth_Service es necesario aquí

class CrearVisitaVeterinariaScreen extends StatefulWidget {
  final String animalId;

  const CrearVisitaVeterinariaScreen({required Key key, required this.animalId}) : super(key: key);

  @override
  _CrearVisitaVeterinariaScreenState createState() => _CrearVisitaVeterinariaScreenState();
}

class _CrearVisitaVeterinariaScreenState extends State<CrearVisitaVeterinariaScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _diagnosticoController = TextEditingController();
  final TextEditingController _tratamientoController = TextEditingController();
  final TextEditingController _medicamentosController = TextEditingController();
  final TextEditingController _observacionesController = TextEditingController();
  final TextEditingController _costoController = TextEditingController();
  final TextEditingController _veterinarianNameController = TextEditingController();

  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  String? _selectedClinicId;
  String? _selectedClinicName;
  String? _selectedClinicAddress;

  List<Map<String, dynamic>> _clinics = [];
  bool _isLoading = true;
  bool _isSaving = false;

  // NUEVAS VARIABLES DE ESTADO PARA UBICACIÓN Y DATOS DEL ANIMAL
  Position? _currentPosition;
  String? _locationError;
  bool _isLocationLoading = false; // Para indicar si la ubicación se está cargando
  Animal? _animalData; // Para almacenar los datos del animal

  @override
  void initState() {
    super.initState();
    _loadAllData(); // Carga todos los datos necesarios al iniciar la pantalla
  }

  // Método unificado para cargar datos (ubicación, animal, clínicas)
  Future<void> _loadAllData() async {
    if (!mounted) return;
    setState(() {
      _isLoading = true; // Indicador de carga general
      _isLocationLoading = true; // Indicador de carga de ubicación
      _locationError = null; // Reinicia errores de ubicación
    });

    try {
      // 1. Obtener la ubicación del usuario
      bool serviceEnabled;
      LocationPermission permission;

      serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        _locationError = 'Los servicios de ubicación están deshabilitados. No se pueden buscar clínicas cercanas.';
        print(_locationError);
        // No se retorna, se intentará cargar todas las clínicas sin filtrar por ubicación.
      }

      permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          _locationError = 'Permiso de ubicación denegado. No se pueden buscar clínicas cercanas.';
          print(_locationError);
        }
      }

      if (permission == LocationPermission.deniedForever) {
        _locationError = 'Los permisos de ubicación están denegados permanentemente. Por favor, habilítelos desde la configuración de su dispositivo.';
        print(_locationError);
      }

      if (_locationError == null && serviceEnabled && (permission == LocationPermission.whileInUse || permission == LocationPermission.always)) {
        try {
          _currentPosition = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
          print("Ubicación actual: ${_currentPosition?.latitude}, ${_currentPosition?.longitude}");
        } catch (e) {
          _locationError = 'Error al obtener la ubicación: $e';
          print(_locationError);
        }
      }
    } catch (e) {
      _locationError = 'Error con la geolocalización: $e';
      print("Error durante la inicialización de geolocator: $e");
    } finally {
      if (mounted) {
        setState(() {
          _isLocationLoading = false; // Finaliza la carga de ubicación
        });
      }
    }

    // 2. Cargar datos del animal (copiado de VisitasalVeterinario.dart)
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
          print("Documento del animal con ID ${widget.animalId} no encontrado.");
        }
      } else {
        print("Usuario no autenticado o animalId vacío.");
      }
    } catch (e) {
      print("Error cargando datos del animal: $e");
    }

    // 3. Cargar Clínicas (y filtrar si la ubicación está disponible)
    try {
      final clinicSnapshot = await FirebaseFirestore.instance.collection('clinics').get();
      List<Map<String, dynamic>> fetchedClinics = clinicSnapshot.docs.map((doc) => {'id': doc.id, ...doc.data()}).toList();

      if (_currentPosition != null) {
        // Calcular distancias y ordenar
        fetchedClinics.forEach((clinic) {
          if (clinic['latitude'] != null && clinic['longitude'] != null) {
            double distance = Geolocator.distanceBetween(
              _currentPosition!.latitude,
              _currentPosition!.longitude,
              clinic['latitude'],
              clinic['longitude'],
            );
            clinic['distance'] = distance; // Distancia en metros
          } else {
            clinic['distance'] = double.infinity; // Clínicas sin coordenadas al final
          }
        });

        // Ordenar por distancia (las más cercanas primero)
        fetchedClinics.sort((a, b) => (a['distance'] as double).compareTo(b['distance'] as double));

        // Opcional: filtrar por una distancia máxima (ej. 50 km)
        // _clinics = fetchedClinics.where((clinic) => clinic['distance'] <= 50000).toList();
        _clinics = fetchedClinics; // Se muestran todas, pero ordenadas por distancia
      } else {
        _clinics = fetchedClinics; // Si no hay ubicación, se cargan todas sin ordenar por distancia
      }

      if (mounted) {
        setState(() {
          _isLoading = false; // Finaliza la carga general
        });
      }
    } catch (e) {
      print("Error cargando clínicas: $e");
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error al cargar datos iniciales: $e')));
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
      });
    }
  }

  Future<void> _saveVisit() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    if (_selectedDate == null || _selectedTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Por favor, seleccione la fecha y hora de la visita.')));
      return;
    }
    if (_selectedClinicId == null || _selectedClinicId!.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Por favor, seleccione un centro de atención.')));
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
          .add({
        'fecha': visitDateTime,
        'hora': _selectedTime!.format(context),
        'centroAtencionId': _selectedClinicId,
        'centroAtencionNombre': _selectedClinicName,
        'centroAtencionDireccion': _selectedClinicAddress,
        'veterinarioId': userId, // Se registra el UID del dueño del animal como quien creó la entrada
        'veterinarioNombre': _veterinarianNameController.text.trim(), // Nombre del veterinario ingresado por el dueño
        'diagnostico': _diagnosticoController.text.trim(),
        'tratamiento': _tratamientoController.text.trim(),
        'medicamentos': _medicamentosController.text.trim(),
        'observaciones': _observacionesController.text.trim(),
        'costo': double.tryParse(_costoController.text.trim().replaceAll(',', '.')) ?? 0.0,
        'createdAt': FieldValue.serverTimestamp(),
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Visita creada con éxito!')));
        Navigator.pop(context, true);
      }
    } catch (e) {
      print("Error al guardar visita: $e");
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error al crear visita: $e')));
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
    super.dispose();
  }

  // MODIFICADO: Añadidos nuevos parámetros para la posición del icono (iconPositionedTop, iconPositionedBottom, iconPositionedLeft)
  Widget _buildTextFormFieldWithIcon({
    required TextEditingController controller,
    required String labelText,
    required String assetIconPath,
    required double iconWidth,
    required double iconHeight,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
    int maxLines = 1,
    bool enabled = true,
    // Nuevos parámetros para la posición explícita del icono
    double? iconPositionedTop,
    double? iconPositionedBottom,
    double? iconPositionedLeft,
  }) {
    // Determinar la posición real del icono, dando prioridad a los parámetros explícitos
    double? actualTop;
    double? actualBottom;
    double actualLeft = iconPositionedLeft ?? 5; // Usa el valor proporcionado o el predeterminado de 5

    if (iconPositionedTop != null) {
      actualTop = iconPositionedTop;
      actualBottom = null; // Si se especifica 'top', 'bottom' se deja nulo (a menos que también se especifique)
    } else if (iconPositionedBottom != null) {
      actualBottom = iconPositionedBottom;
      actualTop = null; // Si se especifica 'bottom', 'top' se deja nulo
    } else {
      // Si no se especifica 'top' ni 'bottom', se usa la lógica original basada en maxLines
      actualTop = maxLines > 1 ? 10 : 0;
      actualBottom = maxLines > 1 ? null : 10;
    }

    return Container(
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
            maxLines: maxLines,
          ),
          Positioned(
            left: actualLeft,
            top: actualTop,
            bottom: actualBottom,
            child: Align(
              // El Alignment se ajusta. Si top/bottom explícitos, se centra. Si no, usa la lógica anterior.
              alignment: (iconPositionedTop != null || iconPositionedBottom != null)
                  ? Alignment.centerLeft
                  : (maxLines > 1 ? Alignment.topLeft : Alignment.centerLeft),
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

  // Método auxiliar para mostrar imagen grande (copiado de VisitasalVeterinario.dart)
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
    // Estas constantes se ajustan para el layout de CrearVisitaVeterinariaScreen
    // El logo y los botones superiores ocupan la parte superior.
    // La foto del animal se colocará debajo de ellos, antes del título del formulario.
    const double animalPhotoTop = 120.0; // Posición vertical de la foto del animal
    const double animalPhotoSize = 90.0; // Alto y ancho de la foto del animal
    const double animalNameHeight = 20.0; // Altura estimada para el nombre
    const double spaceAfterAnimalPhoto = 20.0; // Espacio entre el nombre y el título del formulario

    // La posición superior del área principal del formulario se ajusta
    final double mainContentTop = animalPhotoTop + animalPhotoSize + animalNameHeight + spaceAfterAnimalPhoto;


    return Scaffold(
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
            Pin(size: 74.0, middle: 0.5), Pin(size: 73.0, start: 42.0),
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
            Pin(size: 52.9, start: 15.0), Pin(size: 50.0, start: 49.0),
            child: GestureDetector(
              onTap: () => Navigator.of(context).pop(),
              child: Container(decoration: const BoxDecoration(image: DecorationImage(image: AssetImage('assets/images/back.png'), fit: BoxFit.fill))),
            ),
          ),
          Pinned.fromPins(
            Pin(size: 47.2, end: 7.6), Pin(size: 50.0, start: 49.0),
            child: PageLink(
              links: [PageLinkInfo(transition: LinkTransition.Fade, ease: Curves.easeOut, duration: 0.3, pageBuilder: () => Configuraciones(key: const Key('Settings'), authService: AuthService()))],
              child: Container(decoration: const BoxDecoration(image: DecorationImage(image: AssetImage('assets/images/settingsbutton.png'), fit: BoxFit.fill))),
            ),
          ),
          Pinned.fromPins(
            Pin(size: 40.5, end: 7.6 + 47.2 + 5.0), Pin(size: 50.0, start: 49.0),
            child: PageLink(
              links: [PageLinkInfo(transition: LinkTransition.Fade, ease: Curves.easeOut, duration: 0.3, pageBuilder: () => Ayuda(key: const Key('Ayuda')))],
              child: Container(decoration: const BoxDecoration(image: DecorationImage(image: AssetImage('assets/images/help.png'), fit: BoxFit.fill))),
            ),
          ),

          // NUEVO: Foto y Nombre del Animal (copiado de VisitasalVeterinario.dart)
          Positioned(
            top: animalPhotoTop, // Posición ajustada para el diseño actual
            left: 0,
            right: 0,
            child: _animalData != null
                ? Center(
              child: GestureDetector(
                onTap: (_animalData!.fotoPerfilUrl != null && _animalData!.fotoPerfilUrl!.isNotEmpty)
                    ? () => _showLargeImage(_animalData!.fotoPerfilUrl!)
                    : null,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: animalPhotoSize, height: animalPhotoSize, // Usar tamaño fijo para la foto
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
                            errorWidget: (context, url, error) => Icon(Icons.pets, size: 50, color: Colors.grey[600]))
                            : Icon(Icons.pets, size: 50, color: Colors.grey[600]),
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


          // Área de contenido principal, movida hacia abajo para acomodar la foto del animal
          Positioned(
            top: mainContentTop, // Posición superior ajustada
            left: 20,
            right: 20,
            bottom: 20,
            child: _isLoading
                ? const Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.white)))
                : Form(
              key: _formKey,
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Column(
                  children: [
                    const SizedBox(height: 10), // Pequeño espacio después del nombre del animal

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
                          'Crear Visita Veterinaria',
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
                    Container(
                      height: 60,
                      margin: const EdgeInsets.only(bottom: 20),
                      child: Stack(
                        children: [
                          InkWell(
                            onTap: () => _selectDate(context),
                            child: InputDecorator(
                              decoration: InputDecoration(
                                labelText: 'Fecha de la Visita',
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                                filled: true,
                                fillColor: Colors.white.withOpacity(0.95),
                                contentPadding: const EdgeInsets.only(left: 50.0, top: 15, bottom: 15, right: 15.0),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    _selectedDate != null ? DateFormat('dd/MM/yyyy').format(_selectedDate!) : 'Seleccionar fecha',
                                    style: TextStyle(fontFamily: 'Comic Sans MS', fontSize: 16, color: _selectedDate != null ? Colors.black87 : Colors.grey.shade700),
                                  ),
                                  const Icon(Icons.calendar_today, color: Colors.grey),
                                ],
                              ),
                            ),
                          ),
                          Positioned(
                            left: 5, top: 0, bottom: 10,
                            child: Align(alignment: Alignment.centerLeft, child: Container(width: 35.2, height: 40.0, decoration: const BoxDecoration(image: DecorationImage(image: AssetImage('assets/images/fecha.png'), fit: BoxFit.fill)))),
                          ),
                        ],
                      ),
                    ),

                    // Selector de hora
                    Container(
                      height: 60,
                      margin: const EdgeInsets.only(bottom: 20),
                      child: Stack(
                        children: [
                          InkWell(
                            onTap: () => _selectTime(context),
                            child: InputDecorator(
                              decoration: InputDecoration(
                                labelText: 'Hora de la Visita',
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                                filled: true,
                                fillColor: Colors.white.withOpacity(0.95),
                                contentPadding: const EdgeInsets.only(left: 50.0, top: 15, bottom: 15, right: 15.0),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    _selectedTime != null ? _selectedTime!.format(context) : 'Seleccionar hora',
                                    style: TextStyle(fontFamily: 'Comic Sans MS', fontSize: 16, color: _selectedTime != null ? Colors.black87 : Colors.grey.shade700),
                                  ),
                                  const Icon(Icons.access_time, color: Colors.grey),
                                ],
                              ),
                            ),
                          ),
                          Positioned(
                            left: 5, top: 0, bottom: 10,
                            child: Align(alignment: Alignment.centerLeft, child: Container(width: 35.2, height: 40.0, decoration: const BoxDecoration(image: DecorationImage(image: AssetImage('assets/images/hora.png'), fit: BoxFit.fill)))),
                          ),
                        ],
                      ),
                    ),

                    // Selector de Centro de Atención - Altura consistente con fecha y hora
                    Container(
                      height: 60, // Mantiene la misma altura que Fecha y Hora
                      margin: const EdgeInsets.only(bottom: 20),
                      child: Stack(
                        children: [
                          DropdownButtonFormField<String>(
                            value: _selectedClinicId,
                            decoration: InputDecoration(
                              labelText: _isLocationLoading
                                  ? 'Cargando centros de atención...'
                                  : (_locationError ?? 'Centro de Atención'), // Muestra error o etiqueta normal
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                              filled: true,
                              fillColor: Colors.white.withOpacity(0.95),
                              // Padding de contenido consistente con los campos de fecha/hora
                              contentPadding: const EdgeInsets.only(left: 50.0, right: 15.0, top: 15, bottom: 15),
                            ),
                            items: _clinics.map((clinic) {
                              String clinicName = clinic['name'] ?? 'Clínica desconocida';
                              String distanceText = '';
                              if (clinic['distance'] != null && clinic['distance'] != double.infinity) {
                                // Convertir metros a km y formatear a 1 decimal
                                double distanceKm = clinic['distance'] / 1000;
                                distanceText = ' (${distanceKm.toStringAsFixed(1)} km)';
                              }
                              return DropdownMenuItem<String>(
                                value: clinic['id'] as String,
                                child: Text('$clinicName$distanceText', style: const TextStyle(fontFamily: 'Comic Sans MS', fontSize: 16)),
                              );
                            }).toList(),
                            onChanged: _isLoading || _isLocationLoading ? null : (value) { // Deshabilitar si se está cargando
                              setState(() {
                                _selectedClinicId = value;
                                final selectedClinic = _clinics.firstWhere((clinic) => clinic['id'] == value);
                                _selectedClinicName = selectedClinic['name'] as String?;
                                _selectedClinicAddress = selectedClinic['address'] as String?;
                              });
                            },
                            validator: (value) => value == null ? 'Seleccione un centro' : null,
                            isExpanded: true,
                          ),
                          Positioned(
                            left: 5, top: 0, bottom: 10,
                            child: Align(alignment: Alignment.centerLeft, child: Container(width: 35.2, height: 40.0, decoration: const BoxDecoration(image: DecorationImage(image: AssetImage('assets/images/ubicacion.png'), fit: BoxFit.fill)))),
                          ),
                          if (_isLocationLoading) // Muestra un pequeño indicador de carga junto a la etiqueta
                            Positioned(
                              right: 40, // Ajusta la posición según sea necesario
                              top: 0,
                              bottom: 0,
                              child: Center(
                                child: SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(strokeWidth: 2.0, valueColor: AlwaysStoppedAnimation<Color>(Colors.grey.shade600)),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),

                    // Muestra el error de ubicación si existe
                    if (_locationError != null && !_isLocationLoading)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10.0),
                        child: Text(
                          _locationError!,
                          style: const TextStyle(
                            fontFamily: 'Comic Sans MS',
                            fontSize: 14,
                            color: Colors.red,
                            fontWeight: FontWeight.w600,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),

                    // Campo de texto para el nombre del Veterinario (ahora editable por el dueño)
                    // MODIFICADO: Uso de los nuevos parámetros de posicionamiento para el icono
                    _buildTextFormFieldWithIcon(
                      controller: _veterinarianNameController,
                      labelText: 'Nombre del Veterinario',
                      assetIconPath: 'assets/images/veterinario.png', // Asegúrate de tener este icono
                      validator: (v) => v!.isEmpty ? 'Ingrese nombre del veterinario' : null,
                      iconWidth: 40, iconHeight: 40.0,
                      iconPositionedTop: 5.0, // Coloca el icono a 10px del top del Container (centrado verticalmente para campos de 60px de alto con icono de 40px)
                      // iconPositionedBottom: null, // No es necesario especificar si iconPositionedTop ya está
                      // iconPositionedLeft: 5.0, // Puedes ajustarlo si deseas moverlo horizontalmente
                    ),

                    // Campos de texto para la visita
                    _buildTextFormFieldWithIcon(
                      controller: _diagnosticoController,
                      labelText: 'Diagnóstico',
                      assetIconPath: 'assets/images/diagnostico.png',
                      iconWidth: 40.0, iconHeight: 40.0,
                      maxLines: 3,
                      validator: (v) => v!.isEmpty ? 'Ingrese diagnóstico' : null,
                    ),
                    _buildTextFormFieldWithIcon(
                      controller: _tratamientoController,
                      labelText: 'Tratamiento',
                      assetIconPath: 'assets/images/tratamiento.png',
                      iconWidth: 40.0, iconHeight: 40.0,
                      maxLines: 3,
                      validator: (v) => v!.isEmpty ? 'Ingrese tratamiento' : null,
                    ),
                    _buildTextFormFieldWithIcon(
                      controller: _medicamentosController,
                      labelText: 'Medicamentos',
                      assetIconPath: 'assets/images/medicamentos.png',
                      iconWidth: 40.0, iconHeight: 40.0,
                      maxLines: 3,
                    ),
                    _buildTextFormFieldWithIcon(
                      controller: _observacionesController,
                      labelText: 'Observaciones',
                      assetIconPath: 'assets/images/observaciones.png',
                      iconWidth: 40.0, iconHeight: 40.0,
                      maxLines: 3,
                    ),
                    _buildTextFormFieldWithIcon(
                      controller: _costoController,
                      labelText: 'Costo (\$)',
                      assetIconPath: 'assets/images/costo.png',
                      iconWidth: 40.0, iconHeight: 40.0,
                      keyboardType: TextInputType.numberWithOptions(decimal: true),
                      validator: (v) => v!.isEmpty ? 'Ingrese costo' : (double.tryParse(v.replaceAll(',', '.')) == null ? 'Número inválido' : null),
                    ),
                    const SizedBox(height: 20),

                    // Botón para guardar visita - ¡MODIFICADO CON EL NUEVO ICONO!
                    GestureDetector(
                      onTap: _isSaving ? null : _saveVisit,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Image.asset(
                            'assets/images/visitavet.png', // Nuevo icono para crear la visita
                            width: 120.0, // Ancho de 120
                            height: 120.0, // Altura de 120 (para que sea cuadrado)
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
    );
  }
}