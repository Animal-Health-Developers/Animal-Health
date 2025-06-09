// src/services/auth_service.dart
// Para ChangeNotifier
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart'; // Importar GoogleSignIn
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:developer' as developer;
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import '../models/user.dart' as usermodel; // Asumiendo que tienes un modelo user.dart

class AuthService extends ChangeNotifier {
  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;
  final FirebaseStorage _storage;
  final ImagePicker _picker;
  final GoogleSignIn _googleSignIn;

  static const String emailAlreadyInUse = 'email-already-in-use';
  static const String invalidEmail = 'invalid-email';
  static const String weakPassword = 'weak-password';
  static const String userDisabled = 'user-disabled';
  static const String userNotFound = 'user-not-found';
  static const String wrongPassword = 'wrong-password';
  static const String emailNotVerified = 'email-not-verified';

  AuthService({
    FirebaseAuth? firebaseAuth,
    FirebaseFirestore? firestore,
    FirebaseStorage? firebaseStorage,
    ImagePicker? imagePicker,
    GoogleSignIn? googleSignIn,
  }) : _auth = firebaseAuth ?? FirebaseAuth.instance,
        _firestore = firestore ?? FirebaseFirestore.instance,
        _storage = firebaseStorage ?? FirebaseStorage.instance,
        _picker = imagePicker ?? ImagePicker(),
        _googleSignIn = googleSignIn ?? GoogleSignIn();

  // Esta es la única definición de authStateChanges que debe existir
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  User? get currentUser => _auth.currentUser;

  // ***************************************************************
  // MÉTODOS AUXILIARES MOVIDOS AL INICIO DE LA CLASE
  // PARA QUE ESTÉN DEFINIDOS ANTES DE SER USADOS.
  // ***************************************************************

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
          await Future.delayed(const Duration(seconds: 1));
        }
      }
    }

    throw lastError ?? FirebaseException(plugin: 'firestore', message: 'Error al obtener datos del usuario después de $retries intentos',);
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
          await Future.delayed(const Duration(seconds: 1));
        }
      }
    }

    throw lastError ?? FirebaseException(
      plugin: 'firestore',
      message: 'Error al actualizar datos del usuario después de $retries intentos',
    );
  }

  Future<String> _uploadProfilePhoto(dynamic imageFile, String userId) async {
    try {
      developer.log('Subiendo foto de perfil para usuario $userId...');

      final Reference ref = _storage.ref().child('profile_photos').child('$userId-${DateTime.now().millisecondsSinceEpoch}.jpg');

      if (kIsWeb) {
        final bytes = await imageFile.readAsBytes();
        final metadata = SettableMetadata(contentType: 'image/jpeg');
        final UploadTask uploadTask = ref.putData(bytes, metadata);
        await uploadTask;
      } else {
        final UploadTask uploadTask = ref.putFile(imageFile as File);
        await uploadTask;
      }

      final String downloadUrl = await ref.getDownloadURL();
      developer.log('Foto subida correctamente. URL: $downloadUrl');

      return downloadUrl;
    } catch (e) {
      developer.log('Error en _uploadProfilePhoto: $e');
      throw FirebaseAuthException(code: 'upload-photo-error', message: 'Error al subir la foto de perfil: ${e.toString()}',);
    }
  }

  Future<dynamic> pickImage() async {
    try {
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery, imageQuality: 85,);
      if (image == null) return null;

      if (kIsWeb) {
        return image;
      } else {
        return File(image.path);
      }
    } catch (e) {
      developer.log('Error al seleccionar imagen: $e');
      throw FirebaseAuthException(code: 'image-pick-error', message: 'Error al seleccionar la imagen: ${e.toString()}',);
    }
  }

  // ***************************************************************
  // FIN DE MÉTODOS AUXILIARES
  // ***************************************************************


  Future<User?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return null;

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential = await _auth.signInWithCredential(credential);
      final User? user = userCredential.user;

      if (user != null) {
        await _firestore.collection('users').doc(user.uid).set({
          'uid': user.uid,
          'email': user.email,
          'displayName': user.displayName,
          'profilePhotoUrl': user.photoURL,
          'lastLogin': FieldValue.serverTimestamp(),
        }, SetOptions(merge: true));
        developer.log("Usuario de Google iniciado sesión: ${user.displayName}");
        notifyListeners();
      }
      return user;
    } catch (e) {
      developer.log("Error al iniciar sesión con Google: $e");
      return null;
    }
  }

  Future<usermodel.User?> registrarUsuario({
    required String email,
    required String userName,
    required String password,
    required String confirmPassword,
    DateTime? fechaNacimiento,
    dynamic profileImage,
  }) async {
    try {
      if (email.isEmpty || !email.contains('@')) {
        throw FirebaseAuthException(code: invalidEmail, message: 'Por favor ingresa un correo electrónico válido',);
      }
      if (userName.isEmpty || userName.length < 3) {
        throw FirebaseAuthException(code: 'invalid-username', message: 'El nombre de usuario debe tener al menos 3 caracteres',);
      }
      if (password != confirmPassword) {
        throw FirebaseAuthException(code: 'passwords-mismatch', message: 'Las contraseñas no coinciden',);
      }
      if (password.length < 8) {
        throw FirebaseAuthException(code: weakPassword, message: 'La contraseña debe tener al menos 8 caracteres',);
      }

      final methods = await _auth.fetchSignInMethodsForEmail(email);
      if (methods.isNotEmpty) {
        throw FirebaseAuthException(code: emailAlreadyInUse, message: 'El correo electrónico ya está registrado',);
      }

      final UserCredential userCredential = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      final User? user = userCredential.user;
      if (user == null) {
        throw FirebaseAuthException(code: 'user-creation-failed', message: 'No se pudo crear el usuario',);
      }

      String? photoUrl;
      if (profileImage != null) {
        photoUrl = await _uploadProfilePhoto(profileImage, user.uid); // _uploadProfilePhoto ahora está definido
      }

      await user.updateProfile(displayName: userName, photoURL: photoUrl);
      await user.reload();

      final usuario = usermodel.User(
        uid: user.uid,
        email: user.email ?? '',
        userName: userName,
        password: password,
        emailVerified: false,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        fechaNacimiento: fechaNacimiento,
        documento: null,
        contacto: null,
        profilePhotoUrl: photoUrl,
      );

      await _firestore.collection('users').doc(user.uid).set(usuario.toJson());
      await user.sendEmailVerification();
      notifyListeners();
      return usuario;
    } on FirebaseAuthException {
      if (_auth.currentUser != null) {
        await _auth.currentUser?.delete();
      }
      rethrow;
    } catch (e) {
      if (_auth.currentUser != null) {
        await _auth.currentUser?.delete();
      }
      throw FirebaseAuthException(code: 'registration-failed', message: 'Error durante el registro: ${e.toString()}',);
    }
  }

  Future<usermodel.User?> iniciarSesion(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(email: email, password: password);
      final User? user = userCredential.user;
      if (user == null) {
        throw FirebaseAuthException(code: userNotFound, message: 'No se encontró el usuario',);
      }
      if (!user.emailVerified) {
        await verificarCorreoElectronico();
        throw FirebaseAuthException(code: emailNotVerified, message: 'Por favor verifica tu correo electrónico primero',);
      }

      DocumentSnapshot userDoc = await _firestore.collection('users').doc(user.uid).get();
      if (!userDoc.exists) {
        throw FirebaseAuthException(code: 'user-data-missing', message: 'Datos de usuario no encontrados',);
      }

      await _firestore.collection('users').doc(user.uid).update({
        'lastLogin': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      });
      notifyListeners();
      return usermodel.User.fromJson(userDoc.data() as Map<String, dynamic>);
    } on FirebaseAuthException {
      rethrow;
    } catch (e) {
      throw FirebaseAuthException(code: 'login-error', message: 'Error durante el inicio de sesión: ${e.toString()}',);
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
        notifyListeners();
      }
    } catch (e) {
      throw FirebaseAuthException(code: 'verification-error', message: 'Error al enviar correo de verificación',);
    }
  }

  Future<void> cerrarSesion() async {
    try {
      await _googleSignIn.signOut();
      await _auth.signOut();
      developer.log("Sesión cerrada.");
      notifyListeners();
    } catch (e) {
      developer.log("Error al cerrar sesión: $e");
      rethrow;
    }
  }

  Future<usermodel.User?> getCurrentUser() async {
    try {
      final user = _auth.currentUser;
      if (user == null) return null;

      DocumentSnapshot userDoc = await _getUserDataWithRetry(user.uid); // _getUserDataWithRetry ahora está definido

      if (!userDoc.exists) {
        final newUser = usermodel.User(
          uid: user.uid,
          email: user.email ?? '',
          userName: user.displayName ?? 'Usuario sin nombre',
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

      final userData = userDoc.data();
      if (userData == null) {
        throw FirebaseAuthException(code: 'invalid-user-data', message: 'Datos de usuario no encontrados',);
      }

      final Map<String, dynamic> userJson = userData as Map<String, dynamic>;

      DateTime? parseDate(dynamic date) {
        if (date == null) return null;
        if (date is Timestamp) return date.toDate();
        if (date is DateTime) return date;
        if (date is String) {
          try {
            return DateTime.parse(date);
          } catch (e) {
            developer.log('Error al parsear fecha: $date');
            return null;
          }
        }
        return null;
      }

      return usermodel.User(
        uid: userJson['uid'] as String? ?? user.uid,
        email: userJson['email'] as String? ?? user.email ?? '',
        userName: userJson['userName'] as String? ?? user.displayName ?? 'Usuario sin nombre',
        password: userJson['password'] as String? ?? '',
        emailVerified: userJson['emailVerified'] as bool? ?? user.emailVerified,
        createdAt: parseDate(userJson['createdAt']) ?? DateTime.now(),
        updatedAt: parseDate(userJson['updatedAt']) ?? DateTime.now(),
        fechaNacimiento: parseDate(userJson['fechaNacimiento']),
        documento: userJson['documento'] as String?,
        contacto: userJson['contacto'] as String?,
        profilePhotoUrl: userJson['profilePhotoUrl'] as String? ?? user.photoURL,
      );

    } on FirebaseException catch (e) {
      developer.log('Error en getCurrentUser: ${e.code} - ${e.message}');
      throw FirebaseAuthException(code: 'firestore-error', message: 'Error al obtener datos: ${e.message}',);
    } catch (e) {
      developer.log('Error desconocido en getCurrentUser: $e');
      throw FirebaseAuthException(code: 'user-data-error', message: 'Error al obtener datos del usuario',);
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
    } catch (e) {
      throw FirebaseAuthException(code: 'reset-password-error', message: 'Error al enviar correo de restablecimiento',);
    }
  }

  Future<bool> actualizarUsuario({
    required String email,
    required String userName,
    required DateTime? fechaNacimiento,
    required String documento,
    required String contacto,
    required String password,
    dynamic profilePhotoUrl,
  }) async {
    try {
      final user = _auth.currentUser;
      if (user == null) {
        throw FirebaseAuthException(code: 'user-not-authenticated', message: 'Usuario no autenticado',);
      }

      String? nuevaFotoUrl;

      if (profilePhotoUrl != null) {
        developer.log('Iniciando subida de foto de perfil...');
        nuevaFotoUrl = await _uploadProfilePhoto(profilePhotoUrl, user.uid); // _uploadProfilePhoto ahora está definido
        developer.log('Foto de perfil subida correctamente. URL: $nuevaFotoUrl');
      }

      final updateData = <String, dynamic>{
        'email': email,
        'userName': userName,
        'fechaNacimiento': fechaNacimiento != null ? Timestamp.fromDate(fechaNacimiento) : null,
        'documento': documento,
        'contacto': contacto,
        'updatedAt': FieldValue.serverTimestamp(),
        if (nuevaFotoUrl != null) 'profilePhotoUrl': nuevaFotoUrl,
      };

      if (email != user.email) {
        try {
          await user.updateEmail(email);
          await user.sendEmailVerification();
        } on FirebaseAuthException catch (e) {
          if (e.code == 'requires-recent-login') {
            throw FirebaseAuthException(code: 'requires-recent-login', message: 'Por favor, reautentícate para cambiar tu email',);
          }
          rethrow;
        }
      }

      if (password.isNotEmpty) {
        try {
          await user.updatePassword(password);
        } on FirebaseAuthException catch (e) {
          if (e.code == 'requires-recent-login') {
            throw FirebaseAuthException(code: 'requires-recent-login', message: 'Por favor, reautentícate para cambiar tu contraseña',);
          }
          rethrow;
        }
      }

      developer.log('Actualizando datos en Firestore...');
      await _updateUserDataWithRetry(user.uid, updateData); // _updateUserDataWithRetry ahora está definido
      developer.log('Datos actualizados correctamente en Firestore');
      notifyListeners();
      return true;
    } on FirebaseAuthException catch (e) {
      developer.log('Error en actualizarUsuario (Auth): ${e.code} - ${e.message}');
      rethrow;
    } catch (e) {
      developer.log('Error desconocido en actualizarUsuario: $e');
      throw FirebaseAuthException(code: 'update-error', message: 'Error al actualizar usuario: ${e.toString()}',);
    }
  }

  Future<void> reautenticarUsuario(String email, String password) async {
    try {
      final user = _auth.currentUser;
      if (user == null) {
        throw FirebaseAuthException(code: 'user-not-authenticated', message: 'Usuario no autenticado',);
      }

      final credential = EmailAuthProvider.credential(email: email, password: password,);
      await user.reauthenticateWithCredential(credential);
    } on FirebaseAuthException catch (e) {
      developer.log('Error en reautenticarUsuario: ${e.code} - ${e.message}');
      rethrow;
    } catch (e) {
      developer.log('Error desconocido en reautenticarUsuario: $e');
      throw FirebaseAuthException(code: 'reauth-error', message: 'Error durante la reautenticación: ${e.toString()}',);
    }
  }
}