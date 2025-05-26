import 'package:flutter/material.dart';
import 'package:adobe_xd/pinned.dart';
import 'package:adobe_xd/page_link.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:developer' as developer;

import './Home.dart';
import './Ayuda.dart';
import './Configuracion.dart';
import './DetallesdelProducto.dart';
import './Elejirmetododepagoparacomprar.dart';
import './DirecciondeEnvio.dart';
import './Pedidos.dart';
// Asegúrate que estas importaciones sean correctas
import '../services/auth_service.dart';
import '../services/cart_service.dart'; // Importa el servicio del carrito
import '../models/products.dart'; // Importa tu modelo Product

// Constantes de estilo (puedes moverlas a un archivo común si las usas en múltiples lugares)
const Color APP_PRIMARY_COLOR = Color(0xff4ec8dd);
const Color APP_TEXT_COLOR = Color(0xff000000); // Color de texto negro
const Color LIGHT_BLUE_CONTAINER_COLOR = Color(0xe3a0f4fe); // Color del contenedor del título y items
const String APP_FONT_FAMILY = 'Comic Sans MS';

class Carritodecompras extends StatefulWidget {
  const Carritodecompras({
    required Key key,
  }) : super(key: key);

  @override
  _CarritodecomprasState createState() => _CarritodecomprasState();
}

class _CarritodecomprasState extends State<Carritodecompras> {
  final CartService _cartService = CartService();

  @override
  void initState() {
    super.initState();
    _cartService.addListener(_onCartChanged);
  }

  @override
  void dispose() {
    _cartService.removeListener(_onCartChanged);
    super.dispose();
  }

  void _onCartChanged() {
    if (mounted) {
      setState(() {});
    }
  }

  // ---------- MODIFICACIÓN AQUÍ PARA LA FOTO DE PERFIL DE FIREBASE AUTH ----------
  Widget _buildProfilePicture(BuildContext context) {
    final User? currentUser = FirebaseAuth.instance.currentUser; // Obtener el usuario actual
    String? firebaseAuthPhotoUrl = currentUser?.photoURL; // Obtener la photoURL del usuario de Firebase Auth

    return Container(
      width: 60.0,
      height: 60.0,
      decoration: BoxDecoration(
        color: Colors.grey[200], // Fondo mientras carga o si no hay imagen
        borderRadius: BorderRadius.circular(10.0),
        border: Border.all(color: APP_TEXT_COLOR, width: 0.5),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10.0),
        child: (firebaseAuthPhotoUrl != null && firebaseAuthPhotoUrl.isNotEmpty)
            ? CachedNetworkImage(
            imageUrl: firebaseAuthPhotoUrl, // Usar la photoURL de Firebase Auth
            fit: BoxFit.cover,
            placeholder: (context, url) => const Center(
              child: CircularProgressIndicator(
                strokeWidth: 2.0,
                valueColor: AlwaysStoppedAnimation<Color>(APP_PRIMARY_COLOR),
              ),
            ),
            errorWidget: (context, url, error) {
              developer.log("Error cargando foto de Firebase Auth: $error. URL: $firebaseAuthPhotoUrl");
              return const Icon( // Fallback si hay error cargando la imagen
                Icons.person,
                size: 40.0,
                color: Colors.grey,
              );
            }
        )
            : const Icon( // Fallback si no hay photoURL en Firebase Auth o currentUser es null
          Icons.person,
          size: 40.0,
          color: Colors.grey,
        ),
      ),
    );
  }
  // ---------- FIN DE LA MODIFICACIÓN ----------


  // Widget auxiliar para los botones de cantidad estilizados
  Widget _buildStyledQuantityButton({
    required IconData icon,
    required VoidCallback onPressed,
    double buttonSize = 30.0, // Diámetro del botón
    double iconSize = 18.0,   // Tamaño del ícono
  }) {
    return Container(
      width: buttonSize,
      height: buttonSize,
      decoration: BoxDecoration(
        color: Colors.white, // Fondo blanco
        shape: BoxShape.circle, // Forma circular
        boxShadow: [ // Sombra sutil para un look moderno
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Material( // Material para el InkWell y el efecto ripple
        color: Colors.transparent,
        child: InkWell(
          customBorder: const CircleBorder(),
          onTap: onPressed,
          child: Icon(
            icon,
            size: iconSize,
            color: APP_PRIMARY_COLOR, // Color del ícono
          ),
        ),
      ),
    );
  }

  Widget _buildCartItem(BuildContext context, CartItem cartItem) {
    Product product = cartItem.product;
    String? imageUrl = product.images.isNotEmpty ? product.images.first.url : null;

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      color: LIGHT_BLUE_CONTAINER_COLOR,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(9.0),
        side: const BorderSide(width: 1.0, color: Color(0xe3000000)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DetallesdelProducto(
                      key: Key('DetallesdelProducto_cart_${product.id}'),
                      product: product,
                    ),
                  ),
                );
              },
              child: SizedBox(
                width: 80,
                height: 80,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: imageUrl != null && imageUrl.isNotEmpty
                      ? CachedNetworkImage(
                    imageUrl: imageUrl,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Container(
                      color: Colors.grey[200],
                      child: const Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(APP_PRIMARY_COLOR))),
                    ),
                    errorWidget: (context, url, error) => Container(
                      color: Colors.grey[300],
                      child: const Icon(Icons.broken_image, size: 40, color: Colors.grey),
                    ),
                  )
                      : Container(
                    color: Colors.grey[300],
                    child: const Icon(Icons.inventory_2_outlined, size: 40, color: Colors.grey),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    product.name,
                    style: const TextStyle(fontFamily: APP_FONT_FAMILY, fontSize: 17, fontWeight: FontWeight.w700, color: APP_TEXT_COLOR),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 5),
                  Text(
                    'Precio: \$${product.price.toStringAsFixed(2)}',
                    style: TextStyle(fontFamily: APP_FONT_FAMILY, fontSize: 15, color: Colors.green[700], fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text('Cantidad:', style: TextStyle(fontFamily: APP_FONT_FAMILY, fontSize: 14, color: APP_TEXT_COLOR)),
                      const SizedBox(width: 8),
                      _buildStyledQuantityButton(
                        icon: Icons.remove,
                        onPressed: () => _cartService.decrementQuantity(product),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: Text(
                          '${cartItem.quantity}',
                          style: const TextStyle(fontFamily: APP_FONT_FAMILY, fontSize: 17, fontWeight: FontWeight.bold, color: APP_TEXT_COLOR),
                        ),
                      ),
                      _buildStyledQuantityButton(
                        icon: Icons.add,
                        onPressed: () => _cartService.incrementQuantity(product),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            IconButton(
              iconSize: 55.0,
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(minWidth: 44, minHeight: 44),
              icon: Image.asset(
                'assets/images/eliminar.png',
                height: 55.0,
                fit: BoxFit.contain,
              ),
              onPressed: () => _cartService.removeFromCart(product),
              tooltip: 'Eliminar producto',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton(BuildContext context, String text, Widget Function() pageBuilder) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: APP_TEXT_COLOR,
          padding: const EdgeInsets.symmetric(vertical: 12.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
            side: const BorderSide(width: 1.0, color: Color(0xff707070)),
          ),
          elevation: 3,
        ),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => pageBuilder()),
          );
        },
        child: Text(
          text,
          style: const TextStyle(fontFamily: APP_FONT_FAMILY, fontSize: 18, fontWeight: FontWeight.w700),
        ),
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    final double topIconsBottomY = 49.0 + 50.0;
    final double profilePicMarginFromTopIcons = 15.0;
    final double profilePicTopPosition = topIconsBottomY + profilePicMarginFromTopIcons;
    final double profilePicHeight = 60.0;
    final double titleMarginFromProfilePic = 10.0;
    final double mainContentStartOffset = profilePicTopPosition + profilePicHeight + titleMarginFromProfilePic + 40.0;


    return Scaffold(
      backgroundColor: APP_PRIMARY_COLOR,
      body: Stack(
        children: <Widget>[
          // Fondo de pantalla
          Positioned.fill(
            child: Image.asset(
              'assets/images/Animal Health Fondo de Pantalla.png',
              fit: BoxFit.cover,
            ),
          ),

          // --- Iconos Superiores (sin cambios) ---
          Pinned.fromPins(
            Pin(size: 52.9, start: 9.1),
            Pin(size: 50.0, start: 49.0),
            child: InkWell(
              onTap: () => Navigator.pop(context),
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
            Pin(size: 74.0, middle: 0.5),
            Pin(size: 73.0, start: 42.0),
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
                decoration: BoxDecoration(
                  image: const DecorationImage(
                    image: AssetImage('assets/images/logo.png'),
                    fit: BoxFit.cover,
                  ),
                  borderRadius: BorderRadius.circular(15.0),
                  border: Border.all(width: 1.0, color: const Color(0xff000000)),
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
                  duration: 0.3,
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
            Pin(size: 47.2, end: 7.6),
            Pin(size: 50.0, start: 49.0),
            child: PageLink(
              links: [
                PageLinkInfo(
                  transition: LinkTransition.Fade,
                  ease: Curves.easeOut,
                  duration: 0.3,
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

          // Contenedor para Foto de perfil y Título
          Positioned(
            top: 130,
            left: 20.0,
            right: 20.0,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildProfilePicture(context), // Widget de foto de perfil modificado
                const SizedBox(width: 15.0),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 12.0),
                    decoration: BoxDecoration(
                      color: LIGHT_BLUE_CONTAINER_COLOR,
                      borderRadius: BorderRadius.circular(10.0),
                      border: Border.all(color: APP_TEXT_COLOR.withOpacity(0.5), width: 1.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          spreadRadius: 1,
                          blurRadius: 3,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: const Text(
                      'Carrito de Compras',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: APP_FONT_FAMILY,
                        fontSize: 18,
                        color: APP_TEXT_COLOR,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Contenido principal del carrito (Lista, Total, Botones)
          Padding(
            padding: EdgeInsets.only(
              top: mainContentStartOffset,
              left: 20.0,
              right: 20.0,
              bottom: 20.0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                // Lista de productos en el carrito
                Expanded(
                  child: _cartService.items.isEmpty
                      ? Center(
                    child: Text(
                      'Tu carrito está vacío.',
                      style: TextStyle(
                          fontFamily: APP_FONT_FAMILY,
                          fontSize: 18,
                          color: Colors.white.withOpacity(0.9)),
                    ),
                  )
                      : ListView.builder(
                    padding: EdgeInsets.zero,
                    itemCount: _cartService.items.length,
                    itemBuilder: (context, index) {
                      final cartItem = _cartService.items[index];
                      return _buildCartItem(context, cartItem);
                    },
                  ),
                ),

                // Total en un recuadro
                if (_cartService.items.isNotEmpty)
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 15.0),
                    padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0),
                    decoration: BoxDecoration(
                      color: LIGHT_BLUE_CONTAINER_COLOR,
                      borderRadius: BorderRadius.circular(10.0),
                      border: Border.all(color: APP_TEXT_COLOR.withOpacity(0.5), width: 1.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          spreadRadius: 1,
                          blurRadius: 3,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Total:',
                          style: TextStyle(
                            fontFamily: APP_FONT_FAMILY,
                            fontSize: 20,
                            color: APP_TEXT_COLOR,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          '\$${_cartService.totalPrice.toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontFamily: APP_FONT_FAMILY,
                            fontSize: 20,
                            color: APP_TEXT_COLOR,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),

                // Botones de acción
                if (_cartService.items.isNotEmpty) ...[
                  _buildActionButton(context, 'Elegir Método de Pago', () => Elejirmetododepagoparacomprar(key: ObjectKey(Object()))),
                  const SizedBox(height: 10),
                  _buildActionButton(context, 'Dirección de Envío', () => DirecciondeEnvio(key: ObjectKey(Object()))),
                  const SizedBox(height: 10),
                  _buildActionButton(context, 'Comprar Ahora', () => Pedidos(key: ObjectKey(Object()))),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}