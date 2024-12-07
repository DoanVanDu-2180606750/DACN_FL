import 'dart:async'; // Thêm Timer
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DietScreen extends StatefulWidget {
  const DietScreen({Key? key}) : super(key: key);

  @override
  State<DietScreen> createState() => _DietScreenState();
}

class _DietScreenState extends State<DietScreen> {
  Map<String, String> selectedTimes = {}; // Lưu thời gian người dùng chọn
  Timer? _timer; // Timer kiểm tra thời gian định kỳ

  @override
  void initState() {
    super.initState();
    _loadSavedTimes();
    _startTimer(); // Bắt đầu kiểm tra thời gian
  }

  @override
  void dispose() {
    _timer?.cancel(); // Hủy Timer khi ứng dụng bị đóng
    super.dispose();
  }

  // Hàm nạp thời gian đã lưu từ SharedPreferences
  Future<void> _loadSavedTimes() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      selectedTimes = {
        'Buổi sáng': prefs.getString('Buổi sáng') ?? 'Chưa chọn',
        'Buổi trưa': prefs.getString('Buổi trưa') ?? 'Chưa chọn',
        'Buổi chiều': prefs.getString('Buổi chiều') ?? 'Chưa chọn',
        'Buổi tối': prefs.getString('Buổi tối') ?? 'Chưa chọn',
      };
    });
  }

  // Hàm hiển thị TimePicker
  Future<void> _selectTime(BuildContext context, String key) async {
    TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (pickedTime != null) {
      String formattedTime = pickedTime.format(context); // Ví dụ: 08:30 AM
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString(key, formattedTime);

      setState(() {
        selectedTimes[key] = formattedTime;
      });

      // Hiển thị thông báo xác nhận
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Đã lưu thời gian: $formattedTime cho $key')),
      );
    }
  }

  // Hàm so sánh thời gian hiện tại với thời gian đã chọn
  void _checkCurrentTime() {
    final now = TimeOfDay.now(); // Thời gian hiện tại
    selectedTimes.forEach((key, value) {
      if (value != 'Chưa chọn') {
        // Parse thời gian đã lưu
        final selectedTime = TimeOfDay(
          hour: int.parse(value.split(':')[0]),
          minute: int.parse(value.split(':')[1].split(' ')[0]),
        );

        // So sánh thời gian hiện tại với thời gian đã đặt
        if (now.hour == selectedTime.hour && now.minute == selectedTime.minute) {
          // Hiển thị thông báo snackbar khi đúng giờ
          _showSnackbar('Tới giờ $key rồi!', 'Đã đến giờ ăn $key!');
        }
      }
    });
  }
  // Hàm hiển thị Snackbar
  void _showSnackbar(String title, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$title\n$message'),
        duration: const Duration(seconds: 5),
      ),
    );
  }

  // Bắt đầu Timer với chu kỳ 1 phút để kiểm tra thời gian
  void _startTimer() {
    _timer = Timer.periodic(const Duration(minutes: 1), (_) {
      _checkCurrentTime(); // Gọi hàm kiểm tra thời gian
    });
  }

  // Widget để hiển thị từng bữa ăn
  Widget _buildDietItem(String title, String description, IconData icon) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: ListTile(
        leading: Icon(icon, size: 40.0),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text('${description}\nThời gian đã chọn: ${selectedTimes[title] ?? "Chưa chọn"}'),
        onTap: () => _selectTime(context, title), // Người dùng chọn thời gian
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          _buildDietItem(
            'Buổi sáng',
            'Khởi đầu ngày mới với năng lượng lành mạnh.',
            Icons.breakfast_dining,
          ),
          _buildDietItem(
            'Buổi trưa',
            'Bữa ăn chính giàu dưỡng chất.',
            Icons.lunch_dining,
          ),
          _buildDietItem(
            'Buổi chiều',
            'Giúp cơ thể hồi phục với thực phẩm giàu protein.',
            Icons.fitness_center,
          ),
          _buildDietItem(
            'Buổi tối',
            'Bổ sung dinh dưỡng nhẹ nhàng, dễ tiêu.',
            Icons.nightlife,
          ),
        ],
      ),
    );
  }
}
