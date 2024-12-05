import 'package:fit_25/Model/user_mode.dart';
import 'package:fit_25/Providers/loginProvider.dart';
import 'package:fit_25/Screen/EditProfile.dart'; 
import 'package:fit_25/Widgets/user_widget.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class UserScreen extends StatefulWidget {
  const UserScreen({super.key});

  @override
  State<UserScreen> createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  User? user; // Hold the user directly instead of a list
  bool _isLoading = true; // For loading state management

  @override
  void initState() {
    super.initState();
    _getUserData();
  }

  Future<void> _getUserData() async {
    final String url = 'http://10.17.18.247:8080/api/users/me'; // Adjust this as necessary

    try {
      final userToken = Provider.of<UserProvider>(context, listen: false).token; // Get the token

      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $userToken', // Include the token
        },
      );

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        setState(() {
          user = User.fromJson(jsonData);   // Map to a User instance directly
          _isLoading = false; // Stop loading
        });
      } else {
        _showErrorSnackbar('Unable to fetch data: ${response.reasonPhrase}');
        setState(() {
          _isLoading = false; // Stop loading on error
        });
      }
    } catch (error) {
      print('Error fetching user data: $error');
      _showErrorSnackbar('Error fetching user data: $error');
      setState(() {
        _isLoading = false; // Stop loading on error
      });
    }
  }
  
  void _showErrorSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }
  
  Future<void> _navigateToEditProfile() async {
    if (user != null) {
      final updatedUser = await Navigator.push<User>(
          context,
          MaterialPageRoute(
              builder: (context) => ProfilePage(user: user!)),
      );

      if (updatedUser != null) {
        setState(() {
          user = updatedUser; // Cập nhật thông tin người dùng
        });
      }
    }
  }
  
  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator()); // Loading state
    }

    if (user == null) {
      return const Center(child: Text('Không có thông tin người dùng'));
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Thông tin người dùng')),
      body: RefreshIndicator(
        onRefresh: _getUserData,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              CircleAvatar(
                radius: 55,
                backgroundImage: user?.image != null 
                    ? NetworkImage(user!.image) 
                    : null, // Fallback image
                child: user!.image == null ? const Icon(Icons.person, size: 55) : null,
              ),
              Text(
                user!.name ?? 'Tên không có sẵn',
                style: const TextStyle(fontSize: 24),
              ),
              const SizedBox(height: 16),
              UserWidget.infoRow('Email', user!.email ?? 'N/A'),
              UserWidget.infoRow('Giới tính', user!.gender ?? 'N/A'),
              UserWidget.infoRow('Số Điện Thoại', user!.phone ?? 'N/A'),
              UserWidget.infoRow('Địa chỉ', user!.address ?? 'N/A'),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _navigateToEditProfile,
                child: const Text('Sửa thông tin'),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  final shouldLogout = await showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Đăng Xuất'),
                      content: const Text('Bạn có chắc chắn muốn đăng xuất không?'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(false),
                          child: const Text('Không'),
                        ),
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(true),
                          child: const Text('Có'),
                        ),
                      ],
                    ),
                  );

                  if (shouldLogout) {
                    Provider.of<UserProvider>(context, listen: false).clear();
                    Navigator.pushReplacementNamed(context, '/login');
                  }
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
