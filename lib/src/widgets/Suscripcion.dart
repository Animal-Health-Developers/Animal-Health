// --- Suscripcion.dart ---
// Para consistencia, aunque no se use directamente aquí
import 'package:flutter/material.dart';
import 'package:adobe_xd/pinned.dart';
import 'package:adobe_xd/page_link.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart'; // Para abrir URLs (Términos y Privacidad)

// Imports de Navegación (manteniendo los que podrían ser relevantes)
import './Home.dart';
import './Ayuda.dart';
// import './PerfilPublico.dart'; // Probablemente no se necesite desde aquí
// import './ListadeAnimales.dart'; // Probablemente no se necesite desde aquí
// import './PRIVACIDAD.dart'; // Se podría navegar a una pantalla específica o URL
// import './EditarinfodeUsuario.dart'; // No relevante para esta pantalla
// import './VerMetodosdePago.dart'; // Podría ser relevante si se gestiona desde aquí
// import './Idiomas.dart'; // No relevante para esta pantalla
// import './AnimalHealth.dart'; // Para el logo

// --- Clase Suscripcion ---
class Suscripcion extends StatefulWidget {
  const Suscripcion({super.key});
  // Si necesitas AuthService para alguna lógica específica de suscripción, agrégalo
  // final AuthService authService;

  @override
  _SuscripcionState createState() => _SuscripcionState();
}

// --- Estado de Suscripcion ---
class _SuscripcionState extends State<Suscripcion> {
  // --- Variables de Estado ---
  bool _audioVisualAccessibility = false;
  static const String _accessibilityPrefKey = 'audioVisualAccessibilityEnabled';
  String _currentPlan = "Gratuito"; // Placeholder, esto vendría de tu backend/servicio de suscripción
  bool _isPremiumUser = false; // Placeholder

  // --- Ciclo de Vida: initState ---
  @override
  void initState() {
    super.initState();
    _loadAccessibilityPreference();
    _loadSubscriptionStatus(); // Cargar estado actual de la suscripción
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
  // No necesitamos _saveAccessibilityPreference aquí, ya que no cambiamos la preferencia en esta pantalla.

  // --- Método para Cargar Estado de Suscripción (Placeholder) ---
  Future<void> _loadSubscriptionStatus() async {
    // Aquí iría la lógica para verificar el estado de la suscripción del usuario
    // Por ejemplo, consultar Firebase, RevenueCat, etc.
    // Esto es un placeholder:
    await Future.delayed(const Duration(seconds: 1)); // Simular carga
    if (mounted) {
      setState(() {
        // Lógica de ejemplo:
        // _isPremiumUser = true;
        // _currentPlan = "Premium Anual";
        _isPremiumUser = false; // Mantener como gratuito por defecto para el ejemplo
        _currentPlan = _isPremiumUser ? "Premium" : "Gratuito";
      });
    }
  }

  // --- Método para "Actualizar Plan" (Placeholder) ---
  void _handleUpgradePlan() {
    // Aquí iría la lógica para mostrar planes de suscripción,
    // iniciar el flujo de compra con Play Store/App Store, etc.
    print("Navegar a la pantalla de selección de planes o iniciar compra.");
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Mostrando opciones de actualización...')),
    );
    // Ejemplo: Navigator.push(context, MaterialPageRoute(builder: (context) => PurchaseScreen()));
  }

  // --- Método para "Restaurar Compras" (Placeholder) ---
  void _handleRestorePurchases() {
    // Aquí iría la lógica para restaurar compras previas
    // (ej. usando RevenueCat o la API nativa de la plataforma)
    print("Intentando restaurar compras...");
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Intentando restaurar compras... Por favor, espera.')),
    );
    // Lógica de restauración... luego actualizar _isPremiumUser y _currentPlan
  }

  // --- Método para abrir URLs ---
  Future<void> _launchURL(String urlString) async {
    final Uri url = Uri.parse(urlString);
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No se pudo abrir $urlString')),
      );
    }
  }


  // --- Widget Builder para Opciones de Suscripción (adaptado de _buildConfigOption) ---
  Widget _buildSubscriptionItem({
    required IconData icon,
    required String title,
    String? subtitle,
    required VoidCallback onTap,
    Widget? trailing,
    bool isButton = false,
    Color? buttonColor,
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

    if (isButton) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 25.0),
        child: ElevatedButton.icon(
          icon: Icon(icon, color: Colors.white),
          label: Text(
            title,
            style: TextStyle(
              fontFamily: 'Comic Sans MS',
              fontSize: isAccessibilityModeActive ? 20 : 18,
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
          onPressed: onTap,
          style: ElevatedButton.styleFrom(
            backgroundColor: buttonColor ?? (isAccessibilityModeActive ? Colors.yellowAccent.shade700 : Colors.green.shade600),
            padding: const EdgeInsets.symmetric(vertical: 14.0),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
            minimumSize: const Size(double.infinity, 50),
          ),
        ),
      );
    }

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
        subtitle: subtitle != null
            ? Text(
          subtitle,
          style: TextStyle(
            fontFamily: 'Arial',
            fontSize: isAccessibilityModeActive ? 16 : 14,
            color: isAccessibilityModeActive ? Colors.white70 : Colors.black54,
          ),
        )
            : null,
        trailing: trailing ?? (onTap != (){} ? Icon(Icons.arrow_forward_ios, color: isAccessibilityModeActive ? Colors.yellowAccent.withOpacity(0.7) : Colors.grey, size: 18) : null),
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
      backgroundColor: const Color(0xff4ec8dd), // Color de fondo base
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
                  pageBuilder: () => Home(key: const Key('Home_From_Subscription_Logo')),
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
              links: [PageLinkInfo(pageBuilder: () => Ayuda(key: const Key('Ayuda_From_Subscription')))],
              child: Container(decoration: const BoxDecoration(image: DecorationImage(image: AssetImage('assets/images/help.png'), fit: BoxFit.fill))),
            ),
          ),
          // --- Contenido Principal de Suscripción ---
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
                      Icon( // Usando un Icon widget en lugar de Image.asset para flexibilidad
                        Icons.workspace_premium_outlined, // Icono de suscripción/premium
                        size: 35,
                        color: Colors.white,
                        shadows: [Shadow(blurRadius: 2.0, color: Colors.black.withOpacity(0.5), offset: Offset(1.0, 1.0))],
                      ),
                      const SizedBox(width: 10),
                      Text(
                        'Suscripción',
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
                // --- Lista de Opciones de Suscripción (Scrollable) ---
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
                                        style: const TextStyle(fontFamily: 'Comic Sans MS', fontSize: 20, color: Colors.black, fontWeight: FontWeight.bold),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      if (currentUser.email != null)
                                        Text(
                                          currentUser.email!,
                                          style: const TextStyle(fontFamily: 'Arial', fontSize: 14, color: Colors.black87),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        const SizedBox(height: 15),

                        // --- Estado Actual de la Suscripción ---
                        _buildSubscriptionItem(
                          icon: _isPremiumUser ? Icons.star_rounded : Icons.star_border_rounded,
                          title: 'Plan Actual',
                          subtitle: _currentPlan,
                          onTap: () {
                            // Podrías mostrar más detalles del plan actual si se toca
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Actualmente en el plan: $_currentPlan')),
                            );
                          },
                          trailing: _isPremiumUser
                              ? Chip(
                            label: Text('Activo', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                            backgroundColor: Colors.green.shade400,
                            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          )
                              : null,
                        ),

                        // --- Beneficios de Premium (Ejemplo) ---
                        if (!_isPremiumUser)
                          _buildSubscriptionItem(
                            icon: Icons.emoji_events_outlined,
                            title: 'Beneficios Premium',
                            subtitle: 'Acceso ilimitado, sin anuncios, y más.',
                            onTap: () {
                              // Mostrar un dialog/modal con la lista de beneficios
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: const Text('Beneficios Premium'),
                                    content: const SingleChildScrollView(
                                      child: ListBody(
                                        children: <Widget>[
                                          Text('- Acceso a todas las funciones.'),
                                          Text('- Contenido exclusivo.'),
                                          Text('- Sin publicidad.'),
                                          Text('- Soporte prioritario.'),
                                        ],
                                      ),
                                    ),
                                    actions: <Widget>[
                                      TextButton(
                                        child: const Text('Cerrar'),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                          ),

                        // --- Botón de Actualizar a Premium / Gestionar Suscripción ---
                        if (!_isPremiumUser)
                          _buildSubscriptionItem(
                            icon: Icons.upgrade_rounded,
                            title: 'Actualizar a Premium',
                            onTap: _handleUpgradePlan,
                            isButton: true,
                            buttonColor: _audioVisualAccessibility ? Colors.yellowAccent.shade700 : Color(0xff4ec8dd), // Color principal de la app
                          )
                        else
                          _buildSubscriptionItem(
                            icon: Icons.manage_accounts_outlined, // O algún ícono de gestión
                            title: 'Gestionar Suscripción',
                            onTap: () {
                              // Navegar a la pantalla de gestión de suscripción de la tienda (Play Store/App Store)
                              // Esto requiere platform channels o un paquete como `in_app_purchase`
                              print("Abrir gestión de suscripción en la tienda.");
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Abriendo gestión de suscripción...')),
                              );
                            },
                            isButton: true,
                            buttonColor: _audioVisualAccessibility ? Colors.yellowAccent.shade700 : Colors.blueGrey,
                          ),

                        const SizedBox(height: 10),

                        // --- Restaurar Compras ---
                        _buildSubscriptionItem(
                          icon: Icons.restore_page_outlined,
                          title: 'Restaurar Compras',
                          onTap: _handleRestorePurchases,
                        ),

                        // --- Enlaces a Términos y Privacidad ---
                        _buildSubscriptionItem(
                          icon: Icons.description_outlined,
                          title: 'Términos del Servicio',
                          onTap: () => _launchURL('https://www.tusitio.com/terminos'), // Reemplaza con tu URL
                        ),
                        _buildSubscriptionItem(
                          icon: Icons.privacy_tip_outlined,
                          title: 'Política de Privacidad',
                          onTap: () => _launchURL('https://www.tusitio.com/privacidad'), // Reemplaza con tu URL
                        ),

                        const SizedBox(height: 20),
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