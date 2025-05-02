import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../models/user.dart' as usermodel;

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  // Tipos de errores personalizados
  static const String emailAlreadyInUse = 'email-already-in-use';
  static const String invalidEmail = 'invalid-email';
  static const String weakPassword = 'weak-password';
  static const String userDisabled = 'user-disabled';
  static const String userNotFound = 'user-not-found';
  static const String wrongPassword = 'wrong-password';
  static const String emailNotVerified = 'email-not-verified';

  Future<usermodel.User?> registrarUsuario({
    required String email,
    required String userName,
    required String password,
    required String confirmPassword,
    DateTime? fechaNacimiento,
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

      // Crear documento en Firestore
      final usuario = usermodel.User(
        uid: user.uid,
        email: email,
        userName: userName,
        password: password,
        emailVerified: false,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        fechaNacimiento: fechaNacimiento,
        documento: null,
        contacto: null,
        profilePhotoUrl: null,
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
      throw e;
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

      if (!userDoc.exists) {
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

      return usermodel.User.fromJson(userDoc.data() as Map<String, dynamic>);
    } on FirebaseAuthException catch (e) {
      throw e;
    } catch (e) {
      throw FirebaseAuthException(
        code: 'login-error',
        message: 'Error durante el inicio de sesión: ${e.toString()}',
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
    try {
      final user = _auth.currentUser;
      if (user == null) return null;

      // Obtener datos del usuario con reintentos
      DocumentSnapshot userDoc = await _getUserDataWithRetry(user.uid);

      if (!userDoc.exists) {
        // Si no existe el documento, crearlo con datos básicos
        final newUser = usermodel.User(
          uid: user.uid,
          email: user.email ?? '',
          userName: user.displayName ?? '',
          password: '',
          emailVerified: user.emailVerified,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
          fechaNacimiento: null,
          documento: null,
          contacto: null,
          profilePhotoUrl: user.photoURL,
        );

        await _firestore.collection('users').doc(user.uid).set(newUser.toJson());
        return newUser;
      }

      return usermodel.User.fromJson(userDoc.data() as Map<String, dynamic>);
    } on FirebaseException catch (e) {
      print('Error en getCurrentUser: ${e.code} - ${e.message}');
      throw FirebaseAuthException(
        code: 'firestore-error',
        message: 'Error al obtener datos: ${e.message}',
      );
    } catch (e) {
      print('Error desconocido en getCurrentUser: $e');
      throw FirebaseAuthException(
        code: 'user-data-error',
        message: 'Error al obtener datos del usuario',
      );
    }
  }

  Future<DocumentSnapshot> _getUserDataWithRetry(String uid, {int retries = 3}) async {
    int attempt = 0;
    FirebaseException? lastError;

    while (attempt < retries) {
      try {
        return await _firestore.collection('users').doc(uid).get();
      } on FirebaseException catch (e) {
        lastError = e;
        attempt++;
        if (attempt < retries) {
          await Future.delayed(Duration(seconds: 1));
        }
      }
    }

    throw lastError ?? FirebaseException(
      plugin: 'firestore',
      message: 'Error al obtener datos del usuario después de $retries intentos',
    );
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
    } catch (e) {
      throw FirebaseAuthException(
        code: 'reset-password-error',
        message: 'Error al enviar correo de restablecimiento',
      );
    }
  }

  Future<bool> actualizarUsuario({
    required String email,
    required String userName,
    required DateTime? fechaNacimiento,
    required String documento,
    required String contacto,
    required String password,
    File? profilePhoto,
  }) async {
    try {
      final user = _auth.currentUser;
      if (user == null) {
        throw FirebaseAuthException(
          code: 'user-not-authenticated',
          message: 'Usuario no autenticado',
        );
      }

      // Subir foto de perfil si se proporcionó
      String? photoUrl;
      if (profilePhoto != null) {
        photoUrl = await uploadProfilePhoto(profilePhoto, user.uid);
      }

      // Preparar datos de actualización
      final updateData = <String, dynamic>{
        'userName': userName,
        'fechaNacimiento': fechaNacimiento,
        'documento': documento,
        'contacto': contacto,
        'updatedAt': FieldValue.serverTimestamp(),
        if (photoUrl != null) 'profilePhotoUrl': photoUrl,
      };

      // Actualizar email si es diferente
      if (email != user.email) {
        try {
          await user.updateEmail(email);
          await user.sendEmailVerification();
          updateData['email'] = email;
          updateData['emailVerified'] = false;
        } on FirebaseAuthException catch (e) {
          if (e.code == 'requires-recent-login') {
            throw FirebaseAuthException(
              code: 'requires-recent-login',
              message: 'Por favor, reautentícate para cambiar tu email',
            );
          }
          rethrow;
        }
      }

      // Actualizar contraseña si se proporcionó
      if (password.isNotEmpty) {
        try {
          await user.updatePassword(password);
        } on FirebaseAuthException catch (e) {
          if (e.code == 'requires-recent-login') {
            throw FirebaseAuthException(
              code: 'requires-recent-login',
              message: 'Por favor, reautentícate para cambiar tu contraseña',
            );
          }
          rethrow;
        }
      }

      // Actualizar en Firestore con manejo de reintentos
      await _updateUserDataWithRetry(user.uid, updateData);

      return true;
    } on FirebaseAuthException catch (e) {
      print('Error en actualizarUsuario (Auth): ${e.code} - ${e.message}');
      rethrow;
    } on FirebaseException catch (e) {
      print('Error en actualizarUsuario (Firestore): ${e.code} - ${e.message}');
      throw FirebaseAuthException(
        code: 'firestore-error',
        message: 'Error al actualizar datos: ${e.message}',
      );
    } catch (e) {
      print('Error desconocido en actualizarUsuario: $e');
      throw FirebaseAuthException(
        code: 'update-error',
        message: 'Error al actualizar usuario',
      );
    }
  }

  Future<void> _updateUserDataWithRetry(String uid, Map<String, dynamic> data, {int retries = 3}) async {
    int attempt = 0;
    FirebaseException? lastError;

    while (attempt < retries) {
      try {
        await _firestore.collection('users').doc(uid).update(data);
        return;
      } on FirebaseException catch (e) {
        lastError = e;
        attempt++;
        if (attempt < retries) {
          await Future.delayed(Duration(seconds: 1));
        }
      }
    }

    throw lastError ?? FirebaseException(
      plugin: 'firestore',
      message: 'Error al actualizar datos del usuario después de $retries intentos',
    );
  }

  Future<void> reautenticarUsuario(String email, String password) async {
    try {
      final user = _auth.currentUser;
      if (user == null) {
        throw FirebaseAuthException(
          code: 'user-not-authenticated',
          message: 'Usuario no autenticado',
        );
      }

      final credential = EmailAuthProvider.credential(
        email: email,
        password: password,
      );

      await user.reauthenticateWithCredential(credential);
    } on FirebaseAuthException catch (e) {
      print('Error en reautenticarUsuario: ${e.code} - ${e.message}');
      rethrow;
    } catch (e) {
      print('Error desconocido en reautenticarUsuario: $e');
      throw FirebaseAuthException(
        code: 'reauth-error',
        message: 'Error durante la reautenticación',
      );
    }
  }

  Future<String?> uploadProfilePhoto(File imageFile, String userId) async {
    try {
      final ref = _storage.ref().child('profile_photos/$userId.jpg');
      await ref.putFile(imageFile);
      return await ref.getDownloadURL();
    } catch (e) {
      print('Error al subir foto de perfil: $e');
      throw FirebaseAuthException(
        code: 'upload-photo-error',
        message: 'Error al subir la foto de perfil',
      );
    }
  }
}