
class User {
  final UserName name;
  final String email;
  final String gender;
  final String phone;
  User({
    required this.name,
    required this.email,
    required this.gender,
    required this.phone,
  });
}
 class UserName {
  final String title;
  final String first;
  final String last;
  UserName({
    required this.title,
    required this.first,
    required this.last,
  });
 }