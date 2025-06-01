import 'package:flutter/material.dart';
import 'package:adobe_xd/pinned.dart';
import 'package:adobe_xd/page_link.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:developer' as developer;
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:typed_data';

import './Ayuda.dart';
import './PerfilPublico.dart';
import './Configuracion.dart';
import './ListadeAnimales.dart';
import './VenderProductos.dart';
import './Carritodecompras.dart';
import './DetallesdelProducto.dart';
import './Home.dart';
import '../services/auth_service.dart';
import '../models/products.dart'; // Asegúrate que Product y ProductImage están aquí
import '../services/cart_service.dart';

const Color APP_PRIMARY_COLOR = Color(0xff4ec8dd);
const Color APP_TEXT_COLOR = Color(0xff000000);
const String APP_FONT_FAMILY = 'Comic Sans MS';


class CompradeProductos extends StatefulWidget {
  const CompradeProductos({
    Key? key,
  }) : super(key: key);

  @override
  _CompradeProductosState createState() => _CompradeProductosState();
}

class _CompradeProductosState extends State<CompradeProductos> {
  final TextEditingController _searchController = TextEditingController();
  String _currentInputText = '';

  final ValueNotifier<String> _searchTermNotifier = ValueNotifier<String>('');

  bool _isSearching = false;

  final CartService _cartService = CartService();

  late final Stream<QuerySnapshot<Map<String, dynamic>>> _productsStream;


  /// Inicializa el estado del widget, configurando el stream de productos y los listeners del controlador de búsqueda.
  @override
  void initState() {
    super.initState();
    developer.log('CompradeProductos initState: Initializing _productsStream');
    _productsStream = FirebaseFirestore.instance.collection('products').orderBy('creationDate', descending: true).snapshots();

    _searchController.addListener(_onSearchInputChanged);
    _currentInputText = _searchController.text;
  }

  /// Callback que se ejecuta cuando el texto del campo de búsqueda cambia, actualizando la variable local.
  void _onSearchInputChanged() {
    if (mounted) {
      setState(() {
        _currentInputText = _searchController.text;
      });
    }
  }

  /// Realiza la acción de búsqueda de productos, ocultando el teclado y actualizando el término de búsqueda.
  void _performSearch() async {
    developer.log('CompradeProductos _performSearch: Starting search for: "${_searchController.text.trim()}"');
    FocusScope.of(context).unfocus(); // Ocultar el teclado

    if (mounted) {
      setState(() {
        _isSearching = true;
      });
    }

    // Pequeño retraso para que la animación de carga sea visible.
    await Future.delayed(const Duration(milliseconds: 500));

    if (mounted) {
      _searchTermNotifier.value = _searchController.text.trim();
      setState(() {
        _isSearching = false;
        developer.log("CompradeProductos _performSearch: Search completed. Current term: \"${_searchTermNotifier.value}\"");
      });
    }
  }

  /// Limpia el campo de búsqueda y vuelve a realizar la búsqueda (mostrando todos los productos).
  void _clearSearch() {
    developer.log('CompradeProductos _clearSearch: Clearing search bar');
    _searchController.clear();
    _performSearch();
  }

  /// Libera los controladores y notifiers cuando el widget es desechado.
  @override
  void dispose() {
    developer.log('CompradeProductos dispose: Disposing controllers and notifiers');
    _searchController.removeListener(_onSearchInputChanged);
    _searchController.dispose();
    _searchTermNotifier.dispose();
    super.dispose();
  }

  /// Muestra un modal (bottom sheet) con la lista de productos publicados por el usuario actual.
  Future<void> _mostrarModalMisProductos() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Debes iniciar sesión para ver tus productos.', style: TextStyle(fontFamily: APP_FONT_FAMILY))),
        );
      }
      return;
    }
    developer.log('Mostrando modal Mis Productos para UID: ${currentUser.uid}');

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext modalBuildContext) {
        return _MisProductosModalWidget(
          key: Key('mis_productos_modal_${currentUser.uid}'),
          userId: currentUser.uid,
          parentContextForSnackbars: context,
        );
      },
    );
  }

  /// Muestra un modal (bottom sheet) para editar un producto específico.
  /// Verifica si el usuario actual es el propietario del producto antes de permitir la edición.
  Future<void> _mostrarModalEditarProducto(Product product, BuildContext cardContext) async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null || currentUser.uid != product.userId) {
      if (cardContext.mounted) {
        ScaffoldMessenger.of(cardContext).showSnackBar(
          const SnackBar(content: Text('No tienes permiso para editar este producto.', style: TextStyle(fontFamily: APP_FONT_FAMILY)), backgroundColor: Colors.red),
        );
      }
      return;
    }
    await showModalBottomSheet(
      context: cardContext,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext modalBuildContext) {
        return _EditarProductoModalWidget(
          key: Key('edit_product_modal_main_${product.id}'),
          productToEdit: product,
          parentContextForSnackbars: cardContext,
        );
      },
    );
  }

  /// Constructor de widget para una tarjeta individual de producto en la cuadrícula principal.
  /// Incluye lógica para mostrar opciones de edición/eliminación si el usuario es el propietario.
  ///
  /// Parámetros:
  /// - `context`: El BuildContext actual.
  /// - `product`: El objeto Product a mostrar en la tarjeta.
  Widget _buildProductCard(BuildContext context, Product product) {
    String? imageUrl = product.images.isNotEmpty ? product.images.first.url : null;
    final currentUser = FirebaseAuth.instance.currentUser;
    final bool isOwner = currentUser != null && product.userId.isNotEmpty && product.userId == currentUser.uid;

    /// Función interna para eliminar un producto de la base de datos y Storage.
    /// Muestra un diálogo de confirmación antes de proceder con la eliminación.
    Future<void> _deleteProduct(String productId, String productName) async {
      bool? confirmDelete = await showDialog<bool>(
        context: context,
        builder: (BuildContext dialogContext) {
          return AlertDialog(
            backgroundColor: const Color(0xe3a0f4fe),
            title: const Text('Confirmar Eliminación', style: TextStyle(fontFamily: APP_FONT_FAMILY, color: APP_TEXT_COLOR)),
            content: Text('¿Estás seguro de que quieres eliminar "$productName"? Esta acción no se puede deshacer.', style: const TextStyle(fontFamily: APP_FONT_FAMILY, color: APP_TEXT_COLOR)),
            actions: <Widget>[
              TextButton(
                child: const Text('Cancelar', style: TextStyle(fontFamily: APP_FONT_FAMILY, color: Colors.grey)),
                onPressed: () {
                  Navigator.of(dialogContext).pop(false);
                },
              ),
              TextButton(
                style: TextButton.styleFrom(foregroundColor: Colors.red),
                child: const Text('Eliminar', style: TextStyle(fontFamily: APP_FONT_FAMILY)),
                onPressed: () {
                  Navigator.of(dialogContext).pop(true);
                },
              ),
            ],
          );
        },
      );

      if (confirmDelete == true) {
        try {
          DocumentSnapshot productDoc = await FirebaseFirestore.instance.collection('products').doc(productId).get();
          if (productDoc.exists) {
            final productDataForDelete = Product.fromFirestore(productDoc.data() as Map<String, dynamic>, productDoc.id);
            for (var imageInfo in productDataForDelete.images) {
              if (imageInfo.url.startsWith('https://firebasestorage.googleapis.com')) {
                try {
                  await FirebaseStorage.instance.refFromURL(imageInfo.url).delete();
                  developer.log('Imagen de Storage eliminada: ${imageInfo.url}');
                } catch (e) {
                  developer.log('Error eliminando imagen de storage: ${imageInfo.url}, error: $e');
                }
              }
            }
          }

          await FirebaseFirestore.instance.collection('products').doc(productId).delete();
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Producto eliminado correctamente.', style: TextStyle(fontFamily: APP_FONT_FAMILY)), backgroundColor: Colors.green),
            );
          }
        } catch (e) {
          developer.log('Error al eliminar producto: $e');
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Error al eliminar el producto: $e', style: const TextStyle(fontFamily: APP_FONT_FAMILY)), backgroundColor: Colors.red),
            );
          }
        }
      }
    }

    return Card(
      elevation: 3.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      margin: const EdgeInsets.all(8.0),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DetallesdelProducto(
                key: Key('DetallesdelProducto_${product.id}'),
                product: product,
              ),
            ),
          );
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Expanded(
              flex: 3,
              child: Stack(
                children: [
                  Positioned.fill(
                    child: ClipRRect(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(15.0),
                        topRight: Radius.circular(15.0),
                      ),
                      child: imageUrl != null && imageUrl.isNotEmpty
                          ? CachedNetworkImage(
                        imageUrl: imageUrl,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => Container(
                          color: Colors.grey[200],
                          child: const Center(
                              child: CircularProgressIndicator(
                                valueColor:
                                AlwaysStoppedAnimation<Color>(APP_PRIMARY_COLOR),
                              )),
                        ),
                        errorWidget: (context, url, error) => Container(
                          color: Colors.grey[300],
                          child: const Icon(Icons.broken_image,
                              size: 40, color: Colors.grey),
                        ),
                      )
                          : Container(
                        color: Colors.grey[300],
                        child: const Icon(Icons.inventory_2_outlined,
                            size: 40, color: Colors.grey),
                      ),
                    ),
                  ),
                  if (isOwner)
                    Positioned(
                      top: 0,
                      right: 0,
                      child: Material(
                        color: Colors.transparent,
                        child: PopupMenuButton<String>(
                          icon: Icon(Icons.more_vert, color: Colors.white, shadows: [Shadow(color: Colors.black.withOpacity(0.7), blurRadius: 2)]),
                          color: const Color(0xffa0f4fe).withOpacity(0.95),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          onSelected: (String value) {
                            if (value == 'editar_card') {
                              _mostrarModalEditarProducto(product, context);
                            } else if (value == 'eliminar_card') {
                              _deleteProduct(product.id, product.name);
                            }
                          },
                          itemBuilder: (BuildContext popupContext) => <PopupMenuEntry<String>>[
                            const PopupMenuItem<String>(
                              value: 'editar_card',
                              child: Row(
                                children: [
                                  Icon(Icons.edit_outlined, color: APP_TEXT_COLOR, size: 20),
                                  SizedBox(width: 8),
                                  Text('Editar', style: TextStyle(fontFamily: APP_FONT_FAMILY, color: APP_TEXT_COLOR)),
                                ],
                              ),
                            ),
                            const PopupMenuItem<String>(
                              value: 'eliminar_card',
                              child: Row(
                                children: [
                                  Icon(Icons.delete_forever, color: Colors.red, size: 20),
                                  SizedBox(width: 8),
                                  Text('Eliminar', style: TextStyle(fontFamily: APP_FONT_FAMILY, color: Colors.red)),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(
                    product.name,
                    style: const TextStyle(
                      fontFamily: APP_FONT_FAMILY,
                      fontSize: 16,
                      color: APP_TEXT_COLOR,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2.0),
                  Text(
                    '\$${product.price.toStringAsFixed(2)}',
                    style: TextStyle(
                      fontFamily: APP_FONT_FAMILY,
                      fontSize: 17,
                      color: Colors.green[700],
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(8.0, 0, 8.0, 8.0),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: APP_PRIMARY_COLOR,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                ),
                onPressed: () {
                  _cartService.addToCart(product);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('${product.name} agregado al carrito', style: const TextStyle(fontFamily: APP_FONT_FAMILY)),
                      duration: const Duration(seconds: 2),
                      action: SnackBarAction(
                        label: 'VER CARRITO',
                        textColor: Colors.white,
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => Carritodecompras(key: const Key('CarritoDesdeCompraProductosCardV4'))),
                          );
                        },
                      ),
                    ),
                  );
                },
                child: SizedBox(
                  height: 30.0,
                  child: Center(
                    child: Image.asset(
                      'assets/images/carrito.png',
                      height: 22.0,
                      width: 22.0,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Construye la interfaz de usuario principal de la pantalla de compra de productos.
  /// Contiene la barra de búsqueda, iconos de navegación y la cuadrícula de productos.
  @override
  Widget build(BuildContext context) {
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
          ),
          Pinned.fromPins(
            Pin(size: 52.9, start: 9.1),
            Pin(size: 50.0, start: 49.0),
            child: PageLink(
              links: [
                PageLinkInfo(
                  pageBuilder: () => Home(key: const Key("HomeFromCompraProductosV4")),
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
            Pin(size: 74.0, middle: 0.5),
            Pin(size: 73.0, start: 42.0),
            child: PageLink(
              links: [
                PageLinkInfo(
                  transition: LinkTransition.Fade,
                  ease: Curves.easeOut,
                  duration: 0.3,
                  pageBuilder: () => Home(key: const Key('HomeLogoFromCompraProductosV4')),
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
            Pin(size: 47.2, middle: 0.6987),
            Pin(size: 50.0, start: 49.0),
            child: PageLink(
              links: [
                PageLinkInfo(
                  transition: LinkTransition.Fade,
                  ease: Curves.easeOut,
                  duration: 0.3,
                  pageBuilder: () => Carritodecompras(key: const Key('CarritoIconFromCompraProductosV4')),
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
          Pinned.fromPins(
            Pin(size: 40.5, middle: 0.8328),
            Pin(size: 50.0, start: 49.0),
            child: PageLink(
              links: [
                PageLinkInfo(
                  transition: LinkTransition.Fade,
                  ease: Curves.easeOut,
                  duration: 0.3,
                  pageBuilder: () => Ayuda(key: const Key('AyudaFromCompraProductosV4')),
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
                  pageBuilder: () => Configuraciones(key: const Key('SettingsFromCompraProductosV4'), authService: AuthService()),
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
            Pin(size: 60.0, start: 13.0),
            Pin(size: 60.0, start: 115.0),
            child: StreamBuilder<DocumentSnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('users')
                  .doc(FirebaseAuth.instance.currentUser?.uid)
                  .snapshots(),
              builder: (context, snapshot) {
                String? profilePhotoUrl;
                final currentUserAuth = FirebaseAuth.instance.currentUser;
                if (currentUserAuth?.photoURL != null && currentUserAuth!.photoURL!.isNotEmpty) {
                  profilePhotoUrl = currentUserAuth.photoURL;
                } else if (snapshot.hasData && snapshot.data!.exists) {
                  try {
                    final userData = snapshot.data!.data() as Map<String, dynamic>?;
                    profilePhotoUrl = userData?['profilePhotoUrl'] as String?;
                  } catch (e) {
                    developer.log("Error al obtener profilePhotoUrl: $e");
                    profilePhotoUrl = null;
                  }
                }

                return PageLink(
                  links: [
                    PageLinkInfo(
                      transition: LinkTransition.Fade,
                      ease: Curves.easeOut,
                      duration: 0.3,
                      pageBuilder: () => PerfilPublico(key: const Key('PerfilPublicoFromCompraProductosV4')),
                    ),
                  ],
                  child: Container(
                    width: 60.0,
                    height: 60.0,
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(10.0),
                      border: Border.all(color: APP_TEXT_COLOR, width: 0.5),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10.0),
                      child: (profilePhotoUrl != null && profilePhotoUrl.isNotEmpty)
                          ? CachedNetworkImage(
                        imageUrl: profilePhotoUrl,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => const Center(
                          child: CircularProgressIndicator(
                            strokeWidth: 2.0,
                            valueColor: AlwaysStoppedAnimation<Color>(APP_PRIMARY_COLOR),
                          ),
                        ),
                        errorWidget: (context, url, error) => const Icon(
                          Icons.person,
                          size: 40.0,
                          color: Colors.grey,
                        ),
                      )
                          : const Icon(
                        Icons.person,
                        size: 40.0,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Pinned.fromPins(
            Pin(middle: 0.5, size: 280.0),
            Pin(size: 45.0, start: 148.0),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(5.0),
                border: Border.all(width: 1.0, color: const Color(0xff707070)),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 12.0),
                      child: TextField(
                        controller: _searchController,
                        textAlignVertical: TextAlignVertical.center,
                        style: const TextStyle(
                          fontFamily: APP_FONT_FAMILY,
                          fontSize: 18,
                          color: APP_TEXT_COLOR,
                          fontWeight: FontWeight.w700,
                        ),
                        decoration: const InputDecoration(
                          hintText: '¿Qué Producto Buscas?',
                          hintStyle: TextStyle(
                            fontFamily: APP_FONT_FAMILY,
                            fontSize: 18,
                            color: Color(0xffa9a9a9),
                            fontWeight: FontWeight.w700,
                          ),
                          border: InputBorder.none,
                          isDense: true,
                          // Ajuste aquí para el padding interno del TextField
                          contentPadding: EdgeInsets.symmetric(horizontal: 0, vertical: 8.0),
                        ),
                        textInputAction: TextInputAction.search,
                        onSubmitted: (value) {
                          _performSearch();
                        },
                      ),
                    ),
                  ),
                  if (_currentInputText.isNotEmpty)
                    IconButton(
                      icon: Icon(Icons.clear, color: Colors.grey[600], size: 22),
                      onPressed: _clearSearch,
                      tooltip: 'Limpiar búsqueda',
                      padding: const EdgeInsets.symmetric(horizontal: 4.0),
                      constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
                      splashRadius: 20,
                    ),
                  GestureDetector(
                    onTap: _performSearch,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 8.0, left: 6.0),
                      child: Image.asset(
                        'assets/images/busqueda1.png',
                        width: 31.0,
                        height: 31.0,
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                ],
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
                  duration: 0.3,
                  pageBuilder: () => ListadeAnimales(key: const Key('ListadeAnimalesFromCompraProductosV4')),
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
            Pin(size: 65.0, end: 7.6),
            Pin(size: 60.0, start: 198.0),
            child: PageLink(
              links: [
                PageLinkInfo(
                  transition: LinkTransition.Fade,
                  ease: Curves.easeOut,
                  duration: 0.3,
                  pageBuilder: () => VenderProductos(key: const Key('VenderProductosDesdeCompraV4')),
                ),
              ],
              child: Container(
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/vender.png'),
                    fit: BoxFit.fill,
                  ),
                ),
              ),
            ),
          ),
          Pinned.fromPins(
            Pin(size: 60.0, end: 7.6 + 65.0 + 10.0),
            Pin(size: 55.0, start: 200.5),
            child: GestureDetector(
              onTap: _mostrarModalMisProductos,
              child: Container(
                padding: const EdgeInsets.all(4.0),
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/misproductos.png'),
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
          ),
          Pinned.fromPins(
            Pin(start: 8.0, end: 8.0),
            Pin(start: 270.0, end: 0.0),
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 500),
              transitionBuilder: (Widget child, Animation<double> animation) {
                return FadeTransition(
                  opacity: animation,
                  child: SlideTransition(
                    position: Tween<Offset>(
                      begin: const Offset(0, 0.05),
                      end: Offset.zero,
                    ).animate(animation),
                    child: child,
                  ),
                );
              },
              child: _isSearching
                  ? Container(
                key: const ValueKey<String>('loading_products_state'),
                child: const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.white)),
                      SizedBox(height: 16),
                      Text('Buscando productos...', style: TextStyle(color: Colors.white, fontFamily: APP_FONT_FAMILY, fontSize: 16)),
                    ],
                  ),
                ),
              )
                  : ValueListenableBuilder<String>(
                valueListenable: _searchTermNotifier,
                builder: (context, currentSearchTerm, child) {
                  developer.log('ValueListenableBuilder: Filtering with term: "$currentSearchTerm"');

                  return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                    key: ValueKey<String>('product_grid_for_term_${currentSearchTerm.isEmpty ? 'all' : currentSearchTerm}'),
                    stream: _productsStream,
                    builder: (context, snapshot) {
                      developer.log('StreamBuilder: Connection state: ${snapshot.connectionState}, hasData: ${snapshot.hasData}, hasError: ${snapshot.hasError}');

                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.white)));
                      }
                      if (snapshot.hasError) {
                        developer.log('StreamBuilder Error: ${snapshot.error} ${snapshot.stackTrace}');
                        return const Center(
                            child: Text('Error al cargar productos. Por favor, revisa tu conexión a internet.',
                                textAlign: TextAlign.center,
                                style: TextStyle(color: Colors.white, fontFamily: APP_FONT_FAMILY)));
                      }
                      if (!snapshot.hasData || snapshot.data == null || snapshot.data!.docs.isEmpty) {
                        return const Center(
                            child: Text('No hay productos disponibles en la base de datos.',
                                style: TextStyle(color: Colors.white, fontFamily: APP_FONT_FAMILY)));
                      }

                      final allProducts = snapshot.data!.docs.map((doc) {
                        try {
                          final data = doc.data();
                          final id = doc.id;
                          return Product.fromFirestore(data, id);
                        } catch (e, s) {
                          developer.log('ERROR al parsear producto ${doc.id}: $e\nStackTrace: $s\nDatos: ${doc.data()}');
                          return null;
                        }
                      }).whereType<Product>().toList();

                      developer.log('StreamBuilder: Total products fetched: ${allProducts.length}');

                      // Si después de parsear, la lista de productos está vacía, puede que todos hayan fallado en el parseo
                      if (allProducts.isEmpty) {
                        return const Center(
                            child: Text('No se pudieron cargar productos válidos de la base de datos. Por favor, revisa tus datos.',
                                textAlign: TextAlign.center,
                                style: TextStyle(color: Colors.white, fontFamily: APP_FONT_FAMILY)));
                      }


                      final filteredProducts = currentSearchTerm.isEmpty
                          ? allProducts
                          : allProducts.where((product) {
                        final searchTermLower = currentSearchTerm.toLowerCase();
                        final nameLower = (product.name).toLowerCase();
                        final descriptionLower = (product.description).toLowerCase();
                        final categoryLower = (product.category).toLowerCase();
                        final sellerLower = (product.seller).toLowerCase();

                        return nameLower.contains(searchTermLower) ||
                            descriptionLower.contains(searchTermLower) ||
                            categoryLower.contains(searchTermLower) ||
                            sellerLower.contains(searchTermLower);
                      }).toList();

                      developer.log('StreamBuilder: Filtered products count for "$currentSearchTerm": ${filteredProducts.length}');

                      if (filteredProducts.isEmpty) {
                        if (currentSearchTerm.isNotEmpty) {
                          return Center(
                              child: Text('No se encontraron productos para "$currentSearchTerm".',
                                  style: const TextStyle(color: Colors.white, fontFamily: APP_FONT_FAMILY, fontSize: 16)));
                        } else {
                          // Este caso no debería alcanzarse si allProducts no está vacío
                          return const Center(
                              child: Text('Aún no hay productos publicados.',
                                  style: TextStyle(color: Colors.white, fontFamily: APP_FONT_FAMILY, fontSize: 16)));
                        }
                      }

                      return GridView.builder(
                        padding: const EdgeInsets.only(top: 8.0, left: 8.0, right: 8.0, bottom: 80.0),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 0.60,
                          crossAxisSpacing: 8.0,
                          mainAxisSpacing: 8.0,
                        ),
                        itemCount: filteredProducts.length,
                        itemBuilder: (context, index) {
                          final product = filteredProducts[index];
                          return _buildProductCard(context, product);
                        },
                      );
                    },
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Widget modal para mostrar los productos publicados por un usuario específico.
/// Recibe el ID del usuario y un BuildContext padre para mostrar SnackBar.
class _MisProductosModalWidget extends StatelessWidget {
  final String userId;
  final BuildContext parentContextForSnackbars;

  const _MisProductosModalWidget({
    Key? key,
    required this.userId,
    required this.parentContextForSnackbars,
  }) : super(key: key);

  /// Método estático para eliminar un producto desde dentro del modal "Mis Productos".
  /// Incluye validación de permisos y confirmación de eliminación.
  ///
  /// Parámetros:
  /// - `contextForDialogsAndSnackbars`: Contexto para mostrar diálogos y SnackBar.
  /// - `productId`: ID del producto a eliminar.
  /// - `productName`: Nombre del producto a eliminar (para confirmación).
  /// - `userIdOfProduct`: ID del usuario propietario del producto.
  static Future<void> _deleteProductFromModal(
      BuildContext contextForDialogsAndSnackbars,
      String productId,
      String productName,
      String userIdOfProduct) async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null || currentUser.uid != userIdOfProduct) {
      if (contextForDialogsAndSnackbars.mounted) {
        ScaffoldMessenger.of(contextForDialogsAndSnackbars).showSnackBar(
          const SnackBar(content: Text('No tienes permiso para eliminar este producto.', style: TextStyle(fontFamily: APP_FONT_FAMILY)), backgroundColor: Colors.red),
        );
      }
      return;
    }

    bool? confirmDelete = await showDialog<bool>(
      context: contextForDialogsAndSnackbars,
      builder: (BuildContext ctx) {
        return AlertDialog(
          backgroundColor: const Color(0xe3a0f4fe),
          title: const Text('Confirmar Eliminación', style: TextStyle(fontFamily: APP_FONT_FAMILY, color: APP_TEXT_COLOR)),
          content: Text('¿Estás seguro de que quieres eliminar "$productName"? Esta acción no se puede deshacer.', style: const TextStyle(fontFamily: APP_FONT_FAMILY, color: APP_TEXT_COLOR)),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancelar', style: TextStyle(fontFamily: APP_FONT_FAMILY, color: Colors.grey)),
              onPressed: () {
                Navigator.of(ctx).pop(false);
              },
            ),
            TextButton(
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              child: const Text('Eliminar', style: TextStyle(fontFamily: APP_FONT_FAMILY)),
              onPressed: () {
                Navigator.of(ctx).pop(true);
              },
            ),
          ],
        );
      },
    );

    if (confirmDelete == true) {
      try {
        DocumentSnapshot productDoc = await FirebaseFirestore.instance.collection('products').doc(productId).get();
        if (productDoc.exists) {
          final productData = Product.fromFirestore(productDoc.data() as Map<String, dynamic>, productDoc.id);
          for (var imageInfo in productData.images) {
            if (imageInfo.url.startsWith('https://firebasestorage.googleapis.com')) {
              try {
                await FirebaseStorage.instance.refFromURL(imageInfo.url).delete();
                developer.log('Imagen de Storage eliminada (modal): ${imageInfo.url}');
              } catch (e) {
                developer.log('Error eliminando imagen de storage (modal): ${imageInfo.url}, error: $e');
              }
            }
          }
        }

        await FirebaseFirestore.instance.collection('products').doc(productId).delete();
        if (contextForDialogsAndSnackbars.mounted) {
          ScaffoldMessenger.of(contextForDialogsAndSnackbars).showSnackBar(
            const SnackBar(content: Text('Producto eliminado correctamente.', style: TextStyle(fontFamily: APP_FONT_FAMILY)), backgroundColor: Colors.green),
          );
        }
      } catch (e) {
        developer.log('Error al eliminar producto desde modal: $e');
        if (contextForDialogsAndSnackbars.mounted) {
          ScaffoldMessenger.of(contextForDialogsAndSnackbars).showSnackBar(
            SnackBar(content: Text('Error al eliminar el producto: $e', style: const TextStyle(fontFamily: APP_FONT_FAMILY)), backgroundColor: Colors.red),
          );
        }
      }
    }
  }

  /// Construye la interfaz de usuario del modal "Mis Productos Publicados".
  /// Muestra una lista de productos del usuario y permite editar o eliminar cada uno.
  @override
  Widget build(BuildContext modalSheetContext) {
    return FractionallySizedBox(
      heightFactor: 0.85,
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20.0),
          topRight: Radius.circular(20.0),
        ),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            title: const Text('Mis Productos Publicados', style: TextStyle(fontFamily: APP_FONT_FAMILY, color: Colors.white)),
            backgroundColor: APP_PRIMARY_COLOR,
            elevation: 1,
            automaticallyImplyLeading: false,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20.0),
                topRight: Radius.circular(20.0),
              ),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.close, color: Colors.white),
                onPressed: () => Navigator.of(modalSheetContext).pop(),
              )
            ],
          ),
          body: Stack(
            children: [
              Container(
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/Animal Health Fondo de Pantalla.png'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                stream: FirebaseFirestore.instance
                    .collection('products')
                    .where('userId', isEqualTo: userId)
                    .orderBy('creationDate', descending: true)
                    .snapshots(),
                builder: (streamBuilderContext, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.white)));
                  }
                  if (snapshot.hasError) {
                    developer.log('Error cargando mis productos (modal) para user $userId: ${snapshot.error}');
                    // MODIFICACIÓN: Mensaje de error más informativo
                    final errorMessage = 'Error al cargar tus productos. Esto puede deberse a problemas de conexión, permisos o la configuración de tus reglas en Firebase (posiblemente falta un índice compuesto para userId y creationDate). Por favor, intenta de nuevo o revisa la consola de depuración para más detalles.';
                    return Center(
                        child: Text(
                            errorMessage,
                            textAlign: TextAlign.center,
                            style: const TextStyle(color: Colors.white, fontFamily: APP_FONT_FAMILY, fontSize: 16)));
                  }
                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    developer.log('No se encontraron productos para el usuario: $userId');
                    return const Center(
                        child: Padding(
                          padding: EdgeInsets.all(20.0),
                          child: Text('Aún no has publicado ningún producto.\n¡Anímate a vender!',
                              textAlign: TextAlign.center,
                              style: TextStyle(color: Colors.white, fontSize: 18, fontFamily: APP_FONT_FAMILY, fontWeight: FontWeight.w600)),
                        ));
                  }

                  final userProducts = snapshot.data!.docs.map((doc) {
                    try {
                      final data = doc.data();
                      return Product.fromFirestore(data, doc.id);
                    } catch (e, s) {
                      developer.log('Error parseando producto en modal (ID: ${doc.id}): $e, Stack: $s, Data: ${doc.data()}');
                      return null;
                    }
                  }).whereType<Product>().toList();

                  developer.log('Mis Productos Modal - Se encontraron ${userProducts.length} productos para el userId: $userId');

                  if (userProducts.isEmpty) {
                    return const Center(
                        child: Padding(
                          padding: EdgeInsets.all(20.0),
                          child: Text('No se pudieron cargar tus productos válidos.\nRevisa la estructura de tus datos.',
                              textAlign: TextAlign.center,
                              style: TextStyle(color: Colors.white, fontSize: 18, fontFamily: APP_FONT_FAMILY, fontWeight: FontWeight.w600)),
                        ));
                  }


                  return ListView.builder(
                    padding: const EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 60.0),
                    itemCount: userProducts.length,
                    itemBuilder: (BuildContext itemBuildContext, int index) {
                      final product = userProducts[index];
                      String? imageUrl = product.images.isNotEmpty ? product.images.first.url : null;

                      return Card(
                        color: const Color(0xe3a0f4fe).withOpacity(0.92),
                        margin: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 4.0),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        elevation: 2,
                        child: ListTile(
                          contentPadding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
                          leading: SizedBox(
                            width: 65,
                            height: 65,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8.0),
                              child: imageUrl != null && imageUrl.isNotEmpty
                                  ? CachedNetworkImage(
                                imageUrl: imageUrl,
                                fit: BoxFit.cover,
                                placeholder: (ctx, url) => Container(color: Colors.grey[300], child: const Center(child: CircularProgressIndicator(strokeWidth: 2.5, valueColor: AlwaysStoppedAnimation<Color>(APP_PRIMARY_COLOR)))),
                                errorWidget: (ctx, url, err) => Container(color: Colors.grey[300], child: const Icon(Icons.broken_image, color: Colors.grey, size: 30)),
                              )
                                  : Container(color: Colors.grey[300], child: const Icon(Icons.inventory_2_outlined, color: Colors.grey, size: 30)),
                            ),
                          ),
                          title: Text(product.name, style: const TextStyle(fontFamily: APP_FONT_FAMILY, fontWeight: FontWeight.bold, fontSize: 16, color: APP_TEXT_COLOR)),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text('\$${product.price.toStringAsFixed(2)}', style: TextStyle(fontFamily: APP_FONT_FAMILY, color: Colors.green[800], fontWeight: FontWeight.w700, fontSize: 15)),
                              Text('Stock: ${product.stock}', style: const TextStyle(fontFamily: APP_FONT_FAMILY, color: APP_TEXT_COLOR, fontSize: 13)),
                            ],
                          ),
                          // MODIFICACIÓN: Se añade un Row para contener múltiples acciones en el trailing.
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min, // Para que el Row ocupe solo el espacio necesario
                            children: [
                              // Botón de opciones (ahora solo para editar)
                              PopupMenuButton<String>(
                                icon: Icon(Icons.more_vert, color: APP_TEXT_COLOR.withOpacity(0.7)),
                                color: const Color(0xffa0f4fe).withOpacity(0.95),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                onSelected: (String value) {
                                  if (value == 'editar_modal') {
                                    // Cierra el modal actual para abrir el de edición desde el contexto padre
                                    Navigator.of(modalSheetContext).pop();
                                    showModalBottomSheet(
                                      context: parentContextForSnackbars,
                                      isScrollControlled: true,
                                      backgroundColor: Colors.transparent,
                                      builder: (BuildContext editModalCtx) {
                                        return _EditarProductoModalWidget(
                                          key: Key('edit_product_modal_list_${product.id}'),
                                          productToEdit: product,
                                          parentContextForSnackbars: parentContextForSnackbars,
                                        );
                                      },
                                    );
                                  }
                                  // La opción 'eliminar_modal' se ha movido a un botón directo
                                },
                                itemBuilder: (BuildContext popupCtx) => <PopupMenuEntry<String>>[
                                  const PopupMenuItem<String>(
                                    value: 'editar_modal',
                                    child: Row(
                                      children: [
                                        Icon(Icons.edit_outlined, color: APP_TEXT_COLOR, size: 20),
                                        SizedBox(width: 8),
                                        Text('Editar', style: TextStyle(fontFamily: APP_FONT_FAMILY, color: APP_TEXT_COLOR)),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              // Botón de eliminar directo con imagen personalizada
                              IconButton(
                                icon: Image.asset(
                                  'assets/images/eliminar.png',
                                  height: 50.0, // Altura deseada
                                  width: 50.0,  // Ancho para mantener la proporción si es necesario
                                  fit: BoxFit.contain, // Ajuste de la imagen dentro del espacio
                                ),
                                onPressed: () {
                                  // Llama a la función estática para eliminar el producto
                                  _MisProductosModalWidget._deleteProductFromModal(itemBuildContext, product.id, product.name, product.userId);
                                },
                                tooltip: 'Eliminar producto', // Etiqueta para accesibilidad
                                padding: EdgeInsets.zero, // Elimina el padding interno predeterminado del IconButton
                                constraints: const BoxConstraints(minWidth: 50, minHeight: 50), // Asegura que el área del botón sea de al menos 50x50
                              ),
                            ],
                          ),
                          onTap: () {
                            Navigator.of(modalSheetContext).pop();
                            Navigator.push(
                              parentContextForSnackbars,
                              MaterialPageRoute(
                                builder: (_) => DetallesdelProducto(
                                  key: Key('DetallesModalList_${product.id}'),
                                  product: product,
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Widget modal para editar los detalles de un producto existente.
/// Recibe el producto a editar y un BuildContext padre para mostrar SnackBar.
class _EditarProductoModalWidget extends StatefulWidget {
  final Product productToEdit;
  final BuildContext parentContextForSnackbars;

  const _EditarProductoModalWidget({
    Key? key,
    required this.productToEdit,
    required this.parentContextForSnackbars,
  }) : super(key: key);

  @override
  __EditarProductoModalWidgetState createState() => __EditarProductoModalWidgetState();
}

/// Clase de estado para el widget _EditarProductoModalWidget.
class __EditarProductoModalWidgetState extends State<_EditarProductoModalWidget> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _descriptionController;
  late TextEditingController _priceController;
  late TextEditingController _stockController;
  late TextEditingController _categoryController;
  List<ProductImage> _currentImagesInfo = [];
  List<XFile> _newImageFiles = [];
  bool _isUploading = false;
  final ImagePicker _picker = ImagePicker();

  /// Inicializa los controladores de texto con los datos del producto a editar.
  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.productToEdit.name);
    _descriptionController = TextEditingController(text: widget.productToEdit.description);
    _priceController = TextEditingController(text: widget.productToEdit.price.toStringAsFixed(2));
    _stockController = TextEditingController(text: widget.productToEdit.stock.toString());
    _categoryController = TextEditingController(text: widget.productToEdit.category);
    _currentImagesInfo = List.from(widget.productToEdit.images);
  }

  /// Libera los controladores de texto cuando el widget es desechado.
  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    _stockController.dispose();
    _categoryController.dispose();
    super.dispose();
  }

  /// Permite al usuario seleccionar nuevas imágenes desde la galería o cámara.
  /// Añade las imágenes seleccionadas a la lista de nuevas imágenes.
  Future<void> _pickImages() async {
    try {
      final List<XFile> pickedFiles = await _picker.pickMultiImage(imageQuality: 70, maxWidth: 1024);
      if (pickedFiles.isNotEmpty) {
        setState(() {
          _newImageFiles.addAll(pickedFiles);
        });
      }
    } catch (e) {
      developer.log("Error seleccionando imágenes para editar producto: $e");
      if (mounted) {
        ScaffoldMessenger.of(widget.parentContextForSnackbars).showSnackBar(
          SnackBar(content: Text('Error al seleccionar imágenes: $e', style: const TextStyle(fontFamily: APP_FONT_FAMILY))),
        );
      }
    }
  }

  /// Elimina una imagen existente (ya subida a Storage) de la lista a mostrar.
  void _removeExistingImage(int index) {
    setState(() {
      _currentImagesInfo.removeAt(index);
    });
  }

  /// Elimina una imagen recién seleccionada (aún no subida a Storage).
  void _removeNewImage(int index) {
    setState(() {
      _newImageFiles.removeAt(index);
    });
  }

  /// Sube una imagen individual a Firebase Storage.
  /// Retorna un objeto ProductImage con la URL de descarga y el publicId.
  ///
  /// Parámetros:
  /// - `imageFile`: El archivo de imagen a subir.
  /// - `productId`: El ID del producto al que pertenece la imagen (para la ruta de almacenamiento).
  /// - `index`: El índice de la imagen (para el nombre del archivo).
  Future<ProductImage> _uploadImage(XFile imageFile, String productId, int index) async {
    String fileExtension = imageFile.name.split('.').last.toLowerCase();
    String fileName = 'products/$productId/image_${DateTime.now().millisecondsSinceEpoch}_$index.$fileExtension';
    Reference storageRef = FirebaseStorage.instance.ref().child(fileName);
    UploadTask uploadTask;
    String contentType = 'image/$fileExtension';
    if (fileExtension == 'jpg') contentType = 'image/jpeg';

    if (kIsWeb) {
      uploadTask = storageRef.putData(await imageFile.readAsBytes(), SettableMetadata(contentType: contentType));
    } else {
      uploadTask = storageRef.putFile(File(imageFile.path), SettableMetadata(contentType: contentType));
    }
    TaskSnapshot snapshot = await uploadTask;
    String downloadUrl = await snapshot.ref.getDownloadURL();
    return ProductImage(publicId: fileName, url: downloadUrl);
  }

  /// Guarda los cambios del producto, subiendo nuevas imágenes, eliminando las antiguas si es necesario,
  /// y actualizando los datos en Firestore.
  Future<void> _saveProductChanges() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    if (_isUploading) return;

    setState(() => _isUploading = true);

    try {
      List<ProductImage> finalImageInfos = List.from(_currentImagesInfo);

      // Sube las nuevas imágenes y las añade a la lista final
      for (int i = 0; i < _newImageFiles.length; i++) {
        ProductImage newProductImage = await _uploadImage(_newImageFiles[i], widget.productToEdit.id, i);
        finalImageInfos.add(newProductImage);
      }

      // Identifica y elimina las imágenes que ya no están en la lista actual
      List<String> originalUrls = widget.productToEdit.images.map((img) => img.url).toList();
      List<String> remainingUrls = _currentImagesInfo.map((img) => img.url).toList();
      List<String> urlsToDeleteFromStorage = originalUrls.where((url) => !remainingUrls.contains(url)).toList();

      for (String urlToDelete in urlsToDeleteFromStorage) {
        if (urlToDelete.startsWith('https://firebasestorage.googleapis.com')) {
          try {
            await FirebaseStorage.instance.refFromURL(urlToDelete).delete();
            developer.log('Imagen antigua eliminada de Storage: $urlToDelete');
          } catch (e) {
            developer.log('Error eliminando imagen antigua de Storage ($urlToDelete): $e');
          }
        }
      }

      // Prepara los datos actualizados para Firestore
      Map<String, dynamic> updatedData = {
        'name': _nameController.text.trim(),
        'description': _descriptionController.text.trim(),
        'price': double.tryParse(_priceController.text) ?? widget.productToEdit.price,
        'stock': int.tryParse(_stockController.text) ?? widget.productToEdit.stock,
        'category': _categoryController.text.trim(),
        'images': finalImageInfos.map((img) => img.toJson()).toList(),
        'lastUpdated': FieldValue.serverTimestamp(),
      };

      // Actualiza el documento del producto en Firestore
      await FirebaseFirestore.instance.collection('products').doc(widget.productToEdit.id).update(updatedData);

      if (mounted) {
        ScaffoldMessenger.of(widget.parentContextForSnackbars).showSnackBar(
          const SnackBar(content: Text('Producto actualizado correctamente.', style: TextStyle(fontFamily: APP_FONT_FAMILY)), backgroundColor: Colors.green),
        );
        Navigator.of(context).pop(); // Cierra el modal después de guardar
      }
    } catch (e) {
      developer.log("Error actualizando producto: $e");
      if (mounted) {
        ScaffoldMessenger.of(widget.parentContextForSnackbars).showSnackBar(
          SnackBar(content: Text('Error al actualizar el producto: $e', style: const TextStyle(fontFamily: APP_FONT_FAMILY)), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isUploading = false); // Finaliza el estado de carga
      }
    }
  }

  /// Widget auxiliar para construir un campo de texto con estilo.
  ///
  /// Parámetros:
  /// - `controller`: El controlador de texto para el campo.
  /// - `label`: La etiqueta del campo.
  /// - `keyboardType`: Tipo de teclado a usar (por defecto TextInputType.text).
  /// - `maxLines`: Número máximo de líneas (por defecto 1).
  /// - `validator`: Función de validación personalizada para el campo.
  Widget _buildTextField({required TextEditingController controller, required String label, TextInputType keyboardType = TextInputType.text, int maxLines = 1, String? Function(String?)? validator}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        style: const TextStyle(fontFamily: APP_FONT_FAMILY, color: APP_TEXT_COLOR, fontSize: 15),
        keyboardType: keyboardType,
        maxLines: maxLines,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(fontFamily: APP_FONT_FAMILY, color: Colors.black54, fontSize: 16),
          filled: true,
          fillColor: Colors.white.withOpacity(0.92),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0), borderSide: BorderSide.none),
          focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0), borderSide: const BorderSide(color: APP_PRIMARY_COLOR, width: 2.5)),
          errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0), borderSide: BorderSide(color: Colors.redAccent[700]!, width: 1.5)),
          focusedErrorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0), borderSide: BorderSide(color: Colors.redAccent[700]!, width: 2.5)),
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: maxLines > 1 ? 16 : 12),
          errorStyle: TextStyle(fontFamily: APP_FONT_FAMILY, color: Colors.red[600], fontWeight: FontWeight.w600),
        ),
        validator: validator ?? (value) {
          if (value == null || value.trim().isEmpty) {
            return '$label no puede estar vacío.';
          }
          if (label.toLowerCase().contains("precio") && (double.tryParse(value) == null || double.parse(value) <= 0)) {
            return 'Ingresa un precio válido mayor a cero.';
          }
          if (label.toLowerCase().contains("stock") && (int.tryParse(value) == null || int.parse(value) < 0)) {
            return 'Ingresa un stock válido (0 o más).';
          }
          return null;
        },
        autovalidateMode: AutovalidateMode.onUserInteraction,
      ),
    );
  }

  /// Construye la interfaz de usuario del modal de edición de producto.
  /// Contiene un formulario para editar los detalles del producto y la gestión de imágenes.
  @override
  Widget build(BuildContext modalEditContext) {
    return FractionallySizedBox(
      heightFactor: 0.92,
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20.0),
          topRight: Radius.circular(20.0),
        ),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            title: const Text('Editar Producto', style: TextStyle(fontFamily: APP_FONT_FAMILY, color: Colors.white)),
            backgroundColor: APP_PRIMARY_COLOR,
            elevation: 1,
            automaticallyImplyLeading: false,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20.0),
                topRight: Radius.circular(20.0),
              ),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.close, color: Colors.white),
                onPressed: () => Navigator.of(modalEditContext).pop(),
              )
            ],
          ),
          body: Stack(
            children: [
              Container(
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/Animal Health Fondo de Pantalla.png'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 0),
                child: Form(
                  key: _formKey,
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.only(bottom: 100),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        _buildTextField(controller: _nameController, label: "Nombre del Producto"),
                        _buildTextField(controller: _descriptionController, label: "Descripción", maxLines: 4),
                        Row(
                          children: [
                            Expanded(child: _buildTextField(controller: _priceController, label: "Precio", keyboardType: const TextInputType.numberWithOptions(decimal: true))),
                            const SizedBox(width: 10),
                            Expanded(child: _buildTextField(controller: _stockController, label: "Stock", keyboardType: TextInputType.number)),
                          ],
                        ),
                        _buildTextField(controller: _categoryController, label: "Categoría"),

                        const SizedBox(height: 15),
                        Text("Imágenes:", style: TextStyle(fontFamily: APP_FONT_FAMILY, color: Colors.white.withOpacity(0.9), fontSize: 17, fontWeight: FontWeight.w600)),
                        const SizedBox(height: 8),
                        if (_currentImagesInfo.isEmpty && _newImageFiles.isEmpty)
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 12.0),
                            child: Text("No hay imágenes. ¡Añade algunas!", textAlign: TextAlign.center, style: TextStyle(fontFamily: APP_FONT_FAMILY, color: Colors.white.withOpacity(0.75), fontSize: 15)),
                          ),
                        Wrap(
                            spacing: 10.0,
                            runSpacing: 10.0,
                            children: [
                              // Muestra las imágenes existentes (ya subidas)
                              ...List.generate(_currentImagesInfo.length, (index) {
                                final imageInfo = _currentImagesInfo[index];
                                return Stack(
                                  clipBehavior: Clip.none,
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(8),
                                      child: CachedNetworkImage(
                                        imageUrl: imageInfo.url,
                                        width: 85, height: 85, fit: BoxFit.cover,
                                        placeholder: (c,u) => Container(width:85, height: 85, color: Colors.grey[700], child: const Center(child: CircularProgressIndicator(strokeWidth: 2.5, valueColor: AlwaysStoppedAnimation(APP_PRIMARY_COLOR)))),
                                        errorWidget: (c,u,e) => Container(width:85, height: 85, color: Colors.grey[700], child: const Icon(Icons.error_outline, color: Colors.redAccent, size: 30)),
                                      ),
                                    ),
                                    Positioned(
                                      top: -10, right: -10,
                                      child: InkWell(
                                        onTap: () => _removeExistingImage(index),
                                        child: Container(
                                          padding: const EdgeInsets.all(2),
                                          decoration: BoxDecoration(color: Colors.black.withOpacity(0.6), shape: BoxShape.circle),
                                          child: const Icon(Icons.close, color: Colors.white, size: 18),
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              }),
                              // Muestra las nuevas imágenes seleccionadas (aún no subidas)
                              ...List.generate(_newImageFiles.length, (index) {
                                return Stack(
                                  clipBehavior: Clip.none,
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(8),
                                      child: kIsWeb
                                          ? FutureBuilder<Uint8List>(
                                        future: _newImageFiles[index].readAsBytes(),
                                        builder: (context, snapshot) {
                                          if (snapshot.connectionState == ConnectionState.done && snapshot.data != null) {
                                            return Image.memory(snapshot.data!, width: 85, height: 85, fit: BoxFit.cover);
                                          }
                                          return Container(width: 85, height: 85, color: Colors.grey[700], child: const Center(child: CircularProgressIndicator(strokeWidth: 2.5, valueColor: AlwaysStoppedAnimation(APP_PRIMARY_COLOR))));
                                        },
                                      )
                                          : Image.file(File(_newImageFiles[index].path), width: 85, height: 85, fit: BoxFit.cover),
                                    ),
                                    Positioned(
                                      top: -10, right: -10,
                                      child: InkWell(
                                        onTap: () => _removeNewImage(index),
                                        child: Container(
                                          padding: const EdgeInsets.all(2),
                                          decoration: BoxDecoration(color: Colors.black.withOpacity(0.6), shape: BoxShape.circle),
                                          child: const Icon(Icons.close, color: Colors.white, size: 18),
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              }),
                            ]
                        ),
                        const SizedBox(height: 20),
                        ElevatedButton.icon(
                          icon: Icon(Icons.add_photo_alternate_rounded, color: Colors.white.withOpacity(0.9)),
                          label: Text('Añadir/Cambiar Imágenes', style: TextStyle(fontFamily: APP_FONT_FAMILY, color: Colors.white.withOpacity(0.9), fontSize: 15)),
                          onPressed: _pickImages,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: APP_PRIMARY_COLOR.withOpacity(0.85),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          ),
                        ),
                        const SizedBox(height: 30),
                      ],
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: Container(
                  color: APP_PRIMARY_COLOR.withOpacity(0.9),
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                  child: SafeArea(
                    bottom: true,
                    top: false,
                    child: _isUploading
                        ? const SizedBox(
                        height: 50,
                        child: Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.white), strokeWidth: 3)))
                        : ElevatedButton.icon(
                      icon: const Icon(Icons.save_as_outlined, color: Colors.white, size: 22),
                      label: const Text('Guardar Cambios', style: TextStyle(fontFamily: APP_FONT_FAMILY, color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                      onPressed: _saveProductChanges,
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green[600]!,
                          minimumSize: const Size(double.infinity, 50),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}