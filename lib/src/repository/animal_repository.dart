import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/animal.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebaseauth;
class AnimalRepository {
  // Crear (crearAnimal)
  Future<void> crearAnimal(Animal animal) async {
    try {
      final firebaseUser = firebaseauth.FirebaseAuth.instance.currentUser;
      if (firebaseUser != null) {
        final userId = firebaseUser.uid; // Obtener el UID del usuario actual
        // Guardar el animal en la subcolección 'animales' del usuario
        await FirebaseFirestore.instance.collection('users').doc(userId).collection('animals').add(animal.toJson());
        print('Perfil de peludito creado exitosamente para el usuario $userId');
      } else {
        print('Error: Usuario no autenticado');
        // Maneja el error (por ejemplo, muestra un mensaje al usuario)
      }
    } catch (e) {
      print('Error al crear el perfil del peludito: $e');
      // Maneja el error
    }
  }
  // Ver Animal (leerAnimal)
  Future<Animal?> verAnimal(Animal animal) async {
    try {
      //Definimos la consulta para obtener o ver la informacion de un Animal
      final querySnapshot = await FirebaseFirestore.instance.collection('animals').where('nombre', isEqualTo: animal.nombre).get();

      if (querySnapshot.docs.isNotEmpty) {
        final doc = querySnapshot.docs.first; // Obtener el primer documento coincidente
        return Animal.fromJson(doc.data());
      } else {
        return null; // Animal no encontrado
      }
      } catch (e) {
        print('Error al acceder al perfil del peludito: $e');
      // Maneja el error
      return null;
      }
    }

  // Actualizar (actualizarAnimal)
  Future<void> actualizarAnimal(DocumentReference animalRef, Animal animal) async {
    try {
      await animalRef.update(animal.toJson());
    } catch (e) {
      print('Error al actualizar el perfil de su hijo Peludito: $e');
      // Maneja el error
    }
  }
  // Eliminar (eliminarAnimal)
  Future<void> eliminarAnimal(DocumentReference animalRef) async {
    try {
      await animalRef.delete();
    } catch (e) {
      print('Error al eliminar el perfil de su Peludito: $e');
      // Maneja el error
    }
  }
}