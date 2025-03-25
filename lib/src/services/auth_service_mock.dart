import 'package:animal_health/src/services/auth_service.dart';
import 'package:mockito/mockito.dart';

// Crear una clase mock
class MockAuthService extends Mock implements AuthService {
  @override
  final authStateChanges = Stream.empty();
}