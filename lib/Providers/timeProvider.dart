import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TimeProvider with ChangeNotifier {
  String _formattedTime = '';
  Timer? _timer;

  TimeProvider() {
    _updateTime(); 
    startAutoRefreshing();
  }

  String get formattedTime => _formattedTime;

  void startAutoRefreshing() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _updateTime();
    });
  }

  void stopAutoRefreshing() {
    _timer?.cancel();
  }

  void _updateTime() {
    _formattedTime = DateFormat('HH:mm a').format(DateTime.now());
    notifyListeners(); // Cập nhật UI
  }

  void dispose() {
    stopAutoRefreshing(); // Hủy timer khi không cần thiết
    super.dispose();
  }
}
