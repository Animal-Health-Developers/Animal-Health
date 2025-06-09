import 'package:flutter/material.dart';
import 'package:adobe_xd/pinned.dart';
import '../services/auth_service.dart';
import './Home.dart';
import 'package:adobe_xd/page_link.dart';
import './Ayuda.dart';
import './PerfilPublico.dart';
import './Configuracion.dart';
import './ListadeAnimales.dart';
import './CompradeProductos.dart';
import './CuidadosyRecomendaciones.dart';
import './Emergencias.dart';
import './Comunidad.dart';
import './Crearpublicaciones.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:developer' as developer;

class ServiciodeAmbulancia extends StatefulWidget {
  const ServiciodeAmbulancia({
    required Key key,
  }) : super(key: key);

  @override
  _ServiciodeAmbulanciaState createState() => _ServiciodeAmbulanciaState();
}

class _ServiciodeAmbulanciaState extends State<ServiciodeAmbulancia> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nombreAnimalController = TextEditingController();
  final TextEditingController _edadController = TextEditingController();
  final TextEditingController _especieController = TextEditingController();
  final TextEditingController _razaController = TextEditingController();
  final TextEditingController _pesoController = TextEditingController();
  final TextEditingController _largoController = TextEditingController();
  final TextEditingController _anchoController = TextEditingController();
  final TextEditingController _otroProblemaController = TextEditingController();

  // Controladores y variable para la nueva dirección estructurada
  String? _selectedAddressType; // Tipo de vía (Calle, Carrera, Av, etc.)
  final TextEditingController _addressNumberController = TextEditingController(); // Número principal (ej: 74)
  final TextEditingController _addressComplementController = TextEditingController(); // Números complementarios (ej: 114-35)


  final List<String> _healthProblems = [
    'Atragantamiento', 'Fractura Expuesta', 'Fractura Interna', 'Golpe de Calor',
    'Herida Abierta Sangrante', 'Herida Leve', 'Intoxicación / Envenenamiento',
    'Picadura de Insecto / Animal', 'Reacción Alérgica Grave', 'Reacción Alérgica Leve',
    'Problemas Respiratorios Agudos', 'Convulsiones', 'Vómitos Persistentes / Diarrea',
    'Letargo Extremo / Debilidad', 'Sangrado Nasal / Ocular / Ótico',
    'Dificultad para Orinar / Defecar', 'Abdomen Hinchado / Duro', 'Otro (especificar)',
  ];
  String? _selectedHealthProblem;
  bool _showOtroProblemaField = false;

  String _currentLocationString = "Obteniendo ubicación..."; // Coordenadas GPS
  bool _isLocationLoading = true;

  final Map<String, String> _contactInfo = {
    'name': 'Cargando...',
    'email': 'Cargando...',
    'documento': 'Cargando...',
    'contacto' : 'Cargando...'
  };
  bool _isContactInfoLoading = true;

  final ImagePicker _picker = ImagePicker();
  Uint8List? _historiaClinicaBytes;
  File? _historiaClinicaFile;
  String? _historiaClinicaFileName;
  bool _isUploadingHistoria = false;


  @override
  void initState() {
    super.initState();
    _initializeFieldsAndLoadData();
  }

  void _initializeFieldsAndLoadData() {
    _fetchUserLocation();
    _fetchContactInfo();
  }

  Future<void> _fetchUserLocation() async {
    if (!mounted) return;
    setState(() { _isLocationLoading = true; _currentLocationString = "Obteniendo ubicación...";});

    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      if (!mounted) return;
      setState(() { _currentLocationString = 'Servicio de ubicación desactivado.'; _isLocationLoading = false; });
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Servicio de ubicación desactivado. Por favor, actívalos.')));
      return;
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        if (!mounted) return;
        setState(() { _currentLocationString = 'Permiso de ubicación denegado.'; _isLocationLoading = false;});
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Permiso de ubicación denegado.')));
        return;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      if (!mounted) return;
      setState(() { _currentLocationString = 'Permiso de ubicación denegado permanentemente.'; _isLocationLoading = false;});
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Permiso de ubicación denegado permanentemente. Habilítalo desde la configuración.')));
      return;
    }
    try {
      Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.medium);
      if (!mounted) return;
      setState(() {
        _currentLocationString = "Lat: ${position.latitude.toStringAsFixed(4)}, Lon: ${position.longitude.toStringAsFixed(4)}";
        _isLocationLoading = false;
      });
    } catch (e) {
      developer.log("Error obteniendo ubicación: $e");
      if (!mounted) return;
      setState(() { _currentLocationString = "Error al obtener ubicación."; _isLocationLoading = false;});
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error al obtener ubicación: $e')));
    }
  }

  Future<void> _fetchContactInfo() async {
    if (!mounted) return;
    setState(() { _isContactInfoLoading = true; });
    User? currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      try {
        DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('users').doc(currentUser.uid).get();
        if (!mounted) return;
        setState(() {
          _contactInfo['name'] = userDoc.get('displayName') ?? currentUser.displayName ?? 'No disponible';
          _contactInfo['email'] = currentUser.email ?? 'No disponible';
          _contactInfo['documento'] = userDoc.get('documentId') ?? 'No disponible';
          _contactInfo['contacto'] = userDoc.get('contacto') ?? 'No disponible';
          _isContactInfoLoading = false;
        });
      } catch (e) {
        developer.log("Error obteniendo información de contacto de Firestore: $e");
        if (!mounted) return;
        setState(() {
          _contactInfo['name'] = currentUser.displayName ?? 'Error al cargar';
          _contactInfo['email'] = currentUser.email ?? 'Error al cargar';
          _contactInfo['documento'] = 'Error al cargar';
          _contactInfo['contacto'] = 'Error al cargar';
          _isContactInfoLoading = false;
        });
      }
    } else {
      if (!mounted) return;
      setState(() {
        _contactInfo['name'] = 'Usuario no autenticado';
        _contactInfo['email'] = 'N/A';
        _contactInfo['documento'] = 'N/A';
        _contactInfo['contacto'] = 'N/A';
        _isContactInfoLoading = false;
      });
    }
  }

  Future<void> _pickHistoriaClinica() async {
    try {
      final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        _historiaClinicaFileName = pickedFile.name;
        if (kIsWeb) {
          final bytes = await pickedFile.readAsBytes();
          if (!mounted) return;
          setState(() { _historiaClinicaBytes = bytes; _historiaClinicaFile = null; });
        } else {
          if (!mounted) return;
          setState(() { _historiaClinicaFile = File(pickedFile.path); _historiaClinicaBytes = null; });
        }
      }
    } catch (e) {
      developer.log("Error seleccionando historia clínica: $e");
      if(mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error al seleccionar archivo: $e')));
    }
  }

  Future<String?> _uploadHistoriaClinica() async {
    if (_historiaClinicaBytes == null && _historiaClinicaFile == null) return null;
    if (!mounted) return null;

    setState(() { _isUploadingHistoria = true; });

    String? downloadUrl;

    try {
      final userId = FirebaseAuth.instance.currentUser?.uid;
      if (userId == null) throw Exception("Usuario no autenticado.");
      final fileName = _historiaClinicaFileName ?? 'historia_clinica_${DateTime.now().millisecondsSinceEpoch}';
      final storageRef = firebase_storage.FirebaseStorage.instance
          .ref()
          .child('historias_clinicas/$userId/$fileName');

      firebase_storage.UploadTask uploadTask;
      if (kIsWeb) {
        if (_historiaClinicaBytes == null) throw Exception("Bytes de historia clínica no disponibles para web.");
        uploadTask = storageRef.putData(_historiaClinicaBytes!);
      } else {
        if (_historiaClinicaFile == null) throw Exception("Archivo de historia clínica no disponible para móvil.");
        uploadTask = storageRef.putFile(_historiaClinicaFile!);
      }

      final taskSnapshot = await uploadTask.whenComplete(() {});
      downloadUrl = await taskSnapshot.ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      developer.log("Error subiendo historia clínica: $e");
      if(mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error al subir archivo: $e')));
      return null;
    } finally {
      if (mounted) {
        setState(() { _isUploadingHistoria = false; });
      }
    }
  }


  Future<void> _solicitarAmbulancia() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      if (_isUploadingHistoria) {
        if(mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Espere a que termine de subirse la historia clínica.')));
        return;
      }

      String? historiaClinicaUrl;
      if (_historiaClinicaBytes != null || _historiaClinicaFile != null) {
        historiaClinicaUrl = await _uploadHistoriaClinica();
        if (historiaClinicaUrl == null && mounted) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('No se pudo subir la historia clínica. Intente de nuevo.')));
          return;
        }
      }

      // Construir la dirección estructurada
      String fullAddress = "";
      if (_selectedAddressType != null && _addressNumberController.text.isNotEmpty) {
        fullAddress = "$_selectedAddressType ${_addressNumberController.text}";
        if (_addressComplementController.text.isNotEmpty) {
          fullAddress += " - ${_addressComplementController.text}";
        }
      }

      final solicitudData = {
        'nombreAnimal': _nombreAnimalController.text,
        'edadAnimal': _edadController.text,
        'especieAnimal': _especieController.text,
        'razaAnimal': _razaController.text,
        'pesoAnimal': _pesoController.text,
        'largoAnimal': _largoController.text,
        'anchoAnimal': _anchoController.text,
        'problemaMotivo': _selectedHealthProblem == 'Otro (especificar)' ? _otroProblemaController.text : _selectedHealthProblem,
        'ubicacionRecogida': fullAddress, // Dirección estructurada ingresada
        'coordenadasRecogida': _currentLocationString, // Coordenadas GPS obtenidas automáticamente
        'contactoNombre': _contactInfo['name'],
        'contactoEmail': _contactInfo['email'],
        'contactoDocumento': _contactInfo['documento'],
        'contactoTelefono': _contactInfo['contacto'],
        'historiaClinicaUrl': historiaClinicaUrl,
        'fechaSolicitud': FieldValue.serverTimestamp(),
        'solicitanteId': FirebaseAuth.instance.currentUser?.uid,
        'estado': 'Pendiente',
      };

      developer.log("Datos de solicitud de ambulancia: $solicitudData");

      try {
        await FirebaseFirestore.instance.collection('solicitudes_ambulancia').add(solicitudData);
        if(mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Solicitud de ambulancia enviada exitosamente.'), backgroundColor: Colors.green),
          );
          _formKey.currentState?.reset();
          _nombreAnimalController.clear();
          _edadController.clear();
          _especieController.clear();
          _razaController.clear();
          _pesoController.clear();
          _largoController.clear();
          _anchoController.clear();
          _otroProblemaController.clear();
          _addressNumberController.clear(); // Limpiar campos de dirección
          _addressComplementController.clear(); // Limpiar campos de dirección
          setState(() {
            _selectedHealthProblem = null;
            _selectedAddressType = null; // Resetear tipo de vía
            _historiaClinicaBytes = null;
            _historiaClinicaFile = null;
            _historiaClinicaFileName = null;
            _showOtroProblemaField = false;
          });
        }
      } catch (e) {
        developer.log("Error guardando solicitud de ambulancia: $e");
        if(mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error al enviar solicitud: $e')));
      }
    }
  }


  @override
  void dispose() {
    _nombreAnimalController.dispose();
    _edadController.dispose();
    _especieController.dispose();
    _razaController.dispose();
    _pesoController.dispose();
    _largoController.dispose();
    _anchoController.dispose();
    _otroProblemaController.dispose();
    _addressNumberController.dispose(); // Disponer controladores de dirección
    _addressComplementController.dispose(); // Disponer controladores de dirección
    super.dispose();
  }

  Widget _buildNavigationButtonItem({
    required String imagePath,
    bool isHighlighted = false,
    double? fixedWidth,
    double height = 60.0,
  }) {
    double itemWidth;
    if (fixedWidth != null) {
      itemWidth = fixedWidth;
    } else {
      if (imagePath.contains('noticias')) {
        itemWidth = 54.3;
      } else if (imagePath.contains('cuidadosrecomendaciones')) itemWidth = 63.0;
      else if (imagePath.contains('emergencias')) itemWidth = 65.0;
      else if (imagePath.contains('comunidad')) itemWidth = 67.0;
      else if (imagePath.contains('crearpublicacion')) itemWidth = 53.6;
      else itemWidth = 60.0;
    }
    return Container(
      width: itemWidth, height: height,
      decoration: BoxDecoration(
        image: DecorationImage(image: AssetImage(imagePath), fit: BoxFit.fill),
        boxShadow: isHighlighted ? const [BoxShadow(color: Color(0xffa3f0fb), offset: Offset(0, 3), blurRadius: 6)] : null,
      ),
    );
  }

  Widget _buildFormField({
    required TextEditingController controller,
    required String label,
    required String iconAsset,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
    bool readOnly = false,
    VoidCallback? onTap,
    int? maxLines = 1, // Añadido para controlar maxLines
  }) {
    const double iconSize = 42.0; // Altura base para todos los íconos
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
              contentPadding: EdgeInsets.only(left: textFieldLeftPadding, top: 18, bottom: 18, right: 15),
              floatingLabelBehavior: FloatingLabelBehavior.auto,
            ),
            validator: validator,
          ),
          Padding(
            padding: EdgeInsets.only(left: iconLeftPadding),
            child: Image.asset(
              iconAsset,
              width: iconSize, // Usar iconSize para mantener la misma altura
              height: iconSize, // Usar iconSize para mantener la misma altura
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


  @override
  Widget build(BuildContext context) {
    const double navBarTopPosition = 200.0;
    const double navBarHeight = 60.0;
    const double spaceBelowNavBar = 15.0;
    final double topOffsetForContent = navBarTopPosition + navBarHeight + spaceBelowNavBar;

    return Scaffold(
      backgroundColor: const Color(0xff4ec8dd),
      body: Stack(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: const AssetImage('assets/images/Animal Health Fondo de Pantalla.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Pinned.fromPins(
            Pin(size: 74.0, middle: 0.5),
            Pin(size: 73.0, start: 42.0),
            child: PageLink(
              links: [PageLinkInfo(pageBuilder: () => Home(key: Key('Home')))],
              child: Container(
                decoration: BoxDecoration(
                  image: DecorationImage(image: const AssetImage('assets/images/logo.png'), fit: BoxFit.cover),
                  borderRadius: BorderRadius.circular(15.0),
                  border: Border.all(width: 1.0, color: const Color(0xff000000)),
                ),
              ),
            ),
          ),
          Pinned.fromPins(
            Pin(size: 40.5, middle: 0.8328),
            Pin(size: 50.0, start: 49.0),
            child: PageLink(
              links: [PageLinkInfo(pageBuilder: () => Ayuda(key: Key('Ayuda')))],
              child: Container(
                decoration: BoxDecoration(image: DecorationImage(image: const AssetImage('assets/images/help.png'), fit: BoxFit.fill)),
              ),
            ),
          ),
          Pinned.fromPins(
            Pin(size: 307.0, middle: 0.5),
            Pin(size: 45.0, start: 150.0),
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xffffffff),
                borderRadius: BorderRadius.circular(5.0),
                border: Border.all(width: 1.0, color: const Color(0xff707070)),
              ),
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Image.asset('assets/images/busqueda1.png', width: 24.0, height: 24.0),
                  ),
                  const Expanded(
                    child: TextField(
                      style: TextStyle(fontFamily: 'Comic Sans MS', fontSize: 18, color: Color(0xff000000)),
                      decoration: InputDecoration(
                        hintText: 'Buscar...',
                        hintStyle: TextStyle(fontFamily: 'Comic Sans MS', fontSize: 18, color: Colors.grey),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(vertical: 12.0),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Pinned.fromPins(
            Pin(size: 60.0, start: 6.0),
            Pin(size: 60.0, middle: 0.1947),
            child: StreamBuilder<DocumentSnapshot>(
              stream: FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser?.uid).snapshots(),
              builder: (context, snapshot) {
                final profilePhotoUrl = snapshot.data?['profilePhotoUrl'] as String?;
                return PageLink(
                  links: [PageLinkInfo(pageBuilder: () => PerfilPublico(key: Key('PerfilPublico')))],
                  child: Container(
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(10.0), color: Colors.grey[200]),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10.0),
                      child: profilePhotoUrl != null && profilePhotoUrl.isNotEmpty
                          ? CachedNetworkImage(
                        imageUrl: profilePhotoUrl,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => const Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Color(0xff4ec8dd)))),
                        errorWidget: (context, url, error) => const Icon(Icons.person, size: 30, color: Colors.grey),
                      )
                          : const Icon(Icons.person, size: 30, color: Colors.grey),
                    ),
                  ),
                );
              },
            ),
          ),
          Pinned.fromPins(
            Pin(size: 47.2, end: 7.6),
            Pin(size: 50.0, start: 49.0),
            child: PageLink(
              links: [PageLinkInfo(pageBuilder: () => Configuraciones(key: const Key('Settings'), authService: AuthService()))],
              child: Container(decoration: const BoxDecoration(image: DecorationImage(image: AssetImage('assets/images/settingsbutton.png'), fit: BoxFit.fill))),
            ),
          ),
          Pinned.fromPins(
            Pin(size: 60.1, start: 6.0),
            Pin(size: 60.0, start: 44.0),
            child: PageLink(
              links: [PageLinkInfo(pageBuilder: () => ListadeAnimales(key: Key('ListadeAnimales')))],
              child: Container(decoration: const BoxDecoration(image: DecorationImage(image: AssetImage('assets/images/listaanimales.png'), fit: BoxFit.fill))),
            ),
          ),
          Pinned.fromPins(
            Pin(size: 58.5, end: 2.0),
            Pin(size: 60.0, start: 105.0),
            child: PageLink(
              links: [PageLinkInfo(pageBuilder: () => CompradeProductos(key: Key('CompradeProductos')))],
              child: Container(decoration: const BoxDecoration(image: DecorationImage(image: AssetImage('assets/images/store.png'), fit: BoxFit.fill))),
            ),
          ),
          Positioned(
            top: navBarTopPosition,
            left: 16.0,
            right: 16.0,
            height: navBarHeight,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                PageLink(links: [PageLinkInfo(pageBuilder: () => Home(key: const Key('Home')))], child: _buildNavigationButtonItem(imagePath: 'assets/images/noticias.png', fixedWidth: 54.3)),
                PageLink(links: [PageLinkInfo(pageBuilder: () => CuidadosyRecomendaciones(key: const Key('CuidadosyRecomendaciones')))], child: _buildNavigationButtonItem(imagePath: 'assets/images/cuidadosrecomendaciones.png', fixedWidth: 63.0)),
                PageLink(links: [PageLinkInfo(pageBuilder: () => const Emergencias(key: Key('Emergencias')))], child: _buildNavigationButtonItem(imagePath: 'assets/images/emergencias.png', isHighlighted: true, fixedWidth: 65.0)),
                PageLink(links: [PageLinkInfo(pageBuilder: () => Comunidad(key: const Key('Comunidad')))], child: _buildNavigationButtonItem(imagePath: 'assets/images/comunidad.png', fixedWidth: 67.0)),
                PageLink(links: [PageLinkInfo(pageBuilder: () => Crearpublicaciones(key: const Key('Crearpublicaciones')))], child: _buildNavigationButtonItem(imagePath: 'assets/images/crearpublicacion.png', fixedWidth: 53.6)),
              ],
            ),
          ),
          Positioned(
            top: topOffsetForContent,
            left: 20.0,
            right: 20.0,
            bottom: 10.0,
            child: Container(
              padding: const EdgeInsets.all(15.0),
              decoration: BoxDecoration(
                color: const Color(0xDDA0F4FE),
                borderRadius: BorderRadius.circular(20.0),
                border: Border.all(width: 1.0, color: const Color(0xB3000000)),
              ),
              child: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(bottom: 20.0),
                        child: Text(
                          'Servicio de Ambulancia',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontFamily: 'Comic Sans MS', fontSize: 22, color: Color(0xff000000), fontWeight: FontWeight.w700),
                        ),
                      ),

                      _buildFormField(controller: _nombreAnimalController, label: 'Nombre del Animal', iconAsset: 'assets/images/nombreanimal.png', validator: (v) => v!.isEmpty ? 'Ingrese nombre' : null),
                      _buildFormField(controller: _edadController, label: 'Edad (ej: 2 años, 6 meses)', iconAsset: 'assets/images/edad.png'),
                      _buildFormField(controller: _especieController, label: 'Especie', iconAsset: 'assets/images/especie.png', validator: (v) => v!.isEmpty ? 'Ingrese especie' : null),
                      _buildFormField(controller: _razaController, label: 'Raza', iconAsset: 'assets/images/raza.png', validator: (v) => v!.isEmpty ? 'Ingrese raza' : null),
                      _buildFormField(controller: _pesoController, label: 'Peso (kg)', iconAsset: 'assets/images/peso.png', keyboardType: TextInputType.numberWithOptions(decimal: true), validator: (v){ if(v!.isEmpty) return 'Ingrese peso'; if(double.tryParse(v) == null) return 'Número inválido'; return null;}),
                      _buildFormField(controller: _largoController, label: 'Largo (cm)', iconAsset: 'assets/images/largo.png', keyboardType: TextInputType.numberWithOptions(decimal: true), validator: (v){ if(v!.isEmpty) return 'Ingrese largo'; if(double.tryParse(v) == null) return 'Número inválido'; return null;}),
                      _buildFormField(controller: _anchoController, label: 'Ancho (cm)', iconAsset: 'assets/images/ancho.png', keyboardType: TextInputType.numberWithOptions(decimal: true), validator: (v){ if(v!.isEmpty) return 'Ingrese ancho'; if(double.tryParse(v) == null) return 'Número inválido'; return null;}),

                      Container(
                        margin: const EdgeInsets.only(bottom: 18.0),
                        child: Stack(
                            children: [
                              DropdownButtonFormField<String>(
                                decoration: InputDecoration(
                                  labelText: 'Problema / Motivo',
                                  labelStyle: const TextStyle(fontFamily: 'Comic Sans MS', color: Colors.black54, fontSize: 15),
                                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.0), borderSide: BorderSide(color: Colors.grey.shade400)),
                                  enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12.0), borderSide: BorderSide(color: Colors.grey.shade500)),
                                  focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12.0), borderSide: BorderSide(color: Theme.of(context).primaryColor, width: 1.5)),
                                  filled: true,
                                  fillColor: Colors.white.withOpacity(0.9),
                                  contentPadding: const EdgeInsets.only(left: 50.0, right: 10.0, top: 18, bottom: 18),
                                ),
                                hint: Text('Seleccione un problema', style: TextStyle(fontFamily: 'Comic Sans MS', color: Colors.grey[600], fontSize: 15)),
                                value: _selectedHealthProblem,
                                isExpanded: true,
                                icon: const Icon(Icons.arrow_drop_down, color: Color(0xff4ec8dd)),
                                style: const TextStyle(fontFamily: 'Comic Sans MS', color: Colors.black87, fontSize: 15), // Estilo del texto seleccionado
                                dropdownColor: Colors.white,
                                items: _healthProblems.map<DropdownMenuItem<String>>((String value) {
                                  return DropdownMenuItem<String>(value: value, child: Text(value, style: TextStyle(fontFamily: 'Comic Sans MS'))); // Estilo de los items del menú
                                }).toList(),
                                onChanged: (String? newValue) {
                                  setState(() {
                                    _selectedHealthProblem = newValue;
                                    _showOtroProblemaField = newValue == 'Otro (especificar)';
                                  });
                                },
                                validator: (value) => value == null ? 'Seleccione un problema' : null,
                              ),
                              Positioned(
                                  left: 8, top: 0, bottom: 0,
                                  child: Center(child: Image.asset('assets/images/motivoconsulta.png', width: 32, height: 32, fit: BoxFit.contain, errorBuilder: (c,e,s) => Icon(Icons.help_outline, size: 30)))
                              ),
                            ]
                        ),
                      ),
                      if (_showOtroProblemaField)
                        _buildFormField(controller: _otroProblemaController, label: 'Especifique el problema', iconAsset: 'assets/images/motivoconsulta.png', validator: (v) => v!.isEmpty ? 'Especifique el problema' : null, maxLines: 3),

                      // --- Nuevo Bloque de Dirección Estructurada ---
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
                              validator: (value) => value == null ? 'Seleccione tipo de vía' : null,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 10.0),
                              child: Image.asset('assets/images/ubicacion.png', width: 42, height: 42, fit: BoxFit.contain, errorBuilder: (c,e,s) => Icon(Icons.location_on_outlined, size: 38)),
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
                        validator: (v) => v!.isEmpty ? 'Ingrese los números complementarios' : null,
                      ),
                      // --- Fin del Bloque de Dirección Estructurada ---

                      Padding(
                        padding: const EdgeInsets.only(bottom: 18.0),
                        child: InputDecorator(
                          decoration: InputDecoration(
                              labelText: 'Coordenadas GPS', // Etiqueta para las coordenadas
                              labelStyle: const TextStyle(fontFamily: 'Comic Sans MS', color: Colors.black54, fontSize: 15),
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.0), borderSide: BorderSide(color: Colors.grey.shade400)),
                              enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12.0), borderSide: BorderSide(color: Colors.grey.shade500)),
                              filled: true,
                              fillColor: Colors.grey[200],
                              contentPadding: const EdgeInsets.only(left: 50.0, top: 18, bottom: 18, right: 15),
                              prefixIconConstraints: BoxConstraints(minWidth: 45, minHeight: 45),
                              prefixIcon: Padding(
                                padding: const EdgeInsets.only(left: 8.0, right:10.0),
                                child: Image.asset('assets/images/coordenada.png', width: 40, height: 40, fit: BoxFit.contain, errorBuilder: (c,e,s) => Icon(Icons.gps_fixed, size: 30)), // <--- ÍCONO ACTUALIZADO AQUÍ
                              )
                          ),
                          child: _isLocationLoading
                              ? SizedBox(height: 20, width:20, child: Center(child: CircularProgressIndicator(strokeWidth: 2.0, valueColor: AlwaysStoppedAnimation<Color>(Color(0xff4ec8dd)))))
                              : Text(_currentLocationString, style: const TextStyle(fontFamily: 'Comic Sans MS', fontSize: 15, color: Colors.black87)),
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.only(bottom: 18.0),
                        child: InputDecorator(
                          decoration: InputDecoration(
                              labelText: 'Información de Contacto',
                              labelStyle: const TextStyle(fontFamily: 'Comic Sans MS', color: Colors.black54, fontSize: 15),
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.0), borderSide: BorderSide(color: Colors.grey.shade400)),
                              enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12.0), borderSide: BorderSide(color: Colors.grey.shade500)),
                              filled: true,
                              fillColor: Colors.grey[200],
                              contentPadding: const EdgeInsets.only(left: 50.0, top: 12, bottom: 12, right: 15),
                              prefixIconConstraints: BoxConstraints(minWidth: 45, minHeight: 45),
                              prefixIcon: Padding(
                                padding: const EdgeInsets.only(left: 8.0, right:10.0),
                                child: Image.asset('assets/images/infocontacto.png', width: 30, height: 30, fit: BoxFit.contain, errorBuilder: (c,e,s) => Icon(Icons.contact_mail_outlined, size: 30)),
                              )
                          ),
                          child: _isContactInfoLoading
                              ? SizedBox(height: 20, width:20, child: Center(child: CircularProgressIndicator(strokeWidth: 2.0, valueColor: AlwaysStoppedAnimation<Color>(Color(0xff4ec8dd)))))
                              : Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text("Nombre: ${_contactInfo['name']}", style: const TextStyle(fontFamily: 'Comic Sans MS', fontSize: 14, color: Colors.black87)),
                              Text("Email: ${_contactInfo['email']}", style: const TextStyle(fontFamily: 'Comic Sans MS', fontSize: 14, color: Colors.black87)),
                              Text("Documento: ${_contactInfo['documento']}", style: const TextStyle(fontFamily: 'Comic Sans MS', fontSize: 14, color: Colors.black87)),
                              Text("Teléfono: ${_contactInfo['contacto']}", style: const TextStyle(fontFamily: 'Comic Sans MS', fontSize: 14, color: Colors.black87)),
                            ],
                          ),
                        ),
                      ),

                      Container(
                        margin: const EdgeInsets.only(bottom: 18.0),
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.9),
                            borderRadius: BorderRadius.circular(12.0),
                            border: Border.all(color: Colors.grey.shade500)
                        ),
                        child: Row(
                          children: [
                            Image.asset('assets/images/adjuntarhistoria.png', width: 32, height: 32, fit: BoxFit.contain, errorBuilder: (c,e,s) => Icon(Icons.attach_file_outlined, size: 30)),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                _historiaClinicaFileName ?? 'Adjuntar Historia Clínica',
                                style: TextStyle(fontFamily: 'Comic Sans MS', fontSize: 15, color: _historiaClinicaFileName != null ? Colors.black87 : Colors.black54),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            IconButton(
                              icon: Icon(_isUploadingHistoria ? Icons.hourglass_empty : Icons.file_upload_outlined, color: Color(0xff4ec8dd)),
                              tooltip: "Seleccionar archivo",
                              onPressed: _isUploadingHistoria ? null : _pickHistoriaClinica,
                            ),
                          ],
                        ),
                      ),
                      if (_isUploadingHistoria)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 10.0),
                          child: LinearProgressIndicator(color: Color(0xff4ec8dd)),
                        ),

                      const SizedBox(height: 25),
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xff4ec8dd),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15.0),
                              side: const BorderSide(width: 1.0, color: Color(0xff000000)),
                            ),
                            elevation: 3,
                          ),
                          onPressed: _isUploadingHistoria ? null : _solicitarAmbulancia,
                          child: _isUploadingHistoria
                              ? const Text('Subiendo historia...', style: TextStyle(fontFamily: 'Comic Sans MS', fontSize: 18, color: Colors.black54, fontWeight: FontWeight.w700))
                              : const Text(
                            'Solicitar Ambulancia',
                            style: TextStyle(fontFamily: 'Comic Sans MS', fontSize: 20, color: Color(0xff000000), fontWeight: FontWeight.w700),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
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