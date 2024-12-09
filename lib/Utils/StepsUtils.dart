// steps_details_utils.dart
import 'dart:async';
import 'package:fit_25/Providers/StepsProvider.dart';
import 'package:pedometer/pedometer.dart';
import 'package:flutter/material.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

class StepsDetailsUtils {
  // Khai báo stream để lấy số bước và trạng thái người đi bộ
  late Stream<StepCount> stepCountStream;
  StreamSubscription<StepCount>? stepCountSubscription;
  StreamSubscription<PedestrianStatus>? pedestrianStatusSubscription;
  StreamSubscription<AccelerometerEvent>? accelerometerSubscription;

  int stepCount = 0;
  String status = '?';
  bool isShaking = false;
  
  List<double> weeklySteps = List.generate(7, (index) => 0);
  List<double> weeklyKcal = List.generate(7, (index) => 0);

  // Hàm tính toán calo dựa trên số bước
  void calculateKcal() {
    for (int i = 0; i < weeklySteps.length; i++) {
      weeklyKcal[i] = weeklySteps[i] * 0.04; // Tính calo
    }
  }

  // Hàm xử lý khi trạng thái người đi bộ thay đổi
  void onPedestrianStatusChanged(PedestrianStatus event) {
    status = event.status; // Cập nhật trạng thái
  }

  // Hàm phát hiện rung
  void detectShake(AccelerometerEvent event) {
    double threshold = 15.0; // Đặt ngưỡng cho việc rung
    // Kiểm tra nếu có rung hay không
    isShaking = event.x.abs() > threshold || event.y.abs() > threshold || event.z.abs() > threshold;
  }

  // Hàm xử lý sự kiện số bước
  void onStepCount(StepCount event, StepsProvider stepsProvider) {
    if (!isShaking) { // Chỉ cập nhật nếu không rung
      stepCount = event.steps;
      stepsProvider.updateSteps(event.steps);
    }
  }

  // Các hàm khác như _loadSteps, _saveSteps, và _initPlatformState tương tự có thể được thêm vào ...

  // Tải số bước từ SharedPreferences
  Future<void> loadSteps() async {
    final prefs = await SharedPreferences.getInstance();

    stepCount = prefs.getInt('stepCount') ?? 0;
    weeklySteps = (prefs.getStringList('weeklySteps') ?? List.generate(7, (_) => '0'))
        .map((e) => double.parse(e))
        .toList();
    weeklyKcal = (prefs.getStringList('weeklyKcal') ?? List.generate(7, (_) => '0'))
        .map((e) => double.parse(e))
        .toList();

    // Kiểm tra ngày cuối cùng lưu dữ liệu
    String lastSavedDate = prefs.getString('lastSavedDate') ?? DateFormat('yyyy-MM-dd').format(DateTime.now());
    String currentDate = DateFormat('yyyy-MM-dd').format(DateTime.now());

    // Nếu ngày mới, reset bước chân và calo cho ngày đó
    if (lastSavedDate != currentDate) {
      stepCount = 0; // Reset số bước cho ngày mới
      int dayOfWeek = DateTime.now().weekday - 1; 
      weeklySteps[dayOfWeek] = 0; 
      weeklyKcal[dayOfWeek] = 0; 
      
      await saveSteps(prefs); // Lưu lại thông tin reset
    }
  }

  // Lưu số bước vào SharedPreferences
  Future<void> saveSteps(SharedPreferences prefs) async {
    // Lưu thông tin số bước và kcal
    prefs.setInt('stepCount', stepCount);
    prefs.setString('lastSavedDate', DateFormat('yyyy-MM-dd').format(DateTime.now())); // Lưu ngày hiện tại
    
    int dayOfWeek = DateTime.now().weekday - 1;
    if (dayOfWeek >= 0) {
      weeklySteps[dayOfWeek] = stepCount.toDouble();
      prefs.setStringList('weeklySteps', weeklySteps.map((e) => e.toString()).toList());

      calculateKcal(); // Cập nhật kcal
      prefs.setStringList('weeklyKcal', weeklyKcal.map((e) => e.toString()).toList());
    }
  }

  // Khởi tạo các stream và kiểm tra quyền truy cập
  Future<void> initPlatformState() async {
    if (await checkActivityRecognitionPermission()) {
      stepCountStream = Pedometer.stepCountStream;
    }
  }

  // Kiểm tra quyền truy cập nhận diện hoạt động
  Future<bool> checkActivityRecognitionPermission() async {
    var status = await Permission.activityRecognition.request();
    return status.isGranted; // Trả về true nếu được cấp quyền
  }
}
