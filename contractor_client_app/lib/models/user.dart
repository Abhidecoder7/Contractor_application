class User {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String profilePicture;
  final String userType;
  final DateTime createdAt;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.profilePicture,
    required this.userType,
    required this.createdAt,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['_id'],
      name: json['name'],
      email: json['email'],
      phone: json['phone'],
      profilePicture: json['profilePicture'] ?? '',
      userType: json['userType'],
      createdAt: DateTime.parse(json['createdAt']),
    );
  }
}