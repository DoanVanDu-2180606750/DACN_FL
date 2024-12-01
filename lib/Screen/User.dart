import 'package:fit_25/Model/user_mode.dart';
import 'package:fit_25/Screen/EditProfile.dart'; 
import 'package:fit_25/Widgets/user_widget.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class UserScreen extends StatefulWidget {
  const UserScreen({super.key});

  @override
  State<UserScreen> createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  List<dynamic> users = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _getUserData();
    });
  }

  Future<void> _getUserData() async {
    final String url = 'http://192.168.1.6:8080/api/get_users';

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final List<dynamic> jsonData = jsonDecode(response.body);
        setState(() {
          users = jsonData.map((e) => User.fromJson(e as Map<String, dynamic>)).toList();
        });
      } else {
        setState(() {
          users = [];
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to fetch data: ${response.reasonPhrase}')),
        );
      }
    } catch (error) {
      print('Error fetching user data: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching user data: $error')),
      );
    }
  }

  Future<void> _refreshUserData() async {
    await _getUserData();
  }

  Future<void> _navigateToEditProfile() async {
    if (users.isNotEmpty) {
      final updatedUser = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ProfilePage(user: users[0]),
        ),
      );

      if (updatedUser != null) {
        setState(() {
          users[0] = updatedUser;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (users.isEmpty) {
      return const Center(child: Text('Không có thông tin người dùng'));
    }

    final user = users[0];
    return Scaffold(
      appBar: AppBar(title: const Text('Thông tin người dùng')),
      body: RefreshIndicator(
        onRefresh: _refreshUserData,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              CircleAvatar(
                radius: 55,
                backgroundImage: user.image != null 
                    ? NetworkImage(user.image) // Sử dụng NetworkImage
                    : null,
                child: user.image == null ? const Icon(Icons.person, size: 55) : null,
              ),
              Text(
                user.name ?? 'Tên không có sẵn',
                style: const TextStyle(fontSize: 24),
              ),
              const SizedBox(height: 16),
              UserWidget.infoRow('Email', user.email ?? 'N/A'),
              UserWidget.infoRow('Giới tính', user.gender ?? 'N/A'),
              UserWidget.infoRow('Số Điện Thoại', user.phone ?? 'N/A'),
              UserWidget.infoRow('Địa chỉ', user.address ?? 'N/A'),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _navigateToEditProfile,
                child: const Text('Sửa thông tin'),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  // Logic for logging out here
                },
                child: const Text('Đăng Xuất'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
