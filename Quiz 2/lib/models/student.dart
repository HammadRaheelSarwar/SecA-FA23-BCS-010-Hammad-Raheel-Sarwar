class Student {
  final int? id;
  final String name;
  final String email;
  final int age;

  Student({this.id, required this.name, required this.email, required this.age});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'age': age,
    };
  }

  factory Student.fromMap(Map<String, dynamic> map) {
    return Student(
      id: map['id'],
      name: map['name'],
      email: map['email'],
      age: map['age'],
    );
  }
}
