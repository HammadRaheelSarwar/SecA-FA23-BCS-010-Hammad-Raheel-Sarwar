class User {
  final int? id;
  final String name;
  final String email;
  final String passwordHash;

  User({
    this.id,
    required this.name,
    required this.email,
    required this.passwordHash,
  });

  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{
      'name': name,
      'email': email,
      'password_hash': passwordHash,
    };
    if (id != null) map['id'] = id;
    return map;
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'] as int?,
      name: map['name'] as String,
      email: map['email'] as String,
      passwordHash: map['password_hash'] as String,
    );
  }
}
