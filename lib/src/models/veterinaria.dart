import 'package:json_annotation/json_annotation.dart';
part 'veterinaria.g.dart';

@JsonSerializable()
class Veterinaria {
  //Nombre de la veterinaria
  String nombre;
  //Servicios prestados
  List<String> servicios;
  //Direccion
  String direccion;
  //número de contacto
  int numcontacto;
  //ciudad en donde está ubicada
  String ciudad;
  //Barrio en donde está ubicada
  String barrio;

  Veterinaria ({
    required this.nombre,
    required this.servicios,
    required this.direccion,
    required this.numcontacto,
    required this.ciudad,
    required this.barrio

  });

  Map<String, dynamic> toMap() {
    return{
      'nombre': nombre,
      'servicios': servicios,
      'direccion': direccion,
      'numcontacto': numcontacto,
      'ciudad': ciudad,
      'barrio': barrio,
    };
  }
  factory Veterinaria.fromJson(Map<String, dynamic> json) => _$VeterinariaFromJson(json);
  Map<String, dynamic> toJson() => _$VeterinariaToJson(this);
}