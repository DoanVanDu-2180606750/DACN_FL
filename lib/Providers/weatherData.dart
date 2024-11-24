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

  // Create an instance of WeatherService
  final WeatherService _weatherService = WeatherService();

  // Fetch weather data asynchronously
  Future<void> fetchWeather() async {
    _isLoading = true; // Set loading to true at the beginning
    notifyListeners(); // Notify listeners for loading state change

    try {
      // Fetch weather data from WeatherService
      _weatherData = await _weatherService.fetchWeather();
      _error = null; // Reset error if fetching is successful
    } catch (e) {
      _error = e.toString(); // Set error message
    } finally {
      _isLoading = false; // Set loading to false at the end
      notifyListeners(); // Notify listeners again to update UI
    }
  }

  // Start automatic refreshing of weather data
  void startAutoRefreshing() {
    _timer?.cancel(); // Cancel the old timer if exists
    _timer = Timer.periodic(const Duration(minutes: 10), (timer) {
      fetchWeather(); // Fetch weather data periodically
    });
  }

  // Stop automatic refreshing
  void stopAutoRefreshing() {
    _timer?.cancel();
  }
}
