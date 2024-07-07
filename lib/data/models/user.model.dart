class User {
  int? id;
  String? googleId;
  String? name;
  String? email;
  DateTime? emailVerifiedAt;
  DateTime? createdAt;
  DateTime? updatedAt;
  bool? isAdmin;

  User({
    this.id,
    this.googleId,
    this.name,
    this.email,
    this.isAdmin,
    this.emailVerifiedAt,
    this.createdAt,
    this.updatedAt,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      googleId: json['google_id'],
      name: json['name'],
      email: json['email'],
      isAdmin: json['is_admin'],
      emailVerifiedAt: DateTime.tryParse(json['email_verified_at'] ?? ''),
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
      'is_admin': isAdmin,
      'email_verified_at': emailVerifiedAt?.toIso8601String(),
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }
}
