import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ResetpassScreen extends StatefulWidget {
  @override
  State<ResetpassScreen> createState() => _ResetpassScreenState();
}

class _ResetpassScreenState extends State<ResetpassScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future<void> _resetPassword() async {
    // Kiểm tra tính hợp lệ của Form trước khi gọi API
    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Đang xử lý...')),
      );

      try {
        final response =
            await http.post(Uri.parse('http://192.168.1.7:8080/api/fogetpass'),
                headers: {
                  'Content-Type': 'application/json',
                },
                body: json.encode({
                  'email': _emailController.text,
                  'newpassword': _passwordController.text,
                }));

        if (response.statusCode == 200) {
          // Thành công, hiển thị thông báo
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Vui lòng xem mail để xác nhận mật khẩu!')),
          );
        } else {
          final responseBody = jsonDecode(response.body);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                  responseBody['error'] ?? 'Lỗi đặt lại mật khẩu, vui lòng thử lại'),
            ),
          );
        }
      } catch (e) {
        // Lỗi khi thực hiện yêu cầu (timeout, không có kết nối, v.v.)
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Lỗi: $e')),
        );
      }
    } else {
      // Nếu form không hợp lệ
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Nhập đúng thông tin!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue.shade200, Colors.blue.shade400],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        padding: const EdgeInsets.all(24.0),
        child: Center(
          child: SingleChildScrollView(
            child: Form(
              key: _formKey, // Khóa để quản lý Form
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 30),
                  const Text(
                    'Đặt lại mật khẩu',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  // Trường nhập Email
                  TextFormField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.email, color: Colors.white),
                      labelText: 'Email',
                      filled: true,
                      fillColor: Colors.blue.shade800,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      labelStyle: const TextStyle(color: Colors.white),
                    ),
                    style: const TextStyle(color: Colors.white),
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Nhập đúng email';
                      }
                      if (!RegExp(r"^[a-zA-Z0-9.+_%-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$")
                          .hasMatch(value)) {
                        return 'Nhập đúng email';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  // Trường nhập Mật khẩu mới
                  TextFormField(
                    controller: _passwordController,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.lock, color: Colors.white),
                      labelText: 'Mật khẩu mới',
                      filled: true,
                      fillColor: Colors.blue.shade800,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      labelStyle: const TextStyle(color: Colors.white),
                    ),
                    style: const TextStyle(color: Colors.white),
                    obscureText: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Nhập mật khẩu mới';
                      }
                      if (value.length < 6) {
                        return 'Mật khẩu phải có ít nhất 6 ký tự';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 24),
                  // Nút Tiếp tục
                  ElevatedButton(
                    onPressed: _resetPassword, // Gọi hàm _resetPassword
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue.shade600,
                      padding: const EdgeInsets.symmetric(
                          vertical: 12, horizontal: 24),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text('Đặt lại mật khẩu',
                        style: TextStyle(fontSize: 16)),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Muốn thử lại không?',
                    style: TextStyle(color: Colors.white, fontSize: 14),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/login');
                    },
                    child: Text(
                      'Đăng nhập',
                      style: TextStyle(
                          color: Colors.blue.shade100,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
