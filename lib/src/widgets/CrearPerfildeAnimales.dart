import 'package:flutter/material.dart';
import 'package:adobe_xd/pinned.dart';
import './Home.dart';
import 'package:adobe_xd/page_link.dart';
import './Ayuda.dart';
import './Configuracion.dart';
import './ListadeAnimales.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:typed_data';
import '../services/auth_service.dart';
class CrearPerfildeAnimal extends StatefulWidget {
  const CrearPerfildeAnimal({
    Key? key,
  }) : super(key: key);

  @override
  _CrearPerfildeAnimalState createState() => _CrearPerfildeAnimalState();
}

class _CrearPerfildeAnimalState extends State<CrearPerfildeAnimal> {
  final _formKey = GlobalKey<FormState>();
  final ImagePicker _picker = ImagePicker();
  Uint8List? _imageBytes;
  String? _imageUrl;
  bool _isUploading = false;

  // Controladores para los campos del formulario
  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _especieController = TextEditingController();
  final TextEditingController _razaController = TextEditingController();
  final TextEditingController _pesoController = TextEditingController();
  final TextEditingController _largoController = TextEditingController();
  final TextEditingController _anchoController = TextEditingController();
  DateTime _fechaNacimiento = DateTime.now();

  List<String> especiesDisponibles = [
    "Perro",
    "Gato",
    "Ave",
    "Roedor",
    "Reptil",
    "Otro"
  ];

  Future<void> _pickImage() async {
    try {
      final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        final bytes = await pickedFile.readAsBytes();
        setState(() {
          _imageBytes = bytes;
          _imageUrl = null;
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al seleccionar imagen: $e')),
      );
    }
  }

  Future<String?> _uploadImage() async {
    if (_imageBytes == null) return null;

    setState(() {
      _isUploading = true;
    });

    try {
      final userId = FirebaseAuth.instance.currentUser?.uid;
      if (userId == null) return null;

      final storageRef = FirebaseStorage.instance
          .ref()
          .child('animal_images/$userId/${DateTime.now().millisecondsSinceEpoch}.jpg');

      final uploadTask = storageRef.putData(_imageBytes!);
      final taskSnapshot = await uploadTask.whenComplete(() {});
      final downloadUrl = await taskSnapshot.ref.getDownloadURL();

      return downloadUrl;
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al subir imagen: $e')),
      );
      return null;
    } finally {
      setState(() {
        _isUploading = false;
      });
    }
  }

  Future<void> _guardarAnimal() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      if (_isUploading) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Espere, se está subiendo la imagen...')),
        );
        return;
      }

      try {
        final userId = FirebaseAuth.instance.currentUser?.uid;
        if (userId == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Usuario no autenticado')),
          );
          return;
        }

        final imageUrl = await _uploadImage();

        await FirebaseFirestore.instance
            .collection('users')
            .doc(userId)
            .collection('animals')
            .add({
          'nombre': _nombreController.text,
          'especie': _especieController.text,
          'raza': _razaController.text,
          'fechaNacimiento': _fechaNacimiento.toIso8601String(),
          'peso': double.tryParse(_pesoController.text) ?? 0,
          'largo': double.tryParse(_largoController.text) ?? 0,
          'ancho': double.tryParse(_anchoController.text) ?? 0,
          'fotoPerfilUrl': imageUrl,
          'userId': userId,
          'createdAt': FieldValue.serverTimestamp(),
        });

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => ListadeAnimales(key: Key('ListadeAnimales'))),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al guardar: $e')),
        );
      }
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _fechaNacimiento,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _fechaNacimiento) {
      setState(() {
        _fechaNacimiento = picked;
      });
    }
  }

  @override
  void dispose() {
    _nombreController.dispose();
    _especieController.dispose();
    _razaController.dispose();
    _pesoController.dispose();
    _largoController.dispose();
    _anchoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff4ec8dd),
      body: Stack(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: const AssetImage('assets/images/Animal Health Fondo de Pantalla.png'),
                fit: BoxFit.cover,
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
                  pageBuilder: () => Home(key: Key('Home'),),
                ),
              ],
              child: Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: const AssetImage('assets/images/logo.png'),
                    fit: BoxFit.cover,
                  ),
                  borderRadius: BorderRadius.circular(15.0),
                  border: Border.all(width: 1.0, color: const Color(0xff000000)),
                ),
              ),
            ),
          ),
          Pinned.fromPins(
            Pin(size: 52.9, start: 9.1),
            Pin(size: 50.0, start: 49.0),
            child: PageLink(
              links: [
                PageLinkInfo(
                  transition: LinkTransition.Fade,
                  ease: Curves.easeOut,
                  duration: 0.3,
                  pageBuilder: () => ListadeAnimales(key: Key('ListadeAnimales'),),
                ),
              ],
              child: Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: const AssetImage('assets/images/back.png'),
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
                  pageBuilder: () => Ayuda(key: Key('Ayuda'),),
                ),
              ],
              child: Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: const AssetImage('assets/images/help.png'),
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
                  pageBuilder: () => Configuraciones(key: Key('Settings'), authService: AuthService(),),
                ),
              ],
              child: Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: const AssetImage('assets/images/settingsbutton.png'),
                    fit: BoxFit.fill,
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            top: 120,
            left: 30,
            right: 30,
            bottom: 27,
            child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    // Foto de perfil
                    GestureDetector(
                      onTap: _pickImage,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          CircleAvatar(
                            radius: 50,
                            backgroundColor: Colors.grey[200],
                            child: _isUploading
                                ? CircularProgressIndicator()
                                : _imageBytes != null
                                ? ClipOval(
                              child: Image.memory(
                                _imageBytes!,
                                width: 100,
                                height: 100,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Icon(Icons.error, size: 40, color: Colors.red);
                                },
                              ),
                            )
                                : _imageUrl != null
                                ? ClipOval(
                              child: Image.network(
                                _imageUrl!,
                                width: 100,
                                height: 100,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Icon(Icons.error, size: 40, color: Colors.red);
                                },
                                loadingBuilder: (context, child, loadingProgress) {
                                  if (loadingProgress == null) return child;
                                  return CircularProgressIndicator();
                                },
                              ),
                            )
                                : Icon(Icons.add_a_photo, size: 40, color: Colors.grey),
                          ),
                          if (_isUploading)
                            CircularProgressIndicator(),
                        ],
                      ),
                    ),
                    SizedBox(height: 30),

                    // Nombre
                    Container(
                      height: 60,
                      child: Stack(
                        children: [
                          TextFormField(
                            controller: _nombreController,
                            decoration: InputDecoration(
                              labelText: 'Nombre',
                              border: OutlineInputBorder(),
                              filled: true,
                              fillColor: Colors.white,
                              contentPadding: EdgeInsets.only(left: 50.0, top: 15, bottom: 15),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Por favor ingrese el nombre';
                              }
                              return null;
                            },
                          ),
                          Positioned(
                            left: 5,
                            top: 0,
                            bottom: 10,
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Container(
                                width: 37.4,
                                height: 40.0,
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: const AssetImage('assets/images/nombreanimal.png'),
                                    fit: BoxFit.fill,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20),

                    // Fecha de Nacimiento
                    Container(
                      height: 60,
                      child: Stack(
                        children: [
                          InkWell(
                            onTap: () => _selectDate(context),
                            child: InputDecorator(
                              decoration: InputDecoration(
                                labelText: 'Fecha de Nacimiento',
                                border: OutlineInputBorder(),
                                filled: true,
                                fillColor: Colors.white,
                                contentPadding: EdgeInsets.only(left: 50.0, top: 15, bottom: 15),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    '${_fechaNacimiento.day}/${_fechaNacimiento.month}/${_fechaNacimiento.year}',
                                  ),
                                  Icon(Icons.arrow_drop_down),
                                ],
                              ),
                            ),
                          ),
                          Positioned(
                            left: 5,
                            top: 0,
                            bottom: 10,
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Container(
                                width: 35.2,
                                height: 40.0,
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: const AssetImage('assets/images/edad.png'),
                                    fit: BoxFit.fill,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20),

                    // Especie
                    Container(
                      height: 60,
                      child: Stack(
                        children: [
                          DropdownButtonFormField<String>(
                            value: _especieController.text.isNotEmpty
                                ? _especieController.text
                                : especiesDisponibles.first,
                            items: especiesDisponibles.map((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                            onChanged: (newValue) {
                              setState(() {
                                _especieController.text = newValue!;
                              });
                            },
                            decoration: InputDecoration(
                              labelText: 'Especie',
                              border: OutlineInputBorder(),
                              filled: true,
                              fillColor: Colors.white,
                              contentPadding: EdgeInsets.only(left: 50.0, top: 15, bottom: 15),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Por favor seleccione la especie';
                              }
                              return null;
                            },
                          ),
                          Positioned(
                            left: 5,
                            top: 0,
                            bottom: 10,
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Container(
                                width: 40.3,
                                height: 40.0,
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: const AssetImage('assets/images/especie.png'),
                                    fit: BoxFit.fill,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20),

                    // Raza
                    Container(
                      height: 60,
                      child: Stack(
                        children: [
                          TextFormField(
                            controller: _razaController,
                            decoration: InputDecoration(
                              labelText: 'Raza',
                              border: OutlineInputBorder(),
                              filled: true,
                              fillColor: Colors.white,
                              contentPadding: EdgeInsets.only(left: 50.0, top: 15, bottom: 15),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Por favor ingrese la raza';
                              }
                              return null;
                            },
                          ),
                          Positioned(
                            left: 5,
                            top: 0,
                            bottom: 10,
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Container(
                                width: 40.4,
                                height: 40.0,
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: const AssetImage('assets/images/raza.png'),
                                    fit: BoxFit.fill,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20),

                    // Peso
                    Container(
                      height: 60,
                      child: Stack(
                        children: [
                          TextFormField(
                            controller: _pesoController,
                            keyboardType: TextInputType.numberWithOptions(decimal: true),
                            decoration: InputDecoration(
                              labelText: 'Peso (kg)',
                              border: OutlineInputBorder(),
                              filled: true,
                              fillColor: Colors.white,
                              contentPadding: EdgeInsets.only(left: 50.0, top: 15, bottom: 15),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Por favor ingrese el peso';
                              }
                              if (double.tryParse(value) == null) {
                                return 'Ingrese un número válido';
                              }
                              return null;
                            },
                          ),
                          Positioned(
                            left: 5,
                            top: 0,
                            bottom: 10,
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Container(
                                width: 40.7,
                                height: 40.0,
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: const AssetImage('assets/images/peso.png'),
                                    fit: BoxFit.fill,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20),

                    // Largo
                    Container(
                      height: 60,
                      child: Stack(
                        children: [
                          TextFormField(
                            controller: _largoController,
                            keyboardType: TextInputType.numberWithOptions(decimal: true),
                            decoration: InputDecoration(
                              labelText: 'Largo (cm)',
                              border: OutlineInputBorder(),
                              filled: true,
                              fillColor: Colors.white,
                              contentPadding: EdgeInsets.only(left: 50.0, top: 15, bottom: 15),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Por favor ingrese el largo';
                              }
                              if (double.tryParse(value) == null) {
                                return 'Ingrese un número válido';
                              }
                              return null;
                            },
                          ),
                          Positioned(
                            left: 5,
                            top: 0,
                            bottom: 10,
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Container(
                                width: 35.8,
                                height: 40.0,
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: const AssetImage('assets/images/largo.png'),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20),

                    // Ancho
                    Container(
                      height: 60,
                      child: Stack(
                        children: [
                          TextFormField(
                            controller: _anchoController,
                            keyboardType: TextInputType.numberWithOptions(decimal: true),
                            decoration: InputDecoration(
                              labelText: 'Ancho (cm)',
                              border: OutlineInputBorder(),
                              filled: true,
                              fillColor: Colors.white,
                              contentPadding: EdgeInsets.only(left: 50.0, top: 15, bottom: 15),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Por favor ingrese el ancho';
                              }
                              if (double.tryParse(value) == null) {
                                return 'Ingrese un número válido';
                              }
                              return null;
                            },
                          ),
                          Positioned(
                            left: 5,
                            top: 0,
                            bottom: 10,
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Container(
                                width: 35.8,
                                height: 40.0,
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: const AssetImage('assets/images/ancho.png'),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 30),

                    // Botón Crear Perfil
                    GestureDetector(
                      onTap: _guardarAnimal,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Container(
                            width: 127.3,
                            height: 120.0,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: const AssetImage('assets/images/editarperfilanimal.png'),
                                fit: BoxFit.fill,
                              ),
                            ),
                          ),
                          if (_isUploading)
                            CircularProgressIndicator(),
                        ],
                      ),
                    ),
                    SizedBox(height: 30),
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