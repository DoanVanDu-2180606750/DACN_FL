import 'package:fit_25/Screen/Login.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class SignUpScreen extends StatefulWidget {
  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  bool _isLoading = false; // State variable to manage loading

  Future<void> _signUp() async {
  final validationMessage = _validateInputs();
  if (validationMessage != null) {
    _showErrorMessage(validationMessage);
    return;
  }

  setState(() {
    _isLoading = true;
  });

  try {
    final response = await http.post(
      Uri.parse('http://10.17.18.247:8080/api/register'), // Use env variable for production
      headers: {'Content-Type': 'application/json'}, // Include headers
      body: json.encode({
        'name': _fullNameController.text,
        'email': _emailController.text,
        'password': _passwordController.text,
      }),
    );

    if (response.statusCode == 201) {
      Navigator.pushReplacementNamed(context, '/login', arguments: {'message': 'Registration successful. Please log in.'});
      _clearInputs();
    } else {
      // Log the error response
      print('Error response: ${response.body}');
      final errorResponse = json.decode(response.body);
      String errorMessage = errorResponse['message'] ?? 'Failed to register. Please try again.';
      _showErrorMessage(errorMessage);
    }
  } catch (e) {
    print('Error: $e');
    _showErrorMessage('An error occurred. Please check your Internet connection.');
  } finally {
    setState(() {
      _isLoading = false;
    });
  }
}


  String? _validateInputs() {
    if (_fullNameController.text.isEmpty) {
      return 'Full name is required.';
    }
    if (_emailController.text.isEmpty) {
      return 'Email is required.';
    }
    if (!_isValidEmail(_emailController.text)) {
      return 'Invalid email format.';
    }
    if (_passwordController.text.isEmpty) {
      return 'Password is required.';
    }
    if (_passwordController.text != _confirmPasswordController.text) {
      return 'Passwords do not match.';
    }
    if (_passwordController.text.length < 8) {
      return 'Password must be at least 8 characters long.';
    }
    return null;
  }

  bool _isValidEmail(String email) {
    final regex = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
    return regex.hasMatch(email);
  }

  void _showErrorMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: const Color.fromARGB(255, 255, 0, 0),
        content: Center(child: Text(message, style: const TextStyle(color: Colors.white))),
        duration: const Duration(seconds: 5),
      ),
    );
  }

  void _clearInputs() {
    _fullNameController.clear();
    _emailController.clear();
    _passwordController.clear();
    _confirmPasswordController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              const Color.fromARGB(255, 18, 105, 226),
              Colors.blue.shade200,
              Colors.blue.shade400,
              Colors.blueGrey
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        padding: const EdgeInsets.all(24.0),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 30),
                const Text(
                  'Create Your Account',
                  style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: _fullNameController,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.person, color: Colors.white),
                    labelText: 'Full Name',
                    filled: true,
                    fillColor: Colors.blue.shade800,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    labelStyle: const TextStyle(color: Colors.white),
                  ),
                  style: const TextStyle(color: Colors.white),
                ),
                const SizedBox(height: 16),
                TextField(
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
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.lock, color: Colors.white),
                    labelText: 'Password',
                    filled: true,
                    fillColor: Colors.blue.shade800,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    labelStyle: const TextStyle(color: Colors.white),
                  ),
                  style: const TextStyle(color: Colors.white),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _confirmPasswordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.lock, color: Colors.white),
                    labelText: 'Confirm Password',
                    filled: true,
                    fillColor: Colors.blue.shade800,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    labelStyle: const TextStyle(color: Colors.white),
                  ),
                  style: const TextStyle(color: Colors.white),
                ),
                const SizedBox(height: 24),
                _isLoading   
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: _signUp,
                      
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 11, 218, 255),
                        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text('Register', style: TextStyle(fontSize: 16)),
                    ),
                const SizedBox(height: 20),
                const Text(
                  'Already have an account?',
                  style: TextStyle(color: Colors.white, fontSize: 14),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => LoginScreen()));
                  },
                  child: const Text(
                    'Login',
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
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
