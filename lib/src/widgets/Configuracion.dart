import 'package:animal_health/src/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:adobe_xd/pinned.dart';
import 'package:adobe_xd/page_link.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Imports de Navegación
import './Home.dart';
import './Ayuda.dart';
import './PRIVACIDAD.dart';
import './EditarinfodeUsuario.dart';
import './VerMetodosdePago.dart';
import './Idiomas.dart';
import './AnimalHealth.dart';
import './Suscripcion.dart';

// --- Clase Configuraciones ---
class Configuraciones extends StatefulWidget {
  const Configuraciones({required Key key, required this.authService})
      : super(key: key);

  final AuthService authService;

  @override
  _ConfiguracionesState createState() => _ConfiguracionesState();
}

// --- Estado de Configuraciones ---
class _ConfiguracionesState extends State<Configuraciones> {
  // --- Variables de Estado ---
  bool _audioVisualAccessibility = false;
  static const String _accessibilityPrefKey = 'audioVisualAccessibilityEnabled';

  // --- Ciclo de Vida: initState ---
  @override
  void initState() {
    super.initState();
    _loadAccessibilityPreference();
  }

  // --- Métodos para Preferencias de Accesibilidad ---
  Future<void> _loadAccessibilityPreference() async {
    final prefs = await SharedPreferences.getInstance();
    if (mounted) {
      setState(() {
        _audioVisualAccessibility = prefs.getBool(_accessibilityPrefKey) ?? false;
      });
    }
  }

  Future<void> _saveAccessibilityPreference(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_accessibilityPrefKey, value);
  }

  // --- Método para Cerrar Sesión ---
  Future<void> _logout(BuildContext context) async {
    try {
      await widget.authService.cerrarSesion();
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (context) => AnimalHealth(
            key: const Key('AnimalHealth_Login'),
            authService: widget.authService,
            onLoginSuccess: () {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => Home(key: const Key('Home_After_Relogin'))),
              );
            },
          ),
        ),
            (Route<dynamic> route) => false,
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al cerrar sesión: ${e.toString()}')),
        );
      }
    }
  }

  // --- Widget Builder para Opciones de Configuración ---
  Widget _buildConfigOption({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    Widget? trailing,
  }) {
    final bool isAccessibilityModeActive = _audioVisualAccessibility;
    final Color cardBackgroundColor = isAccessibilityModeActive
        ? Colors.black.withOpacity(0.85)
        : const Color(0xffffffff).withOpacity(0.92);
    final Color textColor = isAccessibilityModeActive
        ? Colors.yellowAccent.shade700
        : const Color(0xff222222);
    final Color iconColor = isAccessibilityModeActive
        ? Colors.yellowAccent.shade700
        : const Color(0xff4ec8dd);

    return Card(
      elevation: 3.0,
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 25.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      color: cardBackgroundColor,
      child: ListTile(
        leading: Icon(icon, color: iconColor, size: 28),
        title: Text(
          title,
          style: TextStyle(
            fontFamily: 'Comic Sans MS',
            fontSize: isAccessibilityModeActive ? 20 : 18,
            color: textColor,
            fontWeight: FontWeight.w600,
          ),
        ),
        trailing: trailing ?? Icon(Icons.arrow_forward_ios, color: isAccessibilityModeActive ? Colors.yellowAccent.withOpacity(0.7) : Colors.grey, size: 18),
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
      ),
    );
  }

  // --- Método Build Principal ---
  @override
  Widget build(BuildContext context) {
    final User? currentUser = FirebaseAuth.instance.currentUser;
    const double topOffsetForContent = 130.0;

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
              links: [
                PageLinkInfo(
                  transition: LinkTransition.Fade,
                  ease: Curves.easeOut,
                  duration: 0.3,
                  pageBuilder: () => Home(key: const Key('Home_From_Settings_Logo')),
                ),
              ],
              child: Container(
                decoration: BoxDecoration(
                  image: const DecorationImage(image: AssetImage('assets/images/logo.png'), fit: BoxFit.cover),
                  borderRadius: BorderRadius.circular(15.0),
                  border: Border.all(width: 1.0, color: const Color(0xff000000)),
                ),
              ),
            ),
          ),
          // --- Botón de Retroceso ---
          Pinned.fromPins(
            Pin(size: 52.9, start: 15.0), Pin(size: 50.0, start: 49.0),
            child: InkWell(
              onTap: () => Navigator.of(context).pop(),
              child: Container(decoration: const BoxDecoration(image: DecorationImage(image: AssetImage('assets/images/back.png'), fit: BoxFit.fill))),
            ),
          ),
          // --- Botón de Ayuda ---
          Pinned.fromPins(
            Pin(size: 40.5, end: 15.0), Pin(size: 50.0, start: 49.0),
            child: PageLink(
              links: [PageLinkInfo(pageBuilder: () => Ayuda(key: const Key('Ayuda')))],
              child: Container(decoration: const BoxDecoration(image: DecorationImage(image: AssetImage('assets/images/help.png'), fit: BoxFit.fill))),
            ),
          ),
          // --- Contenido Principal de Configuraciones ---
          Positioned(
            top: topOffsetForContent,
            left: 0,
            right: 0,
            bottom: 0,
            child: Column(
              children: [
                // --- Título de la Pantalla con Icono ---
                Padding(
                  padding: const EdgeInsets.only(bottom: 20.0),
                  child: Row( // Usar Row para alinear icono y texto
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/images/settingsbutton.png', // Icono de settings
                        width: 35, // Ajustar tamaño según sea necesario
                        height: 35,
                      ),
                      const SizedBox(width: 10), // Espacio entre icono y texto
                      Text(
                        'Configuraciones',
                        style: TextStyle(
                          fontFamily: 'Comic Sans MS',
                          fontSize: 24,
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          shadows: [Shadow(blurRadius: 2.0, color: Colors.black.withOpacity(0.5), offset: Offset(1.0, 1.0))],
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                // --- Lista de Opciones de Configuración (Scrollable) ---
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.only(bottom: 20.0),
                    child: Column(
                      children: <Widget>[
                        // --- Información del Usuario (Foto, Nombre, Email) ---
                        if (currentUser != null)
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 25.0),
                            child: Row(
                              children: [
                                StreamBuilder<DocumentSnapshot>(
                                  stream: FirebaseFirestore.instance.collection('users').doc(currentUser.uid).snapshots(),
                                  builder: (context, snapshot) {
                                    String? profilePhotoUrl;
                                    if (snapshot.hasData && snapshot.data!.exists) {
                                      final userData = snapshot.data!.data() as Map<String, dynamic>;
                                      profilePhotoUrl = userData['profilePhotoUrl'] as String?;
                                    }
                                    return Container(
                                      width: 70,
                                      height: 70,
                                      decoration: BoxDecoration(
                                          color: Colors.grey[300],
                                          borderRadius: BorderRadius.circular(12.0),
                                          border: Border.all(color: Colors.white, width: 2.0),
                                          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.2), spreadRadius: 1, blurRadius: 3, offset: Offset(0, 2))]
                                      ),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(10.0),
                                        child: (profilePhotoUrl != null && profilePhotoUrl.isNotEmpty)
                                            ? CachedNetworkImage(
                                          imageUrl: profilePhotoUrl, fit: BoxFit.cover,
                                          placeholder: (context, url) => const Center(child: CircularProgressIndicator(strokeWidth: 2.0)),
                                          errorWidget: (context, url, error) => Icon(Icons.person, size: 40, color: Colors.grey[600]),
                                        )
                                            : Icon(Icons.person, size: 40, color: Colors.grey[600]),
                                      ),
                                    );
                                  },
                                ),
                                const SizedBox(width: 15),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        currentUser.displayName ?? currentUser.email ?? 'Usuario',
                                        style: TextStyle(fontFamily: 'Comic Sans MS', fontSize: 20, color: Colors.black, fontWeight: FontWeight.bold),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      if (currentUser.email != null)
                                        Text(
                                          currentUser.email!,
                                          style: TextStyle(fontFamily: 'Arial', fontSize: 14, color: Colors.black87),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        const SizedBox(height: 5),
                        // --- Opciones de Configuración Individuales ---
                        _buildConfigOption(
                          icon: Icons.shield_outlined,
                          title: 'Privacidad',
                          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => PRIVACIDAD(key: const Key('PRIVACIDAD')))),
                        ),
                        _buildConfigOption(
                          icon: Icons.workspace_premium_outlined,
                          title: 'Suscripción',
                          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => Suscripcion(key: const Key('Suscripcion')))),
                        ),
                        _buildConfigOption(
                          icon: Icons.manage_accounts_outlined,
                          title: 'Información Personal',
                          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => EditarinfodeUsuario(key: const Key('EditarinfodeUsuario'), authService: widget.authService, onUpdateSuccess: (){}))),
                        ),
                        _buildConfigOption(
                          icon: Icons.credit_card,
                          title: 'Métodos de Pago',
                          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => VerMetodosdePago(key: const Key('AgregarMetodosdePago')))),
                        ),
                        _buildConfigOption(
                          icon: Icons.translate_outlined,
                          title: 'Idioma',
                          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => Idiomas(key: const Key('Idiomas')))),
                        ),
                        _buildConfigOption(
                          icon: _audioVisualAccessibility ? Icons.hearing_disabled_outlined : Icons.hearing_outlined,
                          title: 'Accesibilidad Audiovisual',
                          trailing: Switch(
                            value: _audioVisualAccessibility,
                            onChanged: (bool value) {
                              setState(() {
                                _audioVisualAccessibility = value;
                                _saveAccessibilityPreference(value);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('Modo accesibilidad ${value ? "activado" : "desactivado"}.')),
                                );
                              });
                            },
                            activeTrackColor: Colors.blue.withOpacity(0.5),
                            activeColor: Colors.blueAccent,
                            inactiveThumbColor: Colors.blueGrey.shade600,
                            inactiveTrackColor: Colors.grey.shade400,
                          ),
                          onTap: () {
                            setState(() {
                              _audioVisualAccessibility = !_audioVisualAccessibility;
                              _saveAccessibilityPreference(_audioVisualAccessibility);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Modo accesibilidad ${ _audioVisualAccessibility ? "activado" : "desactivado"}.')),
                              );
                            });
                          },
                        ),
                        const SizedBox(height: 25),
                        // --- Botón de Cerrar Sesión ---
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 40.0),
                          child: ElevatedButton.icon(
                            icon: const Icon(Icons.exit_to_app, color: Colors.white),
                            label: const Text('Cerrar Sesión', style: TextStyle(fontFamily: 'Comic Sans MS', fontSize: 18, color: Colors.white)),
                            onPressed: () => _logout(context),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red.shade700,
                              padding: const EdgeInsets.symmetric(vertical: 14.0),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
                              minimumSize: const Size(double.infinity, 50),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}