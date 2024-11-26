import 'package:fit_25/Model/steps_model.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:pedometer/pedometer.dart';
import 'dart:async';

class StepsDetailsScreen extends StatefulWidget {
  const StepsDetailsScreen({Key? key}) : super(key: key);

  @override
  _StepsDetailsScreenState createState() => _StepsDetailsScreenState();
}

class _StepsDetailsScreenState extends State<StepsDetailsScreen> {
  StepData stepData = StepData(
      currentSteps: 0, targetSteps: 8000, elapsedTime: Duration.zero, runningSteps: 0, caloriesBurned: 0);
  
  late Stream<StepCount> _stream;
  Timer? _timer;
  bool _isTracking = false;

  // Dữ liệu số bước và calo cho từng ngày trong tuần
List<int> weeklySteps = [1500, 3200, 4500, 6100, 7200, 8500, 9500]; // Dữ liệu số bước cho 7 ngày trong tuần
List<int> weeklyCalories = [60, 128, 180, 244, 288, 340, 380]; // Dữ liệu calo cho 7 ngày trong tuần

  @override
  void initState() {
    super.initState();
    _startListening();
  }

  void _startListening() {
    _stream = Pedometer.stepCountStream;
    _stream.listen((StepCount event) {
      setState(() {
        stepData = stepData.copyWith(
          currentSteps: event.steps,
          runningSteps: stepData.runningSteps + 1,
          caloriesBurned: _calculateCalories(event.steps),
        );
        _addDailyData(event.steps);
      });
    });
  }

  int _calculateCalories(int steps) {
    return (steps * 0.04).toInt();
  }

  void _addDailyData(int steps) {
    int weekday = DateTime.now().weekday; 
    int index = (weekday - 1) % 7; 
    weeklySteps[index] += steps; 
    weeklyCalories[index] = _calculateCalories(weeklySteps[index]); 
  }

  void _startTimer() {
    _isTracking = true;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        stepData = stepData.copyWith(
          elapsedTime: Duration(seconds: stepData.elapsedTime.inSeconds + 1),
        );
      });
    });
  }

  void _pauseTimer() {
    if (_timer?.isActive == true) {
      _timer!.cancel();
      setState(() {
        _isTracking = false;
      });
    }
  }

  void _stopTimer() {
    if (_timer?.isActive == true) {
      _timer!.cancel();
    }
    setState(() {
      _isTracking = false;
      stepData = stepData.copyWith(
        elapsedTime: Duration.zero,
        runningSteps: 0,
        caloriesBurned: 0,
      );
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _stream.drain();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final elapsedMinutes = stepData.elapsedTime.inMinutes.remainder(60);
    final elapsedSeconds = stepData.elapsedTime.inSeconds.remainder(60).toString().padLeft(2, '0');

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16.0),
            child: CircleAvatar(
              radius: 25,
              child: Center(
                child: Text(
                  'J',
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView( // Thay đổi tại đây để cho phép cuộn
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              const SizedBox(height: 10),
              GestureDetector(
                onTap: () {
                  // Logic hiển thị dialog chọn bước mục tiêu
                },
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.cyan,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    'Steps ${stepData.currentSteps} / ${stepData.targetSteps}',
                    style: const TextStyle(color: Colors.black, fontSize: 16),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.symmetric(vertical: 30),
                decoration: BoxDecoration(
                  color: Colors.cyan[300],
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Text(
                  'Calo: ${stepData.caloriesBurned}',
                  style: const TextStyle(color: Colors.black, fontSize: 24),
                ),
              ),
              const SizedBox(height: 20),
              // Container cho số bước đang chạy
              Center(
                child: Container(
                  width: 250,
                  height: 250,
                  alignment: Alignment.center,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.cyan,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Running Steps',
                        style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.black),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        '$elapsedMinutes:$elapsedSeconds',
                        style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        '${stepData.runningSteps}',
                        style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: _isTracking ? _pauseTimer : _startTimer,
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(const Color.fromARGB(255, 139, 106, 145)),
                      padding: MaterialStateProperty.all<EdgeInsets>(const EdgeInsets.symmetric(horizontal: 60, vertical: 20)),
                    ),
                    child: Text(
                      _isTracking ? 'Pause' : 'Start',
                      style: const TextStyle(fontSize: 20, color: Colors.white),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: _stopTimer,
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(const Color.fromARGB(255, 139, 106, 145)),
                      padding: MaterialStateProperty.all<EdgeInsets>(const EdgeInsets.symmetric(horizontal: 60, vertical: 20)),
                    ),
                    child: const Text(
                      'Stop',
                      style: TextStyle(fontSize: 20, color: Colors.white),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              SizedBox(
                height: 300, // Chiều cao biểu đồ
                child: LineChart(
                  LineChartData(
                    titlesData: FlTitlesData(
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 40,
                          getTitlesWidget: (value, meta) {
                            return Text(value.toInt().toString());
                          },
                        ),
                      ),
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 30,
                          getTitlesWidget: (value, meta) {
                            switch (value.toInt()) {
                              case 0:
                                return const Text('Mon');
                              case 1:
                                return const Text('Tue');
                              case 2:
                                return const Text('Wed');
                              case 3:
                                return const Text('Thu');
                              case 4:
                                return const Text('Fri');
                              case 5:
                                return const Text('Sat');
                              case 6:
                                return const Text('Sun');
                            }
                            return const Text('');
                          },
                        ),
                      ),
                      topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    ),
                    borderData: FlBorderData(
                      show: true,
                      border: const Border(
                        left: BorderSide(color: Colors.grey, width: 1),
                        bottom: BorderSide(color: Colors.grey, width: 1),
                      ),
                    ),
                    gridData: const FlGridData(show: true),
                    lineBarsData: [
                      LineChartBarData(
                        spots: List.generate(7, (index) {
                          return FlSpot(index.toDouble(), weeklySteps[index].toDouble());
                        }),
                        isCurved: true,
                        color: Colors.blue,
                        dotData: const FlDotData(show: true),
                        belowBarData: BarAreaData(show: false),
                        gradient: LinearGradient(
                          colors: [Colors.blue.withOpacity(0.4), Colors.blue.withOpacity(0.6)],
                        ),
                      ),
                      LineChartBarData(
                        spots: List.generate(7, (index) {
                          return FlSpot(index.toDouble(), weeklyCalories[index].toDouble());
                        }),
                        isCurved: true,
                        color: Colors.red,
                        dotData: const FlDotData(show: true),
                        belowBarData: BarAreaData(show: false),
                        gradient: LinearGradient(
                          colors: [Colors.red.withOpacity(0.4), Colors.red.withOpacity(0.6)],
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
