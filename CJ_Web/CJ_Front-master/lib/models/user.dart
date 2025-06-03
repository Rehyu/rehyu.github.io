class User {
  final String id;
  final String name;
  final String grade;
  final String department;

  User({
    required this.id,
    required this.name,
    required this.grade,
    required this.department,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      grade: json['grade'].toString(),
      department: json['department'],
    );
  }
}
