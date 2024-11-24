import 'package:fit_25/Providers/weatherData.dart';
import 'package:fit_25/Widgets/weather_card.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  @override
  void initState() {
    super.initState();
    // Fetch weather data after the first frame is built.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<WeatherProvider>(context, listen: false).fetchWeather();
    });
  }

  @override
  Widget build(BuildContext context) {
    final weatherProvider = Provider.of<WeatherProvider>(context);
    String formattedTime = DateFormat('hh:mm a').format(DateTime.now());
    return Scaffold(
      backgroundColor: const Color(0xFF676BD0),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: weatherProvider.isLoading // Check loading state
                  ? const CircularProgressIndicator(color: Colors.white)
                  : weatherProvider.error != null // Check for errors
                      ? Text(
                          weatherProvider.error!, // Display error message
                          style: const TextStyle(color: Colors.red),
                        )
                      : weatherProvider.weatherData != null // Check if weatherData is not null
                          ? WeatherDetail(
                              weather: weatherProvider.weatherData!, // Access weather data
                              formattedDate: DateFormat('EEEE d, MMMM yyyy').format(DateTime.now()),
                              formattedTime: formattedTime,
                            )
                          : const Text(
                              "No weather data available", // Handle the null case while displaying
                              style: TextStyle(color: Colors.white),
                            ),
            ),
          ],
        ),
      ),
    );
  }
}
