import 'package:animal_health/src/widgets/AyudaOutSession.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:adobe_xd/page_link.dart';
import '../services/auth_service.dart';
import './AnimalHealth.dart';
import './Settingsoutsesion.dart';

class CrearCuenta extends StatefulWidget {
  final AuthService authService;

  const CrearCuenta({required Key key, required this.authService})
    : super(key: key);

  @override
  _CrearCuentaState createState() => _CrearCuentaState();
}

class _CrearCuentaState extends State<CrearCuenta> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _isLoading = false;
  String? _errorMessage;

  @override
  void dispose() {
    _emailController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }
  Future<void> _registerUser() async {
    if (!_formKey.currentState!.validate()) return;

    if (_passwordController.text != _confirmPasswordController.text) {
      setState(() => _errorMessage = 'Las contraseñas no coinciden');
      return;
    }
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
    try {
      final user = await widget.authService.registrarUsuario(
        email: _emailController.text.trim(),
        userName: _usernameController.text.trim(),
        password: _passwordController.text.trim(),
        confirmPassword: _confirmPasswordController.text.trim(),
      );
      if (user != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Registro exitoso! Verifica tu correo electrónico'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.of(context).pop(); // Regresa a la pantalla anterior
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
      setState(() => _errorMessage = 'Error durante el registro');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error durante el registro'),
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
      case 'operation-not-allowed':
        return 'Operación no permitida';
      case 'weak-password':
        return 'Contraseña demasiado débil';
      case 'passwords-mismatch':
        return 'Las contraseñas no coinciden';
      default:
        return 'Error durante el registro';
    }
  }

  Widget _buildTextField({
    required String hintText,
    required TextEditingController controller,
    required String imageAsset,
    required String? Function(String?) validator,
    bool obscureText = false,
  }) {
    return Container(
      height: 45,
      margin: EdgeInsets.symmetric(horizontal: 43, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(width: 1, color: Colors.black),
      ),
      child: Row(
        children: [
          Container(
            width: 45,
            height: 45,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(imageAsset),
                fit: BoxFit.fill,
              ),
            ),
          ),
          Expanded(
            child: TextFormField(
              controller: controller,
              obscureText: obscureText,
              decoration: InputDecoration(
                hintText: hintText,
                border: InputBorder.none,
                hintStyle: TextStyle(
                  fontFamily: 'Comic Sans MS',
                  fontSize: 20,
                  color: Colors.black,
                  fontWeight: FontWeight.w700,
                ),
              ),
              style: TextStyle(
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff4ec8dd),
      body: Stack(
        children: [
          // Fondo
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                  'assets/images/Animal Health Fondo de Pantalla.png',
                ),
                fit: BoxFit.cover,
              ),
            ),
          ),

          // Logo
          Positioned(
            top: 60,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                width: 177,
                height: 175,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/logo.png'),
                    fit: BoxFit.cover,
                  ),
                  borderRadius: BorderRadius.circular(32),
                  border: Border.all(width: 1, color: Colors.black),
                ),
              ),
            ),
          ),

          // Botón Atrás
          Positioned(
            top: 49,
            left: 9.1,
            child: PageLink(
              links: [
                PageLinkInfo(
                  transition: LinkTransition.Fade,
                  ease: Curves.easeOut,
                  duration: 0.3,
                  pageBuilder:
                      () => AnimalHealth(
                        key: Key('AnimalHealth'),
                        authService: widget.authService,
                      ),
                ),
              ],
              child: Container(
                width: 52.9,
                height: 50,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/back.png'),
                    fit: BoxFit.fill,
                  ),
                ),
              ),
            ),
          ),

          // Botón Ayuda
          Positioned(
            top: 49,
            right: MediaQuery.of(context).size.width * 0.1672,
            child: PageLink(
              links: [
                PageLinkInfo(
                  transition: LinkTransition.Fade,
                  ease: Curves.easeOut,
                  duration: 0.3,
                  pageBuilder: () => AyudaOutSession(key: Key('AyudaOutSession')),
                ),
              ],
              child: Container(
                width: 40.5,
                height: 50,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/help.png'),
                    fit: BoxFit.fill,
                  ),
                ),
              ),
            ),
          ),

          // Botón Configuración
          Positioned(
            top: 49,
            right: 7.6,
            child: PageLink(
              links: [
                PageLinkInfo(
                  transition: LinkTransition.Fade,
                  ease: Curves.easeOut,
                  duration: 0.3,
                  pageBuilder:
                      () => Settingsoutsesion(key: Key('Settingsoutsesion')),
                ),
              ],
              child: Container(
                width: 47.2,
                height: 50,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/settingsbutton.png'),
                    fit: BoxFit.fill,
                  ),
                ),
              ),
            ),
          ),

          // Formulario
          Positioned(
            top: 250,
            left: 0,
            right: 0,
            bottom: 0,
            child: SingleChildScrollView(
              padding: EdgeInsets.only(bottom: 20),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    // Campo Email
                    _buildTextField(
                      hintText: 'Correo Electrónico',
                      controller: _emailController,
                      imageAsset: 'assets/images/@.png',
                      validator: (value) {
                        if (value == null || value.isEmpty)
                          return 'Ingrese su correo';
                        if (!value.contains('@'))
                          return 'Ingrese un correo válido';
                        return null;
                      },
                    ),

                    // Campo Nombre de Usuario
                    _buildTextField(
                      hintText: 'Nombre de Usuario',
                      controller: _usernameController,
                      imageAsset: 'assets/images/username.png',
                      validator: (value) {
                        if (value == null || value.isEmpty)
                          return 'Ingrese un nombre de usuario';
                        if (value.length < 4) return 'Mínimo 4 caracteres';
                        return null;
                      },
                    ),

                    // Campo Contraseña
                    _buildTextField(
                      hintText: 'Contraseña',
                      controller: _passwordController,
                      imageAsset: 'assets/images/password.png',
                      obscureText: true,
                      validator: (value) {
                        if (value == null || value.isEmpty)
                          return 'Ingrese una contraseña';
                        if (value.length < 8) return 'Mínimo 8 caracteres';
                        return null;
                      },
                    ),

                    // Campo Confirmar Contraseña
                    _buildTextField(
                      hintText: 'Confirmar Contraseña',
                      controller: _confirmPasswordController,
                      imageAsset: 'assets/images/password.png',
                      obscureText: true,
                      validator: (value) {
                        if (value == null || value.isEmpty)
                          return 'Confirme su contraseña';
                        if (value != _passwordController.text)
                          return 'Las contraseñas no coinciden';
                        return null;
                      },
                    ),

                    // Mensaje de error
                    if (_errorMessage != null)
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 50,
                          vertical: 10,
                        ),
                        child: Text(
                          _errorMessage!,
                          style: TextStyle(
                            fontFamily: 'Comic Sans MS',
                            fontSize: 16,
                            color: Colors.red,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),

                    // Botón Registrarse
                    Container(
                      width: 242,
                      height: 49,
                      margin: EdgeInsets.only(top: 20),
                      child:
                          _isLoading
                              ? Center(child: CircularProgressIndicator())
                              : PageLink(
                                links: [
                                  PageLinkInfo(
                                    transition: LinkTransition.Fade,
                                    ease: Curves.easeOut,
                                    duration: 0.3,
                                    pageBuilder:
                                        () => AnimalHealth(
                                          key: Key('AnimalHealth'),
                                          authService: widget.authService,
                                        ),
                                  ),
                                ],
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Color(0xff4ec8dd),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15),
                                      side: BorderSide(
                                        width: 1,
                                        color: Colors.black,
                                      ),
                                    ),
                                    shadowColor: Color(0xff080808),
                                    elevation: 3,
                                  ),
                                  onPressed: _registerUser,
                                  child: Text(
                                    'Registrarse',
                                    style: TextStyle(
                                      fontFamily: 'Comic Sans MS',
                                      fontSize: 20,
                                      color: Colors.black,
                                      fontWeight: FontWeight.w700,
                                    ),
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
