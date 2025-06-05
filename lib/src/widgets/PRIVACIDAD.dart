import 'package:flutter/material.dart';
import 'package:adobe_xd/pinned.dart';
import 'package:adobe_xd/page_link.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Imports de Navegación (ajusta según sea necesario para tus rutas)
import './Home.dart'; // Asumiendo que tienes un Home.dart
import './Ayuda.dart'; // Asumiendo que tienes un Ayuda.dart
// import './Configuraciones.dart'; // No necesitarías volver directamente a configuraciones desde aquí usualmente

// --- Clase PRIVACIDAD ---
class PRIVACIDAD extends StatefulWidget {
  const PRIVACIDAD({Key? key}) : super(key: key); // Key? para null safety

  @override
  _PRIVACIDADState createState() => _PRIVACIDADState();
}

// --- Estado de PRIVACIDAD ---
class _PRIVACIDADState extends State<PRIVACIDAD> {
  // --- Variables de Estado para Accesibilidad ---
  bool _audioVisualAccessibility = false;
  static const String _accessibilityPrefKey = 'audioVisualAccessibilityEnabled';

  // --- Variables de Estado para Configuración de Privacidad ---
  bool _profileVisibilityPublic = true; // Ejemplo: true = público, false = solo amigos/privado
  bool _activityStatusVisible = true;
  bool _dataSharingEnabled = false;

  static const String _profileVisibilityPrefKey = 'profileVisibilityPublic';
  static const String _activityStatusPrefKey = 'activityStatusVisible';
  static const String _dataSharingPrefKey = 'dataSharingEnabled';

  // --- Ciclo de Vida: initState ---
  @override
  void initState() {
    super.initState();
    _loadAllPreferences();
  }

  Future<void> _loadAllPreferences() async {
    await _loadAccessibilityPreference();
    await _loadPrivacyPreferences();
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

  // --- Métodos para Preferencias de Privacidad ---
  Future<void> _loadPrivacyPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    if (mounted) {
      setState(() {
        _profileVisibilityPublic = prefs.getBool(_profileVisibilityPrefKey) ?? true;
        _activityStatusVisible = prefs.getBool(_activityStatusPrefKey) ?? true;
        _dataSharingEnabled = prefs.getBool(_dataSharingPrefKey) ?? false;
      });
    }
  }

  Future<void> _savePrivacyPreference(String key, bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(key, value);
  }

  // --- Widget Builder para Opciones de Configuración (Idéntico a Configuraciones) ---
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

  // --- Método para mostrar un SnackBar (helper) ---
  void _showSnackBar(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
    }
  }

  // --- Método Build Principal ---
  @override
  Widget build(BuildContext context) {
    final User? currentUser = FirebaseAuth.instance.currentUser;
    const double topOffsetForContent = 130.0;

    return Scaffold(
      backgroundColor: const Color(0xff4ec8dd), // Mismo color de fondo
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
                  pageBuilder: () => Home(key: const Key('Home_From_Privacy_Logo')), // Asegúrate que Home tenga un constructor con Key
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
              links: [PageLinkInfo(pageBuilder: () => Ayuda(key: const Key('Ayuda_From_Privacy')))], // Asegúrate que Ayuda tenga un constructor con Key
              child: Container(decoration: const BoxDecoration(image: DecorationImage(image: AssetImage('assets/images/help.png'), fit: BoxFit.fill))),
            ),
          ),
          // --- Contenido Principal de Privacidad ---
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
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon( // Icono de Privacidad
                        Icons.shield_outlined, // Puedes cambiarlo por Icons.privacy_tip_outlined o similar
                        color: Colors.white,
                        size: 35,
                        shadows: [Shadow(blurRadius: 2.0, color: Colors.black.withOpacity(0.5), offset: Offset(1.0, 1.0))],
                      ),
                      const SizedBox(width: 10),
                      Text(
                        'Privacidad', // Título cambiado
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
                // --- Lista de Opciones de Privacidad (Scrollable) ---
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

                        // --- Opciones de Privacidad Individuales ---
                        _buildConfigOption(
                          icon: Icons.visibility_outlined,
                          title: 'Visibilidad del Perfil',
                          trailing: Switch(
                            value: _profileVisibilityPublic,
                            onChanged: (bool value) {
                              setState(() {
                                _profileVisibilityPublic = value;
                                _savePrivacyPreference(_profileVisibilityPrefKey, value);
                                _showSnackBar('Visibilidad del perfil ${value ? "pública" : "restringida"}');
                              });
                            },
                            activeTrackColor: Colors.blue.withOpacity(0.5),
                            activeColor: Colors.blueAccent,
                          ),
                          onTap: () { // Permitir tap en toda la fila para cambiar el switch
                            setState(() {
                              _profileVisibilityPublic = !_profileVisibilityPublic;
                              _savePrivacyPreference(_profileVisibilityPrefKey, _profileVisibilityPublic);
                              _showSnackBar('Visibilidad del perfil ${ _profileVisibilityPublic ? "pública" : "restringida"}');
                            });
                          },
                        ),
                        _buildConfigOption(
                          icon: Icons.timer_outlined,
                          title: 'Estado de Actividad',
                          trailing: Switch(
                            value: _activityStatusVisible,
                            onChanged: (bool value) {
                              setState(() {
                                _activityStatusVisible = value;
                                _savePrivacyPreference(_activityStatusPrefKey, value);
                                _showSnackBar('Estado de actividad ${value ? "visible" : "oculto"}');
                              });
                            },
                            activeTrackColor: Colors.blue.withOpacity(0.5),
                            activeColor: Colors.blueAccent,
                          ),
                          onTap: () {
                            setState(() {
                              _activityStatusVisible = !_activityStatusVisible;
                              _savePrivacyPreference(_activityStatusPrefKey, _activityStatusVisible);
                              _showSnackBar('Estado de actividad ${ _activityStatusVisible ? "visible" : "oculto"}');
                            });
                          },
                        ),
                        _buildConfigOption(
                          icon: Icons.share_outlined,
                          title: 'Compartir Datos Anónimos',
                          trailing: Switch(
                            value: _dataSharingEnabled,
                            onChanged: (bool value) {
                              setState(() {
                                _dataSharingEnabled = value;
                                _savePrivacyPreference(_dataSharingPrefKey, value);
                                _showSnackBar('Compartir datos anónimos ${value ? "activado" : "desactivado"}');
                              });
                            },
                            activeTrackColor: Colors.blue.withOpacity(0.5),
                            activeColor: Colors.blueAccent,
                          ),
                          onTap: () {
                            setState(() {
                              _dataSharingEnabled = !_dataSharingEnabled;
                              _savePrivacyPreference(_dataSharingPrefKey, _dataSharingEnabled);
                              _showSnackBar('Compartir datos anónimos ${ _dataSharingEnabled ? "activado" : "desactivado"}');
                            });
                          },
                        ),
                        _buildConfigOption(
                          icon: Icons.devices_other_outlined,
                          title: 'Administrar Dispositivos',
                          onTap: () {
                            // TODO: Implementar navegación o lógica para administrar dispositivos
                            _showSnackBar('Función no implementada: Administrar Dispositivos');
                          },
                        ),
                        _buildConfigOption(
                          icon: Icons.download_for_offline_outlined,
                          title: 'Descargar mis Datos',
                          onTap: () {
                            // TODO: Implementar lógica para descargar datos del usuario
                            _showSnackBar('Función no implementada: Descargar mis Datos');
                          },
                        ),
                        _buildConfigOption(
                          icon: Icons.policy_outlined, // O un ícono más específico si lo tienes
                          title: 'Política de Privacidad',
                          onTap: () {
                            // TODO: Navegar a una pantalla con la política de privacidad o abrir un enlace web
                            _showSnackBar('Función no implementada: Ver Política de Privacidad');
                            // Ejemplo: launchUrl(Uri.parse('https://tusitioweb.com/privacidad'));
                          },
                        ),
                        const Divider(height: 30, indent: 30, endIndent: 30),
                        // --- Accesibilidad Audiovisual (Mantenida para consistencia) ---
                        _buildConfigOption(
                          icon: _audioVisualAccessibility ? Icons.hearing_disabled_outlined : Icons.hearing_outlined,
                          title: 'Accesibilidad Audiovisual',
                          trailing: Switch(
                            value: _audioVisualAccessibility,
                            onChanged: (bool value) {
                              setState(() {
                                _audioVisualAccessibility = value;
                                _saveAccessibilityPreference(value);
                                _showSnackBar('Modo accesibilidad ${value ? "activado" : "desactivado"}.');
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
                              _showSnackBar('Modo accesibilidad ${ _audioVisualAccessibility ? "activado" : "desactivado"}.');
                            });
                          },
                        ),
                        const SizedBox(height: 25),
                        // --- Opción para Eliminar Cuenta (con advertencia) ---
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 40.0),
                          child: ElevatedButton.icon(
                            icon: const Icon(Icons.delete_forever_outlined, color: Colors.white),
                            label: const Text('Eliminar mi Cuenta', style: TextStyle(fontFamily: 'Comic Sans MS', fontSize: 18, color: Colors.white)),
                            onPressed: () {
                              // TODO: Implementar diálogo de confirmación y lógica de eliminación de cuenta
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: const Text('Eliminar Cuenta'),
                                    content: const Text('¿Estás seguro de que deseas eliminar tu cuenta? Esta acción no se puede deshacer.'),
                                    actions: <Widget>[
                                      TextButton(
                                        child: const Text('Cancelar'),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                      TextButton(
                                        child: Text('Eliminar', style: TextStyle(color: Colors.red.shade700)),
                                        onPressed: () {
                                          Navigator.of(context).pop(); // Cierra el diálogo
                                          _showSnackBar('Función no implementada: Eliminación de cuenta.');
                                          // Aquí iría la lógica para eliminar la cuenta del usuario
                                          // Ejemplo: await widget.authService.deleteCurrentUserAccount();
                                          // Y luego navegar fuera, ej: Navigator.of(context).pushAndRemoveUntil(...)
                                        },
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red.shade600, // Un rojo un poco menos intenso que el de cerrar sesión
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