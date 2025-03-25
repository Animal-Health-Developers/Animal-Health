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
            return const CircularProgressIndicator();
          } else if (snapshot.hasData) {
            return HomePage();
          } else {
            return AnimalHealth(key: Key('AnimalHealth'),); // Navegar a la LandingPage
          }
        },
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('Bienvenido a la app!'),
      ),
    );
  }
}

Future<void> crearProducto(Product product) async {
  try {
    final firebaseUser = firebaseauth.FirebaseAuth.instance.currentUser;
    if (firebaseUser != null) {
      final userId = firebaseUser.uid; // Obtener el UID del usuario actual
      // Guardar el producto en la subcolección 'products' del usuario
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('products')
          .add(product.toJson());
      print('Producto creado exitosamente para el usuario $userId');
    } else {
      print('Error: Usuario no autenticado');
      // Maneja el error (por ejemplo, muestra un mensaje al usuario)
    }
  } catch (e) {
    print('Error al crear el producto: $e');
    // Maneja el error
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