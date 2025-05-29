// lib/src/widgets/CrearVisitaVeterinariaScreen.dart
import 'package:flutter/material.dart';
import 'package:adobe_xd/pinned.dart';
import 'package:adobe_xd/page_link.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

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

  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  String? _selectedClinicId;
  String? _selectedClinicName;
  String? _selectedClinicAddress;

  List<Map<String, dynamic>> _clinics = [];
  bool _isLoading = true;
  bool _isSaving = false;
  String? _veterinarianName;
  List<String> _affiliatedClinicIds = [];

  @override
  void initState() {
    super.initState();
    _loadClinicsAndUserAffiliation();
  }

  Future<void> _loadClinicsAndUserAffiliation() async {
    if (!mounted) return;
    setState(() {
      _isLoading = true;
    });

    try {
      final userId = FirebaseAuth.instance.currentUser?.uid;
      if (userId == null) {
        if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Usuario no autenticado.')));
        Navigator.pop(context);
        return;
      }

      // Cargar información del usuario actual (veterinario)
      final userDoc = await FirebaseFirestore.instance.collection('users').doc(userId).get();
      if (userDoc.exists) {
        final userData = userDoc.data();
        _veterinarianName = userData?['name'] ?? 'Veterinario Desconocido';
        _affiliatedClinicIds = List<String>.from(userData?['affiliatedClinics'] ?? []);
      } else {
        if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('No se encontró el perfil del veterinario.')));
        Navigator.pop(context);
        return;
      }

      // Cargar clínicas disponibles
      final clinicSnapshot = await FirebaseFirestore.instance.collection('clinics').get();
      _clinics = clinicSnapshot.docs.map((doc) => {'id': doc.id, ...doc.data()}).toList();

      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      print("Error cargando clínicas o afiliación: $e");
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error al cargar datos iniciales: $e')));
      Navigator.pop(context);
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

    // Permiso: Verificar afiliación del veterinario
    if (!_affiliatedClinicIds.contains(_selectedClinicId)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error: No estás afiliado a la clínica seleccionada para crear visitas.')),
      );
      return;
    }

    if (!mounted) return;
    setState(() {
      _isSaving = true;
    });

    try {
      final userId = FirebaseAuth.instance.currentUser?.uid;
      if (userId == null) throw Exception("Usuario no autenticado.");

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
        'veterinarioId': userId, // UID del veterinario que crea la visita
        'veterinarioNombre': _veterinarianName,
        'diagnostico': _diagnosticoController.text.trim(),
        'tratamiento': _tratamientoController.text.trim(),
        'medicamentos': _medicamentosController.text.trim(),
        'observaciones': _observacionesController.text.trim(),
        'costo': double.tryParse(_costoController.text.trim().replaceAll(',', '.')) ?? 0.0,
        'createdAt': FieldValue.serverTimestamp(),
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Visita creada con éxito!')));
        Navigator.pop(context, true); // Regresar y pasar 'true' para indicar éxito
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
    super.dispose();
  }

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
  }) {
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
            left: 5,
            top: maxLines > 1 ? 10 : 0, // Ajusta la posición vertical del icono para multilínea
            bottom: maxLines > 1 ? null : 10,
            child: Align(
              alignment: maxLines > 1 ? Alignment.topLeft : Alignment.centerLeft,
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

  @override
  Widget build(BuildContext context) {
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
              onTap: () => Navigator.of(context).pop(), // Botón de retroceso
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

          Positioned(
            top: 125,
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
                    const SizedBox(height: 10),
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

                    // Selector de Centro de Atención
                    Container(
                      height: 60,
                      margin: const EdgeInsets.only(bottom: 20),
                      child: Stack(
                        children: [
                          DropdownButtonFormField<String>(
                            value: _selectedClinicId,
                            decoration: InputDecoration(
                              labelText: 'Centro de Atención',
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                              filled: true,
                              fillColor: Colors.white.withOpacity(0.95),
                              contentPadding: const EdgeInsets.only(left: 50.0, right: 15.0, top: 15, bottom: 15),
                            ),
                            items: _clinics.map((clinic) {
                              return DropdownMenuItem<String>( // FIXED: Explicitly type DropdownMenuItem
                                value: clinic['id'] as String, // FIXED: Cast value to String
                                child: Text(clinic['name'] ?? 'Clínica desconocida', style: const TextStyle(fontFamily: 'Comic Sans MS', fontSize: 16)),
                              );
                            }).toList(),
                            onChanged: (value) {
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
                        ],
                      ),
                    ),

                    // Campos de texto para la visita
                    _buildTextFormFieldWithIcon(
                      controller: _diagnosticoController,
                      labelText: 'Diagnóstico',
                      assetIconPath: 'assets/images/diagnostico.png',
                      iconWidth: 35.2, iconHeight: 40.0,
                      maxLines: 3, // Para permitir texto largo
                      validator: (v) => v!.isEmpty ? 'Ingrese diagnóstico' : null,
                    ),
                    _buildTextFormFieldWithIcon(
                      controller: _tratamientoController,
                      labelText: 'Tratamiento',
                      assetIconPath: 'assets/images/tratamiento.png',
                      iconWidth: 35.2, iconHeight: 40.0,
                      maxLines: 3,
                      validator: (v) => v!.isEmpty ? 'Ingrese tratamiento' : null,
                    ),
                    _buildTextFormFieldWithIcon(
                      controller: _medicamentosController,
                      labelText: 'Medicamentos',
                      assetIconPath: 'assets/images/medicamentos.png',
                      iconWidth: 35.2, iconHeight: 40.0,
                      maxLines: 3,
                    ),
                    _buildTextFormFieldWithIcon(
                      controller: _observacionesController,
                      labelText: 'Observaciones',
                      assetIconPath: 'assets/images/observaciones.png',
                      iconWidth: 35.2, iconHeight: 40.0,
                      maxLines: 3,
                    ),
                    _buildTextFormFieldWithIcon(
                      controller: _costoController,
                      labelText: 'Costo (\$)',
                      assetIconPath: 'assets/images/costo.png',
                      iconWidth: 35.2, iconHeight: 40.0,
                      keyboardType: TextInputType.numberWithOptions(decimal: true),
                      validator: (v) => v!.isEmpty ? 'Ingrese costo' : (double.tryParse(v.replaceAll(',', '.')) == null ? 'Número inválido' : null),
                    ),
                    const SizedBox(height: 20),

                    // Botón para guardar visita
                    GestureDetector(
                      onTap: _isSaving ? null : _saveVisit,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Container(
                            width: 127.3, height: 120.0,
                            decoration: const BoxDecoration(image: DecorationImage(image: AssetImage('assets/images/guardar.png'), fit: BoxFit.fill)), // Asume que tienes un icono de guardar
                          ),
                          if (_isSaving) const CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.white)),
                        ],
                      ),
                    ),
                    const SizedBox(height: 30),
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