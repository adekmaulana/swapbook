class User {
  int? id;
  String? googleId;
  String? name;
  String? email;
  String? gender;
  String? photoURL;
  DateTime? emailVerifiedAt;
  DateTime? lastActive;
  DateTime? createdAt;
  DateTime? updatedAt;
  bool? isAdmin;

  User({
    this.id,
    this.googleId,
    this.name,
    this.email,
    this.gender,
    this.photoURL,
    this.isAdmin,
    this.emailVerifiedAt,
    this.lastActive,
    this.createdAt,
    this.updatedAt,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      googleId: json['google_id'],
      name: json['name'],
      email: json['email'],
      gender: json['gender'],
      photoURL: json['photo_url'],
      isAdmin: json['is_admin'],
      emailVerifiedAt: DateTime.tryParse(json['email_verified_at'] ?? ''),
      lastActive: DateTime.tryParse(json['last_active'] ?? ''),
      createdAt: DateTime.tryParse(json['created_at'] ?? ''),
      updatedAt: DateTime.tryParse(json['updated_at'] ?? ''),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'google_id': googleId,
      'name': name,
      'email': email,
      'gender': gender,
      'photo_url': photoURL,
      'is_admin': isAdmin,
      'email_verified_at': emailVerifiedAt?.toIso8601String(),
      'last_active': lastActive?.toIso8601String(),
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }
}
