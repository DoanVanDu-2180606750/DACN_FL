import 'dart:convert';
import 'package:fit_25/Model/weather_model.dart';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart'; // Import geolocator

class WeatherService {
  final String _apiKey = "befe89839e80e0a7c1ecdf5708af00ab";

  Future<WeatherData?> fetchWeather() async {
    // Request location
    Position position = await _determinePosition();
    print(position);

    if (position != null) {
//       final response = await http.get(
// Uri.parse("https://api.openweathermap.org/data/2.5/weather?lat=10.863290&lon=106.728592&appid=befe89839e80e0a7c1ecdf5708af00ab"),
// );
      final response = await http.get(
        Uri.parse(
          "https://api.openweathermap.org/data/2.5/weather"
          "?lat=${position.latitude}&lon=${position.longitude}&appid=$_apiKey",
        ),
      );

      try {
        if (response.statusCode == 200) {
          var json = jsonDecode(response.body);
          return WeatherData.fromJson(json);
        } else {
          throw Exception('Failed to load Weather data');
        }
      } catch (e) {
        print(e.toString());
      }
    }
    return null; // Return null if position is not available
  }

  // Method to determine position
  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled, return an error
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, return an error
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, return an error
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can continue
    return await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
  }
}
