class User {
  final int id;
  final String name;
  final String email;
  final String role; // user أو admin أو guest

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
  });

  // من JSON (اللي يرجعه السيرفر) إلى User
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      role: json['role'] ?? 'user',
    );
  }

  // من User إلى JSON (عشان نحفظه في الجهاز)
  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name, 'email': email, 'role': role};
  }

  bool get isGuest => role == 'guest';
}
