import 'package:flutter/material.dart';

class UserProvider with ChangeNotifier {
  String _id = '';
  String _name = '';
  String _email = '';
  String _role = '';
  String _image = '';
  String _token = ''; // Store JWT or session token if applicable

  // Getter methods
  String get id => _id;
  String get name => _name;
  String get email => _email;
  String get role => _role;
  String get image => _image;
  String get token => _token; // You can use this to verify if the user is logged in

  // Check if user is logged in
  bool get isLoggedIn => _token.isNotEmpty; // Evaluate logged in status based on token

  // Method for setting user details
  void setUserDetails(String? id, String? name, String? email, String? role, String? image, String? token) {
    // Validate input to avoid null values
    if (id != null) {
      _id = id;
    } else {
      // handle the case where id may not be provided
      throw ArgumentError("id cannot be null");
    }

    if (name != null) {
      _name = name; 
    } else {
      throw ArgumentError("name cannot be null");
    }

    if (email != null) {
      _email = email; 
    } else {
      throw ArgumentError("email cannot be null");
    }

    if (role != null) {
      _role = role; 
    } else {
      throw ArgumentError("role cannot be null");
    }

    if( image != null ){
      _image = image;
    } else{
        throw ArgumentError("image cannot be null");
    }

    if (token != null) {
      _token = token; 
    } else {
      throw ArgumentError("token cannot be null");
    }
    notifyListeners(); 
  }

  // Method to clear user data on logout
  void clear() {
    _id = '';
    _name = '';
    _email = '';
    _role = '';
    _image = '';
    _token = ''; 
    notifyListeners();
  }
}

