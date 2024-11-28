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

  final WeatherService _weatherService = WeatherService();

  Future<void> fetchWeather() async {
    _isLoading = true; 
    notifyListeners();

    try {
      _weatherData = await _weatherService.fetchWeather();
      _error = null; 
    } catch (e) {
      _error = e.toString(); 
    } finally {
      _isLoading = false; 
      notifyListeners(); 
    }
  }

 
  void startAutoRefreshing() {
    _timer?.cancel(); 
    _timer = Timer.periodic(const Duration(minutes: 10), (timer) {
      fetchWeather(); 
    });
  }

  void stopAutoRefreshing() {
    _timer?.cancel();
  }
}
