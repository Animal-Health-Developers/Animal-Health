import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebaseauth;
import 'package:json_annotation/json_annotation.dart';
part 'user.g.dart';
@JsonSerializable()
class User {
  //Nombre del usuario
  String nombre;
  //Email del usuario
  String email;
  //Password de la cuenta del usuario, esta no debe ser texto plano.
  String password;
  //UserName
  String? userName;
  //Numero de contacto del Usuario
  String numcontact;
  //Direccion de la ubicacion del usuario
  String direccion;
  //Rol que tiene el usuario dentro de la App dependiendo si es adminsitrador o usuario normal
  String rol;
  // URL de foto de perfil opcional
  String? profilePicture;
  // Fecha de nacimiento opcional
  @TimestampConverter()
  Timestamp fechanacimiento;
  //Biografía opcional
  String bio;
  //Constructor de la clase Usuario o User.
  User({
    required this.nombre,
    required this.email,
    required this.password,
    required this.userName,
    required this.numcontact,
    required this.direccion,
    required this.rol,
    required this.profilePicture,
    required this.fechanacimiento,
    required this.bio
  });
  Map<String, dynamic> toJson() {
    return{
      'nombre': nombre,
      'email' : email,
      'password' : password,
      'userName' : userName,
      'numcontact' : numcontact,
      'direccion' : direccion,
      'rol' : rol,
      'profilePicture' : profilePicture,
      'fechanacimiento': fechanacimiento,
      'bio' : bio,
    };
  }
  factory User.fromJson(Map<String, dynamic> json) {
    final user = _$UserFromJson(json);
    // Verificar si 'fechanacimiento' es un Timestamp válido
    if (json['fechanacimiento'] is Timestamp) {
      // Si es un Timestamp válido, no es necesario convertirlo
      user.fechanacimiento = json['fechanacimiento'] as Timestamp;
    } else if (json['fechanacimiento'] is DateTime) {
      // Si es un DateTime, convertirlo a Timestamp
      user.fechanacimiento = Timestamp.fromDate(json['fechanacimiento'] as DateTime);
    } else if (json['fechanacimiento'] is int) {
      // Si es un int, convertirlo a Timestamp
      user.fechanacimiento = Timestamp.fromMillisecondsSinceEpoch(json['fechanacimiento'] * 1000);
    } else if (json['fechanacimiento'] is Map && json.containsKey('seconds') && json.containsKey('nanoseconds')) {
      // Si es un Map con 'seconds' y 'nanoseconds', convertirlo a Timestamp
      user.fechanacimiento = Timestamp(json['fechanacimiento']['seconds'] as int, json['fechanacimiento']['nanoseconds'] as int);
    } else {
      // Manejar otros casos o lanzar una excepción
      print('Formato de fechanacimiento desconocido: ${json['fechanacimiento']}');
      user.fechanacimiento = Timestamp.now(); // O un valor predeterminado adecuado
    }
    return user;
  }
  factory User.fromFirebaseUser(firebaseauth.User firebaseUser) { // Cambiar el tipo del parámetro
    return User(
      nombre: firebaseUser.displayName ?? '', // Usar firebaseUser para acceder a displayName
      email: firebaseUser.email ?? '', // Usar firebaseUser para acceder a email
      password: '', // No se debe almacenar la contraseña aquí, se obtiene de Firebase Authentication
      userName: '', //nombre de usuario o nickname
      numcontact: '', // Puedes obtener este valor de Firestore si lo almacenas allí
      direccion: '', // Puedes obtener este valor de Firestore si lo almacenas allí
      rol: '', // Puedes obtener este valor de Firestore si lo almacenas allí
      profilePicture: firebaseUser.photoURL, // Usar firebaseUser para acceder a photoURL
      fechanacimiento: Timestamp.fromDate(DateTime.now()), // O usar otro valor predeterminado si es nulo
      bio: '', // Puedes obtener este valor de Firestore si lo almacenas allí
    );
  }
}
class TimestampConverter implements JsonConverter<Timestamp, dynamic> {
  const TimestampConverter();
  @override
  Timestamp fromJson(dynamic json) {
    if (json is int) {
      return Timestamp.fromMillisecondsSinceEpoch(json * 1000); // Convertir segundos a milisegundos
    } else if (json is Map && json.containsKey('seconds') && json.containsKey('nanoseconds')) {
      return Timestamp(json['seconds'] as int, json['nanoseconds'] as int);
    } else if (json is DateTime) {
      return Timestamp.fromDate(json); // Convertir DateTime a Timestamp
    } else {
      // Manejar otros casos o lanzar una excepción
      print('Formato de fechanacimiento desconocido: $json');
      return Timestamp.now(); // O un valor predeterminado adecuado
    }
  }
  @override
  dynamic toJson(Timestamp object) => object.toDate().toIso8601String();
}