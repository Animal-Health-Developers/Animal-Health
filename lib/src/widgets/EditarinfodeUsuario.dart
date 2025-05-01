import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:adobe_xd/page_link.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;
import './Home.dart';
import './Ayuda.dart';
import './Configuracion.dart';
import '../services/auth_service.dart';
import '../models/user.dart' as user_model;

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

  File? _selectedImage;
  bool _isLoading = false;
  String? _errorMessage;
  String? _profilePhotoUrl;
  user_model.User? _currentUser;

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

    try {
      final user = await widget.authService.getCurrentUser();
      if (user != null) {
        setState(() {
          _currentUser = user;
          _emailController.text = user.email ?? '';
          _usernameController.text = user.userName ?? '';
          _fechaNacimientoController.text = user.fechaNacimiento ?? '';
          _documentoController.text = user.documento ?? '';
          _contactoController.text = user.contacto ?? '';
          _profilePhotoUrl = user.profilePhotoUrl;
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al cargar datos: ${e.toString()}')),
      );
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _pickImage() async {
    try {
      final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        setState(() {
          _selectedImage = File(pickedFile.path);
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
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final userUpdated = await widget.authService.actualizarUsuario(
        email: _emailController.text.trim(),
        userName: _usernameController.text.trim(),
        fechaNacimiento: _fechaNacimientoController.text.trim(),
        documento: _documentoController.text.trim(),
        contacto: _contactoController.text.trim(),
        password: _passwordController.text.trim(),
        profilePhoto: _selectedImage,
      );

      if (userUpdated) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Información actualizada exitosamente'),
            backgroundColor: Colors.green,
          ),
        );
        widget.onUpdateSuccess();
      }
    } on FirebaseAuthException catch (e) {
      setState(() => _errorMessage = _getErrorMessage(e.code));
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(_getErrorMessage(e.code)),
          backgroundColor: Colors.red,
        ),
      );
    } catch (e) {
      setState(() => _errorMessage = 'Error durante la actualización: ${e.toString()}');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error durante la actualización: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
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
      default:
        return 'Error durante la actualización';
    }
  }

  Widget _buildTextField({
    required String hintText,
    required TextEditingController controller,
    required String imageAsset,
    required String? Function(String?) validator,
    bool obscureText = false,
    bool readOnly = false,
  }) {
    return Container(
      height: 45,
      margin: const EdgeInsets.symmetric(horizontal: 43, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(width: 1, color: Colors.black),
      ),
      child: Row(
        children: [
          if (imageAsset.isNotEmpty)
            Container(
              width: 45,
              height: 45,
              child: Image.asset(
                imageAsset,
                width: 45,
                height: 45,
                fit: BoxFit.fill,
                errorBuilder: (context, error, stackTrace) => Container(),
              ),
            ),
          Expanded(
            child: TextFormField(
              controller: controller,
              obscureText: obscureText,
              readOnly: readOnly,
              decoration: InputDecoration(
                hintText: hintText,
                border: InputBorder.none,
                hintStyle: const TextStyle(
                  fontFamily: 'Comic Sans MS',
                  fontSize: 20,
                  color: Colors.black,
                  fontWeight: FontWeight.w700,
                ),
              ),
              style: const TextStyle(
                fontFamily: 'Comic Sans MS',
                fontSize: 20,
                color: Colors.black,
                fontWeight: FontWeight.w700,
              ),
              validator: validator,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileImage() {
    if (_selectedImage != null) {
      if (kIsWeb) {
        return ClipRRect(
          borderRadius: BorderRadius.circular(30),
          child: Image.network(
            _selectedImage!.path,
            width: 150,
            height: 150,
            fit: BoxFit.cover,
          ),
        );
      } else {
        return ClipRRect(
          borderRadius: BorderRadius.circular(30),
          child: Image.file(
            _selectedImage!,
            width: 150,
            height: 150,
            fit: BoxFit.cover,
          ),
        );
      }
    } else if (_profilePhotoUrl != null && _profilePhotoUrl!.isNotEmpty) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(30),
        child: Image.network(
          _profilePhotoUrl!,
          width: 150,
          height: 150,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return const Icon(
              Icons.person,
              size: 50,
              color: Colors.black,
            );
          },
        ),
      );
    } else {
      return const Icon(
        Icons.add_a_photo,
        size: 50,
        color: Colors.black,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff4ec8dd),
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/Animal Health Fondo de Pantalla.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),

          Positioned(
            top: 60,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                width: 74,
                height: 73,
                decoration: BoxDecoration(
                  image: const DecorationImage(
                    image: AssetImage('assets/images/logo.png'),
                    fit: BoxFit.cover,
                  ),
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(width: 1, color: Colors.black),
                ),
              ),
            ),
          ),

          Positioned(
            top: 49,
            left: 9.1,
            child: PageLink(
              links: [
                PageLinkInfo(
                  transition: LinkTransition.Fade,
                  ease: Curves.easeOut,
                  duration: 0.3,
                  pageBuilder: () => Home(key: const Key('Home')),
                ),
              ],
              child: Container(
                width: 52.9,
                height: 50,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/back.png'),
                    fit: BoxFit.fill,
                  ),
                ),
              ),
            ),
          ),

          Positioned(
            top: 49,
            right: MediaQuery.of(context).size.width * 0.1672,
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
                width: 40.5,
                height: 50,
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
            top: 49,
            right: 7.6,
            child: PageLink(
              links: [
                PageLinkInfo(
                  transition: LinkTransition.Fade,
                  ease: Curves.easeOut,
                  duration: 0.3,
                  pageBuilder: () => Configuraciones(key: const Key('Settings')),
                ),
              ],
              child: Container(
                width: 47.2,
                height: 50,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/settingsbutton.png'),
                    fit: BoxFit.fill,
                  ),
                ),
              ),
            ),
          ),

          Positioned(
            top: 150,
            left: 0,
            right: 0,
            child: Center(
              child: GestureDetector(
                onTap: _pickImage,
                child: Container(
                  width: 150,
                  height: 150,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(width: 1, color: Colors.black),
                  ),
                  child: _isLoading
                      ? const CircularProgressIndicator()
                      : _buildProfileImage(),
                ),
              ),
            ),
          ),

          Positioned(
            top: 320,
            left: 0,
            right: 0,
            bottom: 0,
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : SingleChildScrollView(
              padding: const EdgeInsets.only(bottom: 20),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    _buildTextField(
                      hintText: 'Correo Electrónico',
                      controller: _emailController,
                      imageAsset: 'assets/images/@.png',
                      validator: (value) => null,
                      readOnly: true,
                    ),

                    _buildTextField(
                      hintText: 'Nombre de Usuario',
                      controller: _usernameController,
                      imageAsset: 'assets/images/nombreusuario.png',
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
                      hintText: 'Fecha de Nacimiento',
                      controller: _fechaNacimientoController,
                      imageAsset: 'assets/images/fechanacimientopersona.png',
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Ingrese su fecha de nacimiento';
                        }
                        return null;
                      },
                    ),

                    _buildTextField(
                      hintText: 'Número de Documento',
                      controller: _documentoController,
                      imageAsset: 'assets/images/id.png',
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Ingrese su documento';
                        }
                        return null;
                      },
                    ),

                    _buildTextField(
                      hintText: 'Número de Contacto',
                      controller: _contactoController,
                      imageAsset: 'assets/images/numerocontacto.png',
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Ingrese su número de contacto';
                        }
                        return null;
                      },
                    ),

                    _buildTextField(
                      hintText: 'Nueva Contraseña (opcional)',
                      controller: _passwordController,
                      imageAsset: 'assets/images/password.png',
                      obscureText: true,
                      validator: (value) {
                        if (value != null && value.isNotEmpty && value.length < 8) {
                          return 'Mínimo 8 caracteres';
                        }
                        return null;
                      },
                    ),

                    _buildTextField(
                      hintText: 'Confirmar Contraseña',
                      controller: _confirmPasswordController,
                      imageAsset: 'assets/images/password.png',
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
                        padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 10),
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

                    Container(
                      width: 242,
                      height: 49,
                      margin: const EdgeInsets.only(top: 20),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xff4ec8dd),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                            side: const BorderSide(width: 1, color: Colors.black),
                          ),
                          shadowColor: const Color(0xff080808),
                          elevation: 3,
                        ),
                        onPressed: _updateUser,
                        child: const Text(
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