import 'package:flutter/material.dart';
import 'package:adobe_xd/pinned.dart';
import 'package:adobe_xd/page_link.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cached_network_image/cached_network_image.dart';
// Imports de Navegación
import './Home.dart';
import './ManualdeUso.dart';
import './TratamientodeDatos.dart';
import './SoporteTcnico.dart';
import './PerfilPublico.dart';
import './Configuracion.dart';
import './ListadeAnimales.dart';
import '../services/auth_service.dart';

// --- Clase Ayuda ---
class Ayuda extends StatefulWidget {
  const Ayuda({
    required Key key,
  }) : super(key: key);

  @override
  _AyudaState createState() => _AyudaState();
}

// --- Estado de Ayuda ---
class _AyudaState extends State<Ayuda> {

  // --- Widget Builder para Opciones de Ayuda ---
  Widget _buildHelpOption({
    required Widget leadingWidget, // Cambiado de IconData a Widget
    required String title,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 3.0,
      margin: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 25.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      color: const Color(0xff4ec8dd).withOpacity(0.95),
      child: ListTile(
        leading: leadingWidget, // Usar el widget proporcionado
        title: Text(
          title,
          style: const TextStyle(
            fontFamily: 'Comic Sans MS',
            fontSize: 20,
            color: Color(0xff000000),
            fontWeight: FontWeight.w700,
          ),
          textAlign: TextAlign.center,
        ),
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 16.0),
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
                  pageBuilder: () => Home(key: const Key('Home_From_Ayuda_Logo')),
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
          // --- Botón de Configuración ---
          Pinned.fromPins(
            Pin(size: 47.2, end: 15.0), Pin(size: 50.0, start: 49.0),
            child: PageLink(
              links: [
                PageLinkInfo(
                  transition: LinkTransition.Fade,
                  ease: Curves.easeOut,
                  duration: 0.3,
                  pageBuilder: () => Configuraciones(key: const Key('Settings_From_Ayuda'), authService: AuthService()),
                ),
              ],
              child: Container(
                decoration: const BoxDecoration(
                  image: DecorationImage(image: AssetImage('assets/images/settingsbutton.png'), fit: BoxFit.fill),
                ),
              ),
            ),
          ),
          // --- Contenido Principal de Ayuda ---
          Positioned(
            top: topOffsetForContent,
            left: 0,
            right: 0,
            bottom: 0,
            child: Column(
              children: [
                // --- Título de la Pantalla "Centro de Ayuda" ---
                Padding(
                    padding: const EdgeInsets.only(bottom: 20.0), // Reducido un poco el espacio
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset('assets/images/help.png', width: 35, height: 35), // Ligeramente más pequeño
                        const SizedBox(width: 8),
                        Text(
                          'Centro de Ayuda',
                          style: TextStyle(
                            fontFamily: 'Comic Sans MS',
                            fontSize: 22, // Ligeramente más pequeño
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            shadows: [Shadow(blurRadius: 2.0, color: Colors.black.withOpacity(0.5), offset: Offset(1.0, 1.0))],
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    )
                ),
                // --- Lista de Opciones de Ayuda (Scrollable) ---
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.only(bottom: 20.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start, // Alinear al inicio
                      children: <Widget>[
                        // --- Opciones de Ayuda ---
                        _buildHelpOption(
                          leadingWidget: Icon(Icons.lightbulb_outline, color: Colors.black, size: 30),
                          title: 'Sugerencias',
                          onTap: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Sección de Sugerencias (pendiente)')),
                            );
                          },
                        ),
                        _buildHelpOption(
                          leadingWidget: Icon(Icons.support_agent_outlined, color: Colors.black, size: 30),
                          title: 'Soporte Técnico',
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => SoporteTcnico(key: const Key('SoporteTcnico'))));
                          },
                        ),
                        _buildHelpOption(
                          leadingWidget: Icon(Icons.menu_book_outlined, color: Colors.black, size: 30),
                          title: 'Manual de Uso',
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => ManualdeUso(key: const Key('ManualdeUso'))));
                          },
                        ),
                        _buildHelpOption(
                          leadingWidget: Icon(Icons.privacy_tip_outlined, color: Colors.black, size: 30),
                          title: 'Tratamiento de Datos',
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => TratamientodeDatos(key: const Key('TratamientodeDatos'))));
                          },
                        ),
                        const SizedBox(height: 15), // Separador
                        // --- Opción Mi Perfil con foto del usuario ---
                        if (currentUser != null)
                          _buildHelpOption(
                              leadingWidget: StreamBuilder<DocumentSnapshot>(
                                stream: FirebaseFirestore.instance.collection('users').doc(currentUser.uid).snapshots(),
                                builder: (context, snapshot) {
                                  String? profilePhotoUrl;
                                  if (snapshot.hasData && snapshot.data!.exists) {
                                    final userData = snapshot.data!.data() as Map<String, dynamic>;
                                    profilePhotoUrl = userData['profilePhotoUrl'] as String?;
                                  }
                                  return Container( // Contenedor para la foto, similar al de Config
                                    width: 35, height: 35, // Tamaño del ícono
                                    decoration: BoxDecoration(
                                      color: Colors.grey[200],
                                      borderRadius: BorderRadius.circular(8.0), // Bordes más sutiles
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(7.0),
                                      child: (profilePhotoUrl != null && profilePhotoUrl.isNotEmpty)
                                          ? CachedNetworkImage(imageUrl: profilePhotoUrl, fit: BoxFit.cover,
                                          placeholder: (context, url) => const SizedBox(width:15, height:15, child:CircularProgressIndicator(strokeWidth: 1.5)),
                                          errorWidget: (context, url, error) => Icon(Icons.person, size: 20, color: Colors.grey[600]))
                                          : Icon(Icons.person, size: 20, color: Colors.grey[600]),
                                    ),
                                  );
                                },
                              ),
                              title: 'Mi Perfil',
                              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => PerfilPublico(key: const Key('PerfilPublico_From_Ayuda'))))
                          ),
                        // --- Opción Mis Animales con ícono ---
                        _buildHelpOption(
                            leadingWidget: Padding( // Padding para ajustar el tamaño si es necesario
                              padding: const EdgeInsets.all(2.0), // Pequeño padding alrededor del asset
                              child: Image.asset(
                                'assets/images/listaanimales.png',
                                width: 50, // Tamaño del ícono
                                height: 50,
                                // Opcional: color si tu imagen es un ícono simple que puede ser coloreado
                                // color: Colors.black,
                              ),
                            ),
                            title: 'Mis Animales',
                            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const ListadeAnimales(key: Key('ListadeAnimales_From_Ayuda'))))
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