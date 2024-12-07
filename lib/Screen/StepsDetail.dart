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

// Màn hình chi tiết số bước
class StepsDetailsScreen extends StatefulWidget {
  const StepsDetailsScreen({super.key});

  @override
  _StepsDetailsScreenState createState() => _StepsDetailsScreenState();
}

class _StepsDetailsScreenState extends State<StepsDetailsScreen> {

  // Khai báo stream để lấy số bước và trạng thái người đi bộ
  late Stream<StepCount> _stepCountStream;


  // Khai báo các subscription
  StreamSubscription<StepCount>? _stepCountSubscription;
  StreamSubscription<PedestrianStatus>? _pedestrianStatusSubscription;
  StreamSubscription<AccelerometerEvent>? _accelerometerSubscription;

  // Biến để lưu trữ số bước và trạng thái
  int _stepCount = 0;
  String _status = '?';
  bool _isShaking = false;

  // Danh sách lưu trữ số bước và calo hàng tuần
  List<double> weeklySteps = List.generate(7, (index) => 0);
  List<double> weeklyKcal = List.generate(7, (index) => 0);

  // Hàm khởi tạo
  @override
  void initState() {
    super.initState();
    _loadSteps(); // Tải dữ liệu bước đã lưu
    _initPlatformState(); // Khởi tạo các stream
    _startAccelerometerListening(); // Bắt đầu lắng nghe cảm biến gia tốc
  }

  // Hàm huỷ bỏ
  @override
  void dispose() {
    _stepCountSubscription?.cancel();
    _pedestrianStatusSubscription?.cancel();
    _accelerometerSubscription?.cancel();
    super.dispose();
  }

  // Hàm tính toán calo dựa trên số bước
  void _calculateKcal() {
    setState(() {
      for (int i = 0; i < weeklySteps.length; i++) {
        weeklyKcal[i] = weeklySteps[i] * 0.04; // Tính calo
      }
    });
  }

  // Hàm xử lý khi trạng thái người đi bộ thay đổi
  void onPedestrianStatusChanged(PedestrianStatus event) {
    setState(() {
      _status = event.status; // Cập nhật trạng thái
    });
  }

  // Hàm bắt đầu lắng nghe cảm biến gia tốc
  void _startAccelerometerListening() {
    _accelerometerSubscription = accelerometerEvents.listen(_detectShake);
  }

  // Phát hiện rung
  void _detectShake(AccelerometerEvent event) {
    double threshold = 15.0; // Đặt ngưỡng cho việc rung
    setState(() {
      // Kiểm tra nếu có rung hay không
      _isShaking = event.x.abs() > threshold || event.y.abs() > threshold || event.z.abs() > threshold;
    });
  }

  // Hàm xử lý sự kiện số bước
  void onStepCount(StepCount event) {
    if (!_isShaking) { // Chỉ cập nhật nếu không rung
      setState(() {
        _stepCount = event.steps;

        // Cập nhật dữ liệu lên StepsProvider
        final stepsProvider = Provider.of<StepsProvider>(context, listen: false);
        stepsProvider.updateSteps(event.steps);

        // Nếu số bước chia hết cho 50, lưu vào SharedPreferences
        if (_stepCount % 50 == 0 && _stepCount != 0) {
          _saveSteps(); 
        }
      });
    }
  }

  // Hàm lấy số tuần hiện tại
  int _currentWeekNumber() {
    DateTime now = DateTime.now();
    int dayOfYear = int.parse(DateFormat("D").format(now));
    return ((dayOfYear - now.weekday + 10) / 7).floor();
  }

  // Tải số bước từ SharedPreferences
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

    // Nếu ngày mới, reset bước chân cho ngày đó
    if (lastSavedDate != currentDate) {
      setState(() {
        _stepCount = 0; // Reset số bước
        weeklySteps[DateTime.now().weekday - 1] = 0; // Reset bước theo ngày trong tuần
        weeklyKcal[DateTime.now().weekday - 1] = 0;  // Reset kcal theo ngày
      });
      await _saveSteps(); // Lưu lại thông tin reset
    }
  }

  // Lưu số bước vào SharedPreferences
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

  // Khởi tạo các stream và kiểm tra quyền truy cập
  Future<void> _initPlatformState() async {
    if (await _checkActivityRecognitionPermission()) {
      _stepCountStream = Pedometer.stepCountStream;
      _stepCountSubscription = _stepCountStream.listen(onStepCount);
    }
  }

  // Kiểm tra quyền truy cập nhận diện hoạt động
  Future<bool> _checkActivityRecognitionPermission() async {
    var status = await Permission.activityRecognition.request();
    return status.isGranted; // Trả về true nếu được cấp quyền
  }

  // Xây dựng giao diện người dùng
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
            const SizedBox(height: 40,),
            _buildChart(), // Xây dựng biểu đồ
            const SizedBox(height: 30),
            _buildStepsCard(), // Xây dựng thẻ hiển thị số bước
          ],
        ),
      ),
    );
  }

  // Xây dựng thẻ hiển thị số bước và kcal
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

  // Xây dựng biểu đồ
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
