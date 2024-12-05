class User {
  final String id;
  final String name;
  final String email;
  final String password; // Note: ensure this field is secure
  final String? vToken; // Make this nullable
  final String image;
  final String role;
  final String address;
  final String gender;
  final String phone;
  final DateTime createdAt;
  final DateTime updatedAt;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.password,
    this.vToken,
    required this.image,
    required this.role,
    required this.address,
    required this.gender,
    required this.phone,
    required this.createdAt,
    required this.updatedAt,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      password: json['password'] ?? '',
      vToken: json['vToken'] ?? '', // Handle null here
      image: json['image'] ?? '',
      role: json['role'] ?? '',
      address: json['address'] ?? '',
      gender: json['gender'] ?? '',
      phone: json['phone'] ?? '',
      createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : DateTime.now(),
      updatedAt: json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : DateTime.now(),
    );
  }
}
