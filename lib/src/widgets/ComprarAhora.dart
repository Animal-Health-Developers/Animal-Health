import 'package:animal_health/src/models/products.dart';
import 'package:animal_health/src/services/auth_service.dart';
// Para el botón back
import 'package:flutter/material.dart';
import 'package:adobe_xd/pinned.dart';
import './Home.dart';
import 'package:adobe_xd/page_link.dart';
import './Ayuda.dart';
import './PerfilPublico.dart';
import './DetallesdelProducto.dart';
import './Elejirmetododepagoparacomprar.dart';
import './DirecciondeEnvio.dart';
import './Pedidos.dart';
import './Configuracion.dart';
import './ListadeAnimales.dart';
import './Carritodecompras.dart';
import 'package:cached_network_image/cached_network_image.dart'; // Para mostrar la imagen
import 'package:cloud_firestore/cloud_firestore.dart'; // Para perfil
import 'package:firebase_auth/firebase_auth.dart'; // Para perfil


// Constantes de estilo (puedes definirlas aquí o importarlas si son globales)
const Color APP_PRIMARY_COLOR = Color(0xff4ec8dd);
const Color APP_TEXT_COLOR = Color(0xff000000);
const String APP_FONT_FAMILY = 'Comic Sans MS';

class ComprarAhora extends StatelessWidget {
  final Product product; // Recibe el producto

  const ComprarAhora({
    super.key,
    required this.product, // Hacerlo requerido
  });

  @override
  Widget build(BuildContext context) {
    // Lógica para mostrar la primera imagen o un placeholder
    String? imageUrl = product.images.isNotEmpty ? product.images.first.url : null;

    return Scaffold(
      backgroundColor: APP_PRIMARY_COLOR,
      body: Stack(
        children: <Widget>[
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/Animal Health Fondo de Pantalla.png'),
                fit: BoxFit.cover,
              ),
            ),
            // margin: EdgeInsets.symmetric(horizontal: 0.0, vertical: 0.0), // No es necesario si es el fondo
          ),
          Pinned.fromPins(
            Pin(size: 74.0, middle: 0.5),
            Pin(size: 73.0, start: 42.0),
            child: PageLink(
              links: [
                PageLinkInfo(
                  transition: LinkTransition.Fade,
                  ease: Curves.easeOut,
                  duration: 0.3, // 0.3
                  pageBuilder: () => Home(key: const Key('Home')),
                ),
              ],
              child: Container(
                decoration: BoxDecoration(
                  image: const DecorationImage(
                    image: AssetImage('assets/images/logo.png'),
                    fit: BoxFit.cover,
                  ),
                  borderRadius: BorderRadius.circular(15.0),
                  border:
                  Border.all(width: 1.0, color: const Color(0xff000000)),
                ),
              ),
            ),
          ),
          Pinned.fromPins(
            Pin(size: 52.9, start: 9.1),
            Pin(size: 50.0, start: 49.0),
            child: PageLink(
              links: [
                PageLinkInfo( // Debería navegar a la pantalla anterior, ej. DetallesdelProducto
                  pageBuilder: () => DetallesdelProducto(
                    key: Key('DetallesdelProducto_back_${product.name}'),
                    product: product,
                  ),
                ),
              ],
              child: Container(
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/back.png'),
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
                  duration: 0.3, // 0.3
                  pageBuilder: () => Ayuda(key: const Key('Ayuda')),
                ),
              ],
              child: Container(
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/help.png'),
                    fit: BoxFit.fill,
                  ),
                ),
              ),
            ),
          ),
          Pinned.fromPins(
            Pin(size: 60.0, start: 13.0),
            Pin(size: 60.0, start: 115.0),
            child: StreamBuilder<DocumentSnapshot>( // Para la foto de perfil del usuario actual
              stream: FirebaseFirestore.instance
                  .collection('users')
                  .doc(FirebaseAuth.instance.currentUser?.uid)
                  .snapshots(),
              builder: (context, snapshot) {
                String? profilePhotoUrl;
                if (snapshot.hasData && snapshot.data!.exists) {
                  try {
                    profilePhotoUrl = snapshot.data!.get('profilePhotoUrl') as String?;
                  } catch (e) { profilePhotoUrl = null;}
                }
                return PageLink(
                  links: [
                    PageLinkInfo(
                      transition: LinkTransition.Fade,
                      ease: Curves.easeOut,
                      duration: 0.3, // 0.3
                      pageBuilder: () => PerfilPublico(key: const Key('PerfilPublico')),
                    ),
                  ],
                  child: Container(
                    width: 60.0, height: 60.0,
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(10.0),
                      border: Border.all(color: APP_TEXT_COLOR, width: 0.5),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10.0),
                      child: (profilePhotoUrl != null && profilePhotoUrl.isNotEmpty)
                          ? CachedNetworkImage(
                        imageUrl: profilePhotoUrl, fit: BoxFit.cover,
                        placeholder: (context, url) => const Center(child: CircularProgressIndicator(strokeWidth: 2.0, valueColor: AlwaysStoppedAnimation<Color>(APP_PRIMARY_COLOR))),
                        errorWidget: (context, url, error) => const Icon(Icons.person, size: 40.0, color: Colors.grey),
                      )
                          : const Icon(Icons.person, size: 40.0, color: Colors.grey),
                    ),
                  ),
                );
              },
            ),
          ),
          // Contenedor principal de la información del producto y opciones de compra
          Pinned.fromPins(
            Pin(start: 16.0, end: 16.0), // Márgenes laterales
            Pin(start: 190.0, end: 20.0), // Posición vertical, dejando espacio arriba y abajo
            child: SingleChildScrollView( // Para permitir scroll si el contenido es mucho
              child: Column(
                children: [
                  // Resumen del producto
                  Container(
                    padding: const EdgeInsets.all(12.0),
                    decoration: BoxDecoration(
                        color: const Color(0xe3a0f4fe), // Azul claro semi-transparente
                        borderRadius: BorderRadius.circular(15.0),
                        border: Border.all(width: 1.0, color: const Color(0xe3000000)),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 5,
                              offset: const Offset(0,3)
                          )
                        ]
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        // Imagen del Producto
                        SizedBox(
                          width: 120.0, // Ancho fijo para la imagen
                          height: 120.0, // Alto fijo para la imagen
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12.0),
                            child: imageUrl != null
                                ? CachedNetworkImage(
                              imageUrl: imageUrl,
                              fit: BoxFit.cover,
                              placeholder: (context, url) => Container(color: Colors.grey[300]),
                              errorWidget: (context, url, error) => const Icon(Icons.broken_image, size: 50, color: Colors.grey),
                            )
                                : Container( // Placeholder si no hay imagen
                              color: Colors.grey[300],
                              child: const Icon(Icons.inventory_2_outlined, size: 50, color: Colors.grey),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12.0),
                        // Detalles del Producto (Nombre, Precio, Cantidad)
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween, // Para distribuir el espacio
                            children: <Widget>[
                              Text(
                                product.name,
                                style: const TextStyle(
                                  fontFamily: APP_FONT_FAMILY,
                                  fontSize: 18, // Un poco más pequeño para caber
                                  color: APP_TEXT_COLOR,
                                  fontWeight: FontWeight.w700,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Precio: \$${product.price.toStringAsFixed(2)}',
                                style: TextStyle(
                                  fontFamily: APP_FONT_FAMILY,
                                  fontSize: 16,
                                  color: Colors.green[700],
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const SizedBox(height: 8),
                              // TODO: Añadir selector de cantidad si es necesario
                              const Text(
                                'Cantidad: 1', // Asumiendo 1 por ahora
                                style: TextStyle(
                                  fontFamily: APP_FONT_FAMILY,
                                  fontSize: 16,
                                  color: APP_TEXT_COLOR,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24.0), // Espacio entre secciones

                  // Opciones de Compra
                  _buildOptionButton(
                    context: context,
                    text: 'Elegir Método de Pago',
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Elejirmetododepagoparacomprar(key: const Key('Elejirmetododepagoparacomprar'))),
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  _buildOptionButton(
                    context: context,
                    text: 'Dirección de Envío',
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => DirecciondeEnvio(key: const Key('DirecciondeEnvio'))),
                    ),
                  ),
                  const SizedBox(height: 24.0),

                  // Botón Final de Comprar
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: APP_PRIMARY_COLOR, // Usar color primario
                      padding: const EdgeInsets.symmetric(vertical: 15.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        side: const BorderSide(color: Colors.white70, width: 1.0),
                      ),
                      elevation: 5,
                      shadowColor: const Color(0xff080808),
                    ),
                    onPressed: () {
                      // Lógica para finalizar la compra
                      // Esto podría involucrar validar el método de pago, dirección, etc.
                      // y luego navegar a Pedidos o una pantalla de confirmación.
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Pedidos(key: const Key('Pedidos'))),
                      );
                    },
                    child: const Text(
                      'Comprar',
                      style: TextStyle(
                        fontFamily: APP_FONT_FAMILY,
                        fontSize: 20,
                        color: Colors.white, // Texto blanco para contraste
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Iconos laterales que se mantienen
          Pinned.fromPins(
            Pin(size: 47.2, end: 7.6),
            Pin(size: 50.0, start: 49.0),
            child: PageLink(
              links: [
                PageLinkInfo(
                  transition: LinkTransition.Fade,
                  ease: Curves.easeOut,
                  duration: 0.3, // 0.3
                  pageBuilder: () => Configuraciones(key: const Key('Settings'), authService: AuthService()),
                ),
              ],
              child: Container(
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/settingsbutton.png'),
                    fit: BoxFit.fill,
                  ),
                ),
              ),
            ),
          ),
          Pinned.fromPins(
            Pin(size: 60.1, end: 7.6),
            Pin(size: 60.0, start: 110.0),
            child: PageLink(
              links: [
                PageLinkInfo(
                  transition: LinkTransition.Fade,
                  ease: Curves.easeOut,
                  duration: 0.3, // 0.3
                  pageBuilder: () => ListadeAnimales(key: const Key('ListadeAnimales')),
                ),
              ],
              child: Container(
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/listaanimales.png'),
                    fit: BoxFit.fill,
                  ),
                ),
              ),
            ),
          ),
          Pinned.fromPins(
            Pin(size: 47.2, middle: 0.6987),
            Pin(size: 50.0, start: 49.0),
            child: PageLink(
              links: [
                PageLinkInfo(
                  transition: LinkTransition.Fade,
                  ease: Curves.easeOut,
                  duration: 0.3, // 0.3
                  pageBuilder: () => Carritodecompras(key: const Key('Carritodecompras')),
                ),
              ],
              child: Container(
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/carrito.png'),
                    fit: BoxFit.fill,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Helper widget para los botones de opción
  Widget _buildOptionButton({
    required BuildContext context,
    required String text,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: double.infinity, // Para que ocupe el ancho
        padding: const EdgeInsets.symmetric(vertical: 15.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10.0),
          border: Border.all(width: 1.0, color: const Color(0xff707070)),
          boxShadow: [
            BoxShadow(
              color: const Color(0xff51b5e0).withOpacity(0.7),
              offset: const Offset(0, 3),
              blurRadius: 6,
            ),
          ],
        ),
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontFamily: APP_FONT_FAMILY,
            fontSize: 20,
            color: APP_TEXT_COLOR,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}