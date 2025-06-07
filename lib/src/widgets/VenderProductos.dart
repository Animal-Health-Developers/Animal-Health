import 'dart:io'; // Para File
import 'dart:typed_data'; // Para Uint8List
import 'package:flutter/foundation.dart' show kIsWeb; // Para verificar si es web
import 'package:flutter/material.dart';
import 'package:adobe_xd/pinned.dart';
import 'package:adobe_xd/page_link.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:developer' as developer;

// Tus importaciones de páginas
import './Ayuda.dart';
import './PerfilPublico.dart';
import './Configuracion.dart';
import './ListadeAnimales.dart';
import './CompradeProductos.dart';
import './Carritodecompras.dart';
import './Home.dart';
import '../services/auth_service.dart';
import '../models/products.dart'; // Asegúrate que ProductImage y Product estén definidos correctamente

const Color APP_PRIMARY_COLOR = Color(0xff4ec8dd);
const Color APP_TEXT_COLOR = Color(0xff000000);
const String APP_FONT_FAMILY = 'Comic Sans MS';

// Helper class para manejar la previsualización y datos de imagen
class _ImageWrapper {
  final File? file; // Para móvil/escritorio
  final Uint8List? bytes; // Para web y previsualización
  final String name; // Nombre del archivo

  _ImageWrapper({this.file, this.bytes, required this.name});
}


class VenderProductos extends StatefulWidget {
  const VenderProductos({
    Key? key,
  }) : super(key: key);

  @override
  _VenderProductosState createState() => _VenderProductosState();
}

class _VenderProductosState extends State<VenderProductos> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _precioController = TextEditingController();
  final TextEditingController _cantidadController = TextEditingController();
  final TextEditingController _empresaController = TextEditingController();
  final TextEditingController _descripcionController = TextEditingController();

  List<_ImageWrapper> _selectedImageWrappers = [];

  bool _isUploading = false;
  String? _categoriaSeleccionada;
  final List<String> _listaDeCategorias = [
    'Alimentos', 'Juguetes', 'Accesorios (Correas, Collares, Camas)',
    'Productos de Aseo e Higiene', 'Medicamentos y Salud (Antipulgas, Vitaminas)',
    'Snacks y Premios', 'Ropa', 'Transportadoras y Jaulas', 'Otros',
  ];

  final ImagePicker _picker = ImagePicker();

  /// Genera una lista de palabras clave (keywords) a partir de una cadena de texto (nombre del producto).
  /// Estas keywords se usarán para la búsqueda en Firestore.
  List<String> _generateSearchKeywords(String name) {
    return name
        .toLowerCase()
        .replaceAll(RegExp(r'[^\w\s]'), '') // Elimina puntuación y símbolos
        .split(' ')
        .where((word) => word.isNotEmpty)
        .toSet() // Usa Set para asegurar que las palabras clave sean únicas
        .toList();
  }

  Future<void> _seleccionarImagenes() async {
    final List<XFile> pickedFiles = await _picker.pickMultiImage(imageQuality: 70);

    if (pickedFiles.isNotEmpty) {
      List<_ImageWrapper> newWrappers = [];
      for (XFile pickedFile in pickedFiles) {
        if (kIsWeb) {
          final bytes = await pickedFile.readAsBytes();
          newWrappers.add(_ImageWrapper(bytes: bytes, name: pickedFile.name));
        } else {
          newWrappers.add(_ImageWrapper(file: File(pickedFile.path), name: pickedFile.name));
        }
      }
      if (mounted) {
        setState(() {
          _selectedImageWrappers.addAll(newWrappers);
        });
      }
    }
  }

  void _removerImagenSeleccionada(int index) {
    if (mounted) {
      setState(() {
        _selectedImageWrappers.removeAt(index);
      });
    }
  }

  Future<List<Map<String, String>>> _subirImagenes() async {
    if (FirebaseAuth.instance.currentUser == null || _selectedImageWrappers.isEmpty) {
      return [];
    }

    List<Map<String, String>> productImagesData = [];
    String userId = FirebaseAuth.instance.currentUser!.uid;

    for (int i = 0; i < _selectedImageWrappers.length; i++) {
      final wrapper = _selectedImageWrappers[i];
      String cleanedOriginalName = wrapper.name.replaceAll(RegExp(r'[^\w\s.-]'), '').replaceAll(' ', '_');
      String imageName = '${DateTime.now().millisecondsSinceEpoch}_${i}_$cleanedOriginalName';
      String fileName = 'product_images/$userId/$imageName';

      try {
        UploadTask uploadTask;
        if (kIsWeb) {
          if (wrapper.bytes == null) continue;
          final metadata = SettableMetadata(contentType: 'image/jpeg');
          uploadTask = FirebaseStorage.instance.ref(fileName).putData(wrapper.bytes!, metadata);
        } else {
          if (wrapper.file == null) continue;
          uploadTask = FirebaseStorage.instance.ref(fileName).putFile(wrapper.file!);
        }

        TaskSnapshot snapshot = await uploadTask;
        String downloadUrl = await snapshot.ref.getDownloadURL();
        String publicId = snapshot.ref.fullPath;
        // Creamos un mapa simple para la imagen, que es como Firestore lo espera
        productImagesData.add({'publicId': publicId, 'url': downloadUrl});
      } catch (e) {
        developer.log("Error al subir imagen ${wrapper.name}: $e");
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error al subir imagen ${wrapper.name}', style: const TextStyle(fontFamily: APP_FONT_FAMILY))),
          );
        }
      }
    }
    return productImagesData;
  }


  // ==============================================================================
  // ===== INICIO: FUNCIÓN _publicarProducto CORREGIDA PARA INCLUIR KEYWORDS =====
  // ==============================================================================
  Future<void> _publicarProducto() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    if (_categoriaSeleccionada == null || _categoriaSeleccionada!.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, selecciona una categoría', style: TextStyle(fontFamily: APP_FONT_FAMILY))),
      );
      return;
    }
    if (FirebaseAuth.instance.currentUser == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Debes iniciar sesión para vender productos', style: TextStyle(fontFamily: APP_FONT_FAMILY))),
      );
      return;
    }
    if (_selectedImageWrappers.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, selecciona al menos una imagen', style: TextStyle(fontFamily: APP_FONT_FAMILY))),
      );
      return;
    }

    setState(() {
      _isUploading = true;
    });

    // Subimos las imágenes y obtenemos una lista de mapas con sus datos
    List<Map<String, String>> uploadedImagesData = await _subirImagenes();

    if (uploadedImagesData.isEmpty && _selectedImageWrappers.isNotEmpty) {
      developer.log("Error: Se intentaron subir imágenes pero ninguna tuvo éxito.");
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error al subir imágenes. Inténtalo de nuevo.', style: TextStyle(fontFamily: APP_FONT_FAMILY))),
        );
        setState(() {
          _isUploading = false;
        });
      }
      return;
    }

    try {
      // 1. Obtener el nombre del producto
      final String productName = _nombreController.text.trim();

      // 2. ¡LA PARTE MÁS IMPORTANTE! Generar las palabras clave para la búsqueda.
      final List<String> searchKeywords = _generateSearchKeywords(productName);

      // 3. Crear el mapa de datos que se guardará en Firestore
      final Map<String, dynamic> productData = {
        'name': productName,
        'searchKeywords': searchKeywords, // <-- ¡CAMPO AÑADIDO! Esto hace que el producto sea buscable.
        'price': double.tryParse(_precioController.text.trim()) ?? 0.0,
        'description': _descripcionController.text.trim(),
        'category': _categoriaSeleccionada!,
        'seller': _empresaController.text.trim(),
        'stock': int.tryParse(_cantidadController.text.trim()) ?? 0,
        'images': uploadedImagesData, // La lista de mapas de imágenes
        'userId': FirebaseAuth.instance.currentUser!.uid,
        'creationDate': FieldValue.serverTimestamp(),
        // Añadimos valores por defecto para los campos de calificación
        'qualification': 0.0,
        'qualificationsNumber': 0,
      };

      // 4. Guardar el mapa de datos directamente en Firestore
      await FirebaseFirestore.instance.collection('products').add(productData);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('¡Producto publicado con éxito!', style: TextStyle(fontFamily: APP_FONT_FAMILY)), backgroundColor: Colors.green),
        );
        _nombreController.clear();
        _precioController.clear();
        _cantidadController.clear();
        _empresaController.clear();
        _descripcionController.clear();
        setState(() {
          _selectedImageWrappers.clear();
          _categoriaSeleccionada = null;
        });
        // Navegar a CompradeProductos después de publicar
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const CompradeProductos(key: Key('CompradeProductosPostVenta'))),
        );
      }

    } catch (e) {
      developer.log("Error al publicar producto: $e");
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al publicar producto: $e', style: const TextStyle(fontFamily: APP_FONT_FAMILY))),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isUploading = false;
        });
      }
    }
  }
  // ============================================================================
  // ===== FIN: FUNCIÓN _publicarProducto CORREGIDA =============================
  // ============================================================================


  // --- El resto del código no necesita cambios, ya que la UI y la lógica de los widgets son correctas ---

  Widget _buildTextField({
    required TextEditingController controller,
    required String labelText,
    required String originalHint,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
    int maxLines = 1,
    required String iconPath,
    required String tooltipMessage,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: SizedBox(
        height: maxLines > 1 ? null : 60.0,
        child: Stack(
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
                hintText: originalHint,
                hintStyle: const TextStyle(fontFamily: APP_FONT_FAMILY, fontSize: 18, color: Colors.grey, fontWeight: FontWeight.w700),
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
                contentPadding: const EdgeInsets.only(left: 50.0, top: 15, bottom: 15, right: 16.0),
              ),
              validator: validator ??
                      (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, ingresa $labelText';
                    }
                    if (labelText.toLowerCase().contains("precio") || labelText.toLowerCase().contains("cantidad")) {
                      if (double.tryParse(value) == null) {
                        return 'Por favor, ingresa un número válido';
                      }
                      if (double.parse(value) < 0) {
                        return 'El valor no puede ser negativo';
                      }
                    }
                    return null;
                  },
            ),
            Positioned(
              left: 5,
              top: maxLines > 1 ? 10 : 0,
              bottom: maxLines > 1 ? null : 10,
              child: Tooltip(
                message: tooltipMessage,
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    width: 37.0,
                    height: 40.0,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(iconPath),
                        fit: BoxFit.fill,
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

  Widget _buildCategoryDropdown({required String iconPath, required String tooltipMessage}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: SizedBox(
        height: 60.0,
        child: Stack(
          children: [
            DropdownButtonFormField<String>(
              value: _categoriaSeleccionada,
              isExpanded: true,
              decoration: InputDecoration(
                labelText: 'Categoría',
                labelStyle: const TextStyle(fontFamily: APP_FONT_FAMILY, fontSize: 18, color: Colors.black54),
                hintText: 'Selecciona una categoría',
                hintStyle: const TextStyle(fontFamily: APP_FONT_FAMILY, fontSize: 18, color: Colors.grey, fontWeight: FontWeight.w700),
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
                contentPadding: const EdgeInsets.only(left: 50.0, top: 15, bottom: 15, right: 16.0),
              ),
              icon: const Icon(Icons.arrow_drop_down_circle, color: APP_PRIMARY_COLOR),
              style: const TextStyle(fontFamily: APP_FONT_FAMILY, fontSize: 18, color: APP_TEXT_COLOR),
              dropdownColor: Colors.white,
              items: _listaDeCategorias.map((String category) {
                return DropdownMenuItem<String>(
                  value: category,
                  child: Text(category, style: const TextStyle(fontFamily: APP_FONT_FAMILY, fontSize: 18, color: APP_TEXT_COLOR)),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  _categoriaSeleccionada = newValue;
                });
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor, selecciona una categoría';
                }
                return null;
              },
            ),
            Positioned(
              left: 5,
              top: 0,
              bottom: 10,
              child: Tooltip(
                message: tooltipMessage,
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    width: 40.0,
                    height: 40.0,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(iconPath),
                        fit: BoxFit.fill,
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

  Widget _buildSelectedImagesPreview() {
    if (_selectedImageWrappers.isEmpty) {
      return const SizedBox.shrink();
    }
    return Container(
      height: 120,
      margin: const EdgeInsets.symmetric(vertical: 10.0),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _selectedImageWrappers.length,
        itemBuilder: (context, index) {
          final wrapper = _selectedImageWrappers[index];
          return Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: Stack(
              alignment: Alignment.topRight,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: kIsWeb && wrapper.bytes != null
                      ? Image.memory(
                    wrapper.bytes!,
                    width: 100,
                    height: 100,
                    fit: BoxFit.cover,
                  )
                      : wrapper.file != null
                      ? Image.file(
                    wrapper.file!,
                    width: 100,
                    height: 100,
                    fit: BoxFit.cover,
                  )
                      : Container(width: 100, height: 100, color: Colors.grey[300], child: const Icon(Icons.image_not_supported)),
                ),
                Material(
                  color: Colors.transparent,
                  child: Tooltip(
                    message: 'Remover imagen',
                    child: InkWell(
                      onTap: () => _removerImagenSeleccionada(index),
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        padding: const EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.6),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.close, color: Colors.white, size: 18),
                      ),
                    ),
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }


  @override
  void dispose() {
    _nombreController.dispose();
    _precioController.dispose();
    _cantidadController.dispose();
    _empresaController.dispose();
    _descripcionController.dispose();
    super.dispose();
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
            child: Tooltip(
              message: 'Volver a Comprar Productos',
              child: PageLink(
                links: [
                  PageLinkInfo(
                    pageBuilder: () => const CompradeProductos(key: Key("CompradeProductosDesdeVenta")),
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
          ),
          Pinned.fromPins(
            Pin(size: 74.0, middle: 0.5),
            Pin(size: 73.0, start: 42.0),
            child: Tooltip(
              message: 'Ir a Inicio',
              child: PageLink(
                links: [
                  PageLinkInfo(
                    transition: LinkTransition.Fade,
                    ease: Curves.easeOut,
                    duration: 0.3,
                    pageBuilder: () => Home(key: const Key('HomeDesdeVenta')),
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
          ),
          Pinned.fromPins(
            Pin(size: 47.2, middle: 0.6987),
            Pin(size: 50.0, start: 49.0),
            child: Tooltip(
              message: 'Carrito de compras',
              child: PageLink(
                links: [
                  PageLinkInfo(
                    transition: LinkTransition.Fade,
                    ease: Curves.easeOut,
                    duration: 0.3,
                    pageBuilder: () => Carritodecompras(key: const Key('CarritodecomprasDesdeVenta')),
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
          ),
          Pinned.fromPins(
            Pin(size: 40.5, middle: 0.8328),
            Pin(size: 50.0, start: 49.0),
            child: Tooltip(
              message: 'Ayuda',
              child: PageLink(
                links: [
                  PageLinkInfo(
                    transition: LinkTransition.Fade,
                    ease: Curves.easeOut,
                    duration: 0.3,
                    pageBuilder: () => Ayuda(key: const Key('AyudaDesdeVenta')),
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
          ),
          Pinned.fromPins(
            Pin(size: 47.2, end: 7.6),
            Pin(size: 50.0, start: 49.0),
            child: Tooltip(
              message: 'Configuración',
              child: PageLink(
                links: [
                  PageLinkInfo(
                    transition: LinkTransition.Fade,
                    ease: Curves.easeOut,
                    duration: 0.3,
                    pageBuilder: () => Configuraciones(key: const Key('SettingsDesdeVenta'), authService: AuthService()),
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
                return Tooltip(
                  message: 'Ver mi perfil',
                  child: PageLink(
                    links: [
                      PageLinkInfo(
                        transition: LinkTransition.Fade,
                        ease: Curves.easeOut,
                        duration: 0.3,
                        pageBuilder: () => PerfilPublico(key: const Key('PerfilPublicoDesdeVenta')),
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
                  ),
                );
              },
            ),
          ),
          Pinned.fromPins(
            Pin(size: 60.1, end: 7.6),
            Pin(size: 60.0, start: 110.0),
            child: Tooltip(
              message: 'Mi lista de animales',
              child: PageLink(
                links: [
                  PageLinkInfo(
                    transition: LinkTransition.Fade,
                    ease: Curves.easeOut,
                    duration: 0.3,
                    pageBuilder: () => ListadeAnimales(key: const Key('ListadeAnimalesDesdeVenta')),
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
          ),

          Positioned(
            top: 125.0,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                decoration: BoxDecoration(
                  color: const Color(0xe3a0f4fe),
                  borderRadius: BorderRadius.circular(10.0),
                  border: Border.all(width: 1.0, color: const Color(0xe3000000)),
                ),
                child: const Text(
                  'Vender Productos',
                  style: TextStyle(
                    fontFamily: APP_FONT_FAMILY,
                    fontSize: 20,
                    color: APP_TEXT_COLOR,
                    fontWeight: FontWeight.w700,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
          Positioned.fill(
            top: 175.0,
            left: 20.0,
            right: 20.0,
            bottom: 20.0,
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    _buildTextField(
                      controller: _nombreController,
                      labelText: 'Nombre del Producto',
                      originalHint: 'Nombre del Producto',
                      iconPath: 'assets/images/nombreproducto.png',
                      tooltipMessage: 'Ingresa el nombre de tu producto',
                    ),
                    _buildTextField(
                      controller: _descripcionController,
                      labelText: 'Descripción del Producto',
                      originalHint: 'Detalles, características...',
                      maxLines: 3,
                      iconPath: 'assets/images/infoproducto.png',
                      tooltipMessage: 'Proporciona una descripción detallada del producto',
                    ),
                    _buildCategoryDropdown(
                      iconPath: 'assets/images/category.png',
                      tooltipMessage: 'Selecciona la categoría a la que pertenece tu producto',
                    ),
                    _buildTextField(
                      controller: _precioController,
                      labelText: 'Precio',
                      originalHint: 'Precio',
                      keyboardType: TextInputType.numberWithOptions(decimal: true),
                      iconPath: 'assets/images/price.png',
                      tooltipMessage: 'Ingresa el precio de venta del producto',
                    ),
                    _buildTextField(
                      controller: _cantidadController,
                      labelText: 'Cantidad de Productos',
                      originalHint: 'Cantidad de Productos',
                      keyboardType: TextInputType.number,
                      iconPath: 'assets/images/stock.png',
                      tooltipMessage: 'Ingresa la cantidad de unidades disponibles en stock',
                    ),
                    _buildTextField(
                      controller: _empresaController,
                      labelText: 'Nombre de la Empresa o Negocio',
                      originalHint: 'Nombre de la Empresa o Negocio',
                      iconPath: 'assets/images/company.png',
                      tooltipMessage: 'Ingresa el nombre de tu empresa o negocio',
                    ),
                    const SizedBox(height: 16.0),

                    _buildSelectedImagesPreview(),

                    Tooltip(
                      message: _selectedImageWrappers.isEmpty ? 'Seleccionar imágenes para el producto' : 'Añadir más imágenes al producto',
                      child: ElevatedButton.icon(
                        icon: const Icon(Icons.add_a_photo_outlined, color: APP_TEXT_COLOR),
                        label: Text(
                          _selectedImageWrappers.isEmpty ? 'Cargar Imágenes' : 'Añadir más Imágenes',
                          style: const TextStyle(
                              fontFamily: APP_FONT_FAMILY,
                              fontSize: 18,
                              color: APP_TEXT_COLOR,
                              fontWeight: FontWeight.w700),
                        ),
                        style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xff4ec8dd),
                            padding: const EdgeInsets.symmetric(vertical: 12.0),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15.0),
                              side: const BorderSide(color: APP_TEXT_COLOR, width: 1.0),
                            ),
                            elevation: 3,
                            shadowColor: const Color(0xff080808)),
                        onPressed: _isUploading ? null : _seleccionarImagenes,
                      ),
                    ),
                    const SizedBox(height: 24.0),
                    _isUploading
                        ? const Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(Colors.white)),
                            SizedBox(height: 8),
                            Text("Subiendo producto e imágenes...", style: TextStyle(fontFamily: APP_FONT_FAMILY, color: Colors.white)),
                          ],
                        )
                    )
                        : Tooltip(
                      message: 'Publica tu producto para venderlo',
                      child: ElevatedButton(
                        onPressed: _publicarProducto,
                        style: ElevatedButton.styleFrom(
                            backgroundColor: APP_PRIMARY_COLOR,
                            padding: const EdgeInsets.symmetric(vertical: 15.0),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15.0),
                              side: const BorderSide(color: APP_TEXT_COLOR, width: 1.0),
                            ),
                            elevation: 3,
                            shadowColor: const Color(0xff080808)),
                        child: const Text(
                          'Publicar Producto',
                          style: TextStyle(
                            fontFamily: APP_FONT_FAMILY,
                            fontSize: 20,
                            color: APP_TEXT_COLOR,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20.0),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}