import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:developer' as developer;
import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:typed_data';
import 'package:image_picker/image_picker.dart';

import './Ayuda.dart';
import './PerfilPublico.dart';
import './Configuracion.dart';
import './ListadeAnimales.dart';
import './Carritodecompras.dart';
import './ComprarAhora.dart';
import './Home.dart';
import './CompradeProductos.dart';
import '../services/auth_service.dart';
import '../models/products.dart';
import '../services/cart_service.dart';

const Color APP_PRIMARY_COLOR = Color(0xff4ec8dd);
const Color APP_TEXT_COLOR = Color(0xff000000);
const String APP_FONT_FAMILY = 'Comic Sans MS';

class DetallesdelProducto extends StatefulWidget {
  final Product product;

  const DetallesdelProducto({
    super.key,
    required this.product,
  });

  @override
  _DetallesdelProductoState createState() => _DetallesdelProductoState();
}

class _DetallesdelProductoState extends State<DetallesdelProducto> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  bool _isLoadingOpinion = false;

  final _formKeyOpinion = GlobalKey<FormState>();
  final TextEditingController _opinionComentarioController = TextEditingController();
  double _opinionNuevaCalificacion = 0;
  Key _opinionsSectionKey = UniqueKey();

  final CartService _cartService = CartService();

  final TextEditingController _searchController = TextEditingController();
  String? _selectedCategoryFilter;
  RangeValues? _priceRangeFilter;
  final List<String> _listaDeCategorias = [
    'Alimentos', 'Juguetes', 'Accesorios (Correas, Collares, Camas)',
    'Productos de Aseo e Higiene', 'Medicamentos y Salud (Antipulgas, Vitaminas)',
    'Snacks y Premios', 'Ropa', 'Transportadoras y Jaulas', 'Otros',
  ];

  @override
  void initState() {
    super.initState();
    _pageController.addListener(() {
      if (_pageController.page?.round() != _currentPage) {
        if (mounted) {
          setState(() {
            _currentPage = _pageController.page!.round();
          });
        }
      }
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    _opinionComentarioController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _applyFiltersAndSearch() {
    FocusScope.of(context).unfocus();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => CompradeProductos(
          key: const Key('CompraDesdeDetallesSearch'),
          initialSearchTerm: _searchController.text,
          initialCategory: _selectedCategoryFilter,
          initialPriceRange: _priceRangeFilter,
        ),
      ),
    );
  }

  Future<void> _showFilterDialog() async {
    String? tempCategory = _selectedCategoryFilter;
    RangeValues tempPriceRange = _priceRangeFilter ?? const RangeValues(0, 5000);

    await showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              backgroundColor: const Color(0xfff0faff),
              title: const Text('Filtrar Productos', style: TextStyle(fontFamily: APP_FONT_FAMILY)),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Categoría:', style: TextStyle(fontFamily: APP_FONT_FAMILY, fontWeight: FontWeight.bold)),
                    DropdownButton<String>(
                      isExpanded: true,
                      value: tempCategory,
                      hint: const Text('Todas las categorías'),
                      items: [
                        const DropdownMenuItem<String>(value: null, child: Text('Todas')),
                        ..._listaDeCategorias.map((cat) => DropdownMenuItem(value: cat, child: Text(cat, style: const TextStyle(fontFamily: APP_FONT_FAMILY)))),
                      ],
                      onChanged: (value) => setDialogState(() => tempCategory = value),
                    ),
                    const SizedBox(height: 20),
                    Text('Rango de Precio: \$${tempPriceRange.start.toStringAsFixed(0)} - \$${tempPriceRange.end.toStringAsFixed(0)}', style: const TextStyle(fontFamily: APP_FONT_FAMILY, fontWeight: FontWeight.bold)),
                    RangeSlider(
                      values: tempPriceRange,
                      min: 0,
                      max: 10000000,
                      divisions: 50,
                      labels: RangeLabels('\$${tempPriceRange.start.round()}', '\$${tempPriceRange.end.round()}'),
                      onChanged: (values) => setDialogState(() => tempPriceRange = values),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    setState(() {
                      _searchController.clear();
                      _selectedCategoryFilter = null;
                      _priceRangeFilter = null;
                    });
                    _applyFiltersAndSearch();
                  },
                  child: const Text('Limpiar Filtros', style: TextStyle(fontFamily: APP_FONT_FAMILY, color: Colors.red)),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: APP_PRIMARY_COLOR),
                  onPressed: () {
                    setState(() {
                      _selectedCategoryFilter = tempCategory;
                      _priceRangeFilter = tempPriceRange;
                    });
                    _applyFiltersAndSearch();
                  },
                  child: const Text('Aplicar', style: TextStyle(fontFamily: APP_FONT_FAMILY, color: Colors.white)),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Future<void> _mostrarModalEditarProducto(Product product) async {
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext modalBuildContext) {
        return _EditarProductoModalWidget(
          key: Key('edit_product_modal_details_${product.id}'),
          productToEdit: product,
          parentContextForSnackbars: context,
        );
      },
    );
    if(mounted) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const CompradeProductos(key: Key("backToProductsAfterEdit"))),
            (Route<dynamic> route) => false,
      );
    }
  }

  Future<void> _confirmAndDeleteProduct(Product product) async {
    bool? confirmDelete = await showDialog<bool>(
      context: context,
      builder: (BuildContext dialogContext) => AlertDialog(
        backgroundColor: const Color(0xe3a0f4fe),
        title: const Text('Confirmar Eliminación', style: TextStyle(fontFamily: APP_FONT_FAMILY, color: APP_TEXT_COLOR)),
        content: Text('¿Estás seguro de que quieres eliminar "${product.name}"? Esta acción no se puede deshacer.', style: const TextStyle(fontFamily: APP_FONT_FAMILY, color: APP_TEXT_COLOR)),
        actions: <Widget>[
          TextButton(
            child: const Text('Cancelar', style: TextStyle(fontFamily: APP_FONT_FAMILY, color: Colors.grey)),
            onPressed: () => Navigator.of(dialogContext).pop(false),
          ),
          TextButton(
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Eliminar', style: TextStyle(fontFamily: APP_FONT_FAMILY)),
            onPressed: () => Navigator.of(dialogContext).pop(true),
          ),
        ],
      ),
    );

    if (confirmDelete == true && mounted) {
      try {
        for (var imageInfo in product.images) {
          if (imageInfo.url.startsWith('https://firebasestorage.googleapis.com')) {
            await FirebaseStorage.instance.refFromURL(imageInfo.url).delete();
          }
        }
        await FirebaseFirestore.instance.collection('products').doc(product.id).delete();
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Producto eliminado correctamente.'), backgroundColor: Colors.green));
        Navigator.of(context).pop();
      } catch (e) {
        developer.log('Error al eliminar producto: $e');
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error al eliminar el producto: $e'), backgroundColor: Colors.red));
      }
    }
  }

  void _showFullScreenImage(int initialIndex) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => _FullScreenImageViewer(
          imageUrls: widget.product.images.map((img) => img.url).toList(),
          initialIndex: initialIndex,
        ),
      ),
    );
  }

  Widget _buildPageIndicator() {
    if (widget.product.images.length <= 1) return Container();
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List<Widget>.generate(widget.product.images.length, (int index) {
        return Container(
          width: 8.0,
          height: 8.0,
          margin: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 4.0),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: _currentPage == index ? APP_PRIMARY_COLOR : Colors.grey[400],
          ),
        );
      }),
    );
  }

  Widget _buildStarRating(double rating, {double size = 20.0, bool interactive = false, Function(double)? onRatingChanged}) {
    List<Widget> stars = [];
    for (int i = 1; i <= 5; i++) {
      Widget star;
      if (i <= rating) {
        star = Icon(Icons.star, color: Colors.amber, size: size);
      } else if (i - 0.5 <= rating) {
        star = Icon(Icons.star_half, color: Colors.amber, size: size);
      } else {
        star = Icon(Icons.star_border, color: Colors.amber, size: size);
      }
      if (interactive) {
        stars.add(
            GestureDetector(
              onTap: () => onRatingChanged?.call(i.toDouble()),
              child: star,
            )
        );
      } else {
        stars.add(star);
      }
    }
    return Row(mainAxisSize: MainAxisSize.min, children: stars);
  }

  Future<void> _enviarOpinion(String productId, int nuevaCalificacion, String nuevoComentario) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Debes iniciar sesión para dejar una opinión.', style: TextStyle(fontFamily: APP_FONT_FAMILY))),
      );
      return;
    }

    if (mounted) {
      setState(() {
        _isLoadingOpinion = true;
      });
    }

    try {
      String clientName = "Usuario Anónimo";
      try {
        DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
        if (userDoc.exists && userDoc.data() != null) {
          final userData = userDoc.data() as Map<String, dynamic>;
          if (userData.containsKey('userName') && userData['userName'] != null && (userData['userName'] as String).isNotEmpty) {
            clientName = userData['userName'];
          } else if (userData.containsKey('name') && userData['name'] != null && (userData['name'] as String).isNotEmpty) {
            clientName = userData['name'];
          } else if (userData.containsKey('displayName') && userData['displayName'] != null && (userData['displayName'] as String).isNotEmpty) {
            clientName = userData['displayName'];
          }
        }
      } catch (e) {
        developer.log("[Opiniones] Error al obtener documento de usuario de Firestore: $e");
      }

      if ((clientName == "Usuario Anónimo" || clientName.contains('@')) &&
          user.displayName != null &&
          user.displayName!.isNotEmpty &&
          !user.displayName!.contains('@')) {
        clientName = user.displayName!;
      }

      if (clientName == "Usuario Anónimo" || clientName.contains('@')) {
        if (user.email != null && user.email!.isNotEmpty) {
          clientName = user.email!.split('@')[0];
        }
      }

      final newOpinion = ProductOpinion(
        clientName: clientName,
        rating: nuevaCalificacion,
        comment: nuevoComentario,
      );

      final productRef = FirebaseFirestore.instance.collection('products').doc(productId);

      await FirebaseFirestore.instance.runTransaction((transaction) async {
        DocumentSnapshot productSnapshot = await transaction.get(productRef);
        if (!productSnapshot.exists) {
          throw Exception("¡El producto ya no existe!");
        }

        List<dynamic> currentOpinionsDynamic = (productSnapshot.data() as Map<String, dynamic>)['opinions'] ?? [];
        List<ProductOpinion> currentOpinions = currentOpinionsDynamic
            .map((op) => ProductOpinion.fromJson(op as Map<String, dynamic>))
            .toList();

        List<Map<String, dynamic>> updatedOpinionsMap =
        currentOpinions.map((op) => op.toJson()).toList();
        updatedOpinionsMap.add(newOpinion.toJson());

        int newQualificationsNumber = updatedOpinionsMap.length;
        double totalRatingSum = updatedOpinionsMap.fold(0.0, (sum, op) => sum + (op['rating'] as num).toDouble());
        double newAverageQualification = (newQualificationsNumber > 0) ? (totalRatingSum / newQualificationsNumber) : 0.0;

        transaction.update(productRef, {
          'opinions': updatedOpinionsMap,
          'qualification': newAverageQualification,
          'qualificationsNumber': newQualificationsNumber,
        });

        if(mounted){
          setState(() {
            widget.product.opinions.add(newOpinion);
            widget.product.qualification = newAverageQualification.round();
            widget.product.qualificationsNumber = newQualificationsNumber;
            _opinionsSectionKey = UniqueKey();
          });
        }
      });
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('¡Gracias por tu opinión!', style: TextStyle(fontFamily: APP_FONT_FAMILY)), backgroundColor: Colors.green),
      );
      if (Navigator.canPop(context)) {
        Navigator.of(context).pop();
      }

    } catch (e) {
      developer.log("Error al enviar opinión: $e");
      if(mounted){
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al enviar opinión: ${e.toString()}', style: const TextStyle(fontFamily: APP_FONT_FAMILY))),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoadingOpinion = false;
        });
      }
    }
  }

  void _mostrarDialogoDejarOpinion() {
    _opinionNuevaCalificacion = 0;
    _opinionComentarioController.clear();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
            builder: (context, setDialogState) {
              return AlertDialog(
                title: const Text('Deja tu Opinión', style: TextStyle(fontFamily: APP_FONT_FAMILY, fontWeight: FontWeight.bold)),
                backgroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
                content: SingleChildScrollView(
                  child: Form(
                    key: _formKeyOpinion,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        const Text('Califica el producto:', style: TextStyle(fontFamily: APP_FONT_FAMILY, fontSize: 16)),
                        const SizedBox(height: 8),
                        Center(
                          child: _buildStarRating(
                            _opinionNuevaCalificacion,
                            size: 30,
                            interactive: true,
                            onRatingChanged: (rating) {
                              setDialogState(() {
                                _opinionNuevaCalificacion = rating;
                              });
                            },
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _opinionComentarioController,
                          decoration: InputDecoration(
                            labelText: 'Tu comentario',
                            labelStyle: const TextStyle(fontFamily: APP_FONT_FAMILY),
                            hintText: 'Escribe tu opinión aquí...',
                            hintStyle: const TextStyle(fontFamily: APP_FONT_FAMILY),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
                            filled: true,
                            fillColor: Colors.grey[100],
                          ),
                          style: const TextStyle(fontFamily: APP_FONT_FAMILY, fontSize: 15),
                          maxLines: 3,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Por favor, escribe un comentario.';
                            }
                            return null;
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                actions: <Widget>[
                  TextButton(
                    child: const Text('Cancelar', style: TextStyle(fontFamily: APP_FONT_FAMILY, color: Colors.redAccent)),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: APP_PRIMARY_COLOR, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
                    onPressed: _isLoadingOpinion ? null : () {
                      if (_formKeyOpinion.currentState!.validate() && _opinionNuevaCalificacion > 0) {
                        _enviarOpinion(
                          widget.product.id,
                          _opinionNuevaCalificacion.toInt(),
                          _opinionComentarioController.text,
                        );
                      } else if (_opinionNuevaCalificacion == 0) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Por favor, selecciona una calificación (estrellas).', style: TextStyle(fontFamily: APP_FONT_FAMILY))),
                        );
                      }
                    },
                    child: _isLoadingOpinion
                        ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2,))
                        : const Text('Enviar Opinión', style: TextStyle(fontFamily: APP_FONT_FAMILY, color: Colors.white)),
                  ),
                ],
              );
            }
        );
      },
    );
  }

  Widget _buildHeaderInfoContainer() {
    final currentUser = FirebaseAuth.instance.currentUser;
    final bool isOwner = currentUser != null && widget.product.userId.isNotEmpty && widget.product.userId == currentUser.uid;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.92),
          borderRadius: BorderRadius.circular(12.0),
          border: Border.all(color: APP_PRIMARY_COLOR.withOpacity(0.7), width: 1.5),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              blurRadius: 6,
              offset: const Offset(0, 3),
            )
          ]
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            widget.product.name,
            style: const TextStyle(
              fontFamily: APP_FONT_FAMILY,
              fontSize: 24,
              color: APP_TEXT_COLOR,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8.0),
          Text(
            '\$${widget.product.price.toStringAsFixed(2)}',
            style: TextStyle(
              fontFamily: APP_FONT_FAMILY,
              fontSize: 22,
              color: Colors.green[700],
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Text(
                  'Vendido por: ${widget.product.seller}',
                  style: const TextStyle(
                    fontFamily: APP_FONT_FAMILY,
                    fontSize: 14,
                    color: Colors.black54,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (isOwner)
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(width: 8),
                    Tooltip(
                      message: 'Editar Producto',
                      child: IconButton(
                        icon: Image.asset('assets/images/editar.png', width: 55, height: 55),
                        onPressed: () => _mostrarModalEditarProducto(widget.product),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                        splashRadius: 20,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Tooltip(
                      message: 'Eliminar Producto',
                      child: IconButton(
                        icon: Image.asset('assets/images/eliminar.png', width: 55, height: 55),
                        onPressed: () => _confirmAndDeleteProduct(widget.product),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                        splashRadius: 20,
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      height: 45,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(5.0),
        border: Border.all(width: 1.0, color: const Color(0xff707070)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 12.0, bottom: 4.0),
              child: TextField(
                controller: _searchController,
                style: const TextStyle(fontFamily: APP_FONT_FAMILY, fontSize: 18, fontWeight: FontWeight.w700),
                decoration: const InputDecoration(
                  hintText: 'Buscar en la tienda...',
                  hintStyle: TextStyle(fontFamily: APP_FONT_FAMILY, fontSize: 16, color: Color(0xffa9a9a9), fontWeight: FontWeight.w700),
                  border: InputBorder.none,
                ),
                textInputAction: TextInputAction.search,
                onSubmitted: (_) => _applyFiltersAndSearch(),
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              FocusScope.of(context).unfocus();
              _applyFiltersAndSearch();
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Tooltip(
                message: 'Buscar',
                child: Image.asset('assets/images/busqueda1.png', width: 31, height: 31),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionContainer({required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.9),
          borderRadius: BorderRadius.circular(10.0),
          border: Border.all(color: APP_PRIMARY_COLOR.withOpacity(0.7), width: 1.5),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              blurRadius: 6,
              offset: const Offset(0, 3),
            )
          ]),
      child: child,
    );
  }

  // ==============================================================================
  // === INICIO DE LA SECCIÓN DE BUILD - CABECERA REESTRUCTURADA ===
  // ==============================================================================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: APP_PRIMARY_COLOR, // Fondo de respaldo
      body: Stack(
        children: <Widget>[
          // Imagen de fondo
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/Animal Health Fondo de Pantalla.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),

          // Contenido principal sobre el fondo
          SafeArea(
            child: Column(
              children: [
                // Cabecera personalizada (igual a la de CompradeProductos)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0).copyWith(top: 8),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 90,
                        child: Stack(
                          alignment: Alignment.center,
                          clipBehavior: Clip.none, // Permite que el logo se salga
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Row(
                                  children: [
                                    _buildHeaderIconButton(
                                      assetPath: 'assets/images/back.png',
                                      tooltip: 'Volver',
                                      width: 52.9,
                                      height: 50.0,
                                      onPressed: () => Navigator.of(context).pop(),
                                    ),
                                    const SizedBox(width: 8),
                                    _buildHeaderIconButton(
                                        assetPath: 'assets/images/listaanimales.png',
                                        width: 60.1,
                                        height: 60.0,
                                        tooltip: 'Ver Lista de Animales',
                                        onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => ListadeAnimales(key: const Key('AnimalListFromDetails'))))
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    _buildHeaderIconButton(assetPath: 'assets/images/carrito.png', tooltip: 'Ver Carrito', width: 47.2, height: 50.0, onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => Carritodecompras(key: const Key('CartFromDetails'))))),
                                    const SizedBox(width: 8),
                                    _buildHeaderIconButton(assetPath: 'assets/images/help.png', tooltip: 'Ayuda', width: 40.5, height: 50.0, onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => Ayuda(key: const Key('HelpFromDetails'))))),
                                    const SizedBox(width: 8),
                                    _buildHeaderIconButton(assetPath: 'assets/images/settingsbutton.png', tooltip: 'Configuración', width: 47.2, height: 50.0, onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => Configuraciones(key: const Key('SettingsFromDetails'), authService: AuthService())))),
                                  ],
                                ),
                              ],
                            ),
                            Positioned(
                              top: 40.0,
                              child: GestureDetector(
                                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => Home(key: const Key('HomeFromDetails')))),
                                child: Tooltip(
                                  message: 'Ir a Inicio',
                                  child: Container(
                                    height: 74,
                                    width: 74,
                                    decoration: BoxDecoration(
                                      image: const DecorationImage(image: AssetImage('assets/images/logo.png'), fit: BoxFit.cover),
                                      borderRadius: BorderRadius.circular(15.0),
                                      border: Border.all(color: const Color(0xff000000)),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 5),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          _buildProfileIcon(), // Icono de perfil
                        ],
                      ),
                      const SizedBox(height: 15),
                      Row(
                        children: [
                          Expanded(
                            child: _buildSearchBar(),
                          ),
                          const SizedBox(width: 8),
                          Tooltip(
                            message: 'Filtros',
                            child: IconButton(
                              style: IconButton.styleFrom(
                                backgroundColor: Colors.white,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                              ),
                              icon: const Icon(Icons.filter_list_rounded, color: APP_PRIMARY_COLOR),
                              onPressed: _showFilterDialog,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                // Contenido desplazable
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 100.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        if (widget.product.images.isNotEmpty)
                          Column(
                            children: [
                              Container(
                                height: 250.0,
                                decoration: BoxDecoration(
                                    color: Colors.grey[200],
                                    borderRadius: BorderRadius.circular(16.0),
                                    border: Border.all(color: APP_PRIMARY_COLOR.withOpacity(0.5), width: 2)),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(14.0),
                                  child: PageView.builder(
                                    controller: _pageController,
                                    itemCount: widget.product.images.length,
                                    itemBuilder: (context, index) {
                                      final productImage = widget.product.images[index];
                                      return GestureDetector(
                                        onTap: () => _showFullScreenImage(index),
                                        child: CachedNetworkImage(
                                          imageUrl: productImage.url,
                                          fit: BoxFit.cover,
                                          placeholder: (context, url) => const Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(APP_PRIMARY_COLOR))),
                                          errorWidget: (context, url, error) => const Icon(Icons.broken_image, size: 60, color: Colors.grey),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ),
                              _buildPageIndicator(),
                            ],
                          )
                        else
                          Container(
                            height: 250.0,
                            decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(16.0), border: Border.all(color: APP_PRIMARY_COLOR.withOpacity(0.5), width: 2)),
                            child: const Center(child: Icon(Icons.inventory_2_outlined, size: 80, color: Colors.grey)),
                          ),
                        const SizedBox(height: 20.0),
                        _buildHeaderInfoContainer(),
                        const SizedBox(height: 16.0),
                        _buildSectionContainer(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('Información del Producto:', style: TextStyle(fontFamily: APP_FONT_FAMILY, fontSize: 18, color: APP_TEXT_COLOR, fontWeight: FontWeight.w700)),
                                const SizedBox(height: 8.0),
                                Text(widget.product.description.isNotEmpty ? widget.product.description : 'No hay descripción disponible.', style: const TextStyle(fontFamily: APP_FONT_FAMILY, fontSize: 16, color: APP_TEXT_COLOR, height: 1.4)),
                              ],
                            )),
                        const SizedBox(height: 16.0),
                        _buildSectionContainer(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text('Calificación:', style: TextStyle(fontFamily: APP_FONT_FAMILY, fontSize: 18, color: APP_TEXT_COLOR, fontWeight: FontWeight.w700)),
                                    TextButton.icon(
                                      icon: const Icon(Icons.edit_note, color: APP_PRIMARY_COLOR, size: 22),
                                      label: const Text("Dejar opinión", style: TextStyle(fontFamily: APP_FONT_FAMILY, color: APP_PRIMARY_COLOR, fontSize: 15, fontWeight: FontWeight.w600)),
                                      onPressed: _mostrarDialogoDejarOpinion,
                                      style: TextButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 4)),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 4.0),
                                Row(
                                  children: [
                                    _buildStarRating(widget.product.qualification.toDouble(), size: 28),
                                    const SizedBox(width: 8),
                                    Text('(${widget.product.qualificationsNumber} ${widget.product.qualificationsNumber == 1 ? "opinión" : "opiniones"})', style: const TextStyle(fontFamily: APP_FONT_FAMILY, fontSize: 14, color: Colors.black54)),
                                  ],
                                ),
                              ],
                            )),
                        const SizedBox(height: 16.0),
                        KeyedSubtree(
                          key: _opinionsSectionKey,
                          child: widget.product.opinions.isNotEmpty
                              ? _buildSectionContainer(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text('Opiniones de Clientes:', style: TextStyle(fontFamily: APP_FONT_FAMILY, fontSize: 18, color: APP_TEXT_COLOR, fontWeight: FontWeight.w700)),
                                  const SizedBox(height: 10.0),
                                  ListView.separated(
                                    shrinkWrap: true,
                                    physics: const NeverScrollableScrollPhysics(),
                                    itemCount: widget.product.opinions.length,
                                    itemBuilder: (context, index) {
                                      final opinion = widget.product.opinions.reversed.toList()[index];
                                      return Padding(
                                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                Expanded(child: Text(opinion.clientName, style: const TextStyle(fontFamily: APP_FONT_FAMILY, fontSize: 16, fontWeight: FontWeight.bold), maxLines: 1, overflow: TextOverflow.ellipsis)),
                                                _buildStarRating(opinion.rating.toDouble(), size: 16),
                                              ],
                                            ),
                                            const SizedBox(height: 4.0),
                                            Text(opinion.comment, style: const TextStyle(fontFamily: APP_FONT_FAMILY, fontSize: 15)),
                                          ],
                                        ),
                                      );
                                    },
                                    separatorBuilder: (context, index) => const Divider(thickness: 0.7, color: Colors.grey),
                                  ),
                                ],
                              ))
                              : _buildSectionContainer(
                              child: const Center(
                                child: Text('Aún no hay opiniones para este producto. ¡Sé el primero!', style: TextStyle(fontFamily: APP_FONT_FAMILY, fontSize: 15, color: Colors.black54), textAlign: TextAlign.center),
                              )
                          ),
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          Positioned(
            left: 16,
            right: 16,
            bottom: 16,
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    icon: Image.asset('assets/images/carrito.png', height: 35.0),
                    label: const Text('Agregar al Carrito', style: TextStyle(fontFamily: APP_FONT_FAMILY, fontSize: 15, fontWeight: FontWeight.w700, color: APP_TEXT_COLOR)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14.0),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0), side: const BorderSide(color: APP_PRIMARY_COLOR, width: 1.5)),
                      elevation: 3,
                    ),
                    onPressed: () {
                      _cartService.addToCart(widget.product);
                      if (!mounted) return;
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('${widget.product.name} agregado al carrito', style: const TextStyle(fontFamily: APP_FONT_FAMILY)),
                          duration: const Duration(seconds: 2),
                          action: SnackBarAction(
                            label: 'VER CARRITO',
                            textColor: Colors.white,
                            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => Carritodecompras(key: const Key('CartFromDetailsSnackbar')))),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: APP_PRIMARY_COLOR,
                      padding: const EdgeInsets.symmetric(vertical: 14.0),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0), side: const BorderSide(color: Colors.white70, width: 1.0)),
                      elevation: 3,
                    ),
                    onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => ComprarAhora(key: Key("buyNow_${widget.product.id}"), product: widget.product))),
                    child: const Text('Comprar Ahora', style: TextStyle(fontFamily: APP_FONT_FAMILY, fontSize: 15, fontWeight: FontWeight.w700, color: Colors.white)),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderIconButton({required String assetPath, required String tooltip, required VoidCallback onPressed, required double width, required double height}) {
    return Tooltip(
      message: tooltip,
      child: GestureDetector(
        onTap: onPressed,
        child: Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            image: DecorationImage(image: AssetImage(assetPath), fit: BoxFit.fill),
          ),
        ),
      ),
    );
  }

  Widget _buildProfileIcon() {
    return GestureDetector(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => PerfilPublico(key: const Key('ProfileFromDetails')))),
      child: Tooltip(
        message: 'Ver Perfil Público',
        child: StreamBuilder<DocumentSnapshot>(
          stream: FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser?.uid).snapshots(),
          builder: (context, snapshot) {
            String? profilePhotoUrl;
            if (FirebaseAuth.instance.currentUser?.photoURL != null) {
              profilePhotoUrl = FirebaseAuth.instance.currentUser!.photoURL;
            } else if (snapshot.hasData && snapshot.data!.exists) {
              profilePhotoUrl = (snapshot.data!.data() as Map<String, dynamic>?)?['profilePhotoUrl'];
            }

            return Container(
              width: 60.0,
              height: 60.0,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(10.0),
                border: Border.all(color: APP_TEXT_COLOR, width: 0.5),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10.0),
                child: profilePhotoUrl != null
                    ? CachedNetworkImage(
                  imageUrl: profilePhotoUrl,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => const Center(child: CircularProgressIndicator(strokeWidth: 2.0)),
                  errorWidget: (context, url, error) => const Icon(Icons.person, size: 40.0, color: Colors.grey),
                )
                    : const Icon(Icons.person, size: 40.0, color: Colors.grey),
              ),
            );
          },
        ),
      ),
    );
  }
}

// ==============================================================================
// === WIDGETS PRIVADOS PARA ESTE ARCHIVO (SOLUCIÓN DE ENCAPSULACIÓN) ===
// ==============================================================================

class _FullScreenImageViewer extends StatelessWidget {
  final List<String> imageUrls;
  final int initialIndex;

  const _FullScreenImageViewer({
    required this.imageUrls,
    required this.initialIndex,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          PageView.builder(
            controller: PageController(initialPage: initialIndex),
            itemCount: imageUrls.length,
            itemBuilder: (context, index) {
              return InteractiveViewer(
                panEnabled: true,
                minScale: 1.0,
                maxScale: 4.0,
                child: CachedNetworkImage(
                  imageUrl: imageUrls[index],
                  fit: BoxFit.contain,
                  placeholder: (context, url) => const Center(child: CircularProgressIndicator(color: Colors.white)),
                  errorWidget: (context, url, error) => const Center(child: Icon(Icons.error, color: Colors.red, size: 50)),
                ),
              );
            },
          ),
          Positioned(
            top: 40,
            right: 16,
            child: IconButton(
              icon: const Icon(Icons.close, color: Colors.white, size: 30),
              onPressed: () => Navigator.of(context).pop(),
              style: IconButton.styleFrom(
                backgroundColor: Colors.black.withOpacity(0.5),
              ),
            ),
          ),
        ],
      ),
    );
  }
}


class _EditarProductoModalWidget extends StatefulWidget {
  final Product productToEdit;
  final BuildContext parentContextForSnackbars;

  const _EditarProductoModalWidget({
    super.key,
    required this.productToEdit,
    required this.parentContextForSnackbars,
  });

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
  final List<XFile> _newImageFiles = [];
  bool _isUploading = false;
  final ImagePicker _picker = ImagePicker();

  final List<String> _listaDeCategorias = [
    'Alimentos', 'Juguetes', 'Accesorios (Correas, Collares, Camas)',
    'Productos de Aseo e Higiene', 'Medicamentos y Salud (Antipulgas, Vitaminas)',
    'Snacks y Premios', 'Ropa', 'Transportadoras y Jaulas', 'Otros',
  ];

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

      final String productName = _nameController.text.trim();
      final List<String> searchKeywords = productName
          .toLowerCase()
          .replaceAll(RegExp(r'[^\w\s]'), '')
          .split(' ')
          .where((s) => s.isNotEmpty)
          .toSet()
          .toList();

      Map<String, dynamic> updatedData = {
        'name': productName,
        'searchKeywords': searchKeywords,
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

  Widget _buildCategoryDropdown() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: SizedBox(
        height: 60.0,
        child: Stack(
          alignment: Alignment.centerLeft,
          children: [
            DropdownButtonFormField<String>(
              value: _listaDeCategorias.contains(_categoryController.text) ? _categoryController.text : null,
              hint: const Text("Selecciona una categoría", style: TextStyle(fontFamily: APP_FONT_FAMILY, color: Colors.black54)),
              isExpanded: true,
              items: _listaDeCategorias.map((String category) {
                return DropdownMenuItem<String>(
                  value: category,
                  child: Text(category, style: const TextStyle(fontFamily: APP_FONT_FAMILY, fontSize: 18, color: APP_TEXT_COLOR)),
                );
              }).toList(),
              onChanged: (newValue) {
                setState(() {
                  _categoryController.text = newValue!;
                });
              },
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
                contentPadding: const EdgeInsets.only(left: 55.0, right: 16.0),
              ),
              validator: (value) => value == null || value.isEmpty ? 'Debes seleccionar una categoría.' : null,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Tooltip(
                message: 'Categoría del producto',
                child: Image.asset('assets/images/category.png', width: 40.0, height: 40.0, fit: BoxFit.contain),
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
                        _buildCategoryDropdown(),
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