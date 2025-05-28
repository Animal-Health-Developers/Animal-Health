import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Asegúrate de importar esto
import 'package:flutter/material.dart';
import 'firebase_options.dart';
import 'src/services/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebaseauth;
import 'src/widgets/AnimalHealth.dart';
import 'src/widgets/Home.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await initializeDateFormatting('es_ES', null);
  await mainAppRunner();
}

Future<void> mainAppRunner({
  AuthService? authService,
  bool skipFirebaseInit = false,
  bool skipDateFormatting = false,
  // Podemos añadir un parámetro para FirebaseFirestore aquí si lo deseas,
  // pero es más común inyectarlo directamente en los widgets o servicios de datos.
  FirebaseFirestore? firestore, // Opcional, para tests de Home si accede directamente
}) async {
  final _authService = authService ?? AuthService();
  // No necesitamos initializeDateFormatting aquí si ya lo haces en main()
  // y solo lo pasas en tests.
  if (!skipDateFormatting) {
    // await initializeDateFormatting('es_ES', null); // Ya está en main()
  }

  runApp(MyApp(
    authService: _authService,
    // Aquí pasaríamos la instancia de Firestore al MyApp,
    // y luego MyApp la pasaría a Home si es necesario.
    // Para simplificar, asumimos que Home necesita FireStore.
    // Si Home no tiene un constructor para Firestore, lo modificaremos más abajo.
  ));
}

class MyApp extends StatefulWidget {
  final AuthService authService;
  // Si Home necesita Firestore, MyApp también podría necesitarlo para pasárselo.
  // final FirebaseFirestore? firestore;
  const MyApp({super.key, required this.authService}); // Puedes añadir this.firestore si lo necesitas

  @override
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
            // Asegúrate de que el CircularProgressIndicator esté visible en la jerarquía
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          } else if (snapshot.hasData && snapshot.data != null) {
            // Pasa la instancia de Firestore a Home si Home la necesita
            return const Home(key: Key('Home')); // Si Home necesita Firestore, aquí deberías pasarlo
          } else {
            return AnimalHealth(
              key: const Key('AnimalHealth'),
              authService: widget.authService,
              onLoginSuccess: () {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => const Home(key: Key('Home')), // Pasa Firestore aquí también si es necesario
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