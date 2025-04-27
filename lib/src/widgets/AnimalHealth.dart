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

          // Campo Email
          Pinned.fromPins(
            Pin(start: 43.0, end: 43.0),
            Pin(size: 45.0, middle: 0.5),
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xffffffff),
                borderRadius: BorderRadius.circular(12.0),
                border: Border.all(width: 1.0, color: const Color(0xff000000)),
              ),
              child: Row(
                children: [
                  Container(
                    width: 45.0,
                    height: 45.0,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: const AssetImage('assets/images/@.png'),
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                  Expanded(
                    child: TextField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        hintText: 'Email',
                        border: InputBorder.none,
                        hintStyle: TextStyle(
                          fontFamily: 'Comic Sans MS',
                          fontSize: 20,
                          color: const Color(0xff000000),
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      style: TextStyle(
                        fontFamily: 'Comic Sans MS',
                        fontSize: 20,
                        color: const Color(0xff000000),
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Campo Contraseña
          Pinned.fromPins(
            Pin(start: 49.0, end: 48.0),
            Pin(size: 45.0, middle: 0.58),
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xffffffff),
                borderRadius: BorderRadius.circular(12.0),
                border: Border.all(width: 1.0, color: const Color(0xff000000)),
              ),
              child: Row(
                children: [
                  Container(
                    width: 45.0,
                    height: 45.0,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: const AssetImage('assets/images/password.png'),
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                  Expanded(
                    child: TextField(
                      controller: _passwordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        hintText: 'Contraseña',
                        border: InputBorder.none,
                        hintStyle: TextStyle(
                          fontFamily: 'Comic Sans MS',
                          fontSize: 20,
                          color: const Color(0xff000000),
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      style: TextStyle(
                        fontFamily: 'Comic Sans MS',
                        fontSize: 20,
                        color: const Color(0xff000000),
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Botón Iniciar Sesión
          Pinned.fromPins(
            Pin(size: 242.0, middle: 0.5),
            Pin(size: 49.0, middle: 0.68),
            child: _isLoading
                ? Center(child: CircularProgressIndicator())
                : GestureDetector(
              onTap: () async {
                await _signInWithEmailAndPassword();

                // Verificar si el usuario está logueado después de intentar iniciar sesión
                if (FirebaseAuth.instance.currentUser != null &&
                    FirebaseAuth.instance.currentUser!.emailVerified) {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (context) => Home(key: Key('Home')),
                    ),
                  );
                }
              },
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0xff4ec8dd),
                  borderRadius: BorderRadius.circular(15.0),
                  border: Border.all(
                      width: 1.0,
                      color: const Color(0xff000000)),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xff080808),
                      blurRadius: 3,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: Center(
                  child: Text(
                    'Iniciar Sesion',
                    style: TextStyle(
                      fontFamily: 'Comic Sans MS',
                      fontSize: 20,
                      color: const Color(0xff000000),
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ),
          ),
          // Mensaje de error
          if (_errorMessage != null)
            Pinned.fromPins(
              Pin(start: 50.0, end: 50.0),
              Pin(size: 30.0, middle: 0.63),
              child: Center(
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
            ),

          // Texto "¿No tienes una cuenta?"
          Pinned.fromPins(
            Pin(start: 50.0, end: 50.0),
            Pin(size: 26.0, middle: 0.75),
            child: Center(
              child: Text(
                '¿No tienes una cuenta?',
                style: TextStyle(
                  fontFamily: 'Comic Sans MS',
                  fontSize: 20,
                  color: const Color(0xff000000),
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),

          // Botón Registrarse
          Pinned.fromPins(
            Pin(size: 249.5, middle: 0.5),
            Pin(size: 49.0, middle: 0.8),
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
              child: GestureDetector(
                onTap: widget.onRegisterPressed ?? () {
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
                child: Container(
                  decoration: BoxDecoration(
                    color: const Color(0xff4ec8dd),
                    borderRadius: BorderRadius.circular(15.0),
                    border: Border.all(
                        width: 1.0,
                        color: const Color(0xff000000)),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xff080808),
                        blurRadius: 3,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      'Registrarse',
                      style: TextStyle(
                        fontFamily: 'Comic Sans MS',
                        fontSize: 20,
                        color: const Color(0xff000000),
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ),
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