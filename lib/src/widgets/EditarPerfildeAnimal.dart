import 'package:flutter/material.dart';
import 'package:adobe_xd/pinned.dart';
import 'package:adobe_xd/page_link.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:typed_data'; // Para Uint8List
import 'dart:io'; // Para File, si no es web
import 'package:flutter/foundation.dart' show kIsWeb; // Para diferenciar web de móvil
import 'package:cached_network_image/cached_network_image.dart'; // Para mostrar imagen desde URL
import 'package:intl/intl.dart'; // Para formatear la fecha si es necesario mostrarla

// Imports de Navegación y Servicios
import '../services/auth_service.dart';
import './Home.dart';
import './Ayuda.dart';
import './Configuracion.dart';
import './ListadeAnimales.dart';
import './FuncionesdelaApp.dart';

class EditarPerfildeAnimal extends StatefulWidget {
  final String animalId;

  const EditarPerfildeAnimal({
    required Key key,
    required this.animalId,
  }) : super(key: key);

  @override
  _EditarPerfildeAnimalState createState() => _EditarPerfildeAnimalState();
}

class _EditarPerfildeAnimalState extends State<EditarPerfildeAnimal> {
  final _formKey = GlobalKey<FormState>();
  final ImagePicker _picker = ImagePicker();

  dynamic _pickedImage;
  Uint8List? _imageBytes;

  String? _currentImageUrl;
  bool _isUploading = false;
  bool _isUpdating = false;
  bool _isLoadingData = true;

  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _especieController = TextEditingController();
  final TextEditingController _razaController = TextEditingController();
  final TextEditingController _pesoController = TextEditingController();
  final TextEditingController _largoController = TextEditingController();
  final TextEditingController _anchoController = TextEditingController();
  DateTime? _fechaNacimiento;

  final List<String> _especiesDisponibles = [
    "Perro", "Gato", "Ave", "Roedor", "Reptil", "Otro"
  ];
  String? _selectedEspecie;

  @override
  void initState() {
    super.initState();
    if (widget.animalId.isEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: ID de animal no proporcionado.')),
          );
          if (Navigator.canPop(context)) {
            Navigator.of(context).pop();
          }
        }
      });
    } else {
      _cargarDatosAnimal();
    }
  }

  Future<void> _cargarDatosAnimal() async {
    if (!mounted) return;
    setState(() { _isLoadingData = true; });
    try {
      final userId = FirebaseAuth.instance.currentUser?.uid;
      if (userId == null) {
        if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Usuario no autenticado')));
        if (mounted) setState(() { _isLoadingData = false; });
        return;
      }
      if (widget.animalId.isEmpty) {
        if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('ID de animal inválido para cargar datos.')));
        if (mounted) setState(() { _isLoadingData = false; });
        return;
      }

      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('animals')
          .doc(widget.animalId)
          .get();

      if (doc.exists) {
        final data = doc.data() as Map<String, dynamic>;
        if (mounted) {
          setState(() {
            _nombreController.text = data['nombre'] ?? '';
            _selectedEspecie = data['especie'] as String? ?? _especiesDisponibles.first;
            _especieController.text = _selectedEspecie!;
            _razaController.text = data['raza'] ?? '';
            _pesoController.text = (data['peso'] as num?)?.toString() ?? '';
            _largoController.text = (data['largo'] as num?)?.toString() ?? '';
            _anchoController.text = (data['ancho'] as num?)?.toString() ?? '';
            _currentImageUrl = data['fotoPerfilUrl'] as String?;
            if (data['fechaNacimiento'] != null) {
              if (data['fechaNacimiento'] is String) {
                _fechaNacimiento = DateTime.tryParse(data['fechaNacimiento']);
              } else if (data['fechaNacimiento'] is Timestamp) {
                _fechaNacimiento = (data['fechaNacimiento'] as Timestamp).toDate();
              }
            } else {
              _fechaNacimiento = null;
            }
            _isLoadingData = false;
          });
        }
      } else {
        if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Perfil de animal no encontrado')));
        if (mounted) setState(() { _isLoadingData = false; });
      }
    } catch (e) {
      print("Error cargando datos del animal: $e");
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error al cargar datos: $e')));
      if (mounted) setState(() { _isLoadingData = false; });
    }
  }

  Future<void> _pickImage() async {
    if (_isUploading) return;
    try {
      final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery, imageQuality: 85);
      if (pickedFile != null) {
        if (kIsWeb) {
          final bytes = await pickedFile.readAsBytes();
          if (mounted) {
            setState(() {
              _imageBytes = bytes;
              _pickedImage = pickedFile;
              _currentImageUrl = null;
            });
          }
        } else {
          if (mounted) {
            setState(() {
              _pickedImage = File(pickedFile.path);
              _imageBytes = null;
              _currentImageUrl = null;
            });
          }
        }
      }
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error al seleccionar imagen: $e')));
    }
  }

  Future<String?> _uploadImage() async {
    if (_pickedImage == null) return _currentImageUrl;

    if (!mounted) return _currentImageUrl;
    setState(() { _isUploading = true; });

    try {
      final userId = FirebaseAuth.instance.currentUser?.uid;
      if (userId == null) throw Exception("Usuario no autenticado para subir imagen.");

      // Intenta eliminar la imagen anterior si existe
      if (_currentImageUrl != null && _currentImageUrl!.isNotEmpty) {
        try {
          final oldImageRef = FirebaseStorage.instance.refFromURL(_currentImageUrl!);
          await oldImageRef.delete();
          print('Imagen anterior eliminada de Storage: $_currentImageUrl');
        } catch (e) {
          // No mostrar error si la imagen no existe o hubo un problema al eliminarla, es una advertencia
          print('Advertencia: Error al eliminar imagen anterior de Storage: $e');
        }
      }

      final String fileName = '${widget.animalId}-${DateTime.now().millisecondsSinceEpoch}.jpg';
      final storageRef = FirebaseStorage.instance.ref().child('animal_images/$userId/$fileName');
      UploadTask uploadTask;

      if (kIsWeb) {
        if (_imageBytes == null) throw Exception("Bytes de imagen no disponibles para subida web.");
        uploadTask = storageRef.putData(_imageBytes!, SettableMetadata(contentType: 'image/jpeg'));
      } else {
        uploadTask = storageRef.putFile(_pickedImage as File);
      }

      final taskSnapshot = await uploadTask;
      final downloadUrl = await taskSnapshot.ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      print("Error al subir imagen: $e");
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error al subir imagen: $e')));
      return _currentImageUrl; // Retorna la URL actual si falla la subida
    } finally {
      if (mounted) setState(() { _isUploading = false; });
    }
  }

  Future<void> _actualizarAnimal() async {
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();

    if (_isUploading) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Espere, se está subiendo la imagen...')));
      return;
    }

    if (!mounted) return;
    setState(() { _isUpdating = true; });

    try {
      final userId = FirebaseAuth.instance.currentUser?.uid;
      if (userId == null) throw Exception("Usuario no autenticado.");
      if (widget.animalId.isEmpty) throw Exception("ID de animal inválido.");

      final String? newImageUrl = await _uploadImage(); // Intenta subir la nueva imagen si hay

      final Map<String, dynamic> updateData = {
        'nombre': _nombreController.text.trim(),
        'especie': _selectedEspecie,
        'raza': _razaController.text.trim(),
        'fechaNacimiento': _fechaNacimiento?.toIso8601String(),
        'peso': double.tryParse(_pesoController.text.trim().replaceAll(',', '.')) ?? 0.0,
        'largo': double.tryParse(_largoController.text.trim().replaceAll(',', '.')) ?? 0.0,
        'ancho': double.tryParse(_anchoController.text.trim().replaceAll(',', '.')) ?? 0.0,
        'updatedAt': FieldValue.serverTimestamp(),
      };
      // Actualiza la URL de la foto de perfil
      if (newImageUrl != null) {
        updateData['fotoPerfilUrl'] = newImageUrl;
      } else if (_currentImageUrl != null && _currentImageUrl!.isNotEmpty) {
        updateData['fotoPerfilUrl'] = _currentImageUrl; // Mantener la URL existente si no se subió una nueva
      } else {
        updateData['fotoPerfilUrl'] = null; // Si no hay ni nueva ni vieja, la establece como null
      }

      await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('animals')
          .doc(widget.animalId)
          .update(updateData);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Perfil de ${_nombreController.text} actualizado con éxito!')));
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => ListadeAnimales(key: Key('ListadeAnimales'))),
        );
      }
    } catch (e) {
      print("Error al actualizar animal: $e");
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error al actualizar: $e')));
    } finally {
      if (mounted) setState(() { _isUpdating = false; });
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _fechaNacimiento ?? DateTime.now(),
      firstDate: DateTime(1980),
      lastDate: DateTime.now(),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: ColorScheme.light(
              primary: const Color(0xff4ec8dd), // Color del encabezado del calendario
              onPrimary: Colors.white, // Color del texto del encabezado
              onSurface: Colors.black, // Color del texto del día
            ),
            dialogBackgroundColor: Colors.white,
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _fechaNacimiento) {
      if (mounted) {
        setState(() {
          _fechaNacimiento = picked;
        });
      }
    }
  }

  // Método para mostrar la imagen de perfil en grande con la "X"
  void _showLargeImage() {
    Widget imageWidget;
    // Determina qué imagen mostrar
    if (_isUploading) {
      imageWidget = const Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.white)));
    } else if (_pickedImage != null) {
      if (kIsWeb && _imageBytes != null) {
        imageWidget = Image.memory(_imageBytes!, fit: BoxFit.contain);
      } else if (!kIsWeb) {
        imageWidget = Image.file(_pickedImage as File, fit: BoxFit.contain);
      } else {
        imageWidget = const Icon(Icons.broken_image, size: 100, color: Colors.grey);
      }
    } else if (_currentImageUrl != null && _currentImageUrl!.isNotEmpty) {
      imageWidget = CachedNetworkImage(
        imageUrl: _currentImageUrl!,
        fit: BoxFit.contain, // Ajusta la imagen manteniendo su relación de aspecto
        placeholder: (context, url) => const Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Color(0xff4ec8dd)))),
        errorWidget: (context, url, error) => const Icon(Icons.error, size: 100, color: Colors.grey),
      );
    } else {
      imageWidget = const Icon(Icons.pets, size: 100, color: Colors.grey); // Placeholder si no hay imagen
    }

    showDialog(
      context: context,
      useSafeArea: false, // Permite que el diálogo ignore el área segura y se extienda por toda la pantalla
      builder: (BuildContext context) {
        return GestureDetector( // Permite cerrar el diálogo al tocar cualquier parte fuera de la "X"
          onTap: () => Navigator.of(context).pop(),
          child: Dialog(
            backgroundColor: Colors.transparent, // Fondo del diálogo transparente
            insetPadding: EdgeInsets.zero, // Elimina el padding alrededor del diálogo para que ocupe todo el espacio
            child: Stack( // Usa un Stack para superponer la imagen y el botón de cierre
              alignment: Alignment.center, // Centra la imagen dentro del Stack
              children: [
                // Contenedor de la imagen que ocupará todo el espacio del diálogo
                Container(
                  width: double.infinity, // Ocupa todo el ancho disponible
                  height: double.infinity, // Ocupa toda la altura disponible
                  color: Colors.black.withOpacity(0.9), // Fondo oscuro semi-transparente para la imagen
                  child: imageWidget, // La imagen real del animal
                ),
                // Botón de cierre (la "X") posicionado en la esquina superior derecha
                Positioned(
                  // Ajusta el 'top' para no chocar con la barra de estado en dispositivos móviles
                  top: MediaQuery.of(context).padding.top + 10,
                  right: 10,
                  child: IconButton(
                    icon: const Icon(Icons.close, color: Colors.white, size: 30), // Icono de "X" blanco y grande
                    onPressed: () {
                      Navigator.of(context).pop(); // Cierra el diálogo
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
  void dispose() {
    _nombreController.dispose();
    _especieController.dispose();
    _razaController.dispose();
    _pesoController.dispose();
    _largoController.dispose();
    _anchoController.dispose();
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
    bool enabled = true,
  }) {
    return Container(
      height: 60,
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
              contentPadding: EdgeInsets.only(left: 50.0, right: 15.0, top: 15, bottom: 15),
              floatingLabelBehavior: FloatingLabelBehavior.auto,
            ),
            keyboardType: keyboardType,
            validator: validator,
            style: TextStyle(fontFamily: 'Comic Sans MS', fontSize: 16),
            enabled: enabled,
          ),
          Positioned(
            left: 5,
            top: 0,
            bottom: 10,
            child: Align(
              alignment: Alignment.centerLeft,
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
          // --- Botón de Retroceso a Lista de Animales ---
          Pinned.fromPins(
            Pin(size: 52.9, start: 15.0), Pin(size: 50.0, start: 49.0),
            child: PageLink(
              links: [PageLinkInfo(pageBuilder: () => const ListadeAnimales(key: Key('ListadeAnimales_Back')))],
              child: Container(decoration: const BoxDecoration(image: DecorationImage(image: AssetImage('assets/images/back.png'), fit: BoxFit.fill))),
            ),
          ),
          // --- Botón de Configuración (A la derecha del todo) ---
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
          // --- Botón de Ayuda (A la izquierda del botón de configuración) ---
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

          // --- Formulario y Foto de Perfil ---
          Positioned(
            top: 125,
            left: 20,
            right: 20,
            bottom: 20,
            child: _isLoadingData
                ? Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.white)))
                : Form(
              key: _formKey,
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Column(
                  children: [
                    const SizedBox(height: 10),
                    // --- Contenedor para Foto, Botón de Actualizar y Botón de Funciones ---
                    SizedBox(
                      height: 170, // Altura aumentada para acomodar el botón "Actualizar Foto"
                      child: Stack(
                        children: [
                          // --- Columna centrada para la Foto y el Botón de Actualizar ---
                          Align(
                            alignment: Alignment.center, // Centra la columna que contiene la imagen y el botón
                            child: Column(
                              mainAxisSize: MainAxisSize.min, // Ajusta la altura al contenido vertical
                              children: [
                                // --- Foto de Perfil (Centrada y con GestureDetector para vista grande) ---
                                GestureDetector(
                                  onTap: _isUploading ? null : _showLargeImage, // Al tocar, muestra la imagen en grande
                                  child: CircleAvatar(
                                    radius: 55,
                                    backgroundColor: Colors.white.withOpacity(0.8),
                                    child: _isUploading
                                        ? const CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Color(0xff4ec8dd)))
                                        : _pickedImage != null
                                        ? (kIsWeb && _imageBytes != null
                                        ? ClipOval(child: Image.memory(_imageBytes!, width: 100, height: 100, fit: BoxFit.cover))
                                        : !kIsWeb ? ClipOval(child: Image.file(_pickedImage as File, width: 100, height: 100, fit: BoxFit.cover))
                                        : const Icon(Icons.add_a_photo, size: 40, color: Colors.grey))
                                        : (_currentImageUrl != null && _currentImageUrl!.isNotEmpty)
                                        ? ClipOval(child: CachedNetworkImage(imageUrl: _currentImageUrl!, width: 100, height: 100, fit: BoxFit.cover, placeholder: (c, u) => CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Color(0xff4ec8dd))), errorWidget: (c,u,e) => Icon(Icons.pets, size: 40, color: Colors.grey[600],)))
                                        : const Icon(Icons.add_a_photo, size: 40, color: Colors.grey),
                                  ),
                                ),
                                const SizedBox(height: 10), // Espacio entre la imagen y el botón
                                // --- Botón de Actualizar Foto ---
                                ElevatedButton(
                                  onPressed: _isUploading ? null : _pickImage, // Al tocar, permite seleccionar nueva imagen
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xff4ec8dd), // Color de tu tema
                                    foregroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                  ),
                                  child: const Text(
                                    'Actualizar Foto',
                                    style: TextStyle(fontFamily: 'Comic Sans MS', fontSize: 16),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // --- Botón de Funciones (Posicionado a la izquierda del Stack padre) ---
                          Positioned(
                            left: 0,
                            top: (170 - 70) / 2, // Centrado verticalmente con la nueva altura
                            child: GestureDetector(
                              onTap: () {
                                if (widget.animalId.isNotEmpty) {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => FuncionesdelaApp(
                                        key: Key('FuncionesdelaApp_${widget.animalId}'),
                                        animalId: widget.animalId,
                                      ),
                                    ),
                                  );
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('ID de animal no disponible.')),
                                  );
                                }
                              },
                              child: Container(
                                width: 60, height: 70,
                                decoration: const BoxDecoration(
                                  image: DecorationImage(image: AssetImage('assets/images/funciones.png'), fit: BoxFit.contain),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 25), // Espaciado ajustado
                    // --- Campos del Formulario ---
                    _buildTextFormFieldWithIcon(controller: _nombreController, labelText: 'Nombre', assetIconPath: 'assets/images/nombreanimal.png', iconWidth: 37.4, iconHeight: 40.0, validator: (v) => v!.isEmpty ? 'Ingrese nombre' : null),
                    Container(
                      height: 60,
                      margin: const EdgeInsets.only(bottom:20),
                      child: Stack(
                        children: [
                          InkWell(
                            onTap: () => _selectDate(context),
                            child: InputDecorator(
                              decoration: InputDecoration(
                                labelText: 'Fecha de Nacimiento',
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                                filled: true,
                                fillColor: Colors.white.withOpacity(0.95),
                                contentPadding: EdgeInsets.only(left: 50.0, top: 15, bottom: 15, right: 15.0),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    _fechaNacimiento != null ? DateFormat('dd/MM/yyyy').format(_fechaNacimiento!) : 'Seleccionar fecha',
                                    style: TextStyle(fontFamily: 'Comic Sans MS', fontSize: 16, color: _fechaNacimiento != null ? Colors.black87 : Colors.grey.shade700),
                                  ),
                                  Icon(Icons.arrow_drop_down, color: Colors.grey.shade700),
                                ],
                              ),
                            ),
                          ),
                          Positioned(
                            left: 5,
                            top: 0,
                            bottom: 10,
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Container(
                                width: 35.2,
                                height: 40.0,
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: const AssetImage('assets/images/edad.png'),
                                    fit: BoxFit.fill,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      height: 60,
                      margin: const EdgeInsets.only(bottom: 20),
                      child: Stack(
                        children: [
                          DropdownButtonFormField<String>(
                            value: _selectedEspecie,
                            items: _especiesDisponibles.map((String value) {
                              return DropdownMenuItem<String>(value: value, child: Text(value, style: TextStyle(fontFamily: 'Comic Sans MS', fontSize: 16)));
                            }).toList(),
                            onChanged: (newValue) => setState(() => _selectedEspecie = newValue),
                            decoration: InputDecoration(
                              labelText: 'Especie',
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                              filled: true,
                              fillColor: Colors.white.withOpacity(0.95),
                              contentPadding: const EdgeInsets.only(left: 50.0, right: 15.0, top: 15, bottom: 15),
                            ),
                            validator: (v) => v == null || v.isEmpty ? 'Seleccione especie' : null,
                            isExpanded: true,
                          ),
                          Positioned(
                            left: 5, top: 0, bottom: 10,
                            child: Align(alignment: Alignment.centerLeft, child: Container(width: 40.3, height: 40.0, decoration: BoxDecoration(image: DecorationImage(image: AssetImage('assets/images/especie.png'), fit: BoxFit.fill)))),
                          ),
                        ],
                      ),
                    ),
                    _buildTextFormFieldWithIcon(controller: _razaController, labelText: 'Raza', assetIconPath: 'assets/images/raza.png', iconWidth: 40.4, iconHeight: 40.0, validator: (v) => v!.isEmpty ? 'Ingrese raza' : null),
                    _buildTextFormFieldWithIcon(controller: _pesoController, labelText: 'Peso (kg)', assetIconPath: 'assets/images/peso.png', iconWidth: 40.7, iconHeight: 40.0, keyboardType: TextInputType.numberWithOptions(decimal: true), validator: (v) => v!.isEmpty ? 'Ingrese peso' : (double.tryParse(v.replaceAll(',', '.')) == null ? 'Número inválido' : null)),
                    _buildTextFormFieldWithIcon(controller: _largoController, labelText: 'Largo (cm)', assetIconPath: 'assets/images/largo.png', iconWidth: 35.8, iconHeight: 40.0, keyboardType: TextInputType.numberWithOptions(decimal: true), validator: (v) => v!.isEmpty ? 'Ingrese largo' : (double.tryParse(v.replaceAll(',', '.')) == null ? 'Número inválido' : null)),
                    _buildTextFormFieldWithIcon(controller: _anchoController, labelText: 'Ancho (cm)', assetIconPath: 'assets/images/ancho.png', iconWidth: 35.8, iconHeight: 40.0, keyboardType: TextInputType.numberWithOptions(decimal: true), validator: (v) => v!.isEmpty ? 'Ingrese ancho' : (double.tryParse(v.replaceAll(',', '.')) == null ? 'Número inválido' : null)),
                    const SizedBox(height: 20),
                    GestureDetector(
                      onTap: _isUpdating || _isUploading ? null : _actualizarAnimal,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Container(
                            width: 127.3, height: 120.0,
                            decoration: const BoxDecoration(image: DecorationImage(image: AssetImage('assets/images/editarperfilanimal.png'), fit: BoxFit.fill)),
                          ),
                          if (_isUpdating || _isUploading) const CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.white)),
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