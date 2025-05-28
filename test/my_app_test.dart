// test/my_app_test.dart

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebaseauth;

// ... otras importaciones ...
import 'package:animal_health/main.dart';
import 'package:animal_health/src/services/auth_service.dart';
import 'package:animal_health/src/widgets/AnimalHealth.dart';
import 'package:animal_health/src/widgets/Home.dart';

@GenerateMocks([
  AuthService,
  firebaseauth.User // ¡Dejarlo así! Generará 'MockUser'
])
// ignore_for_file: directives_ordering, camel_case_types, no_leading_underscores_for_library_prefixes
import 'my_app_test.mocks.dart'; // Este archivo contiene 'MockUser'

void main() {
  late MockAuthService mockAuthService;
  late MockUser mockUser; // <--- ¡CAMBIADO de MockFirebaseUser a MockUser!

  setUp(() {
    mockAuthService = MockAuthService();
    mockUser = MockUser(); // <--- ¡CAMBIADO de MockFirebaseUser a MockUser!

    // Configura un comportamiento por defecto para el usuario mock
    when(mockUser.uid).thenReturn('test_uid'); // <--- Usando mockUser
    when(mockUser.email).thenReturn('test@example.com'); // <--- Usando mockUser
    when(mockUser.emailVerified).thenReturn(true); // <--- Usando mockUser
    when(mockUser.displayName).thenReturn('Test User'); // <--- Usando mockUser
    when(mockUser.photoURL).thenReturn(null); // <--- Usando mockUser
  });

  group('MyApp widget tests', () {
    testWidgets('Muestra CircularProgressIndicator mientras carga el estado de autenticación', (tester) async {
      when(mockAuthService.authStateChanges)
          .thenAnswer((_) => const Stream.empty());

      await mainAppRunner(authService: mockAuthService, skipFirebaseInit: true);
      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.byKey(const Key('Home')), findsNothing);
      expect(find.byKey(const Key('AnimalHealth')), findsNothing);
    });

    testWidgets('Muestra la pantalla Home si el usuario está logueado', (tester) async {
      when(mockAuthService.authStateChanges)
          .thenAnswer((_) => Stream.value(mockUser)); // <--- Usando mockUser

      await mainAppRunner(authService: mockAuthService, skipFirebaseInit: true);
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('Home')), findsOneWidget);
      expect(find.byType(AnimalHealth), findsNothing);
      expect(find.byType(CircularProgressIndicator), findsNothing);
    });

    testWidgets('Muestra la pantalla AnimalHealth si no hay usuario logueado', (tester) async {
      when(mockAuthService.authStateChanges)
          .thenAnswer((_) => Stream.value(null));

      await mainAppRunner(authService: mockAuthService, skipFirebaseInit: true);
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('AnimalHealth')), findsOneWidget);
      expect(find.byKey(const Key('Home')), findsNothing);
      expect(find.byType(CircularProgressIndicator), findsNothing);
    });

    testWidgets('AnimalHealth navega a Home en login exitoso (simulado)', (tester) async {
      when(mockAuthService.authStateChanges)
          .thenAnswer((_) => Stream.value(null));

      await mainAppRunner(authService: mockAuthService, skipFirebaseInit: true);
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('AnimalHealth')), findsOneWidget);
      expect(find.byKey(const Key('Home')), findsNothing);

      when(mockAuthService.authStateChanges)
          .thenAnswer((_) => Stream.value(mockUser)); // <--- Usando mockUser

      await tester.pumpAndSettle();

      expect(find.byKey(const Key('Home')), findsOneWidget);
      expect(find.byKey(const Key('AnimalHealth')), findsNothing);
    });
  });
}