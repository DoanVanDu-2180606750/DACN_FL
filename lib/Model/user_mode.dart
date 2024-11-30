class User {
  final String? id;
  final String? name;
  final String? email;
  final String? gender;
  final String? phone;
  final String? address;
  final String? image;

  User({
    this.id,
    this.name,
    this.email,
    this.gender,
    this.phone,
    this.address,
    this.image,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['_id'],
      name: json['name'],
      email: json['email'],
      gender: json['gender'],
      phone: json['phone'],
      address: json['address'],
      image: json['image'],
    );
  }
}
