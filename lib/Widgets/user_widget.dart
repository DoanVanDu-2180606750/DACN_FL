
import 'package:flutter/material.dart';
class UserWidget {
  static  infoRow(String title, String data) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
          Text(data),
        ],
      ),
    );
  }
}