
import 'package:fit_25/Screen/FoodDetails.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fit_25/Providers/weatherData.dart';
import 'package:fit_25/Widgets/home_widget.dart';
import 'package:fit_25/Widgets/weather_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  
  int? steps;
  double? kcal;

  double? height; // Giá trị chiều cao
  double? weight; // Giá trị cân nặng
  
  @override
  void initState() {
    super.initState();
    // Load weather data after the first frame is built.
      _loadData();
      WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchWeatherData();
    });
  }

  Future<void> _loadData() async {
    final prefs = await SharedPreferences.getInstance();

    setState(() {
      height = prefs.getDouble('height'); // Lấy chiều cao
      weight = prefs.getDouble('weight'); // Lấy cân nặng
      steps =  prefs.getInt('stepCount'); // Lấy cân nặng
      kcal =  (steps!* 0.04) as double?;
    });
  }

  Future<void> _fetchWeatherData() async {
    final weatherProvider = Provider.of<WeatherProvider>(context, listen: false);
    await weatherProvider.fetchWeather(); // Fetch weather data from provider
  }

  @override
  Widget build(BuildContext context) {
    final weatherProvider = Provider.of<WeatherProvider>(context);

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: RefreshIndicator(
        onRefresh: _fetchWeatherData, // Call fetchWeather when refreshed
        child: ListView( // Use ListView to enable scrolling
          children: [
            // Weather Information
            SizedBox(
              height: 105,
              child: Row(
                children: [
                  Center(
                    child: weatherProvider.isLoading
                      ? const CircularProgressIndicator(color: Color.fromARGB(255, 255, 0, 0))
                      : weatherProvider.error != null
                          ? Text(
                              weatherProvider.error!,
                              style: const TextStyle(color: Colors.red),
                            )
                          : weatherProvider.weatherData != null
                              ? WeatherDetail(
                                  weather: weatherProvider.weatherData!,
                                )
                              : const Text(
                                  "Data Loading...",
                                  style: TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
                                ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            // Body Information - Info Cards
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Thông tin cơ thể',
                  style: TextStyle(fontSize: 25, color: Colors.black),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    HomeWidget.buildInfoBodyCard(
                      'Weight',
                      '${weight?.toStringAsFixed(1) ?? 'N/A'} kg',
                    ),
                    HomeWidget.buildInfoBodyCard(
                      'Height',
                      '${height?.toStringAsFixed(2) ?? 'N/A'} m',
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 10),
            // Activity Information
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Thông tin hoạt động',
                  style: TextStyle(fontSize: 25, color: Colors.black),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    HomeWidget.buildStepsCards(
                      'Steps',
                      steps?.toStringAsFixed(1) ?? 'N/A',
                    ),
                    HomeWidget.buildStepsCards(
                      'Kcal',
                      kcal?.toString() ?? 'N/A',
                      ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 10),
            // Energy Information
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
                    GestureDetector(
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) =>  CalorieScreen()));
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
                            'Thông tin thực phẩm', // Replace with meaningful text
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
