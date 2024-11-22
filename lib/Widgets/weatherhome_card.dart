import 'package:fit_25/Model/weather_model.dart';
import 'package:flutter/material.dart';

class WeatheHome extends StatelessWidget {
  final WeatherData weather;
  final String formattedDate;

  const WeatheHome({
    super.key,
    required this.weather,
    required this.formattedDate,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Current address name
        Text(
          weather.name,
          style: const TextStyle(
            fontSize: 20,
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        // Current temperature
        Text(
          "${weather.temperature.current.toStringAsFixed(0)}°C",
          style: const TextStyle(
            fontSize: 20,
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        // Weather condition
        if (weather.weather.isNotEmpty)
          Text(
            weather.weather[0].main,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
        const SizedBox(height: 10),
        // Current date and time
        Text(
          formattedDate,
          style: const TextStyle(
            fontSize: 18,
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Column weatherInfoColumn(String title, String value, IconData icon, Color color) {
    return Column(
      children: [
        Icon(icon, color: color),
        const SizedBox(height: 5),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w700,
            fontSize: 18,
          ),
        ),
        Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w500,
            fontSize: 16,
          ),
        ),
      ],
    );
  }
}