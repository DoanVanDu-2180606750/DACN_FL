import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class HeartSceen extends StatefulWidget {
  const HeartSceen({super.key});

  @override
  State<HeartSceen> createState() => _HeartSceenState();
}

class _HeartSceenState extends State<HeartSceen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white, // Màu nền của AppBar
        elevation: 0, // Không có bóng đổ
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start, // Căn lề trái
          children: [
          ],
        ),
        leading: IconButton( // Thêm nút quay lại
          icon: const Icon(Icons.arrow_back, color: Colors.black), // Biểu tượng mũi tên quay lại
          onPressed: () {
            Navigator.pop(context); // Quay lại trang trước đó
          },
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16.0,), // Thiết lập khoảng cách
            child: CircleAvatar(
              radius: 25, // Bán kính vòng tròn
              child: Center(
                child: Text(
                  'J', // Ký tự hiển thị trong Avatar (hình đại diện)
                  style: TextStyle(fontSize: 16, color: Colors.white), // Định dạng kiểu chữ
                ),
              ),
            ),
          ),
        ],
      ),
      body: const Center(
        child: Text('Hello'),
      ),
    );
  }
}