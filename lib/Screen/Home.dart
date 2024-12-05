
import 'package:fit_25/Providers/heartProrvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fit_25/Providers/weatherData.dart';
import 'package:fit_25/Providers/StepsProvider.dart';
import 'package:fit_25/Providers/bodyProvider.dart';
import 'package:fit_25/Screen/DietDetails.dart';
import 'package:fit_25/Widgets/home_widget.dart';
import 'package:fit_25/Widgets/weather_widget.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    // Load weather data after the first frame is built.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchWeatherData();
    });
  }

  Future<void> _fetchWeatherData() async {
    final weatherProvider = Provider.of<WeatherProvider>(context, listen: false);
    await weatherProvider.fetchWeather(); // Fetch weather data from provider
  }

  @override
  Widget build(BuildContext context) {
    final weatherProvider = Provider.of<WeatherProvider>(context);
    final stepsProvider = Provider.of<StepsProvider>(context);
    final heartProvider = Provider.of<HeartRateProvider>(context);

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: RefreshIndicator(
        onRefresh: _fetchWeatherData, // Call fetchWeather when refreshed
        child: ListView( // Use ListView to enable scrolling
          children: [
            Column(
              children: [
                SizedBox(
                  height: 105,
                  child: Row(
                    children: [
                      Center(
                        child: weatherProvider.isLoading // Check loading state
                          ? const CircularProgressIndicator(color: Color.fromARGB(255, 255, 0, 0))
                          : weatherProvider.error != null // Check for errors
                              ? Text(
                                  weatherProvider.error!, // Display error message
                                  style: const TextStyle(color: Colors.red),
                                )
                              : weatherProvider.weatherData != null // Check if weatherData is not null
                                  ? WeatherDetail(
                                      weather: weatherProvider.weatherData!, // Access weather data
                                    )
                                  : const Text(
                                      "Data Loading...", // Handle the null case while displaying
                                      style: TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
                                    ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            // Health Information - Info Cards
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Thông tin cơ thể', 
                  style: TextStyle(fontSize: 25, color: Colors.black),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    HomeWidget.buildInfoBodyCard(
                      'Weight', 
                      '${context.watch<BodyProvider>().bodyInfo?.weight ?? 'N/A'} kg',
                    ),
                    HomeWidget.buildInfoBodyCard(
                      'Height', 
                      '${context.watch<BodyProvider>().bodyInfo?.height ?? 'N/A'} m', 
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Thông tin hoạt động',
                style: TextStyle(fontSize: 25, color: Colors.black),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    HomeWidget.buildInfoActiCard(
                      'Steps',
                      '${stepsProvider.stepData.currentSteps} / ${stepsProvider.stepData.targetSteps}',
                    ),
                    HomeWidget.buildInfoActiCard(
                      'Nhịp tim / phút',
                      heartProvider.averageBPM.toStringAsFixed(0),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Thông tin năng lượng',
                  style: TextStyle(fontSize: 25, color: Colors.black),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    HomeWidget.buildInfoActiCard(
                      'Calories burned',
                      '${stepsProvider.stepData.caloriesBurned}',
                      color: const Color.fromARGB(255, 30, 213, 82),
                    ),
                    GestureDetector(
                      onTap: () {
                        
                      },
                      child: Container(
                        height: 80,
                        width: (MediaQuery.of(context).size.width / 2) - 20,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: const Color.fromARGB(255, 41, 58, 205),
                        ),
                        child: const Center(
                          child: Text(
                            'sds',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
