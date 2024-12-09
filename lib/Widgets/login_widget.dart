import 'package:flutter/material.dart';

class LoginWidget {
  void showSuccessMessage(String message, BuildContext context) {
    final overlay = Overlay.of(context);
    final overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        top: 40,
        left: 20,
        right: 20,
        child: Material(
          elevation: 4.0,
          child: Container(
            color: Colors.green,
            padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
            child: Text(
              message,
              style: const TextStyle(color: Colors.white, fontSize: 16),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );

    overlay.insert(overlayEntry);
    Future.delayed(const Duration(seconds: 3), () {
      overlayEntry.remove();
    });
  }
}
