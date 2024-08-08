import 'location.model.dart';

class User {
  int? id;
  String? googleId;
  String? name;
  String? username;
  String? email;
  String? gender;
  String? photoURL;
  String? instagram;
  String? twitter;
  DateTime? emailVerifiedAt;
  DateTime? lastActive;
  DateTime? createdAt;
  DateTime? updatedAt;
  bool? isAdmin;
  Location? location;

  User({
    this.id,
    this.googleId,
    this.name,
    this.username,
    this.email,
    this.gender,
    this.photoURL,
    this.instagram,
    this.twitter,
    this.isAdmin,
    this.emailVerifiedAt,
    this.lastActive,
    this.createdAt,
    this.updatedAt,
    this.location,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      googleId: json['google_id'],
      name: json['name'],
      username: json['username'],
      email: json['email'],
      gender: json['gender'],
      photoURL: json['photo_url'],
      instagram: json['instagram'],
      twitter: json['twitter'],
      isAdmin: json['is_admin'],
      location: json['location'] != null && json['location'].isNotEmpty
          ? Location.fromJson(json['location'])
          : null,
      emailVerifiedAt: DateTime.tryParse(json['email_verified_at'] ?? ''),
      lastActive: json['last_active'] is Map
          ? DateTime.tryParse(json['last_active']['date'] ?? '')
          : DateTime.tryParse(json['last_active'] ?? ''),
      createdAt: DateTime.tryParse(json['created_at'] ?? ''),
      updatedAt: DateTime.tryParse(json['updated_at'] ?? ''),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'google_id': googleId,
      'name': name,
      'username': username,
      'email': email,
      'gender': gender,
      'photo_url': photoURL,
      'instagram': instagram,
      'twitter': twitter,
      'is_admin': isAdmin,
      'location': location?.toJson(),
      'email_verified_at': emailVerifiedAt?.toIso8601String(),
      'last_active': lastActive?.toIso8601String(),
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }
}
