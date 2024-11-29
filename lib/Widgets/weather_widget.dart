import 'package:fit_25/Model/weather_model.dart';
import 'package:flutter/material.dart';

class WeatherDetail extends StatelessWidget {
  final WeatherData weather;

  const WeatherDetail({
    super.key,
    required this.weather,
  });
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Column(
        children: [
          Text(
            weather.name,
            style: const TextStyle(
              fontSize: 25,
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            "${weather.temperature.current.toStringAsFixed(0)}°C",
            style: const TextStyle(
              fontSize: 25,
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
          if (weather.weather.isNotEmpty)
            Text(
              weather.weather[0].main,
              style: const TextStyle(
                fontSize: 20,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
        ],
      ),
    );
  }
}