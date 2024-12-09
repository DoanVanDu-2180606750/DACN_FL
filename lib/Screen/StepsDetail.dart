import 'dart:async';
import 'package:fit_25/Providers/StepsProvider.dart';
import 'package:fit_25/Utils/StepsUtils.dart';
import 'package:flutter/material.dart';
import 'package:pedometer/pedometer.dart';
import 'package:provider/provider.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';

class StepsDetailsScreen extends StatefulWidget {
  const StepsDetailsScreen({super.key});

  @override
  _StepsDetailsScreenState createState() => _StepsDetailsScreenState();
}

class _StepsDetailsScreenState extends State<StepsDetailsScreen> {
  late Stream<StepCount> _stepCountStream;
  final StepsDetailsUtils stepsUtils = StepsDetailsUtils();
  int _stepCount = 0;
  String _status = '?';

  @override
  void initState() {
    super.initState();
    _initializeStepsUtils(); // Gọi hàm khởi tạo của utils
    _startAccelerometerListening(); // Bắt đầu lắng nghe cảm biến gia tốc
  }

  Future<void> _initializeStepsUtils() async {
    await stepsUtils.loadSteps(); // Tải dữ liệu bước đã lưu
    stepsUtils.initPlatformState(); // Khởi tạo các stream
    stepsUtils.stepCountSubscription = stepsUtils.stepCountStream.listen((event) {
      _handleStepCount(event); // Hàm xử lý sự kiện số bước
    });
  }

  void _handleStepCount(StepCount event) {
    stepsUtils.onStepCount(event, Provider.of<StepsProvider>(context, listen: false));
    setState(() {
      _stepCount = stepsUtils.stepCount;
    });
  }

  // Hàm nhận diện trạng thái đi bộ
  void onPedestrianStatusChanged(PedestrianStatus event) {
    setState(() {
      _status = event.status;
    });
  }

  // Hàm bắt đầu lắng nghe cảm biến gia tốc
  void _startAccelerometerListening() {
    stepsUtils.accelerometerSubscription = accelerometerEvents.listen(stepsUtils.detectShake);
  }

  @override
  void dispose() {
    // Hủy subscription để tránh rò rỉ bộ nhớ
    stepsUtils.stepCountSubscription?.cancel();
    stepsUtils.pedestrianStatusSubscription?.cancel();
    stepsUtils.accelerometerSubscription?.cancel();
    super.dispose();
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
            const SizedBox(height: 40),
            _buildChart(), // Xây dựng biểu đồ
            const SizedBox(height: 30),
            _buildStepsCard(), // Xây dựng thẻ hiển thị số bước
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
                  "kcal: ${(stepsUtils.weeklyKcal[DateTime.now().weekday - 1]).toInt()}",
                  style: const TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
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
                    child: Text(days[value.toInt()]), // Hiển thị tên ngày
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
              spots: List.generate(7, (index) => FlSpot(index.toDouble(), stepsUtils.weeklySteps[index])),
              isCurved: true,
              color: Colors.green,
              barWidth: 3,
              belowBarData: BarAreaData(show: false),
            ),
            LineChartBarData(
              spots: List.generate(7, (index) => FlSpot(index.toDouble(), stepsUtils.weeklyKcal[index])),
              isCurved: true,
              color: Colors.red,
              barWidth: 2,
              belowBarData: BarAreaData(show: false),
            ),
          ],
        ),
      ),
    );
  }
}
