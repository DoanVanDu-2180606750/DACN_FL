import 'dart:async';
import 'package:fit_25/Providers/StepsProvider.dart';
import 'package:flutter/material.dart';
import 'package:pedometer/pedometer.dart';
import 'package:provider/provider.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';

class StepsDetailsScreen extends StatefulWidget {
  const StepsDetailsScreen({super.key});

  @override
  _StepsDetailsScreenState createState() => _StepsDetailsScreenState();
}

class _StepsDetailsScreenState extends State<StepsDetailsScreen> {
  late Stream<StepCount> _stepCountStream;
  late Stream<PedestrianStatus> _pedestrianStatusStream;

  StreamSubscription<StepCount>? _stepCountSubscription;
  StreamSubscription<PedestrianStatus>? _pedestrianStatusSubscription;
  StreamSubscription<AccelerometerEvent>? _accelerometerSubscription;

  int _stepCount = 0;
  String _status = '?';
  bool _isShaking = false;

  List<double> weeklySteps = List.generate(7, (index) => 0);
  List<double> weeklyKcal = List.generate(7, (index) => 0);

  @override
  void initState() {
    super.initState();
    _loadSteps();
    _initPlatformState();
    _startAccelerometerListening();
  }

  @override
  void dispose() {
    _stepCountSubscription?.cancel();
    _pedestrianStatusSubscription?.cancel();
    _accelerometerSubscription?.cancel();
    super.dispose();
  }

  void _calculateKcal() {
    setState(() {
      for (int i = 0; i < weeklySteps.length; i++) {
        weeklyKcal[i] = weeklySteps[i] * 0.04;
      }
    });
  }

  void onPedestrianStatusChanged(PedestrianStatus event) {
    setState(() {
      _status = event.status;
    });
  }

  void _startAccelerometerListening() {
    _accelerometerSubscription = accelerometerEvents.listen(_detectShake);
  }

  void _detectShake(AccelerometerEvent event) {
    double threshold = 15.0;
    setState(() {
      _isShaking = event.x.abs() > threshold || event.y.abs() > threshold || event.z.abs() > threshold;
    });
  }

  void onStepCount(StepCount event) {
  if (!_isShaking) {
    setState(() {
      _stepCount = event.steps;

      // Cập nhật dữ liệu lên StepsProvider
      final stepsProvider = Provider.of<StepsProvider>(context, listen: false);
      stepsProvider.updateSteps(event.steps);

      if (_stepCount % 50 == 0 && _stepCount != 0) {
        _saveSteps(); // Nếu cần, vẫn lưu dữ liệu vào SharedPreferences
      }
    });
  }
}

  int _currentWeekNumber() {
    DateTime now = DateTime.now();
    int dayOfYear = int.parse(DateFormat("D").format(now));
    return ((dayOfYear - now.weekday + 10) / 7).floor();
  }

  Future<void> _loadSteps() async {
    final prefs = await SharedPreferences.getInstance();
    
    // Tải dữ liệu đã lưu
    setState(() {
      _stepCount = prefs.getInt('stepCount') ?? 0;
      weeklySteps = (prefs.getStringList('weeklySteps') ?? List.generate(7, (_) => '0'))
          .map((e) => double.parse(e))
          .toList();
      weeklyKcal = (prefs.getStringList('weeklyKcal') ?? List.generate(7, (_) => '0'))
          .map((e) => double.parse(e))
          .toList();
    });

    // Kiểm tra ngày cuối cùng lưu dữ liệu
    String lastSavedDate = prefs.getString('lastSavedDate') ?? DateFormat('yyyy-MM-dd').format(DateTime.now());
    String currentDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
    
    if (lastSavedDate != currentDate) {
      // Nếu ngày mới, reset bước chân và kcal cho ngày đó
      setState(() {
        _stepCount = 0; // Reset số bước
        weeklySteps[DateTime.now().weekday - 1] = 0; // Reset bước theo ngày trong tuần
        weeklyKcal[DateTime.now().weekday - 1] = 0;  // Reset kcal theo ngày
      });
      await _saveSteps(); // Lưu lại thông tin reset
    }
  }


  Future<void> _saveSteps() async {
    final prefs = await SharedPreferences.getInstance();
    
    // Lưu thông tin số bước và kcal
    prefs.setInt('stepCount', _stepCount);
    prefs.setString('lastSavedDate', DateFormat('yyyy-MM-dd').format(DateTime.now())); // Lưu ngày hiện tại
    
    int dayOfWeek = DateTime.now().weekday - 1;
    if (dayOfWeek >= 0) {
      weeklySteps[dayOfWeek] = _stepCount.toDouble();
      prefs.setStringList('weeklySteps', weeklySteps.map((e) => e.toString()).toList());
      
      _calculateKcal(); // Cập nhật kcal
      prefs.setStringList('weeklyKcal', weeklyKcal.map((e) => e.toString()).toList());
    }
  }


  Future<void> _initPlatformState() async {
    if (await _checkActivityRecognitionPermission()) {
      _pedestrianStatusStream = Pedometer.pedestrianStatusStream;
      _pedestrianStatusSubscription = _pedestrianStatusStream.listen(onPedestrianStatusChanged);
      _stepCountStream = Pedometer.stepCountStream;
      _stepCountSubscription = _stepCountStream.listen(onStepCount);
    }
  }

  Future<bool> _checkActivityRecognitionPermission() async {
    var status = await Permission.activityRecognition.request();
    return status.isGranted;
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: Text(
                DateFormat('EE-dd-MMMM-y').format(DateTime.now()),
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold), // Tùy chỉnh kiểu chữ
              ),
            ),
            const SizedBox( height: 40,),
            _buildChart(),
            const SizedBox(height: 30),
            _buildStepsCard(),
          ],
        ),
      ),
    );
  }

  Widget _buildStepsCard() {
    return Card(
      color: Colors.black,
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text("Số bước", style: TextStyle(fontSize: 24, color: Colors.white)),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  _status == 'walking'
                      ? Icons.directions_walk
                      : _status == 'stopped'
                          ? Icons.accessibility_new
                          : Icons.error,
                  size: 50,
                  color: _status == 'walking' ? Colors.green : Colors.white,
                ),
                const SizedBox(width: 16),
                Text(
                  _stepCount.toString(),
                  style: const TextStyle(fontSize: 20, color: Colors.blueAccent),
                ),
                const SizedBox(width: 16),
                Text(
                  "kcal: ${(weeklyKcal[DateTime.now().weekday - 1]).toInt()}",
                    style: const TextStyle(fontSize: 20, color: Colors.white,fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

 Widget _buildChart() {
    return SizedBox(
      height: 300,
      width: 400,
      child: LineChart(
        LineChartData(
          minY: 0,
          titlesData: FlTitlesData(
            topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(showTitles: false, getTitlesWidget: (value, meta) {
                return Text(value.toInt().toString());
              }),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 30,
                getTitlesWidget: (value, meta) {
                  const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
                  return Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(days[value.toInt()]),
                  );
                },
              ),
            ),
          ),
          borderData: FlBorderData(
            show: true,
            border: const Border(
              left: BorderSide(color: Colors.blue, width: 2),
              bottom: BorderSide(color: Colors.blue, width: 2),
              right: BorderSide(color: Colors.blue, width: 2),
            ),
          ),
          lineBarsData: [
            LineChartBarData(
              spots: List.generate(7, (index) => FlSpot(index.toDouble(), weeklySteps[index])),
              isCurved: true,
              color: Colors.green,
              barWidth: 3,
              belowBarData: BarAreaData(show: false),
            ),
            LineChartBarData(
              spots: List.generate(7, (index) => FlSpot(index.toDouble(), weeklyKcal[index])),
              isCurved: true,
              color: Colors.red,
              barWidth: 2,
              belowBarData: BarAreaData(show: false),
            )
          ],
        ),
      ),
    );
  }
}
