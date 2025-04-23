import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import '../models/user.dart' as usermodel;

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Tipos de errores personalizados
  static const String emailAlreadyInUse = 'email-already-in-use';
  static const String invalidEmail = 'invalid-email';
  static const String weakPassword = 'weak-password';
  static const String userDisabled = 'user-disabled';
  static const String userNotFound = 'user-not-found';
  static const String wrongPassword = 'wrong-password';
  static const String emailNotVerified = 'email-not-verified';

  // En tu auth_service.dart
  Future<usermodel.User?> registrarUsuario({
    required String email,
    required String userName,
    required String password,
    required String confirmPassword,
  }) async {
    try {
      // Validaciones mejoradas
      if (email.isEmpty || !email.contains('@')) {
        throw FirebaseAuthException(
          code: invalidEmail,
          message: 'Por favor ingresa un correo electrónico válido',
        );
      }

      if (userName.isEmpty || userName.length < 3) {
        throw FirebaseAuthException(
          code: 'invalid-username',
          message: 'El nombre de usuario debe tener al menos 3 caracteres',
        );
      }

      if (password != confirmPassword) {
        throw FirebaseAuthException(
          code: 'passwords-mismatch',
          message: 'Las contraseñas no coinciden',
        );
      }

      if (password.length < 8) {
        throw FirebaseAuthException(
          code: weakPassword,
          message: 'La contraseña debe tener al menos 8 caracteres',
        );
      }

      // Verificar si el email ya está en uso
      final methods = await _auth.fetchSignInMethodsForEmail(email);
      if (methods.isNotEmpty) {
        throw FirebaseAuthException(
          code: emailAlreadyInUse,
          message: 'El correo electrónico ya está registrado',
        );
      }

      // Crear usuario en Firebase Auth
      final UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);

      final User? user = userCredential.user;
      if (user == null) {
        throw FirebaseAuthException(
          code: 'user-creation-failed',
          message: 'No se pudo crear el usuario',
        );
      }

      // Actualizar displayName
      await user.updateProfile(displayName: userName);
      await user.reload();

      // Crear documento en Firestore (¡SIN la contraseña!)
      final usuario = usermodel.User(
        uid: user.uid,
        email: email,
        userName: userName,
        password: password,
        emailVerified: false,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      await _firestore.collection('users').doc(user.uid).set(usuario.toJson());

      // Enviar verificación de email
      await user.sendEmailVerification();

      return usuario;
    } on FirebaseAuthException catch (e) {
      // Limpiar si hay error
      if (_auth.currentUser != null) {
        await _auth.currentUser?.delete();
      }
      throw e; // Re-lanzar la excepción
    } catch (e) {
      // Limpiar si hay error desconocido
      if (_auth.currentUser != null) {
        await _auth.currentUser?.delete();
      }
      throw FirebaseAuthException(
        code: 'registration-failed',
        message: 'Error durante el registro: ${e.toString()}',
      );
    }
  }

  Future<usermodel.User?> iniciarSesion(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final User? user = userCredential.user;
      if (user == null) {
        throw FirebaseAuthException(
          code: userNotFound,
          message: 'No se encontró el usuario',
        );
      }

      // Verificar si el email está verificado
      if (!user.emailVerified) {
        await verificarCorreoElectronico();
        throw FirebaseAuthException(
          code: emailNotVerified,
          message: 'Por favor verifica tu correo electrónico primero',
        );
      }

      // Obtener datos del usuario desde Firestore
      DocumentSnapshot userDoc = await _firestore.collection('users').doc(user.uid).get();

      if (!userDoc.exists || userDoc.data() == null) {
        throw FirebaseAuthException(
          code: 'user-data-missing',
          message: 'Datos de usuario no encontrados',
        );
      }

      // Actualizar última fecha de login
      await _firestore.collection('users').doc(user.uid).update({
        'lastLogin': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      });

      final userData = userDoc.data() as Map<String, dynamic>? ?? {};
      return usermodel.User.fromJson(userData);

    } on FirebaseAuthException catch (e) {
      throw e;
    } on FirebaseException catch (e) {
      throw FirebaseAuthException(
        code: 'firestore-error',
        message: 'Error al acceder a los datos: ${e.message ?? 'Error desconocido'}',
      );
    } catch (e) {
      throw FirebaseAuthException(
        code: 'login-error',
        message: 'Error durante el inicio de sesión',
      );
    }
  }

  Future<void> verificarCorreoElectronico() async {
    try {
      final user = _auth.currentUser;
      if (user != null && !user.emailVerified) {
        await user.sendEmailVerification();

        await _firestore.collection('users').doc(user.uid).update({
          'updatedAt': FieldValue.serverTimestamp(),
          'lastVerificationSent': FieldValue.serverTimestamp(),
        });
      }
    } on FirebaseAuthException catch (e) {
      throw e;
    } catch (e) {
      throw FirebaseAuthException(
        code: 'verification-error',
        message: 'Error al enviar correo de verificación',
      );
    }
  }

  Future<void> cerrarSesion() async {
    await _auth.signOut();
  }

  Stream<User?> get authStateChanges => _auth.authStateChanges();

  Future<usermodel.User?> getCurrentUser() async {
    final user = _auth.currentUser;
    if (user == null) return null;

    try {
      DocumentSnapshot userDoc = await _firestore.collection('users').doc(user.uid).get();
      if (!userDoc.exists || userDoc.data() == null) return null;

      final userData = userDoc.data() as Map<String, dynamic>? ?? {};
      return usermodel.User.fromJson(userData);
    } catch (e) {
      throw FirebaseAuthException(
        code: 'user-data-error',
        message: 'Error al obtener datos del usuario',
      );
    }
  }

  Future<bool> checkEmailVerification() async {
    final user = _auth.currentUser;
    if (user != null) {
      await user.reload();
      return user.emailVerified;
    }
    return false;
  }

  Future<void> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      throw e;
    } catch (e) {
      throw FirebaseAuthException(
        code: 'reset-password-error',
        message: 'Error al enviar correo de restablecimiento',
      );
    }
  }
}