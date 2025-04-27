import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'firebase_options.dart';
import 'src/models/animal.dart';
import 'src/models/user.dart';
import 'src/models/products.dart';
import 'src/services/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebaseauth;
import 'src/widgets/AnimalHealth.dart';
import 'src/widgets/Home.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  final AuthService authService = AuthService();
  runApp(MyApp(authService: authService));
}

class MyApp extends StatefulWidget {
  final AuthService authService;
  const MyApp({super.key, required this.authService});

  @override
  // ignore: library_private_types_in_public_api
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: StreamBuilder<firebaseauth.User?>(
        stream: widget.authService.authStateChanges,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          } else if (snapshot.hasData && snapshot.data != null) {
            // Cambiado para redirigir al widget Home
            return Home(key: Key('Home'));
          } else {
            return AnimalHealth(
              key: Key('AnimalHealth'),
              authService: widget.authService,
              onLoginSuccess: () {
                // Esta función se llamará cuando el login sea exitoso
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => Home(key: Key('Home')),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}

// Eliminé la clase HomePage ya que ahora usamos el widget Home importado

Future<void> crearProducto(Product product) async {
  try {
    final firebaseUser = firebaseauth.FirebaseAuth.instance.currentUser;
    if (firebaseUser != null) {
      final userId = firebaseUser.uid;
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('products')
          .add(product.toJson());
      print('Producto creado exitosamente para el usuario $userId');
    } else {
      print('Error: Usuario no autenticado');
    }
  } catch (e) {
    print('Error al crear el producto: $e');
  }
}

crearUsuario(User nuevoUsuario) {}

crearAnimal(Animal nuevoAnimal) {}

actulizarAnimal(Animal updateAnimal) {}

historia_clinica(
    {required vacunas,
      required List<String> enfermedades,
      required List<String> tratamientos,
      required List<String> alergias,
      required Map<DateTime, String> visitas,
      required Map<String, Map<String, Object>> examenes}) {}

carnetVacunacion(
    {required String nombreVacuna,
      required DateTime fechaVacunacion,
      required String lote,
      required String veterinario,
      required int numeroDosis,
      required DateTime proximaDosis}) {}