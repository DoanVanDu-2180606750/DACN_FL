import 'package:flutter/material.dart';

class HelpScreen extends StatelessWidget {
  final TextEditingController _emailController = TextEditingController();

  void _continue() {
    // Xử lý tiếp tục ở đây
    print('Email: ${_emailController.text}');
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
        padding: EdgeInsets.all(24.0),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 30),
                Text(
                  'Let us help you',
                  style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 20),
                TextField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.email, color: Colors.white),
                    labelText: 'Email',
                    filled: true,
                    fillColor: Colors.blue.shade800,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    labelStyle: TextStyle(color: Colors.white),
                  ),
                  style: TextStyle(color: Colors.white),
                  keyboardType: TextInputType.emailAddress,
                ),
                SizedBox(height: 24),
                ElevatedButton(
                  onPressed: _continue,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue.shade600,
                    padding: EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text('Continue', style: TextStyle(fontSize: 16)),
                ),
                SizedBox(height: 20),
                Text(
                  'Want to try again?',
                  style: TextStyle(color: Colors.white, fontSize: 14),
                ),
                TextButton(
                  onPressed: () {
                    // Chuyển đến trang đăng nhập ở đây
                  },
                  child: Text(
                    'Sign in',
                    style: TextStyle(color: Colors.blue.shade100, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}