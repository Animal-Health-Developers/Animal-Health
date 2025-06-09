import 'package:adobe_xd/pinned.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:adobe_xd/page_link.dart';
import 'package:intl/intl.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
// Nuevas importaciones para manejar imágenes y caché
import 'package:image_picker/image_picker.dart'; // Para XFile (web)
import 'dart:io'; // Para File (móvil)
import 'dart:typed_data'; // Para Uint8List (web)
import 'package:cached_network_image/cached_network_image.dart'; // Para mostrar imágenes desde URL

import './Home.dart';
import './Ayuda.dart';
import './Configuracion.dart';
import '../services/auth_service.dart';

class EditarinfodeUsuario extends StatefulWidget {
  final AuthService authService;
  final VoidCallback onUpdateSuccess;

  const EditarinfodeUsuario({
    required Key key,
    required this.authService,
    required this.onUpdateSuccess,
  }) : super(key: key);

  @override
  _EditarinfodeUsuarioState createState() => _EditarinfodeUsuarioState();
}

class _EditarinfodeUsuarioState extends State<EditarinfodeUsuario> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _emailController;
  late TextEditingController _usernameController;
  late TextEditingController _fechaNacimientoController;
  late TextEditingController _documentoController;
  late TextEditingController _contactoController;
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  // Variables para la gestión de la imagen de perfil
  XFile? _selectedXFileImage; // Para la imagen seleccionada en la web (XFile)
  File? _selectedFileImage; // Para la imagen seleccionada en móvil (File)
  Uint8List? _selectedImageBytes; // Para los bytes de la imagen seleccionada en la web (Uint8List)

  bool _isLoading = false; // Indica si se están cargando los datos iniciales
  bool _isUpdating = false; // Indica si se está realizando una actualización
  String? _errorMessage;
  String? _profilePhotoUrl; // URL de la foto de perfil actual (desde Firebase Storage)
  DateTime? _selectedDate; // Para la fecha de nacimiento

  final ImagePicker _picker = ImagePicker(); // Instancia para seleccionar imágenes

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _usernameController = TextEditingController();
    _fechaNacimientoController = TextEditingController();
    _documentoController = TextEditingController();
    _contactoController = TextEditingController();
    _loadUserData();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _usernameController.dispose();
    _fechaNacimientoController.dispose();
    _documentoController.dispose();
    _contactoController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  // Carga los datos del usuario actual
  Future<void> _loadUserData() async {
    setState(() => _isLoading = true);
    print('Iniciando carga de datos del usuario...');

    try {
      final firebaseUser = FirebaseAuth.instance.currentUser;
      print('Usuario Firebase: ${firebaseUser?.email}');

      if (firebaseUser == null) {
        throw Exception('Usuario no autenticado');
      }

      final user = await widget.authService.getCurrentUser();

      if (user != null) {
        setState(() {
          _emailController.text = firebaseUser.email ?? user.email;
          _usernameController.text = user.userName;

          if (user.fechaNacimiento != null) {
            _selectedDate = user.fechaNacimiento;
            _fechaNacimientoController.text = DateFormat('dd/MM/yyyy').format(user.fechaNacimiento!);
          } else {
            _selectedDate = null;
            _fechaNacimientoController.text = '';
          }

          _documentoController.text = user.documento ?? '';
          _contactoController.text = user.contacto ?? '';
          _profilePhotoUrl = user.profilePhotoUrl;

          // Restablecer las variables de imagen seleccionada al cargar datos
          // Esto asegura que la foto que se muestra es la del URL actual, no una previa selección
          _selectedXFileImage = null;
          _selectedFileImage = null;
          _selectedImageBytes = null;

          print('Datos cargados: Email: ${_emailController.text}, Username: ${_usernameController.text}');
          if (_profilePhotoUrl != null) {
            print('URL de foto de perfil: $_profilePhotoUrl');
          }
        });
      } else {
        setState(() {
          _emailController.text = firebaseUser.email ?? '';
        });
      }
    } catch (e) {
      print('Error al cargar datos: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al cargar datos: ${e.toString()}')),
      );
      final firebaseUser = FirebaseAuth.instance.currentUser;
      if (firebaseUser != null) {
        setState(() {
          _emailController.text = firebaseUser.email ?? '';
        });
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  // Abre el selector de fecha para la fecha de nacimiento
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: ColorScheme.light(
              primary: const Color(0xff4ec8dd), // Color principal del calendario
              onPrimary: Colors.white, // Color del texto en el color principal
              onSurface: Colors.black, // Color del texto en la superficie
            ), dialogTheme: DialogThemeData(backgroundColor: Colors.white),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        _fechaNacimientoController.text = DateFormat('dd/MM/yyyy').format(picked);
      });
    }
  }

  // Abre el selector de imágenes para elegir una nueva foto de perfil
  Future<void> _pickImage() async {
    try {
      final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery, imageQuality: 85);
      if (pickedFile != null) {
        if (kIsWeb) {
          final bytes = await pickedFile.readAsBytes();
          setState(() {
            _selectedXFileImage = pickedFile;
            _selectedFileImage = null; // Asegurar que File es nulo para web
            _selectedImageBytes = bytes;
            _profilePhotoUrl = null; // Limpiar URL existente si se elige una nueva imagen
          });
        } else {
          setState(() {
            _selectedXFileImage = null; // Asegurar que XFile es nulo para móvil
            _selectedFileImage = File(pickedFile.path);
            _selectedImageBytes = null; // Asegurar que bytes son nulos para móvil
            _profilePhotoUrl = null; // Limpiar URL existente si se elige una nueva imagen
          });
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al seleccionar imagen: ${e.toString()}')),
      );
    }
  }

  // Actualiza los datos del usuario en Firebase
  Future<void> _updateUser() async {
    if (!_formKey.currentState!.validate()) return;

    if (_passwordController.text.isNotEmpty &&
        _passwordController.text != _confirmPasswordController.text) {
      setState(() => _errorMessage = 'Las contraseñas no coinciden');
      return;
    }

    setState(() {
      _isUpdating = true;
      _errorMessage = null;
    });

    try {
      print('Iniciando actualización de usuario...');
      print('Tiene nueva imagen: ${_selectedXFileImage != null || _selectedFileImage != null}');

      // Determinar qué fuente de imagen pasar a authService
      dynamic imageToUpload;
      if (kIsWeb) {
        imageToUpload = _selectedXFileImage; // Pasar XFile directamente para web
      } else {
        imageToUpload = _selectedFileImage; // Pasar File directamente para móvil
      }

      final userUpdated = await widget.authService.actualizarUsuario(
        email: _emailController.text.trim(),
        userName: _usernameController.text.trim(),
        fechaNacimiento: _selectedDate,
        documento: _documentoController.text.trim(),
        contacto: _contactoController.text.trim(),
        password: _passwordController.text.trim(),
        profilePhotoUrl: imageToUpload, // Pasar la fuente de imagen correcta
      );

      if (userUpdated) {
        print('Usuario actualizado correctamente');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Información actualizada exitosamente'),
            backgroundColor: Colors.green,
          ),
        );
        await _loadUserData(); // Recargar datos del usuario para obtener la nueva URL de la foto
        widget.onUpdateSuccess();
      } else {
        print('La actualización del usuario falló');
        setState(() => _errorMessage = 'Error al actualizar los datos');
      }
    } on FirebaseAuthException catch (e) {
      print('Error de FirebaseAuth: ${e.code} - ${e.message}');
      setState(() => _errorMessage = _getErrorMessage(e.code));
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(_getErrorMessage(e.code)),
          backgroundColor: Colors.red,
        ),
      );
    } catch (e) {
      print('Error desconocido al actualizar usuario: $e');
      setState(() => _errorMessage = 'Error durante la actualización: ${e.toString()}');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error durante la actualización: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _isUpdating = false);
      }
    }
  }

  // Mapea los códigos de error de Firebase a mensajes legibles
  String _getErrorMessage(String code) {
    switch (code) {
      case 'email-already-in-use':
        return 'El correo ya está en uso';
      case 'invalid-email':
        return 'Correo electrónico inválido';
      case 'requires-recent-login':
        return 'Requiere autenticación reciente';
      case 'weak-password':
        return 'Contraseña demasiado débil';
      case 'photo-upload-failed':
        return 'Error al subir la foto de perfil';
      default:
        return 'Error durante la actualización';
    }
  }

  // Widget para construir campos de texto con un icono en el lado izquierdo
  Widget _buildTextField({
    required String labelText,
    required TextEditingController controller,
    required String imageAsset,
    required double iconWidth, // Ancho del icono
    required double iconHeight, // Alto del icono
    required String? Function(String?) validator,
    bool obscureText = false,
    bool readOnly = false,
    TextInputType? keyboardType,
    VoidCallback? onTap,
    bool enabled = true, // Permite deshabilitar el campo (ej. email)
  }) {
    return Container(
      height: 60,
      margin: const EdgeInsets.only(bottom: 20),
      child: Stack(
        children: [
          TextFormField(
            controller: controller,
            obscureText: obscureText,
            readOnly: readOnly,
            keyboardType: keyboardType,
            onTap: onTap,
            decoration: InputDecoration(
              labelText: labelText,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)), // Esquinas redondeadas
              filled: true,
              fillColor: Colors.white.withOpacity(0.95), // Color de fondo semitransparente
              contentPadding: EdgeInsets.only(left: 50.0, right: 15.0, top: 15, bottom: 15), // Ajuste de padding para el icono
              floatingLabelBehavior: FloatingLabelBehavior.auto, // Etiqueta flotante
            ),
            style: const TextStyle(
              fontFamily: 'Comic Sans MS',
              fontSize: 16,
              color: Colors.black,
              fontWeight: FontWeight.w700,
            ),
            validator: validator,
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
                    image: AssetImage('assets/images/$imageAsset'),
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

  // Widget para mostrar la foto de perfil, manejando diferentes estados y fuentes
  Widget _buildProfileImageWidget({double radius = 50}) {
    if (_selectedXFileImage != null && kIsWeb && _selectedImageBytes != null) {
      // Nueva imagen seleccionada para web
      return ClipOval(
        child: Image.memory(
          _selectedImageBytes!,
          width: radius * 2,
          height: radius * 2,
          fit: BoxFit.cover,
        ),
      );
    } else if (_selectedFileImage != null && !kIsWeb) {
      // Nueva imagen seleccionada para móvil
      return ClipOval(
        child: Image.file(
          _selectedFileImage!,
          width: radius * 2,
          height: radius * 2,
          fit: BoxFit.cover,
        ),
      );
    } else if (_profilePhotoUrl != null && _profilePhotoUrl!.isNotEmpty) {
      // Imagen existente de la red
      return ClipOval(
        child: CachedNetworkImage(
          imageUrl: _profilePhotoUrl!,
          width: radius * 2,
          height: radius * 2,
          fit: BoxFit.cover,
          placeholder: (context, url) => CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Color(0xff4ec8dd))),
          errorWidget: (context, url, error) => Icon(Icons.person, size: radius, color: Colors.grey[600]), // Icono de fallback
        ),
      );
    }
    // Avatar por defecto si no hay imagen
    return Icon(
      Icons.person,
      size: radius,
      color: Colors.grey[600],
    );
  }

  // Muestra la imagen de perfil en un diálogo grande al ser tocada
  void _showLargeImage() {
    Widget imageWidget;
    // Determinar qué widget de imagen usar
    if (_isUpdating) {
      imageWidget = const Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.white)));
    } else if (_selectedXFileImage != null && kIsWeb && _selectedImageBytes != null) {
      imageWidget = Image.memory(_selectedImageBytes!, fit: BoxFit.contain);
    } else if (_selectedFileImage != null && !kIsWeb) {
      imageWidget = Image.file(_selectedFileImage!, fit: BoxFit.contain);
    } else if (_profilePhotoUrl != null && _profilePhotoUrl!.isNotEmpty) {
      imageWidget = CachedNetworkImage(
        imageUrl: _profilePhotoUrl!,
        fit: BoxFit.contain,
        placeholder: (context, url) => const Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Color(0xff4ec8dd)))),
        errorWidget: (context, url, error) => const Icon(Icons.error, size: 100, color: Colors.grey),
      );
    } else {
      imageWidget = const Icon(Icons.person, size: 100, color: Colors.grey);
    }

    showDialog(
      context: context,
      useSafeArea: false, // Permite que el diálogo ignore el área segura
      builder: (BuildContext context) {
        return GestureDetector( // Permite cerrar el diálogo al tocar cualquier parte fuera de la "X"
          onTap: () => Navigator.of(context).pop(),
          child: Dialog(
            backgroundColor: Colors.transparent, // Fondo del diálogo transparente
            insetPadding: EdgeInsets.zero, // Elimina el padding alrededor del diálogo
            child: Stack( // Usa un Stack para superponer la imagen y el botón de cierre
              alignment: Alignment.center,
              children: [
                Container(
                  width: double.infinity,
                  height: double.infinity,
                  color: Colors.black.withOpacity(0.9), // Fondo oscuro semi-transparente
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
    return Scaffold(
      backgroundColor: const Color(0xff4ec8dd),
      body: Stack(
        children: <Widget>[
          // --- Fondo de Pantalla ---
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: const AssetImage('assets/images/Animal Health Fondo de Pantalla.png'),
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
          // --- Botón de Retroceso a Home (Posición ajustada para coincidir con EditarPerfildeAnimal) ---
          Pinned.fromPins(
            Pin(size: 52.9, start: 15.0), // Ajustado de 9.1 a 15.0
            Pin(size: 50.0, start: 49.0),
            child: PageLink(
              links: [
                PageLinkInfo(
                  transition: LinkTransition.Fade,
                  ease: Curves.easeOut,
                  duration: 0.3,
                  pageBuilder: () => Home(key: Key('Home')), // Asumiendo que regresa a Home
                ),
              ],
              child: Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: const AssetImage('assets/images/back.png'),
                    fit: BoxFit.fill,
                  ),
                ),
              ),
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
            Pin(size: 40.5, end: 7.6 + 47.2 + 5.0), // Espaciado consistente
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

          Positioned(
            top: 120,
            left: 30,
            right: 30,
            bottom: 27,
            child: _isLoading
                ? Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.white)))
                : Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(height: 10), // Espaciado ajustado
                    // --- Sección de Foto de Perfil y Botón de Actualizar ---
                    Column(
                      mainAxisSize: MainAxisSize.min, // La columna se ajusta a su contenido
                      children: [
                        GestureDetector(
                          onTap: _isUpdating ? null : _showLargeImage, // Al tocar, muestra la imagen grande
                          child: CircleAvatar(
                            radius: 55, // Radio más grande para la foto de perfil
                            backgroundColor: Colors.white.withOpacity(0.8), // Color de fondo semitransparente
                            child: _isUpdating
                                ? CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Color(0xff4ec8dd)))
                                : _buildProfileImageWidget(radius: 50), // Muestra la foto de perfil
                          ),
                        ),
                        SizedBox(height: 10),
                        ElevatedButton(
                          onPressed: _isUpdating ? null : _pickImage, // Al tocar, permite seleccionar una nueva imagen
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
                    SizedBox(height: 25), // Espaciado ajustado
                    // --- Campos del Formulario ---
                    _buildTextField(
                      labelText: 'Correo Electrónico',
                      controller: _emailController,
                      imageAsset: '@.png',
                      iconWidth: 40.0, // Tamaño de icono
                      iconHeight: 40.0, // Tamaño de icono
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Ingrese su correo electrónico';
                        }
                        if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                          return 'Correo electrónico inválido';
                        }
                        return null;
                      },
                      enabled: false, // Correo no editable
                    ),
                    _buildTextField(
                      labelText: 'Nombre de Usuario',
                      controller: _usernameController,
                      imageAsset: 'nombreusuario.png',
                      iconWidth: 40.0,
                      iconHeight: 40.0,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Ingrese su nombre de usuario';
                        }
                        if (value.length < 3) {
                          return 'Mínimo 3 caracteres';
                        }
                        return null;
                      },
                    ),
                    // Campo de Fecha de Nacimiento con InputDecorator e InkWell
                    Container(
                      height: 60,
                      margin: const EdgeInsets.only(bottom: 20),
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
                                    _selectedDate != null ? DateFormat('dd/MM/yyyy').format(_selectedDate!) : 'Seleccionar fecha',
                                    style: TextStyle(fontFamily: 'Comic Sans MS', fontSize: 16, color: _selectedDate != null ? Colors.black87 : Colors.grey.shade700),
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
                                width: 35.2, // Tamaños de icono específicos de la página del animal
                                height: 40.0,
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: const AssetImage('assets/images/fechanacimientopersona.png'),
                                    fit: BoxFit.fill,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    _buildTextField(
                      labelText: 'Número de Documento',
                      controller: _documentoController,
                      imageAsset: 'id.png',
                      iconWidth: 40.0,
                      iconHeight: 40.0,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Ingrese su documento';
                        }
                        return null;
                      },
                      keyboardType: TextInputType.number,
                    ),
                    _buildTextField(
                      labelText: 'Número de Contacto',
                      controller: _contactoController,
                      imageAsset: 'numerocontacto.png',
                      iconWidth: 40.0,
                      iconHeight: 40.0,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Ingrese su número de contacto';
                        }
                        return null;
                      },
                      keyboardType: TextInputType.phone,
                    ),
                    _buildTextField(
                      labelText: 'Nueva Contraseña (opcional)',
                      controller: _passwordController,
                      imageAsset: 'password.png',
                      iconWidth: 40.0,
                      iconHeight: 40.0,
                      obscureText: true,
                      validator: (value) {
                        if (value != null && value.isNotEmpty && value.length < 8) {
                          return 'Mínimo 8 caracteres';
                        }
                        return null;
                      },
                    ),
                    _buildTextField(
                      labelText: 'Confirmar Contraseña',
                      controller: _confirmPasswordController,
                      imageAsset: 'password.png',
                      iconWidth: 40.0,
                      iconHeight: 40.0,
                      obscureText: true,
                      validator: (value) {
                        if (_passwordController.text.isNotEmpty &&
                            (value == null || value.isEmpty)) {
                          return 'Confirme su contraseña';
                        }
                        if (value != _passwordController.text) {
                          return 'Las contraseñas no coinciden';
                        }
                        return null;
                      },
                    ),
                    if (_errorMessage != null)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 20),
                        child: Text(
                          _errorMessage!,
                          style: const TextStyle(
                            fontFamily: 'Comic Sans MS',
                            fontSize: 16,
                            color: Colors.red,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    GestureDetector(
                      onTap: _isUpdating ? null : _updateUser,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Container(
                            width: 242,
                            height: 49,
                            decoration: BoxDecoration(
                              color: const Color(0xff4ec8dd),
                              borderRadius: BorderRadius.circular(15),
                              border: Border.all(width: 1, color: Colors.black),
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(0xff080808),
                                  offset: Offset(0, 3),
                                  blurRadius: 6,
                                ),
                              ],
                            ),
                            child: Center(
                              child: Text(
                                'Guardar Cambios',
                                style: TextStyle(
                                  fontFamily: 'Comic Sans MS',
                                  fontSize: 20,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w700, // Estilo consistente
                                ),
                              ),
                            ),
                          ),
                          if (_isUpdating)
                            CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.white)), // Indicador blanco
                        ],
                      ),
                    ),
                    SizedBox(height: 30),
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