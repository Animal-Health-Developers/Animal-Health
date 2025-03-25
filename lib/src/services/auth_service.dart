import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user.dart' as usermodel; //Usamos un Alias para evitar conflictos con metodos y clases.

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Registro con correo electrónico, nombre de usuario y contraseña
  Future<usermodel.User?> registrarUsuario(
      String email,
      String userName,
      String password,
      String confirmPassword,
      String nombre,
      String numcontact,
      String direccion,
      String rol,
      Timestamp fechanacimiento,
      String bio) async {
    // Validación de contraseñas
    if (password != confirmPassword) {
      print('La contraseña y la confirmación no coinciden.');
      return null;
    }
    if (password.length < 8) {
      print('La contraseña debe tener al menos 8 caracteres.');
      return null;
    }
    try {
      UserCredential userCredential =
      await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      // Actualizar el nombre para mostrar (nickname)
      await userCredential.user?.updateProfile(displayName: userName);
      // Crear un objeto User con los datos del formulario
      final usuario = usermodel.User(
        nombre: nombre,
        email: email,
        password: password, //  encriptar la contraseña antes de guardarla
        userName: userName,
        numcontact: numcontact,
        direccion: direccion,
        rol: rol,
        profilePicture: null,
        fechanacimiento: fechanacimiento,
        bio: bio,
      );
      // Guardar datos adicionales del usuario en Cloud Firestore
      await _firestore
          .collection('users')
          .doc(userCredential.user!.uid)
          .set(usuario.toJson());
      return usuario; // Retornar el objeto userModel.User
    } on FirebaseAuthException catch (e) {
      // Usa el alias en on-catch
      // Manejo de errores de Firebase Authentication
      if (e.code == 'weak-password') {
        print('La contraseña proporcionada es demasiado débil.');
      } else if (e.code == 'email-already-in-use') {
        print('Ya existe una cuenta con este correo electrónico.');
      } else {
        print('Error de autenticación: ${e.code}');
      }
      return null;
    } catch (e) {
      // Manejo de otros errores
      print('Error: $e');
      return null;
    }
  }

  Future<void> verificarCorreoElectronico() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null && !user.emailVerified) {
        await user.sendEmailVerification();
        print(
            'Se ha enviado un correo electrónico de verificación a ${user.email}');
      } else {
        print(
            'El usuario ya ha verificado su correo electrónico o no ha iniciado sesión.');
      }
    } catch (e) {
      print('Error al enviar el correo electrónico de verificación: $e');
    }
  }

  // Inicio de sesión con correo electrónico y contraseña
  Future<usermodel.User?> iniciarSesion(String email, String password) async {
    try {
      UserCredential userCredential =
      await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      // Obtener el documento del usuario de Firestore
      DocumentSnapshot userDoc = await _firestore
          .collection('users')
          .doc(userCredential.user!.uid)
          .get();
      // Asegúrate de que userDoc.data() no sea nulo antes de acceder a sus campos
      if (userDoc.exists && userDoc.data() != null) {
        try {
          // Obtener los datos del usuario como un mapa
          Map<String, dynamic> userData =
          userDoc.data() as Map<String, dynamic>;
          // Convertir 'fechanacimiento' de DateTime a Timestamp
          if (userData['fechanacimiento'] is DateTime) {
            userData['fechanacimiento'] =
                Timestamp.fromDate(userData['fechanacimiento'] as DateTime);
          }
          // Crear el objeto User con el Timestamp
          usermodel.User usuario = usermodel.User.fromJson(userData);
          return usuario;
        } catch (e) {
          print('Error al convertir los datos del usuario: $e');
          return null;
        }
      }
    } on FirebaseAuthException catch (e) {
      // Manejo de errores de Firebase Authentication
      if (e.code == 'user-not-found') {
        print('No se encontró ningún usuario con ese correo electrónico.');
      } else if (e.code == 'wrong-password') {
        print('Contraseña incorrecta proporcionada para ese usuario.');
      } else {
        print('Error de autenticación: ${e.code}');
      }
      return null;
    } catch (e) {
      // Manejo de otros errores
      print('Error: $e');
      return null;
    }
    return null;
  }

  // Cerrar sesión
  Future<void> cerrarSesion() async {
    await _auth.signOut();
  }
  // getter que retorna un Stream de objetos firebaseauth.User
  Stream<User?> get authStateChanges => _auth.authStateChanges();
  // Obtener el usuario actual con todos sus datos desde Firestore
  Future<usermodel.User?> getAppUser(String uid) async {
    if (uid.isNotEmpty) {
      try {
        final DocumentSnapshot userDoc =
        await _firestore.collection('users').doc(uid).get();
        if (userDoc.exists && userDoc.data() != null) {
          Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>;
          if (userData['fechanacimiento'] is DateTime) {
            userData['fechanacimiento'] =
                Timestamp.fromDate(userData['fechanacimiento'] as DateTime);
          }
          usermodel.User usuario = usermodel.User.fromJson(userData);
          return usuario;
        }
      } catch (e) {
        print('Error al obtener datos del usuario de Firestore: $e');
        return null;
      }
    }
    return null;
  }
}