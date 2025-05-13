import 'package:adobe_xd/pinned.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:adobe_xd/page_link.dart';
import 'package:intl/intl.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
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

  dynamic _selectedImage; // Cambiado a dynamic para manejar web/móvil
  bool _isLoading = false;
  bool _isUpdating = false;
  String? _errorMessage;
  String? _profilePhotoUrl;
  DateTime? _selectedDate;

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
          }

          _documentoController.text = user.documento ?? '';
          _contactoController.text = user.contacto ?? '';
          _profilePhotoUrl = user.profilePhotoUrl;

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

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        _fechaNacimientoController.text = DateFormat('dd/MM/yyyy').format(picked);
      });
    }
  }

  Future<void> _pickImage() async {
    try {
      final image = await widget.authService.pickImage();
      if (image != null) {
        setState(() {
          _selectedImage = image;
          _profilePhotoUrl = null;
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al seleccionar imagen: ${e.toString()}')),
      );
    }
  }

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
      print('Tiene nueva imagen: ${_selectedImage != null}');

      final userUpdated = await widget.authService.actualizarUsuario(
        email: _emailController.text.trim(),
        userName: _usernameController.text.trim(),
        fechaNacimiento: _selectedDate,
        documento: _documentoController.text.trim(),
        contacto: _contactoController.text.trim(),
        password: _passwordController.text.trim(),
        profilePhotoUrl: _selectedImage,
      );

      if (userUpdated) {
        print('Usuario actualizado correctamente');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Información actualizada exitosamente'),
            backgroundColor: Colors.green,
          ),
        );
        await _loadUserData();
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

  Widget _buildTextField({
    required String labelText,
    required TextEditingController controller,
    required String imageAsset,
    required String? Function(String?) validator,
    bool obscureText = false,
    bool readOnly = false,
    TextInputType? keyboardType,
    VoidCallback? onTap,
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
              border: OutlineInputBorder(),
              filled: true,
              fillColor: Colors.white,
              contentPadding: EdgeInsets.only(left: 50.0, top: 15, bottom: 15),
            ),
            style: const TextStyle(
              fontFamily: 'Comic Sans MS',
              fontSize: 16,
              color: Colors.black,
              fontWeight: FontWeight.w700,
            ),
            validator: validator,
          ),
          Positioned(
            left: 5,
            top: 0,
            bottom: 10,
            child: Align(
              alignment: Alignment.centerLeft,
              child: Container(
                width: 40,
                height: 40,
                child: Image.asset(
                  'assets/images/$imageAsset',
                  width: 40,
                  height: 40,
                  errorBuilder: (context, error, stackTrace) => Icon(Icons.error),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileImage() {
    try {
      if (_selectedImage != null) {
        if (kIsWeb) {
          // Para web (XFile)
          return ClipRRect(
            borderRadius: BorderRadius.circular(50),
            child: Image.network(
              _selectedImage.path,
              width: 100,
              height: 100,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => _buildDefaultAvatar(),
            ),
          );
        } else {
          // Para móvil (File)
          return ClipRRect(
            borderRadius: BorderRadius.circular(50),
            child: Image.file(
              _selectedImage,
              width: 100,
              height: 100,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => _buildDefaultAvatar(),
            ),
          );
        }
      } else if (_profilePhotoUrl != null && _profilePhotoUrl!.isNotEmpty) {
        return ClipRRect(
          borderRadius: BorderRadius.circular(50),
          child: Image.network(
            _profilePhotoUrl!,
            width: 100,
            height: 100,
            fit: BoxFit.cover,
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) return child;
              return Center(
                child: CircularProgressIndicator(
                  value: loadingProgress.expectedTotalBytes != null
                      ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                      : null,
                ),
              );
            },
            errorBuilder: (context, error, stackTrace) => _buildDefaultAvatar(),
          ),
        );
      }
      return _buildDefaultAvatar();
    } catch (e) {
      print('Error al cargar imagen de perfil: $e');
      return _buildDefaultAvatar();
    }
  }

  Widget _buildDefaultAvatar() {
    return Icon(
      Icons.person,
      size: 50,
      color: Colors.black,
    );
  }

  @override
  Widget build(BuildContext context) {
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
              links: [
                PageLinkInfo(
                  transition: LinkTransition.Fade,
                  ease: Curves.easeOut,
                  duration: 0.3,
                  pageBuilder: () => Home(key: Key('Home')),
                ),
              ],
              child: Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: const AssetImage('assets/images/logo.png'),
                    fit: BoxFit.cover,
                  ),
                  borderRadius: BorderRadius.circular(15.0),
                  border: Border.all(width: 1.0, color: const Color(0xff000000)),
                ),
              ),
            ),
          ),
          Pinned.fromPins(
            Pin(size: 52.9, start: 9.1),
            Pin(size: 50.0, start: 49.0),
            child: PageLink(
              links: [
                PageLinkInfo(
                  transition: LinkTransition.Fade,
                  ease: Curves.easeOut,
                  duration: 0.3,
                  pageBuilder: () => Home(key: Key('Home')),
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
          Pinned.fromPins(
            Pin(size: 40.5, middle: 0.8328),
            Pin(size: 50.0, start: 49.0),
            child: PageLink(
              links: [
                PageLinkInfo(
                  transition: LinkTransition.Fade,
                  ease: Curves.easeOut,
                  duration: 0.3,
                  pageBuilder: () => Ayuda(key: Key('Ayuda')),
                ),
              ],
              child: Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: const AssetImage('assets/images/help.png'),
                    fit: BoxFit.fill,
                  ),
                ),
              ),
            ),
          ),
          Pinned.fromPins(
            Pin(size: 47.2, end: 7.6),
            Pin(size: 50.0, start: 49.0),
            child: PageLink(
              links: [
                PageLinkInfo(
                  transition: LinkTransition.Fade,
                  ease: Curves.easeOut,
                  duration: 0.3,
                  pageBuilder: () => Configuraciones(key: Key('Settings'), authService: AuthService()),
                ),
              ],
              child: Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: const AssetImage('assets/images/settingsbutton.png'),
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
                ? Center(child: CircularProgressIndicator())
                : Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: _isUpdating ? null : _pickImage,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          CircleAvatar(
                            radius: 50,
                            backgroundColor: Colors.grey[200],
                            child: _isUpdating
                                ? CircularProgressIndicator()
                                : _buildProfileImage(),
                          ),
                          if (!_isUpdating && (_selectedImage == null && _profilePhotoUrl == null))
                            Icon(Icons.add_a_photo, size: 30, color: Colors.black),
                        ],
                      ),
                    ),
                    SizedBox(height: 30),
                    _buildTextField(
                      labelText: 'Correo Electrónico',
                      controller: _emailController,
                      imageAsset: '@.png',
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Ingrese su correo electrónico';
                        }
                        if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                          return 'Correo electrónico inválido';
                        }
                        return null;
                      },
                    ),
                    _buildTextField(
                      labelText: 'Nombre de Usuario',
                      controller: _usernameController,
                      imageAsset: 'nombreusuario.png',
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
                    _buildTextField(
                      labelText: 'Fecha de Nacimiento',
                      controller: _fechaNacimientoController,
                      imageAsset: 'fechanacimientopersona.png',
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Ingrese su fecha de nacimiento';
                        }
                        return null;
                      },
                      readOnly: true,
                      onTap: () => _selectDate(context),
                    ),
                    _buildTextField(
                      labelText: 'Número de Documento',
                      controller: _documentoController,
                      imageAsset: 'id.png',
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
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ),
                          if (_isUpdating)
                            CircularProgressIndicator(),
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