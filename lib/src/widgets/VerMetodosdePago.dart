// --- VerMetodosdePago.dart (Todo en uno) ---
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Para TextInputFormatter
import 'package:adobe_xd/pinned.dart';
import 'package:adobe_xd/page_link.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

// Imports de Navegación
import './Home.dart';
import './Ayuda.dart';
import './Configuracion.dart';
import '../services/auth_service.dart';


// --- Clase Principal de la Página: VerMetodosdePago ---
class VerMetodosdePago extends StatefulWidget {
  const VerMetodosdePago({Key? key}) : super(key: key);

  @override
  _VerMetodosdePagoState createState() => _VerMetodosdePagoState();
}

class _VerMetodosdePagoState extends State<VerMetodosdePago> {
  // --- Variables de Estado ---
  final User? _currentUser = FirebaseAuth.instance.currentUser;
  bool _audioVisualAccessibility = false;
  static const String _accessibilityPrefKey = 'audioVisualAccessibilityEnabled';

  bool _isLoading = true;
  List<Map<String, dynamic>> _paymentMethods = [];
  String? _defaultPaymentMethodId;

  // --- Ciclo de Vida: initState ---
  @override
  void initState() {
    super.initState();
    _loadAccessibilityPreference();
    _loadPaymentMethods();
  }

  // --- Métodos de Lógica ---
  Future<void> _loadAccessibilityPreference() async {
    final prefs = await SharedPreferences.getInstance();
    if (mounted) {
      setState(() {
        _audioVisualAccessibility = prefs.getBool(_accessibilityPrefKey) ?? false;
      });
    }
  }

  Future<void> _loadPaymentMethods() async {
    if (_currentUser == null) {
      if (mounted) setState(() => _isLoading = false);
      return;
    }

    if (mounted) setState(() => _isLoading = true);

    try {
      final userDoc = await FirebaseFirestore.instance.collection('users').doc(_currentUser!.uid).get();
      if (userDoc.exists) {
        _defaultPaymentMethodId = userDoc.data()?['defaultPaymentMethodId'];
      }

      final querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(_currentUser!.uid)
          .collection('payment_methods')
          .orderBy('addedAt', descending: true)
          .get();

      final methods = querySnapshot.docs.map((doc) {
        var data = doc.data();
        data['id'] = doc.id;
        // Aseguramos que el año se muestre en formato de 2 dígitos
        if (data['exp_year'] != null && data['exp_year'].toString().length == 4) {
          data['exp_year_short'] = data['exp_year'].toString().substring(2);
        } else {
          data['exp_year_short'] = data['exp_year']?.toString() ?? 'XX';
        }
        return data;
      }).toList();

      if (mounted) {
        setState(() {
          _paymentMethods = methods;
          _isLoading = false;
        });
      }
    } catch (e) {
      print("Error al cargar métodos de pago: $e");
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error al cargar tus métodos de pago.'), backgroundColor: Colors.red),
        );
      }
    }
  }

  Future<void> _setDefaultMethod(String methodId) async {
    if (_currentUser == null) return;
    try {
      await FirebaseFirestore.instance.collection('users').doc(_currentUser!.uid).update({
        'defaultPaymentMethodId': methodId,
      });
      if (mounted) {
        setState(() {
          _defaultPaymentMethodId = methodId;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Método predeterminado actualizado.'), backgroundColor: Colors.green),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('No se pudo actualizar.'), backgroundColor: Colors.red));
    }
  }

  Future<void> _deleteMethod(String methodId) async {
    final bool? confirmDelete = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Confirmar Eliminación'),
        content: const Text('¿Seguro que quieres eliminar este método de pago?'),
        actions: [
          TextButton(onPressed: () => Navigator.of(context).pop(false), child: const Text('Cancelar')),
          TextButton(onPressed: () => Navigator.of(context).pop(true), child: const Text('Eliminar', style: TextStyle(color: Colors.red))),
        ],
      ),
    );

    if (confirmDelete != true || _currentUser == null) return;

    try {
      await FirebaseFirestore.instance.collection('users').doc(_currentUser!.uid).collection('payment_methods').doc(methodId).delete();
      if (_defaultPaymentMethodId == methodId) {
        await FirebaseFirestore.instance.collection('users').doc(_currentUser!.uid).update({'defaultPaymentMethodId': FieldValue.delete()});
      }
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Método de pago eliminado.'), backgroundColor: Colors.green));
      _loadPaymentMethods();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('No se pudo eliminar el método.'), backgroundColor: Colors.red));
    }
  }

  Future<void> _showPaymentMethodModal() async {
    final result = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext modalBuildContext) {
        return _MetodoDePagoModalForm(
          parentContextForSnackbars: context,
        );
      },
    );
    if (result == true) {
      _loadPaymentMethods(); // Recargar la lista si se añadió una tarjeta
    }
  }

  IconData _getCardIcon(String? brand) {
    switch (brand?.toLowerCase()) {
      case 'visa': return FontAwesomeIcons.ccVisa;
      case 'mastercard': return FontAwesomeIcons.ccMastercard;
      case 'amex': return FontAwesomeIcons.ccAmex;
      default: return FontAwesomeIcons.solidCreditCard;
    }
  }

  Widget _buildPaymentCard({required IconData icon, required String title, String? subtitle, required VoidCallback onTap, Widget? trailing}) {
    final bool isAccessibilityModeActive = _audioVisualAccessibility;
    final Color cardBackgroundColor = isAccessibilityModeActive ? Colors.black.withOpacity(0.85) : const Color(0xffffffff).withOpacity(0.92);
    final Color textColor = isAccessibilityModeActive ? Colors.yellowAccent.shade700 : const Color(0xff222222);
    final Color iconColor = isAccessibilityModeActive ? Colors.yellowAccent.shade700 : const Color(0xff4ec8dd);

    return Card(
      elevation: 3.0,
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 25.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      color: cardBackgroundColor,
      child: ListTile(
        leading: FaIcon(icon, color: iconColor, size: 32),
        title: Text(title, style: TextStyle(fontFamily: 'Comic Sans MS', fontSize: isAccessibilityModeActive ? 20 : 18, color: textColor, fontWeight: FontWeight.w600)),
        subtitle: subtitle != null ? Text(subtitle, style: TextStyle(fontFamily: 'Arial', fontSize: 14, color: isAccessibilityModeActive ? Colors.white70 : Colors.black54)) : null,
        trailing: trailing,
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const double topOffsetForContent = 130.0;

    return Scaffold(
      backgroundColor: const Color(0xff4ec8dd),
      body: Stack(
        children: <Widget>[
          Container(decoration: const BoxDecoration(image: DecorationImage(image: AssetImage('assets/images/Animal Health Fondo de Pantalla.png'), fit: BoxFit.cover))),
          Pinned.fromPins(Pin(size: 74.0, middle: 0.5), Pin(size: 73.0, start: 42.0), child: PageLink(links: [PageLinkInfo(pageBuilder: () => Home(key: const Key('Home_From_Payment')))], child: Container(decoration: BoxDecoration(image: const DecorationImage(image: AssetImage('assets/images/logo.png'), fit: BoxFit.cover), borderRadius: BorderRadius.circular(15.0), border: Border.all(width: 1.0, color: const Color(0xff000000)))))),
          Pinned.fromPins(Pin(size: 52.9, start: 15.0), Pin(size: 50.0, start: 49.0), child: InkWell(onTap: () => Navigator.of(context).pop(), child: Container(decoration: const BoxDecoration(image: DecorationImage(image: AssetImage('assets/images/back.png'), fit: BoxFit.fill))))),
          Pinned.fromPins(Pin(size: 40.5, end: 15.0), Pin(size: 50.0, start: 49.0), child: PageLink(links: [PageLinkInfo(pageBuilder: () => Ayuda(key: const Key('Ayuda_From_Payment')))], child: Container(decoration: const BoxDecoration(image: DecorationImage(image: AssetImage('assets/images/help.png'), fit: BoxFit.fill))))),
          Pinned.fromPins(Pin(size: 47.2, end: 7.6), Pin(size: 50.0, start: 49.0), child: PageLink(links: [PageLinkInfo(pageBuilder: () => Configuraciones(key: Key('Settings'), authService: AuthService()))], child: Container(decoration: BoxDecoration(image: DecorationImage(image: const AssetImage('assets/images/settingsbutton.png'), fit: BoxFit.fill))))),

          Positioned(
            top: topOffsetForContent,
            left: 0,
            right: 0,
            bottom: 0,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 20.0),
                  child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                    const Icon(Icons.credit_card, size: 35, color: Colors.white, shadows: [Shadow(blurRadius: 2.0, color: Colors.black, offset: Offset(1, 1))]),
                    const SizedBox(width: 10),
                    Text('Métodos de Pago', style: TextStyle(fontFamily: 'Comic Sans MS', fontSize: 24, color: Colors.white, fontWeight: FontWeight.w700, shadows: [Shadow(blurRadius: 2.0, color: Colors.black.withOpacity(0.5), offset: Offset(1.0, 1.0))]), textAlign: TextAlign.center),
                  ]),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.only(bottom: 20.0),
                    child: Column(
                      children: <Widget>[
                        if (_currentUser != null)
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 25.0),
                            child: Row(children: [
                              StreamBuilder<DocumentSnapshot>(
                                stream: FirebaseFirestore.instance.collection('users').doc(_currentUser!.uid).snapshots(),
                                builder: (context, snapshot) {
                                  String? profilePhotoUrl;
                                  if (snapshot.hasData && snapshot.data!.exists) {
                                    final userData = snapshot.data!.data() as Map<String, dynamic>;
                                    profilePhotoUrl = userData['profilePhotoUrl'] as String?;
                                  }
                                  return Container(
                                    width: 70, height: 70,
                                    decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(12.0), border: Border.all(color: Colors.white, width: 2.0), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.2), spreadRadius: 1, blurRadius: 3, offset: Offset(0, 2))]),
                                    child: ClipRRect(borderRadius: BorderRadius.circular(10.0), child: (profilePhotoUrl != null && profilePhotoUrl.isNotEmpty) ? CachedNetworkImage(imageUrl: profilePhotoUrl, fit: BoxFit.cover, placeholder: (c, u) => const Center(child: CircularProgressIndicator(strokeWidth: 2.0)), errorWidget: (c, u, e) => Icon(Icons.person, size: 40, color: Colors.grey[600])) : Icon(Icons.person, size: 40, color: Colors.grey[600])),
                                  );
                                },
                              ),
                              const SizedBox(width: 15),
                              Expanded(
                                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                  Text(_currentUser!.displayName ?? _currentUser!.email ?? 'Usuario', style: const TextStyle(fontFamily: 'Comic Sans MS', fontSize: 20, color: Colors.black, fontWeight: FontWeight.bold), overflow: TextOverflow.ellipsis),
                                  if (_currentUser!.email != null) Text(_currentUser!.email!, style: const TextStyle(fontFamily: 'Arial', fontSize: 14, color: Colors.black87), overflow: TextOverflow.ellipsis),
                                ]),
                              ),
                            ]),
                          ),
                        const SizedBox(height: 15),
                        _buildPaymentCard(icon: Icons.add_card_outlined, title: 'Añadir Método de Pago', onTap: _showPaymentMethodModal, trailing: Icon(Icons.arrow_forward_ios, color: _audioVisualAccessibility ? Colors.yellowAccent.withOpacity(0.7) : Colors.grey, size: 18)),
                        const Divider(height: 30, thickness: 1, indent: 40, endIndent: 40, color: Colors.white54),
                        if (_isLoading)
                          const Padding(padding: EdgeInsets.all(30.0), child: CircularProgressIndicator(color: Colors.white))
                        else if (_paymentMethods.isEmpty)
                          const Padding(padding: EdgeInsets.all(20.0), child: Text('No tienes métodos de pago guardados.', style: TextStyle(color: Colors.white, fontSize: 16, fontFamily: 'Arial'), textAlign: TextAlign.center))
                        else
                          ..._paymentMethods.map((method) {
                            final bool isDefault = method['id'] == _defaultPaymentMethodId;
                            return _buildPaymentCard(
                              icon: _getCardIcon(method['brand']),
                              title: '${method['brand'] ?? 'Tarjeta'} terminada en ${method['last4'] ?? '****'}',
                              subtitle: 'Expira ${method['exp_month']}/${method['exp_year_short']}',
                              onTap: isDefault ? () {} : () => _setDefaultMethod(method['id']),
                              trailing: Row(mainAxisSize: MainAxisSize.min, children: [
                                if (isDefault)
                                  Chip(
                                    label: const Text('Default', style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold)),
                                    backgroundColor: Colors.green.shade400, padding: const EdgeInsets.symmetric(horizontal: 6), visualDensity: VisualDensity.compact,
                                  ),
                                IconButton(icon: Icon(Icons.delete_outline, color: isDefault ? Colors.grey : Colors.red.shade400), onPressed: isDefault ? null : () => _deleteMethod(method['id'])),
                              ]),
                            );
                          }).toList(),
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

// --- WIDGET DEL MODAL CON EL FORMULARIO (DEFINIDO DENTRO DEL MISMO ARCHIVO) ---
class _MetodoDePagoModalForm extends StatefulWidget {
  final BuildContext parentContextForSnackbars;
  const _MetodoDePagoModalForm({required this.parentContextForSnackbars});

  @override
  _MetodoDePagoModalFormState createState() => _MetodoDePagoModalFormState();
}

class _MetodoDePagoModalFormState extends State<_MetodoDePagoModalForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _numberController = TextEditingController();
  final _expiryController = TextEditingController();
  final _cvcController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _numberController.dispose();
    _expiryController.dispose();
    _cvcController.dispose();
    super.dispose();
  }

  Future<void> _savePaymentMethod() async {
    if (!_formKey.currentState!.validate() || _isLoading) return;

    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      ScaffoldMessenger.of(widget.parentContextForSnackbars).showSnackBar(const SnackBar(content: Text('Error: No hay un usuario activo.'), backgroundColor: Colors.red));
      return;
    }

    setState(() => _isLoading = true);

    try {
      final cardNumber = _numberController.text.replaceAll(' ', '');
      String brand = 'Tarjeta';
      if (cardNumber.startsWith('4')) brand = 'Visa';
      else if (cardNumber.startsWith('5')) brand = 'Mastercard';
      else if (cardNumber.startsWith('3')) brand = 'Amex';

      final expiryParts = _expiryController.text.split('/');
      final expMonth = int.parse(expiryParts[0]);
      final expYear = int.parse('20${expiryParts[1]}');

      await FirebaseFirestore.instance.collection('users').doc(user.uid).collection('payment_methods').add({
        'cardholderName': _nameController.text.trim(),
        'brand': brand,
        'last4': cardNumber.substring(cardNumber.length - 4),
        'exp_month': expMonth,
        'exp_year': expYear,
        'addedAt': FieldValue.serverTimestamp(),
      });

      if (mounted) Navigator.of(context).pop(true);

    } catch (e) {
      ScaffoldMessenger.of(widget.parentContextForSnackbars).showSnackBar(SnackBar(content: Text('Error al guardar la tarjeta: $e'), backgroundColor: Colors.red));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Widget _buildTextField({required TextEditingController controller, required String label, TextInputType keyboardType = TextInputType.text, String? Function(String?)? validator, IconData? icon, List<TextInputFormatter>? inputFormatters}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        style: const TextStyle(fontFamily: 'Arial', color: Colors.black87),
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(fontFamily: 'Arial', color: Colors.black54),
          prefixIcon: icon != null ? Icon(icon, color: const Color(0xff4ec8dd)) : null,
          filled: true,
          fillColor: Colors.white.withOpacity(0.95),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0), borderSide: BorderSide.none),
          focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0), borderSide: const BorderSide(color: Color(0xff4ec8dd), width: 2)),
          errorStyle: const TextStyle(fontWeight: FontWeight.bold),
        ),
        validator: validator,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        inputFormatters: inputFormatters,
      ),
    );
  }

  @override
  Widget build(BuildContext modalContext) {
    return FractionallySizedBox(
      heightFactor: 0.85,
      child: ClipRRect(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20.0)),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            title: const Text('Añadir Nueva Tarjeta', style: TextStyle(fontFamily: 'Comic Sans MS', color: Colors.white)),
            backgroundColor: const Color(0xff4ec8dd),
            elevation: 1,
            automaticallyImplyLeading: false,
            shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20.0))),
            actions: [IconButton(icon: const Icon(Icons.close, color: Colors.white), onPressed: () => Navigator.of(modalContext).pop())],
          ),
          body: Stack(
            children: [
              Container(decoration: const BoxDecoration(image: DecorationImage(image: AssetImage('assets/images/Animal Health Fondo de Pantalla.png'), fit: BoxFit.cover))),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _formKey,
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.only(bottom: 80),
                    child: Column(
                      children: [
                        _buildTextField(controller: _nameController, label: 'Nombre del Titular', icon: Icons.person_outline, validator: (v) => v!.trim().isEmpty ? 'El nombre no puede estar vacío' : null),
                        _buildTextField(
                          controller: _numberController,
                          label: 'Número de Tarjeta',
                          icon: Icons.credit_card,
                          keyboardType: TextInputType.number,
                          inputFormatters: [FilteringTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(16), CardNumberInputFormatter()],
                          validator: (v) => v!.replaceAll(' ', '').length != 16 ? 'Número de tarjeta inválido' : null,
                        ),
                        Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          Expanded(
                            child: _buildTextField(
                              controller: _expiryController,
                              label: 'Expira (MM/YY)',
                              keyboardType: TextInputType.number,
                              inputFormatters: [FilteringTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(4), CardMonthInputFormatter()],
                              validator: (value) {
                                if (value == null || value.length != 5) return 'Use MM/YY';
                                final parts = value.split('/');
                                final month = int.tryParse(parts[0]);
                                final year = int.tryParse(parts[1]);
                                if (month == null || year == null || month < 1 || month > 12) return 'Fecha inválida';
                                final now = DateTime.now();
                                final currentYear = now.year % 100;
                                final currentMonth = now.month;
                                if (year < currentYear || (year == currentYear && month < currentMonth)) return 'Tarjeta expirada';
                                return null;
                              },
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: _buildTextField(
                              controller: _cvcController,
                              label: 'CVC',
                              keyboardType: TextInputType.number,
                              inputFormatters: [FilteringTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(4)],
                              validator: (v) => (v!.length < 3) ? 'CVC inválido' : null,
                            ),
                          ),
                        ]),
                      ],
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 0, right: 0, bottom: 0,
                child: Container(
                  color: const Color(0xff4ec8dd).withOpacity(0.9),
                  padding: const EdgeInsets.all(16.0),
                  child: SafeArea(
                    child: _isLoading
                        ? const Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation(Colors.white)))
                        : ElevatedButton.icon(
                      icon: const Icon(Icons.save, color: Colors.white),
                      label: const Text('Guardar Tarjeta', style: TextStyle(fontFamily: 'Comic Sans MS', fontSize: 18, color: Colors.white)),
                      onPressed: _savePaymentMethod,
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.green[600]!, minimumSize: const Size(double.infinity, 50), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
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

// --- TextInputFormatters (Clases de ayuda para formatear la entrada de texto) ---
class CardMonthInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    var newText = newValue.text;
    if (newValue.selection.baseOffset == 0) return newValue;
    var buffer = StringBuffer();
    for (int i = 0; i < newText.length; i++) {
      buffer.write(newText[i]);
      if (i == 1 && newText.length > 2) {
        buffer.write('/');
      }
    }
    var string = buffer.toString();
    return newValue.copyWith(text: string, selection: TextSelection.collapsed(offset: string.length));
  }
}

class CardNumberInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    var text = newValue.text.replaceAll(' ', '');
    if (newValue.selection.baseOffset == 0) return newValue;
    var buffer = StringBuffer();
    for (int i = 0; i < text.length; i++) {
      buffer.write(text[i]);
      if ((i + 1) % 4 == 0 && i != text.length - 1) {
        buffer.write(' ');
      }
    }
    var string = buffer.toString();
    return newValue.copyWith(text: string, selection: TextSelection.collapsed(offset: string.length));
  }
}