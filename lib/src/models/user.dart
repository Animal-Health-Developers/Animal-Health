import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

@JsonSerializable(explicitToJson: true)
class User {
  final String uid;
  final String email;
  final String userName;
  final String password;
  final bool emailVerified;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String? profilePhotoUrl;
  final DateTime? fechaNacimiento;
  final String? documento;
  final String? contacto;

  User({
    required this.uid,
    required this.email,
    required this.userName,
    required this.password,
    required this.emailVerified,
    required this.createdAt,
    required this.updatedAt,
    this.profilePhotoUrl,
    this.fechaNacimiento,
    this.documento,
    this.contacto,
  });

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  Map<String, dynamic> toJson() => _$UserToJson(this);

  User copyWith({
    String? uid,
    String? email,
    String? userName,
    String? password,
    bool? emailVerified,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? profilePhotoUrl,
    DateTime? fechaNacimiento,
    String? documento,
    String? contacto,
  }) {
    return User(
      uid: uid ?? this.uid,
      email: email ?? this.email,
      userName: userName ?? this.userName,
      password: password ?? this.password,
      emailVerified: emailVerified ?? this.emailVerified,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      profilePhotoUrl: profilePhotoUrl ?? this.profilePhotoUrl,
      fechaNacimiento: fechaNacimiento ?? this.fechaNacimiento,
      documento: documento ?? this.documento,
      contacto: contacto ?? this.contacto,
    );
  }

  User updateProfilePhoto(String newPhotoUrl) {
    return copyWith(profilePhotoUrl: newPhotoUrl);
  }
}