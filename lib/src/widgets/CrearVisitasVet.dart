import 'package:flutter/material.dart';
import 'package:adobe_xd/pinned.dart';
import 'package:adobe_xd/page_link.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'dart:developer' as developer; // Para logs

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

  // NUEVOS CONTROLADORES PARA LA DIRECCIÓN DEL CENTRO DE ATENCIÓN
  final TextEditingController _centerNameController = TextEditingController(); // Nombre del Centro de Atención
  String? _selectedAddressType; // Tipo de vía (Calle, Carrera, Av, etc.)
  final TextEditingController _addressNumberController = TextEditingController(); // Número principal (ej: 74)
  final TextEditingController _addressComplementController = TextEditingController(); // Números complementarios (ej: 114-35)

  // AÑADIDO: Controladores para Fecha y Hora
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();


  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;

  // bool _isLoading = true; // ELIMINADO: Se usa para el indicador de carga general, ahora solo en GPS
  bool _isSaving = false;

  // NUEVAS VARIABLES DE ESTADO PARA UBICACIÓN Y DATOS DEL ANIMAL
  Position? _currentPosition;
  String _currentLocationString = "Obteniendo ubicación..."; // Coordenadas GPS
  String? _locationError;
  bool _isLocationLoading = false; // Para indicar si la ubicación se está cargando
  Animal? _animalData; // Para almacenar los datos del animal

  @override
  void initState() {
    super.initState();
    // Las cargas ahora no bloquean la UI del formulario de inicio
    _loadAnimalData(); // Carga datos del animal de inmediato
    _loadLocationData(); // Inicia carga de ubicación en segundo plano
    // Inicializar controladores de fecha y hora (aunque al principio estén vacíos)
    _dateController.text = _selectedDate != null ? DateFormat('dd/MM/yyyy').format(_selectedDate!) : '';
    _timeController.text = _selectedTime != null ? _selectedTime!.format(context) : '';
  }

  // Método separado para cargar datos del animal
  Future<void> _loadAnimalData() async {
    final User? currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Usuario no autenticado.')));
        Navigator.pop(context); // O redirigir a login
      }
      return;
    }

    if (widget.animalId.isEmpty) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('ID de animal no proporcionado.')));
        Navigator.pop(context); // O redirigir a lista de animales
      }
      return;
    }

    try {
      final animalDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser.uid)
          .collection('animals')
          .doc(widget.animalId)
          .get();
      if (mounted) {
        setState(() {
          if (animalDoc.exists) {
            _animalData = Animal.fromFirestore(animalDoc);
          } else {
            developer.log("Documento del animal con ID ${widget.animalId} no encontrado.");
          }
        });
      }
    } catch (e) {
      developer.log("Error cargando datos del animal: $e");
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error al cargar datos del animal: $e')));
    }
  }


  // Método para obtener la ubicación (modificado para ser un Future que se actualiza en segundo plano)
  Future<void> _loadLocationData() async {
    if (!mounted) return;
    setState(() {
      _isLocationLoading = true; // Empieza a cargar ubicación
      _locationError = null; // Reinicia errores de ubicación
    });

    try {
      bool serviceEnabled;
      LocationPermission permission;

      serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        _locationError = 'Los servicios de ubicación están deshabilitados. No se pueden obtener coordenadas.';
        developer.log(_locationError!);
      }

      permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          _locationError = 'Permiso de ubicación denegado. No se pueden obtener coordenadas.';
          developer.log(_locationError!);
        }
      }

      if (permission == LocationPermission.deniedForever) {
        _locationError = 'Los permisos de ubicación están denegados permanentemente. Por favor, habilítelos desde la configuración de su dispositivo.';
        developer.log(_locationError!);
      }

      if (_locationError == null && serviceEnabled && (permission == LocationPermission.whileInUse || permission == LocationPermission.always)) {
        try {
          Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
          if (!mounted) return;
          setState(() {
            _currentPosition = position;
            _currentLocationString = "Lat: ${position.latitude.toStringAsFixed(4)}, Lon: ${position.longitude.toStringAsFixed(4)}";
          });
          developer.log("Ubicación actual: ${_currentPosition?.latitude}, ${_currentPosition?.longitude}");
        } catch (e) {
          _locationError = 'Error al obtener la ubicación: $e';
          developer.log(_locationError!);
        }
      }
    } catch (e) {
      _locationError = 'Error con la geolocalización: $e';
      developer.log("Error durante la inicialización de geolocator: $e");
    } finally {
      if (mounted) {
        setState(() {
          _isLocationLoading = false; // Finaliza la carga de ubicación
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
      if (mounted) {
        setState(() {
          _selectedDate = picked;
          _dateController.text = DateFormat('dd/MM/yyyy').format(picked); // ACTUALIZAR CONTROLADOR DE FECHA
        });
      }
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
      if (mounted) {
        setState(() {
          _selectedTime = picked;
          _timeController.text = picked.format(context); // ACTUALIZAR CONTROLADOR DE HORA
        });
      }
    }
  }

  // Helper para construir la dirección completa a partir de los campos estructurados
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

  Future<void> _saveVisit() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    if (_selectedDate == null || _selectedTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Por favor, seleccione la fecha y hora de la visita.')));
      return;
    }
    // Validar que se haya ingresado el nombre del centro y al menos el tipo y número de vía
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
        if (mounted) Navigator.pop(context); // Volver o redirigir
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
        'hora': _selectedTime!.format(context), // Opcional: guardar como string también
        'centroAtencionNombre': _centerNameController.text.trim(), // Nombre del centro de atención
        'centroAtencionTipoVia': _selectedAddressType, // Tipo de vía
        'centroAtencionNumeroVia': _addressNumberController.text.trim(), // Número de vía
        'centroAtencionComplemento': _addressComplementController.text.trim(), // Complemento
        'centroAtencionDireccionCompleta': _buildFullAddress(), // Dirección completa para mostrar fácilmente
        'centroAtencionCoordenadas': _currentLocationString, // Coordenadas GPS
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
      developer.log("Error al guardar visita: $e");
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
    _centerNameController.dispose();
    _addressNumberController.dispose();
    _addressComplementController.dispose();
    // AÑADIDO: Disponer los controladores de fecha y hora
    _dateController.dispose();
    _timeController.dispose();
    super.dispose();
  }

  Widget _buildFormField({
    TextEditingController? controller,
    required String label, // Este es el parámetro que se usa para el título del campo
    required String iconAsset,
    required String tooltipMessage, // Añadido para el Tooltip
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
    bool readOnly = false,
    VoidCallback? onTap,
    int? maxLines = 1,
    Widget? suffixIcon, // Para iconos al final, como en Date/Time pickers
  }) {
    const double iconSize = 42.0; // Altura base para todos los íconos
    const double iconLeftPadding = 10.0;
    const double textFieldLeftPadding = iconLeftPadding + iconSize + 10.0; // Padding del contenido para el texto

    return Container(
      margin: const EdgeInsets.only(bottom: 18.0),
      child: Stack(
        alignment: Alignment.centerLeft,
        children: [
          TextFormField(
            controller: controller, // USANDO EL CONTROLADOR
            readOnly: readOnly,
            onTap: onTap,
            keyboardType: keyboardType,
            maxLines: maxLines,
            style: const TextStyle(fontFamily: 'Comic Sans MS', fontSize: 15, color: Colors.black87),
            decoration: InputDecoration(
              labelText: label, // Aquí se usa el parámetro 'label' para el título
              labelStyle: const TextStyle(fontFamily: 'Comic Sans MS', color: Colors.black54, fontSize: 15),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.0), borderSide: BorderSide(color: Colors.grey.shade400)),
              enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12.0), borderSide: BorderSide(color: Theme.of(context).primaryColor, width: 1.5)),
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
            child: Tooltip( // Tooltip añadido
              message: 'Ir a Inicio',
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
          ),
          Pinned.fromPins(
            Pin(size: 52.9, start: 15.0), Pin(size: 50.0, start: 49.0),
            child: Tooltip( // Tooltip añadido
              message: 'Volver a la pantalla anterior',
              child: GestureDetector(
                onTap: () => Navigator.of(context).pop(),
                child: Container(decoration: const BoxDecoration(image: DecorationImage(image: AssetImage('assets/images/back.png'), fit: BoxFit.fill))),
              ),
            ),
          ),
          Pinned.fromPins(
            Pin(size: 47.2, end: 7.6), Pin(size: 50.0, start: 49.0),
            child: Tooltip( // Tooltip añadido
              message: 'Configuraciones de la Aplicación',
              child: PageLink(
                links: [PageLinkInfo(transition: LinkTransition.Fade, ease: Curves.easeOut, duration: 0.3, pageBuilder: () => Configuraciones(key: const Key('Settings'), authService: AuthService()))],
                child: Container(decoration: const BoxDecoration(image: DecorationImage(image: AssetImage('assets/images/settingsbutton.png'), fit: BoxFit.fill))),
              ),
            ),
          ),
          Pinned.fromPins(
            Pin(size: 40.5, end: 7.6 + 47.2 + 5.0), Pin(size: 50.0, start: 49.0),
            child: Tooltip( // Tooltip añadido
              message: 'Ayuda y Soporte',
              child: PageLink(
                links: [PageLinkInfo(transition: LinkTransition.Fade, ease: Curves.easeOut, duration: 0.3, pageBuilder: () => Ayuda(key: const Key('Ayuda')))],
                child: Container(decoration: const BoxDecoration(image: DecorationImage(image: AssetImage('assets/images/help.png'), fit: BoxFit.fill))),
              ),
            ),
          ),

          // NUEVO: Foto y Nombre del Animal
          Positioned(
            top: animalPhotoTop, // Posición ajustada para el diseño actual
            left: 0,
            right: 0,
            child: _animalData != null
                ? Center(
              child: Tooltip( // Tooltip para la foto del animal
                message: 'Ver perfil de ${_animalData!.nombre}',
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
                            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.3), spreadRadius: 2, blurRadius: 5, offset: const Offset(0,3))]
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(22.5),
                          child: (_animalData!.fotoPerfilUrl != null && _animalData!.fotoPerfilUrl!.isNotEmpty)
                              ? CachedNetworkImage(
                              imageUrl: _animalData!.fotoPerfilUrl!, fit: BoxFit.cover,
                              placeholder: (context, url) => const Center(child: CircularProgressIndicator(strokeWidth: 2.0)),
                              errorWidget: (context, url, error) => Icon(Icons.pets, size: 50, color: Colors.grey[600]))
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
                                shadows: [Shadow(blurRadius: 1.0, color: Colors.black, offset: Offset(1.0,1.0))]
                            ),
                          ),
                        ),
                    ],
                  ),
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
            child: Form( // ELIMINADO EL _isLoading GENERAL
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
                    _buildFormField(
                      controller: _dateController, // USANDO EL CONTROLADOR
                      label: 'Fecha de la Visita',
                      iconAsset: 'assets/images/fechavisita.png',
                      readOnly: true,
                      onTap: () => _selectDate(context),
                      suffixIcon: const Icon(Icons.calendar_today, color: Colors.grey),
                      tooltipMessage: 'Seleccionar la fecha de la visita', // Tooltip
                    ),

                    // Selector de hora
                    _buildFormField(
                      controller: _timeController, // USANDO EL CONTROLADOR
                      label: 'Hora de la Visita',
                      iconAsset: 'assets/images/horavisita.png',
                      readOnly: true,
                      onTap: () => _selectTime(context),
                      suffixIcon: const Icon(Icons.access_time, color: Colors.grey),
                      tooltipMessage: 'Seleccionar la hora de la visita', // Tooltip
                    ),

                    // Campo: Nombre del Centro de Atención
                    _buildFormField(
                      controller: _centerNameController,
                      label: 'Nombre del Centro de Atención',
                      iconAsset: 'assets/images/centrodeatencion.png',
                      validator: (v) => v!.isEmpty ? 'Ingrese el nombre del centro de atención' : null,
                      tooltipMessage: 'Nombre del centro o clínica veterinaria', // Tooltip
                    ),

                    // --- Bloque de Dirección Estructurada para el Centro de Atención ---
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
                      tooltipMessage: 'Número de la calle o vía del centro', // Tooltip
                    ),
                    _buildFormField(
                      controller: _addressComplementController,
                      label: 'Números Complementarios (Ej: # 114-35)',
                      iconAsset: 'assets/images/#.png',
                      tooltipMessage: 'Complemento de la dirección (ej: # 114-35)', // Tooltip
                    ),
                    // --- Fin del Bloque de Dirección Estructurada ---

                    // Coordenadas GPS
                    Padding(
                      padding: const EdgeInsets.only(bottom: 18.0),
                      child: Tooltip( // Tooltip para el campo de Coordenadas GPS
                        message: _isLocationLoading ? 'Obteniendo coordenadas GPS...' : _locationError ?? 'Coordenadas GPS de la ubicación actual',
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
                                child: Tooltip( // Tooltip para el icono de Coordenadas
                                  message: 'Icono de Coordenadas',
                                  child: Image.asset('assets/images/coordenada.png', width: 42, height: 42, fit: BoxFit.contain),
                                ),
                              )
                          ),
                          child: _isLocationLoading
                              ? const SizedBox(height: 20, width:20, child: Center(child: CircularProgressIndicator(strokeWidth: 2.0, valueColor: AlwaysStoppedAnimation<Color>(Color(0xff4ec8dd)))))
                              : Padding(
                            padding: const EdgeInsets.only(top: 1.0),
                            child: Text(_currentLocationString, style: const TextStyle(fontFamily: 'Comic Sans MS', fontSize: 15, color: Colors.black87)),
                          ),
                        ),
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

                    // Campo de texto para el nombre del Veterinario
                    _buildFormField(
                      controller: _veterinarianNameController,
                      label: 'Nombre del Veterinario',
                      iconAsset: 'assets/images/veterinario.png',
                      validator: (v) => v!.isEmpty ? 'Ingrese nombre del veterinario' : null,
                      tooltipMessage: 'Nombre del veterinario que atenderá la visita', // Tooltip
                    ),

                    // Campos de texto para la visita
                    _buildFormField(
                      controller: _diagnosticoController,
                      label: 'Diagnóstico',
                      iconAsset: 'assets/images/diagnostico.png',
                      maxLines: 3,
                      validator: (v) => v!.isEmpty ? 'Ingrese diagnóstico' : null,
                      tooltipMessage: 'Diagnóstico de la condición del animal', // Tooltip
                    ),
                    _buildFormField(
                      controller: _tratamientoController,
                      label: 'Tratamiento',
                      iconAsset: 'assets/images/tratamiento.png',
                      maxLines: 3,
                      validator: (v) => v!.isEmpty ? 'Ingrese tratamiento' : null,
                      tooltipMessage: 'Tratamiento recetado para el animal', // Tooltip
                    ),
                    _buildFormField(
                      controller: _medicamentosController,
                      label: 'Medicamentos',
                      iconAsset: 'assets/images/medicamentos.png',
                      maxLines: 3,
                      tooltipMessage: 'Medicamentos y dosis prescritas', // Tooltip
                    ),
                    _buildFormField(
                      controller: _observacionesController,
                      label: 'Observaciones',
                      iconAsset: 'assets/images/observaciones.png',
                      maxLines: 3,
                      tooltipMessage: 'Cualquier observación adicional relevante', // Tooltip
                    ),
                    _buildFormField(
                      controller: _costoController,
                      label: 'Costo (\$)',
                      iconAsset: 'assets/images/costo.png',
                      keyboardType: TextInputType.numberWithOptions(decimal: true),
                      validator: (v) => v!.isEmpty ? 'Ingrese costo' : (double.tryParse(v.replaceAll(',', '.')) == null ? 'Número inválido' : null),
                      tooltipMessage: 'Costo total de la visita', // Tooltip
                    ),
                    const SizedBox(height: 20),

                    // Botón para guardar visita
                    Tooltip( // Tooltip para el botón de guardar visita
                      message: 'Guardar nueva visita veterinaria',
                      child: GestureDetector(
                        onTap: _isSaving ? null : _saveVisit,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Image.asset(
                              'assets/images/visitavet.png', // Nuevo icono para crear la visita
                              width: 120.0,
                              height: 120.0,
                              fit: BoxFit.fill,
                            ),
                            if (_isSaving) const CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.white)),
                          ],
                        ),
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