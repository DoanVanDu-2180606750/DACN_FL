

import 'dart:async';

import 'package:fit_25/Model/weather_model.dart';
import 'package:fit_25/Service/weather_aip.dart';
import 'package:flutter/material.dart';

class WeatherProvider with ChangeNotifier {
  WeatherData? _weatherData;
  String? _error;
  bool _isLoading = false;
  Timer? _timer;

  WeatherData? get weatherData => _weatherData;
  String? get error => _error;
  bool get isLoading => _isLoading;

  // Tạo một thể hiện của WeatherService
  final WeatherService _weatherService = WeatherService();

  Future<void> fetchWeather() async {
    _isLoading = true;
    notifyListeners();

    try {
      // Gọi phương thức fetchWeather từ WeatherService
      _weatherData = await _weatherService.fetchWeather(); // Lấy dữ liệu thời tiết
      _error = null;
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void startAutoRefreshing() {
    _timer?.cancel(); // Hủy timer cũ nếu có
    _timer = Timer.periodic(const Duration(minutes: 1), (timer) {
      fetchWeather(); // Gọi lại dữ liệu thời tiết mỗi phút
    });
  }

  void stopAutoRefreshing() {
    _timer?.cancel();
  }
}
