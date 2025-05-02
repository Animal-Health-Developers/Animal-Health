import 'package:animal_health/src/widgets/AyudaOutSession.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:adobe_xd/page_link.dart';
import '../services/auth_service.dart';
import './AnimalHealth.dart';
import './Settingsoutsesion.dart';

class CrearCuenta extends StatefulWidget {
  final AuthService authService;
  final VoidCallback onRegistrationSuccess;

  const CrearCuenta({
    required Key key,
    required this.authService,
    required this.onRegistrationSuccess,
  }) : super(key: key);

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
          const SnackBar(
            content: Text('Registro exitoso! Verifica tu correo electrónico'),
            backgroundColor: Colors.green,
          ),
        );

        // Esperar 2 segundos para que el usuario vea el mensaje
        await Future.delayed(const Duration(seconds: 2));

        // Navegar a AnimalHealth
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => AnimalHealth(
              key: const Key('AnimalHealth'),
              authService: widget.authService,
              onLoginSuccess: widget.onRegistrationSuccess,
            ),
          ),
        );
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
        const SnackBar(
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff4ec8dd),
      body: Stack(
        children: [
          // Fondo
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/Animal Health Fondo de Pantalla.png'),
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
                  image: const DecorationImage(
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
                  pageBuilder: () => AnimalHealth(
                    key: const Key('AnimalHealth'),
                    authService: widget.authService,
                    onLoginSuccess: widget.onRegistrationSuccess,
                  ),
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
                  pageBuilder: () => AyudaOutSession(key: const Key('AyudaOutSession')),
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
                  pageBuilder: () => Settingsoutsesion(key: const Key('Settingsoutsesion')),
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

          // Formulario
          Positioned(
            top: 250,
            left: 30,
            right: 30,
            bottom: 27,
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    // Campo Email
                    Container(
                      height: 60,
                      child: Stack(
                        children: [
                          TextFormField(
                            controller: _emailController,
                            decoration: InputDecoration(
                              labelText: 'Correo Electrónico',
                              border: OutlineInputBorder(),
                              filled: true,
                              fillColor: Colors.white,
                              contentPadding: EdgeInsets.only(left: 50.0, top: 15, bottom: 15),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Ingrese su correo';
                              }
                              if (!value.contains('@')) {
                                return 'Ingrese un correo válido';
                              }
                              return null;
                            },
                          ),
                          Positioned(
                            left: 5,
                            top: 0,
                            bottom: 10,
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Container(
                                width: 37.4,
                                height: 40.0,
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: const AssetImage('assets/images/@.png'),
                                    fit: BoxFit.fill,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20),

                    // Campo Nombre de Usuario
                    Container(
                      height: 60,
                      child: Stack(
                        children: [
                          TextFormField(
                            controller: _usernameController,
                            decoration: InputDecoration(
                              labelText: 'Nombre de Usuario',
                              border: OutlineInputBorder(),
                              filled: true,
                              fillColor: Colors.white,
                              contentPadding: EdgeInsets.only(left: 50.0, top: 15, bottom: 15),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Ingrese un nombre de usuario';
                              }
                              if (value.length < 4) {
                                return 'Mínimo 4 caracteres';
                              }
                              return null;
                            },
                          ),
                          Positioned(
                            left: 5,
                            top: 0,
                            bottom: 10,
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Container(
                                width: 37.4,
                                height: 40.0,
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: const AssetImage('assets/images/username.png'),
                                    fit: BoxFit.fill,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20),

                    // Campo Contraseña
                    Container(
                      height: 60,
                      child: Stack(
                        children: [
                          TextFormField(
                            controller: _passwordController,
                            obscureText: true,
                            decoration: InputDecoration(
                              labelText: 'Contraseña',
                              border: OutlineInputBorder(),
                              filled: true,
                              fillColor: Colors.white,
                              contentPadding: EdgeInsets.only(left: 50.0, top: 15, bottom: 15),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Ingrese una contraseña';
                              }
                              if (value.length < 8) {
                                return 'Mínimo 8 caracteres';
                              }
                              return null;
                            },
                          ),
                          Positioned(
                            left: 5,
                            top: 0,
                            bottom: 10,
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Container(
                                width: 37.4,
                                height: 40.0,
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: const AssetImage('assets/images/password.png'),
                                    fit: BoxFit.fill,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20),

                    // Campo Confirmar Contraseña
                    Container(
                      height: 60,
                      child: Stack(
                        children: [
                          TextFormField(
                            controller: _confirmPasswordController,
                            obscureText: true,
                            decoration: InputDecoration(
                              labelText: 'Confirmar Contraseña',
                              border: OutlineInputBorder(),
                              filled: true,
                              fillColor: Colors.white,
                              contentPadding: EdgeInsets.only(left: 50.0, top: 15, bottom: 15),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Confirme su contraseña';
                              }
                              if (value != _passwordController.text) {
                                return 'Las contraseñas no coinciden';
                              }
                              return null;
                            },
                          ),
                          Positioned(
                            left: 5,
                            top: 0,
                            bottom: 10,
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Container(
                                width: 37.4,
                                height: 40.0,
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: const AssetImage('assets/images/password.png'),
                                    fit: BoxFit.fill,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20),

                    // Mensaje de error
                    if (_errorMessage != null)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
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

                    // Botón Registrarse
                    Container(
                      width: 242,
                      height: 49,
                      margin: const EdgeInsets.only(top: 20),
                      child: _isLoading
                          ? const Center(child: CircularProgressIndicator())
                          : ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xff4ec8dd),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                            side: const BorderSide(width: 1, color: Colors.black),
                          ),
                          shadowColor: const Color(0xff080808),
                          elevation: 3,
                        ),
                        onPressed: _registerUser,
                        child: const Text(
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