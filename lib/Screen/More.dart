import 'package:fit_25/Screen/EditProfile.dart';
import 'package:fit_25/Widgets/info_card.dart';
import 'package:flutter/material.dart';


class MoreScreen extends StatelessWidget {
  const MoreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Tạo AppBar cho phần đầu của trang
        backgroundColor: const Color.fromARGB(255, 15, 12, 226), // Màu nền của AppBar
        elevation: 0, // Không có bóng đổ
        title: const Text(
          'Thông Tin Cá Nhân', // Tiêu đề
          style: TextStyle(fontSize: 25, color: Colors.white), // Cài đặt kiểu chữ
        ),
      ),
      body: Center( // Center widget for better layout
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            // Sử dụng Column để hiện thị nhiều widget
            crossAxisAlignment: CrossAxisAlignment.start, // Căn lề trái
            children: [
              const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.only(bottom: 16.0), // Giảm khoảng cách dưới
                    child: CircleAvatar(
                      radius: 55, // Bán kính vòng tròn
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
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const InfoCard(title: 'Họ và Tên',data:  'Đoàn Văn Dự',color:  Colors.green),
                  const InfoCard(title: 'Số Điện Thoại',data:  '0339455501',color:  Colors.green),
                ],
              ),
              const SizedBox(height: 10), // Khoảng cách giữa các dòng
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const InfoCard(title: 'Email',data:  'vdyla2020@',color:  Colors.green),
                  GestureDetector(
                    child: Container(
                      height: 80, // Chiều cao của nút
                      width: (MediaQuery.of(context).size.width / 2) - 20, // Chiều rộng dựa trên kích thước màn hình
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25), // Bo góc
                        color: Colors.white, // Màu nền của nút
                      ),
                      child: const Center(
                        child: Text(
                          '39A, Gò Dưa, Tam Bình', // Văn bản cho nút
                          style: TextStyle(
                            color: Colors.black, // Màu chữ
                            fontSize: 14, // Kích thước chữ
                            fontWeight: FontWeight.bold, // Kiểu chữ đậm
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20), // Khoảng cách giữa các dòng
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const ProfilePage()), // Chuyển đến trang ProfilePage
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue, // Màu nền của nút
                  ),
                  child: const Text(
                    'Sửa thông tin',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const ProfilePage()), // Chuyển đến trang ProfilePage
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                     // Màu nền của nút
                  ),
                  child: const Text(
                    'Đăng xuất',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
