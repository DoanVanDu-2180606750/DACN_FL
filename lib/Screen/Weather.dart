import 'package:fit_25/Providers/StepsProvider.dart';
import 'package:fit_25/Providers/bodyProvider.dart';
import 'package:fit_25/Providers/timeProvider.dart';
import 'package:fit_25/Providers/weatherData.dart';
import 'package:fit_25/Screen/DietDetails.dart';
import 'package:fit_25/Widgets/home_widget.dart';
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
                              "Không có dữ liệu", // Handle the null case while displaying
                              style: TextStyle(color: Colors.white),
                            ),
            ),
          ],
        ),
      ),
    );
  }
}
class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final timeProvider = Provider.of<TimeProvider>(context);
    final stepsProvider = Provider.of<StepsProvider>(context);
   
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Row(
            children: [
              HeadHome(
                formattedDate: DateFormat('EEEE d, MMMM yyyy').format(DateTime.now()),
                formattedTime: timeProvider.formattedTime,
              ),
              const SizedBox(width: 30),
              const Text(
                'Huỳnh Đạo',
                style: TextStyle(fontSize: 20, color: Colors.black, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 50),
          // Health Information - Info Cards
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              HomeWidget.buildInfoCard(
                'Weight', 
                '${context.watch<BodyProvider>().bodyInfo?.weight 
                ?? 'N/A'} kg',
              ),
              HomeWidget.buildInfoCard(
                'Height', 
                '${context.watch<BodyProvider>().bodyInfo?.height 
                ?? 'N/A'} m', 
                ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              HomeWidget.buildInfoCard(
                'Steps',
                '${stepsProvider.stepData.currentSteps} / ${stepsProvider.stepData.targetSteps}',
              ),
              HomeWidget.buildInfoCard(
                'Nhịp tim',
                '89 BPM',
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              HomeWidget.buildInfoCard(
                'Calories burned',
                '${stepsProvider.stepData.caloriesBurned}',
                color: const Color.fromARGB(255, 30, 213, 82),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const DietScreen()));
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
                      'Diet Suggestions',
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
    );
  }
}