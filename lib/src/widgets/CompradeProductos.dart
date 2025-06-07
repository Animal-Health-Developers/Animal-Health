import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:adobe_xd/pinned.dart';
import 'package:adobe_xd/page_link.dart';
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
  final ValueNotifier<String> _searchTermNotifier = ValueNotifier<String>('');
  final CartService _cartService = CartService();
  Stream<QuerySnapshot<Map<String, dynamic>>>? _productsStream;

  @override
  void initState() {
    super.initState();
    developer.log('CompradeProductos initState: Initializing search controller and updating product stream.');
    // La búsqueda se inicia vacía para mostrar todos los productos.
    _updateProductStream('');
    _searchController.addListener(() {
      if (mounted) {
        setState(() {});
      }
    });
  }

  /// Actualiza el stream de productos basado en un término de búsqueda.
  /// Busca por palabras clave individuales en el campo 'searchKeywords'.
  void _updateProductStream(String searchTerm) {
    Query<Map<String, dynamic>> query = FirebaseFirestore.instance.collection('products');

    if (searchTerm.isNotEmpty) {
      // Búsqueda por palabra clave. Encuentra documentos donde el array 'searchKeywords' contiene el término de búsqueda.
      query = query.where('searchKeywords', arrayContains: searchTerm.toLowerCase());
      developer.log('CompradeProductos _updateProductStream: Searching for keyword: "$searchTerm"');
    } else {
      // Si no hay búsqueda, muestra todos los productos.
      query = query.orderBy('creationDate', descending: true);
      developer.log('CompradeProductos _updateProductStream: Search term is empty, showing all products.');
    }

    if (mounted) {
      setState(() {
        _productsStream = query.snapshots();
      });
    }
  }

  void _performSearch() {
    final searchTerm = _searchController.text.trim();
    developer.log('CompradeProductos _performSearch: Starting search for: "$searchTerm"');
    FocusScope.of(context).unfocus();
    _updateProductStream(searchTerm);
    _searchTermNotifier.value = searchTerm;
  }

  void _clearSearch() {
    developer.log('CompradeProductos _clearSearch: Clearing search bar');
    _searchController.clear();
    _updateProductStream('');
    _searchTermNotifier.value = '';
    FocusScope.of(context).unfocus();
  }


  @override
  void dispose() {
    developer.log('CompradeProductos dispose: Disposing controllers and notifiers');
    _searchController.removeListener(() {});
    _searchController.dispose();
    _searchTermNotifier.dispose();
    super.dispose();
  }

  // --- El resto de tu código de la clase _CompradeProductosState permanece sin cambios ---
  // --- (build, _buildProductCard, _mostrarModalMisProductos, etc.) ---
  // --- A continuación, se pega todo el código restante sin modificar su funcionalidad, ---
  // --- ya que la lógica central de la búsqueda ya es correcta. ---

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

  Widget _buildProductCard(BuildContext context, Product product) {
    String? imageUrl = product.images.isNotEmpty ? product.images.first.url : null;
    final currentUser = FirebaseAuth.instance.currentUser;
    final bool isOwner = currentUser != null && product.userId.isNotEmpty && product.userId == currentUser.uid;

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
                  if (isOwner) ...[
                    Positioned(
                      top: 3,
                      right: 2,
                      child: Tooltip(
                        message: 'Eliminar Producto',
                        child: IconButton(
                          icon: Image.asset(
                            'assets/images/eliminar.png',
                            width: 28.0,
                            height: 28.0,
                            fit: BoxFit.contain,
                          ),
                          onPressed: () {
                            _deleteProduct(product.id, product.name);
                          },
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                          splashRadius: 20,
                        ),
                      ),
                    ),
                    Positioned(
                      top: 3,
                      right: 2 + 28 + 4,
                      child: Tooltip(
                        message: 'Editar Producto',
                        child: IconButton(
                          icon: Image.asset(
                            'assets/images/editar.png',
                            width: 28.0,
                            height: 28.0,
                            fit: BoxFit.contain,
                          ),
                          onPressed: () {
                            _mostrarModalEditarProducto(product, context);
                          },
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                          splashRadius: 20,
                        ),
                      ),
                    ),
                  ],
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
                    child: Tooltip(
                      message: 'Añadir al Carrito',
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
            ),
          ],
        ),
      ),
    );
  }

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
              child: Tooltip(
                message: 'Volver a Inicio',
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
              child: Tooltip(
                message: 'Ir a Inicio',
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
              child: Tooltip(
                message: 'Ver Carrito de Compras',
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
              child: Tooltip(
                message: 'Ayuda',
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
              child: Tooltip(
                message: 'Configuración',
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
                  child: Tooltip(
                    message: 'Ver Perfil Público',
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
                          contentPadding: EdgeInsets.symmetric(horizontal: 0, vertical: 8.0),
                        ),
                        textInputAction: TextInputAction.search,
                        onSubmitted: (value) {
                          _performSearch();
                        },
                      ),
                    ),
                  ),
                  if (_searchController.text.isNotEmpty)
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
                      child: Tooltip(
                        message: 'Buscar',
                        child: Image.asset(
                          'assets/images/busqueda1.png',
                          width: 31.0,
                          height: 31.0,
                          fit: BoxFit.fill,
                        ),
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
              child: Tooltip(
                message: 'Ver Lista de Animales',
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
              child: Tooltip(
                message: 'Vender un Producto',
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
          ),
          Pinned.fromPins(
            Pin(size: 65.0, end: 7.6 + 65.0 + 10.0),
            Pin(size: 60.0, start: 200.5),
            child: GestureDetector(
              onTap: _mostrarModalMisProductos,
              child: Tooltip(
                message: 'Mis Productos Publicados',
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
          ),
          Pinned.fromPins(
            Pin(start: 8.0, end: 8.0),
            Pin(start: 270.0, end: 0.0),
            child: ValueListenableBuilder<String>(
              valueListenable: _searchTermNotifier,
              builder: (context, currentSearchTerm, child) {
                return AnimatedSwitcher(
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
                  key: ValueKey<String>('product_grid_for_term_${currentSearchTerm.isEmpty ? 'all' : currentSearchTerm}'),
                  child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                    stream: _productsStream,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting || _productsStream == null) {
                        return const Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.white)),
                              SizedBox(height: 16),
                              Text('Cargando productos...', style: TextStyle(color: Colors.white, fontFamily: APP_FONT_FAMILY, fontSize: 16)),
                            ],
                          ),
                        );
                      }
                      if (snapshot.hasError) {
                        String errorMessage = 'Error al cargar productos.';
                        if (snapshot.error.toString().contains('composite index') || snapshot.error.toString().contains('requires an index')) {
                          errorMessage += '\n\nACCIÓN REQUERIDA:\nLa búsqueda necesita un índice en Firebase. Revisa la consola de depuración (Run/Debug) de tu editor, allí encontrarás un enlace para crear el índice. Haz clic en él y créalo.';
                          developer.log("ERROR DE ÍNDICE DE FIRESTORE: ${snapshot.error}");
                        } else {
                          errorMessage += ' Por favor, revisa tu conexión a internet.';
                          developer.log("ERROR GENÉRICO DEL STREAM: ${snapshot.error}");
                        }
                        return Center(
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Text(errorMessage,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(color: Colors.white, fontFamily: APP_FONT_FAMILY, backgroundColor: Colors.redAccent, fontWeight: FontWeight.bold, fontSize: 16)),
                            ));
                      }
                      if (!snapshot.hasData || snapshot.data == null || snapshot.data!.docs.isEmpty) {
                        String message = _searchController.text.isNotEmpty
                            ? 'No se encontraron productos para "${_searchController.text}"'
                            : 'No hay productos disponibles.';
                        return Center(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 20.0),
                              child: Text(message,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(color: Colors.white, fontFamily: APP_FONT_FAMILY, fontSize: 16)),
                            ));
                      }

                      final List<Product> products = [];
                      for (var doc in snapshot.data!.docs) {
                        try {
                          products.add(Product.fromFirestore(doc.data(), doc.id));
                        } catch (e, s) {
                          developer.log('ERROR al parsear producto ${doc.id}: $e\nStackTrace: $s\nDatos: ${doc.data()}');
                        }
                      }

                      if (products.isEmpty) {
                        return const Center(
                            child: Text('No se pudieron cargar productos válidos.\nRevisa la estructura de los datos.',
                                textAlign: TextAlign.center,
                                style: TextStyle(color: Colors.white, fontFamily: APP_FONT_FAMILY)));
                      }

                      return GridView.builder(
                        padding: const EdgeInsets.only(top: 8.0, left: 8.0, right: 8.0, bottom: 80.0),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 0.60,
                          crossAxisSpacing: 8.0,
                          mainAxisSpacing: 8.0,
                        ),
                        itemCount: products.length,
                        itemBuilder: (context, index) {
                          final product = products[index];
                          return _buildProductCard(context, product);
                        },
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _MisProductosModalWidget extends StatelessWidget {
  final String userId;
  final BuildContext parentContextForSnackbars;

  const _MisProductosModalWidget({
    Key? key,
    required this.userId,
    required this.parentContextForSnackbars,
  }) : super(key: key);

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
                tooltip: 'Cerrar',
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
                    return Center(child: Text('Error: ${snapshot.error}', style: const TextStyle(color: Colors.white)));
                  }
                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
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
                      return Product.fromFirestore(doc.data(), doc.id);
                    } catch (e) {
                      developer.log('Error parseando producto en modal: $e');
                      return null;
                    }
                  }).whereType<Product>().toList();

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
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: Image.asset(
                                  'assets/images/editar.png',
                                  height: 50.0,
                                  width: 50.0,
                                  fit: BoxFit.contain,
                                ),
                                onPressed: () {
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
                                },
                                tooltip: 'Editar producto',
                                padding: EdgeInsets.zero,
                                constraints: const BoxConstraints(minWidth: 50, minHeight: 50),
                              ),
                              IconButton(
                                icon: Image.asset(
                                  'assets/images/eliminar.png',
                                  height: 50.0,
                                  width: 50.0,
                                  fit: BoxFit.contain,
                                ),
                                onPressed: () {
                                  _MisProductosModalWidget._deleteProductFromModal(itemBuildContext, product.id, product.name, product.userId);
                                },
                                tooltip: 'Eliminar producto',
                                padding: EdgeInsets.zero,
                                constraints: const BoxConstraints(minWidth: 50, minHeight: 50),
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

// ==============================================================================
// ===== CLASE _EditarProductoModalWidget CON LA LÓGICA DE KEYWORDS CORRECTA ====
// ==============================================================================
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

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    _stockController.dispose();
    _categoryController.dispose();
    super.dispose();
  }

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
    }
  }

  void _removeExistingImage(int index) {
    setState(() {
      _currentImagesInfo.removeAt(index);
    });
  }

  void _removeNewImage(int index) {
    setState(() {
      _newImageFiles.removeAt(index);
    });
  }

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

  /// ESTA ES LA FUNCIÓN CLAVE. ASEGURA QUE CADA VEZ QUE SE GUARDA
  /// UN PRODUCTO, SE GENERAN LAS PALABRAS CLAVE PARA LA BÚSQUEDA.
  Future<void> _saveProductChanges() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    if (_isUploading) return;

    if (mounted) setState(() => _isUploading = true);

    try {
      List<ProductImage> finalImageInfos = List.from(_currentImagesInfo);

      for (int i = 0; i < _newImageFiles.length; i++) {
        ProductImage newProductImage = await _uploadImage(_newImageFiles[i], widget.productToEdit.id, i);
        finalImageInfos.add(newProductImage);
      }

      List<String> originalUrls = widget.productToEdit.images.map((img) => img.url).toList();
      List<String> remainingUrls = _currentImagesInfo.map((img) => img.url).toList();
      List<String> urlsToDeleteFromStorage = originalUrls.where((url) => !remainingUrls.contains(url)).toList();

      for (String urlToDelete in urlsToDeleteFromStorage) {
        if (urlToDelete.startsWith('https://firebasestorage.googleapis.com')) {
          try {
            await FirebaseStorage.instance.refFromURL(urlToDelete).delete();
          } catch (e) {
            developer.log('Error eliminando imagen antigua ($urlToDelete): $e');
          }
        }
      }

      // ---- INICIO DE LA LÓGICA DE KEYWORDS (LA PARTE MÁS IMPORTANTE) ----
      final String productName = _nameController.text.trim();

      // Procesa el nombre para crear la lista de palabras clave (keywords).
      final List<String> searchKeywords = productName
          .toLowerCase() // 1. Convertir a minúsculas: "comida para gatos"
          .replaceAll(RegExp(r'[^\w\s]'), '') // 2. Opcional: quitar puntuación
          .split(' ') // 3. Dividir por espacios: ["comida", "para", "gatos"]
          .where((s) => s.isNotEmpty) // 4. Quitar posibles strings vacíos
          .toSet() // 5. Opcional pero recomendado: eliminar duplicados
          .toList(); // 6. Convertir de nuevo a una lista
      // ---- FIN DE LA LÓGICA DE KEYWORDS ----

      Map<String, dynamic> updatedData = {
        'name': productName,
        'searchKeywords': searchKeywords, // <-- ¡EL CAMPO MÁGICO PARA LA BÚSQUEDA!
        'description': _descriptionController.text.trim(),
        'price': double.tryParse(_priceController.text) ?? widget.productToEdit.price,
        'stock': int.tryParse(_stockController.text) ?? widget.productToEdit.stock,
        'category': _categoryController.text.trim(),
        'images': finalImageInfos.map((img) => img.toJson()).toList(),
        'lastUpdated': FieldValue.serverTimestamp(),
      };

      await FirebaseFirestore.instance.collection('products').doc(widget.productToEdit.id).update(updatedData);

      if (mounted) {
        ScaffoldMessenger.of(widget.parentContextForSnackbars).showSnackBar(
          const SnackBar(content: Text('Producto actualizado correctamente.', style: TextStyle(fontFamily: APP_FONT_FAMILY)), backgroundColor: Colors.green),
        );
        Navigator.of(context).pop();
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
        setState(() => _isUploading = false);
      }
    }
  }

  Widget _buildTextFieldWithIcon({
    required TextEditingController controller,
    required String labelText,
    required String iconPath,
    required String tooltipMessage,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: SizedBox(
        height: maxLines > 1 ? null : 60.0,
        child: Stack(
          alignment: Alignment.centerLeft,
          children: [
            TextFormField(
              controller: controller,
              keyboardType: keyboardType,
              maxLines: maxLines,
              minLines: maxLines > 1 ? 3 : 1,
              style: const TextStyle(fontFamily: APP_FONT_FAMILY, fontSize: 18, color: APP_TEXT_COLOR),
              decoration: InputDecoration(
                labelText: labelText,
                labelStyle: const TextStyle(fontFamily: APP_FONT_FAMILY, fontSize: 18, color: Colors.black54),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: const BorderSide(color: Color(0xff707070)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: const BorderSide(color: Color(0xff707070), width: 1.0),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: const BorderSide(color: APP_PRIMARY_COLOR, width: 2.0),
                ),
                contentPadding: const EdgeInsets.only(left: 55.0, top: 20, bottom: 20, right: 16.0),
              ),
              validator: validator,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Tooltip(
                message: tooltipMessage,
                child: Image.asset(
                  iconPath,
                  width: 40.0,
                  height: 40.0,
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

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
                tooltip: 'Cerrar',
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
                        _buildTextFieldWithIcon(
                          controller: _nameController,
                          labelText: "Nombre del Producto",
                          iconPath: 'assets/images/nombreproducto.png',
                          tooltipMessage: 'Edita el nombre de tu producto',
                          validator: (value) => value == null || value.trim().isEmpty ? 'El nombre no puede estar vacío.' : null,
                        ),
                        _buildTextFieldWithIcon(
                          controller: _descriptionController,
                          labelText: "Descripción",
                          iconPath: 'assets/images/infoproducto.png',
                          tooltipMessage: 'Edita la descripción del producto',
                          maxLines: 4,
                          validator: (value) => value == null || value.trim().isEmpty ? 'La descripción no puede estar vacía.' : null,
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: _buildTextFieldWithIcon(
                                controller: _priceController,
                                labelText: "Precio",
                                iconPath: 'assets/images/price.png',
                                tooltipMessage: 'Edita el precio del producto',
                                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                                validator: (value) {
                                  if (value == null || value.trim().isEmpty) return 'Ingresa un precio.';
                                  if (double.tryParse(value) == null || double.parse(value) <= 0) return 'Precio inválido.';
                                  return null;
                                },
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: _buildTextFieldWithIcon(
                                controller: _stockController,
                                labelText: "Stock",
                                iconPath: 'assets/images/stock.png',
                                tooltipMessage: 'Edita el stock disponible',
                                keyboardType: TextInputType.number,
                                validator: (value) {
                                  if (value == null || value.trim().isEmpty) return 'Ingresa el stock.';
                                  if (int.tryParse(value) == null || int.parse(value) < 0) return 'Stock inválido.';
                                  return null;
                                },
                              ),
                            ),
                          ],
                        ),
                        _buildTextFieldWithIcon(
                          controller: _categoryController,
                          labelText: "Categoría",
                          iconPath: 'assets/images/category.png',
                          tooltipMessage: 'Edita la categoría del producto',
                          validator: (value) => value == null || value.trim().isEmpty ? 'La categoría no puede estar vacía.' : null,
                        ),
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
                                        child: Tooltip(
                                          message: 'Eliminar imagen',
                                          child: Container(
                                            padding: const EdgeInsets.all(2),
                                            decoration: BoxDecoration(color: Colors.black.withOpacity(0.6), shape: BoxShape.circle),
                                            child: const Icon(Icons.close, color: Colors.white, size: 18),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              }),
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
                                        child: Tooltip(
                                          message: 'Eliminar nueva imagen',
                                          child: Container(
                                            padding: const EdgeInsets.all(2),
                                            decoration: BoxDecoration(color: Colors.black.withOpacity(0.6), shape: BoxShape.circle),
                                            child: const Icon(Icons.close, color: Colors.white, size: 18),
                                          ),
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