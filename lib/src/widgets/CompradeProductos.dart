import 'package:flutter/material.dart';
import 'package:adobe_xd/pinned.dart';
import 'package:adobe_xd/page_link.dart'; // Asegúrate que esta importación esté
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:developer' as developer;

import './Ayuda.dart';
import './PerfilPublico.dart';
import './Configuracion.dart';
import './ListadeAnimales.dart';
import './VenderProductos.dart'; // <<<--- ASEGÚRATE DE ESTA IMPORTACIÓN
import './Carritodecompras.dart';
import './DetallesdelProducto.dart';
import './Home.dart';
import '../services/auth_service.dart';
import '../models/products.dart';
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
  String _searchTerm = '';
  final CartService _cartService = CartService();

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      if (mounted) {
        setState(() {
          _searchTerm = _searchController.text;
        });
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Widget _buildProductCard(BuildContext context, Product product) {
    String? imageUrl = product.images.isNotEmpty ? product.images.first.url : null;
    final currentUser = FirebaseAuth.instance.currentUser;
    final bool canDelete = currentUser != null && product.userId.isNotEmpty && product.userId == currentUser.uid;

    Future<void> _deleteProduct(String productId) async {
      bool? confirmDelete = await showDialog<bool>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Confirmar Eliminación', style: TextStyle(fontFamily: APP_FONT_FAMILY)),
            content: const Text('¿Estás seguro de que quieres eliminar este producto? Esta acción no se puede deshacer.', style: TextStyle(fontFamily: APP_FONT_FAMILY)),
            actions: <Widget>[
              TextButton(
                child: const Text('Cancelar', style: TextStyle(fontFamily: APP_FONT_FAMILY, color: Colors.grey)),
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
              ),
              TextButton(
                style: TextButton.styleFrom(foregroundColor: Colors.red),
                child: const Text('Eliminar', style: TextStyle(fontFamily: APP_FONT_FAMILY)),
                onPressed: () {
                  Navigator.of(context).pop(true);
                },
              ),
            ],
          );
        },
      );

      if (confirmDelete == true) {
        try {
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
                  if (canDelete)
                    Positioned(
                      top: 4,
                      right: 4,
                      child: Material(
                        color: Colors.black.withOpacity(0.4),
                        shape: const CircleBorder(),
                        clipBehavior: Clip.antiAlias,
                        child: IconButton(
                          icon: const Icon(Icons.delete_forever, color: Colors.white, size: 20),
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
                          tooltip: 'Eliminar producto',
                          onPressed: () {
                            _deleteProduct(product.id);
                          },
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
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0, right: 6.0),
                    child: Image.asset(
                      'assets/images/busqueda1.png',
                      width: 31.0,
                      height: 31.0,
                      fit: BoxFit.fill,
                    ),
                  ),
                  Expanded(
                    child: Center(
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
                          contentPadding: EdgeInsets.symmetric(vertical: 8.0),
                        ),
                        textInputAction: TextInputAction.search,
                        onSubmitted: (value) {
                          developer.log("Búsqueda enviada (onSubmitted): $value");
                        },
                      ),
                    ),
                  ),
                  if (_searchController.text.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(right: 4.0),
                      child: IconButton(
                        icon: Icon(Icons.clear, color: Colors.grey[600], size: 20),
                        onPressed: () {
                          _searchController.clear();
                        },
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(minWidth: 24, minHeight: 24),
                        splashRadius: 18,
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
          // --- BOTÓN VENDER PRODUCTOS ---
          Pinned.fromPins(
            Pin(size: 65.0, end: 7.6),
            Pin(size: 60.0, start: 198.0),
            child: PageLink( // Este PageLink debe navegar a VenderProductos
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
          // --- FIN BOTÓN VENDER PRODUCTOS ---


          Pinned.fromPins(
            Pin(start: 8.0, end: 8.0),
            Pin(start: 270.0, end: 0.0), // Ajustado para bajar la lista
            child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
              stream: FirebaseFirestore.instance.collection('products').orderBy('creationDate', descending: true).snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.white)));
                }
                if (snapshot.hasError) {
                  developer.log('Error cargando productos: ${snapshot.error} ${snapshot.stackTrace}');
                  return const Center(
                      child: Text('Error al cargar productos.',
                          style: TextStyle(color: Colors.white, fontFamily: APP_FONT_FAMILY)));
                }
                if (!snapshot.hasData || snapshot.data == null || snapshot.data!.docs.isEmpty) {
                  developer.log('StreamBuilder (CompraProductos): No hay datos o los documentos están vacíos.');
                  return const Center(
                      child: Text('No hay productos disponibles.',
                          style: TextStyle(color: Colors.white, fontFamily: APP_FONT_FAMILY)));
                }

                // developer.log('StreamBuilder (CompraProductos): Se recibieron ${snapshot.data!.docs.length} documentos.'); // Comentado si ya funciona
                final allProducts = snapshot.data!.docs.map((doc) {
                  try {
                    final data = doc.data();
                    final id = doc.id;
                    return Product.fromFirestore(data, id);
                  } catch (e, s) {
                    developer.log('Error al parsear producto ${doc.id} (CompraProductos): $e\nStackTrace: $s\nDatos: ${doc.data()}');
                    return null;
                  }
                }).whereType<Product>().toList();
                // developer.log('StreamBuilder (CompraProductos): ${allProducts.length} productos parseados correctamente.'); // Comentado si ya funciona

                final filteredProducts = _searchTerm.isEmpty
                    ? allProducts
                    : allProducts.where((product) {
                  final searchTermLower = _searchTerm.toLowerCase();
                  final categoryLower = (product.category).toLowerCase();
                  final nameMatch = product.name.toLowerCase().contains(searchTermLower);
                  final descriptionMatch = product.description.toLowerCase().contains(searchTermLower);
                  final categoryMatch = categoryLower.contains(searchTermLower);
                  final sellerMatch = product.seller.toLowerCase().contains(searchTermLower);
                  return nameMatch || descriptionMatch || categoryMatch || sellerMatch;
                }).toList();
                // developer.log('StreamBuilder (CompraProductos): ${_searchTerm.isEmpty ? "Mostrando todos" : "Filtrando por \'$_searchTerm\'"}, ${filteredProducts.length} productos filtrados.');


                if (filteredProducts.isEmpty) {
                  if (_searchTerm.isNotEmpty) {
                    return Center(
                        child: Text('No se encontraron productos para "$_searchTerm".',
                            style: const TextStyle(color: Colors.white, fontFamily: APP_FONT_FAMILY, fontSize: 16)));
                  } else if (allProducts.isEmpty) {
                    return const Center(
                        child: Text('Aún no hay productos publicados.',
                            style: TextStyle(color: Colors.white, fontFamily: APP_FONT_FAMILY, fontSize: 16)));
                  }
                }

                return GridView.builder(
                  padding: const EdgeInsets.only(top: 8.0, left: 8.0, right: 8.0, bottom: 8.0),
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
            ),
          ),
        ],
      ),
    );
  }
}