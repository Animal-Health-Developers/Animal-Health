import 'package:adobe_xd/page_link.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:adobe_xd/pinned.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/auth_service.dart';
import './Home.dart';
import './CrearCuenta.dart';
import './AyudaOutSession.dart';
import './Settingsoutsesion.dart';
import '/firebase_options.dart';

class AnimalHealth extends StatefulWidget {
  final AuthService authService;
  final VoidCallback onLoginSuccess;
  final VoidCallback? onRegisterPressed;

  const AnimalHealth({
    required Key key,
    required this.authService,
    required this.onLoginSuccess,
    this.onRegisterPressed,
  }) : super(key: key);

  @override
  _AnimalHealthState createState() => _AnimalHealthState();
}

class _AnimalHealthState extends State<AnimalHealth> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _signInWithEmailAndPassword() async {
    try {
      // Verifica que Firebase esté inicializado
      if (Firebase.apps.isEmpty) {
        await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
      }

      if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
        setState(() => _errorMessage = 'Por favor complete todos los campos');
        return;
      }

      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });

      final user = await widget.authService.iniciarSesion(
        _emailController.text.trim(),
        _passwordController.text.trim(),
      );

      if (user != null) {
        final currentUser = FirebaseAuth.instance.currentUser;
        if (currentUser != null && !currentUser.emailVerified) {
          await widget.authService.verificarCorreoElectronico();
          setState(() {
            _errorMessage = 'Verifique su correo electrónico. Se envió un nuevo correo de verificación.';
          });
          return;
        }

        // Navegar a Home después de login exitoso
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => Home(key: Key('Home')),
          ),
        );
      }
    } on FirebaseException catch (e) {
      setState(() => _errorMessage = _getErrorMessage(e.code));
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.message}')),
      );
    } catch (e) {
      setState(() => _errorMessage = 'Error de configuración: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error de configuración: $e')),
      );
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  String _getErrorMessage(String code) {
    switch (code) {
      case 'invalid-email': return 'Email inválido';
      case 'user-disabled': return 'Usuario deshabilitado';
      case 'user-not-found': return 'Usuario no encontrado';
      case 'wrong-password': return 'Contraseña incorrecta';
      case 'too-many-requests': return 'Demasiados intentos. Espere.';
      default: return 'Error: $code';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff4ec8dd),
      body: Stack(
        children: <Widget>[
          // Fondo
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: const AssetImage('assets/images/Animal Health Fondo de Pantalla.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),

          // Logo
          Pinned.fromPins(
            Pin(size: 177.0, middle: 0.5),
            Pin(size: 175.0, start: 100.0),
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: const AssetImage('assets/images/logo.png'),
                  fit: BoxFit.cover,
                ),
                borderRadius: BorderRadius.circular(32.0),
                border: Border.all(width: 1.0, color: const Color(0xff000000)),
              ),
            ),
          ),

          // Formulario
          Positioned(
            top: 300,
            left: 30,
            right: 30,
            child: Column(
              children: [
                // Campo Email
                SizedBox(
                  height: 60,
                  child: Stack(
                    children: [
                      TextFormField(
                        controller: _emailController,
                        decoration: InputDecoration(
                          labelText: 'Email',
                          border: OutlineInputBorder(),
                          filled: true,
                          fillColor: Colors.white,
                          contentPadding: EdgeInsets.only(left: 50.0, top: 15, bottom: 15),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Por favor ingrese su email';
                          }
                          if (!value.contains('@')) {
                            return 'Ingrese un email válido';
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

                // Campo Contraseña
                SizedBox(
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
                            return 'Por favor ingrese su contraseña';
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
                    padding: const EdgeInsets.symmetric(horizontal: 10),
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
                SizedBox(height: 20),

                // Botón Iniciar Sesión
                SizedBox(
                  width: 242,
                  height: 49,
                  child: _isLoading
                      ? Center(child: CircularProgressIndicator())
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
                    onPressed: () async {
                      await _signInWithEmailAndPassword();
                      if (FirebaseAuth.instance.currentUser != null &&
                          FirebaseAuth.instance.currentUser!.emailVerified) {
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                            builder: (context) => Home(key: Key('Home')),
                          ),
                        );
                      }
                    },
                    child: const Text(
                      'Iniciar Sesión',
                      style: TextStyle(
                        fontFamily: 'Comic Sans MS',
                        fontSize: 20,
                        color: Colors.black,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20),

                // Texto "¿No tienes una cuenta?"
                const Text(
                  '¿No tienes una cuenta?',
                  style: TextStyle(
                    fontFamily: 'Comic Sans MS',
                    fontSize: 20,
                    color: Colors.black,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 10),

                // Botón Registrarse
                SizedBox(
                  width: 242,
                  height: 49,
                  child: PageLink(
                    links: [
                      PageLinkInfo(
                        transition: LinkTransition.Fade,
                        ease: Curves.easeOut,
                        duration: 0.3,
                        pageBuilder: () => CrearCuenta(
                          key: Key('CrearCuenta'),
                          authService: widget.authService,
                          onRegistrationSuccess: widget.onLoginSuccess,
                        ),
                      ),
                    ],
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
                      onPressed: widget.onRegisterPressed ?? () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => CrearCuenta(
                              key: Key('CrearCuenta'),
                              authService: widget.authService,
                              onRegistrationSuccess: widget.onLoginSuccess,
                            ),
                          ),
                        );
                      },
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
                ),
              ],
            ),
          ),

          // Botones de Ayuda y Configuración
          Pinned.fromPins(
            Pin(size: 40.5, middle: 0.8328),
            Pin(size: 50.0, start: 49.0),
            child: PageLink(
              links: [
                PageLinkInfo(
                  transition: LinkTransition.Fade,
                  ease: Curves.easeOut,
                  duration: 0.3,
                  pageBuilder: () => AyudaOutSession(key: Key('AyudaOutSession'),),
                ),
              ],
              child: GestureDetector(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                        builder: (context) => AyudaOutSession(key: Key('AyudaOutSession'))),
                  );
                },
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
                  pageBuilder: () => Settingsoutsesion(key: Key('Settingsoutsesion'),),
                ),
              ],
              child: GestureDetector(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                        builder: (context) => Settingsoutsesion(key: Key('Settingsoutsesion'))),
                  );
                },
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
          ),
        ],
      ),
    );
  }
}