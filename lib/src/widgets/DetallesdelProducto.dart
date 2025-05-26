import 'package:flutter/material.dart';
import 'package:adobe_xd/pinned.dart';
import 'package:adobe_xd/page_link.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:developer' as developer;
import 'dart:async'; // Para Future

import './Ayuda.dart';
import './PerfilPublico.dart';
import './Configuracion.dart';
import './ListadeAnimales.dart';
import './Carritodecompras.dart';
import './ComprarAhora.dart';
import './Home.dart';
import './CompradeProductos.dart'; // Para el botón de volver
import '../services/auth_service.dart';
import '../models/products.dart';
import '../services/cart_service.dart';

const Color APP_PRIMARY_COLOR = Color(0xff4ec8dd);
const Color APP_TEXT_COLOR = Color(0xff000000);
const String APP_FONT_FAMILY = 'Comic Sans MS';

class DetallesdelProducto extends StatefulWidget {
  final Product product;

  const DetallesdelProducto({
    Key? key,
    required this.product,
  }) : super(key: key);

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
  // No se necesita _searchFieldController aquí ya que Autocomplete lo maneja internamente
  // y lo pasa a fieldViewBuilder.

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
    super.dispose();
  }

  Future<Iterable<Product>> _fetchProductSuggestions(String query) async {
    if (query.trim().isEmpty) {
      return const Iterable<Product>.empty();
    }
    final String lowerCaseQuery = query.toLowerCase();

    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('products')
      // Considera optimizar esta consulta para producción
      // .where('name_lowercase', isGreaterThanOrEqualTo: lowerCaseQuery)
      // .where('name_lowercase', isLessThanOrEqualTo: lowerCaseQuery + '\uf8ff')
      // .limit(10) // Limitar resultados
          .get();

      if (querySnapshot.docs.isEmpty) {
        return const Iterable<Product>.empty();
      }

      List<Product> products = [];
      for (var doc in querySnapshot.docs) {
        try {
          // ---------- CORRECCIÓN APLICADA AQUÍ ----------
          final data = doc.data();
          final id = doc.id;
          final product = Product.fromFirestore(data, id);
          // ---------- FIN DE LA CORRECCIÓN ----------
          if (product.name.toLowerCase().contains(lowerCaseQuery)) {
            products.add(product);
          }
        } catch (e) {
          developer.log("Error parsing product ${doc.id} for suggestions: $e. Data: ${doc.data()}");
        }
      }
      return products.take(5); // Muestra un máximo de 5 sugerencias
    } catch (e) {
      developer.log('Error fetching product suggestions: $e');
      return const Iterable<Product>.empty();
    }
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
                    child: _isLoadingOpinion
                        ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2,))
                        : const Text('Enviar Opinión', style: TextStyle(fontFamily: APP_FONT_FAMILY, color: Colors.white)),
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
                  ),
                ],
              );
            }
        );
      },
    );
  }


  Widget _buildHeaderInfoContainer() {
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
          Text(
            'Vendido por: ${widget.product.seller}',
            style: const TextStyle(
              fontFamily: APP_FONT_FAMILY,
              fontSize: 14,
              color: Colors.black54,
            ),
          ),
        ],
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
                  pageBuilder: () => CompradeProductos(key: const Key("CompradeProductosDesdeDetalles")),
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
                  pageBuilder: () => Home(key: const Key('HomeDesdeDetalles')),
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
                  pageBuilder: () => Carritodecompras(key: const Key('CarritodecomprasDesdeDetalles')),
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
                  pageBuilder: () => Ayuda(key: const Key('AyudaDesdeDetalles')),
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
                  pageBuilder: () => Configuraciones(key: const Key('SettingsDesdeDetalles'), authService: AuthService()),
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
                final currentUser = FirebaseAuth.instance.currentUser;
                if (currentUser?.photoURL != null && currentUser!.photoURL!.isNotEmpty) {
                  profilePhotoUrl = currentUser.photoURL;
                } else if (snapshot.hasData && snapshot.data!.exists) {
                  try {
                    profilePhotoUrl = snapshot.data!.get('profilePhotoUrl') as String?;
                  } catch (e) {
                    developer.log("Error al obtener profilePhotoUrl de Firestore: $e");
                    profilePhotoUrl = null;
                  }
                }
                return PageLink(
                  links: [
                    PageLinkInfo(
                      transition: LinkTransition.Fade,
                      ease: Curves.easeOut,
                      duration: 0.3,
                      pageBuilder: () => PerfilPublico(key: const Key('PerfilPublicoDesdeDetalles')),
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
                                valueColor: AlwaysStoppedAnimation<Color>(APP_PRIMARY_COLOR))),
                        errorWidget: (context, url, error) =>
                        const Icon(Icons.person, size: 40.0, color: Colors.grey),
                      )
                          : const Icon(Icons.person, size: 40.0, color: Colors.grey),
                    ),
                  ),
                );
              },
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
                  pageBuilder: () => ListadeAnimales(key: const Key('ListadeAnimalesDesdeDetalles')),
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
            Pin(middle: 0.5, size: 280.0),
            Pin(size: 45.0, start: 148.0),
            child: Autocomplete<Product>(
              fieldViewBuilder: (BuildContext context,
                  TextEditingController fieldTextEditingController,
                  FocusNode fieldFocusNode,
                  VoidCallback onFieldSubmitted) {
                return Container(
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
                        child: TextFormField(
                          controller: fieldTextEditingController,
                          focusNode: fieldFocusNode,
                          textAlignVertical: TextAlignVertical.center,
                          style: const TextStyle(
                            fontFamily: APP_FONT_FAMILY,
                            fontSize: 16,
                            color: APP_TEXT_COLOR,
                          ),
                          decoration: const InputDecoration(
                            hintText: 'Buscar producto...',
                            hintStyle: TextStyle(
                              fontFamily: APP_FONT_FAMILY,
                              fontSize: 16,
                              color: Colors.grey,
                            ),
                            border: InputBorder.none,
                            isDense: true,
                            contentPadding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 2.0),
                          ),
                          textInputAction: TextInputAction.search,
                          onFieldSubmitted: (value) {
                            onFieldSubmitted();
                          },
                        ),
                      ),
                      if (fieldTextEditingController.text.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(right: 4.0),
                          child: IconButton(
                            icon: Icon(Icons.clear, color: Colors.grey[600], size: 20),
                            onPressed: () {
                              fieldTextEditingController.clear();
                            },
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(minWidth: 24, minHeight: 24),
                            splashRadius: 18,
                          ),
                        ),
                    ],
                  ),
                );
              },
              optionsBuilder: (TextEditingValue textEditingValue) async {
                if (textEditingValue.text.trim().isEmpty) {
                  return const Iterable<Product>.empty();
                }
                return await _fetchProductSuggestions(textEditingValue.text);
              },
              optionsViewBuilder: (BuildContext context,
                  AutocompleteOnSelected<Product> onSelected,
                  Iterable<Product> options) {
                return Align(
                  alignment: Alignment.topLeft,
                  child: Material(
                    elevation: 4.0,
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5.0),
                        side: BorderSide(color: Colors.grey.shade300)
                    ),
                    child: Container(
                      constraints: const BoxConstraints(maxHeight: 220),
                      width: 280.0,
                      child: ListView.builder(
                        padding: EdgeInsets.zero,
                        shrinkWrap: true,
                        itemCount: options.length,
                        itemBuilder: (BuildContext context, int index) {
                          final Product option = options.elementAt(index);
                          return InkWell(
                            onTap: () {
                              onSelected(option);
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                              child: Text(
                                option.name,
                                style: const TextStyle(fontFamily: APP_FONT_FAMILY, fontSize: 15),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                );
              },
              onSelected: (Product selection) {
                developer.log('Producto seleccionado del Autocomplete: ${selection.name}');
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DetallesdelProducto(
                      key: Key('Detalles_${selection.id}'),
                      product: selection,
                    ),
                  ),
                );
                FocusScope.of(context).unfocus();
              },
              displayStringForOption: (Product option) => option.name,
            ),
          ),

          Positioned.fill(
            top: 205.0,
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
                                return CachedNetworkImage(
                                  imageUrl: productImage.url,
                                  fit: BoxFit.cover,
                                  placeholder: (context, url) => const Center(
                                    child: CircularProgressIndicator(
                                      valueColor: AlwaysStoppedAnimation<Color>(APP_PRIMARY_COLOR),
                                    ),
                                  ),
                                  errorWidget: (context, url, error) =>
                                  const Icon(Icons.broken_image, size: 60, color: Colors.grey),
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
                      decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(16.0),
                          border: Border.all(color: APP_PRIMARY_COLOR.withOpacity(0.5), width: 2)),
                      child: const Center(
                        child: Icon(Icons.inventory_2_outlined, size: 80, color: Colors.grey),
                      ),
                    ),
                  const SizedBox(height: 20.0),
                  _buildHeaderInfoContainer(),
                  const SizedBox(height: 16.0),
                  _buildSectionContainer(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Información del Producto:',
                            style: TextStyle(
                              fontFamily: APP_FONT_FAMILY,
                              fontSize: 18,
                              color: APP_TEXT_COLOR,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 8.0),
                          Text(
                            widget.product.description.isNotEmpty ? widget.product.description : 'No hay descripción disponible.',
                            style: const TextStyle(
                              fontFamily: APP_FONT_FAMILY,
                              fontSize: 16,
                              color: APP_TEXT_COLOR,
                              height: 1.4,
                            ),
                          ),
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
                              const Text(
                                'Calificación:',
                                style: TextStyle(
                                  fontFamily: APP_FONT_FAMILY,
                                  fontSize: 18,
                                  color: APP_TEXT_COLOR,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
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
                              Text(
                                '(${widget.product.qualificationsNumber} ${widget.product.qualificationsNumber == 1 ? "opinión" : "opiniones"})',
                                style: const TextStyle(fontFamily: APP_FONT_FAMILY, fontSize: 14, color: Colors.black54),
                              ),
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
                            const Text(
                              'Opiniones de Clientes:',
                              style: TextStyle(
                                fontFamily: APP_FONT_FAMILY,
                                fontSize: 18,
                                color: APP_TEXT_COLOR,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: 10.0),
                            ListView.separated(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: widget.product.opinions.length,
                              itemBuilder: (context, index) {
                                final opinion = widget.product.opinions.reversed.toList()[index];
                                String clientDisplayName = opinion.clientName;
                                return Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Expanded(
                                            child: Text(
                                              clientDisplayName,
                                              style: const TextStyle(
                                                fontFamily: APP_FONT_FAMILY,
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                              ),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                          _buildStarRating(opinion.rating.toDouble(), size: 16),
                                        ],
                                      ),
                                      const SizedBox(height: 4.0),
                                      Text(
                                        opinion.comment,
                                        style: const TextStyle(fontFamily: APP_FONT_FAMILY, fontSize: 15),
                                      ),
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
                          child: Text(
                            'Aún no hay opiniones para este producto. ¡Sé el primero!',
                            style: TextStyle(fontFamily: APP_FONT_FAMILY, fontSize: 15, color: Colors.black54),
                            textAlign: TextAlign.center,
                          ),
                        )
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
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
                    icon: Image.asset(
                      'assets/images/carrito.png',
                      height: 35.0,
                    ),
                    label: const Text(
                      'Agregar al Carrito',
                      style: TextStyle(
                          fontFamily: APP_FONT_FAMILY,
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: APP_TEXT_COLOR),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        side: const BorderSide(color: APP_PRIMARY_COLOR, width: 1.5),
                      ),
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
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => Carritodecompras(key: const Key('CarritodecomprasDesdeSnackbarDetalles'))),
                              );
                            },
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    child: const Text(
                      'Comprar Ahora',
                      style: TextStyle(
                          fontFamily: APP_FONT_FAMILY,
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: Colors.white),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: APP_PRIMARY_COLOR,
                      padding: const EdgeInsets.symmetric(vertical: 14.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        side: const BorderSide(color: Colors.white70, width: 1.0),
                      ),
                      elevation: 3,
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ComprarAhora(
                              key: Key('ComprarAhora_${widget.product.id}'),
                              product: widget.product,
                            )),
                      );
                    },
                  ),
                ),
              ],
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
}