// main.dart
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // <--- CORRECTO
import 'firebase_options.dart';
import 'src/services/auth_service.dart';
import 'src/services/cart_service.dart'; // <--- CORRECTO
import 'package:firebase_auth/firebase_auth.dart' as firebaseauth;
import 'src/widgets/AnimalHealth.dart';
import 'src/widgets/Home.dart';
import 'package:intl/date_symbol_data_local.dart';

// Puedes quitar esta constante si no la usas en main.dart
// const String GEMINI_API_KEY_CARE = 'AIzaSyBYFGiQrNtcOkfbf3Pz1rGKsgoYPyQejmM';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await initializeDateFormatting('es_ES', null);
  // REMOVIDO: Gemini.init(apiKey: GEMINI_API_KEY_CARE);
  await mainAppRunner();
}

Future<void> mainAppRunner({
  AuthService? authService,
  bool skipFirebaseInit = false,
  bool skipDateFormatting = false,
  FirebaseFirestore? firestore,
}) async {
  final _authService = authService ?? AuthService();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthService>(create: (_) => _authService), // <--- CORRECTO
        ChangeNotifierProvider<CartService>(create: (_) => CartService()), // <--- CORRECTO
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);

    return MaterialApp(
      home: StreamBuilder<firebaseauth.User?>(
        stream: authService.authStateChanges,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          } else if (snapshot.hasData && snapshot.data != null) {
            return const Home(key: Key('Home'));
          } else {
            return AnimalHealth(
              key: const Key('AnimalHealth'),
              authService: authService,
              onLoginSuccess: () {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => const Home(key: Key('Home')),
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