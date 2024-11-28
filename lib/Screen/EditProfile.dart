import 'package:fit_25/Model/User.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  final User user;

  const ProfilePage({super.key, required this.user});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late TextEditingController _firstNameController;
  late TextEditingController _lastNameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _addressController;
  late TextEditingController _genderController;

  @override
  void initState() {
    super.initState();
    _firstNameController = TextEditingController(text: widget.user.name.first);
    _lastNameController = TextEditingController(text: widget.user.name.last);
    _emailController = TextEditingController(text: widget.user.email);
    _phoneController = TextEditingController(text: widget.user.phone);
    _addressController = TextEditingController(text: widget.user.address);
    _genderController = TextEditingController(text: widget.user.gender);
  }

  void _saveProfile() {
    final updatedUser = User(
      name: UserName(
        title: widget.user.name.title,
        first: _firstNameController.text.trim(),
        last: _lastNameController.text.trim(),
      ),
      email: _emailController.text.trim(),
      gender: _genderController.text.trim(),
      phone: _phoneController.text.trim(),
      address: _addressController.text.trim(),
    );

    Navigator.pop(context, updatedUser);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Chỉnh sửa thông tin')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _firstNameController,
              decoration: const InputDecoration(labelText: 'Tên'),
            ),
            TextField(
              controller: _lastNameController,
              decoration: const InputDecoration(labelText: 'Họ'),
            ),
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: _phoneController,
              decoration: const InputDecoration(labelText: 'Số Điện Thoại'),
            ),
            TextField(
              controller: _addressController,
              decoration: const InputDecoration(labelText: 'Địa chỉ'),
            ),
            TextField(
              controller: _genderController,
              decoration: const InputDecoration(labelText: 'Giới tính'),
            ),
            const Spacer(),
            ElevatedButton(
              onPressed: _saveProfile,
              child: const Text('Lưu'),
            ),
          ],
        ),
      ),
    );
  }
}
