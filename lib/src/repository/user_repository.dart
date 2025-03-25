import '../models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebaseauth;
class UserRepository{
  Future<void> crearUsuario(User user) async {
    try {
      final firebaseUser = firebaseauth.FirebaseAuth.instance.currentUser;
      if (firebaseUser != null) {
        final userId = firebaseUser.uid; // Obtener el UID del usuario actual
        // Crear un nuevo documento con un ID automático
        final docRef = await FirebaseFirestore.instance.collection('users').add({...user.toJson(), // Agregar los datos del usuario
          'uid': userId, // Agregar el UID al documento
        });
        print('Usuario Exitosamente Creado! ID del documento: ${docRef.id}');
      } else {
        print('Error: Usuario no autenticado');
        // Maneja el error (por ejemplo, muestra un mensaje al usuario)
      }
    } catch (e) {
      print('Error al Crear el Usuario: $e');
    }
  }
  Future<User?> verUsuario(User user) async{
    try{
      final querySnapshot = await FirebaseFirestore.instance.collection('users').where('email', isEqualTo: user.email).get();
      if (querySnapshot.docs.isNotEmpty) {
        final doc = querySnapshot.docs.first; // Obtener el primer documento coincidente
        return User.fromJson(doc.data());
      } else {
        return null; // Usruario no Encontrado
      }
    }catch(e){
      print('No se puede Visualizar al Usuario: $e');
    }
return null;
  }
  Future<void> actulizarUsuario(DocumentReference userRef, User user) async {
    try{
      await userRef.update(user.toJson());
      print('Usuario Actulizado Exitosamente!');
    }catch(e){
      print('El Usuario no pudo ser Actilizado: $e');
    }
  }
  Future<void> eliminarUsuario(DocumentReference userRef) async{
    try{
      await userRef.delete();
      print('El Usuario ha Sido Eliminado Exitosamente!');
    }catch(e){
      print('El Usuario no Pudo ser Eliminado: $e');
    }
  }
}