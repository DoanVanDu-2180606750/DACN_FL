import 'package:fit_25/page/More.dart';
import 'package:fit_25/page/Other.dart';
import 'package:fit_25/page/chat.dart';
import 'package:flutter/material.dart'; // Nhập môn Flutter material package

// Khai báo lớp MyHomePage kế thừa StatefulWidget
class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Phương thức xây dựng widget giao diện người dùng
    return Scaffold(
      backgroundColor: Colors.white, // Thiết lập nền trắng cho giao diện
      appBar: AppBar(
        // Tạo AppBar cho phần đầu của trang
        backgroundColor: Colors.white, // Màu nền của AppBar
        elevation: 0, // Không có bóng đổ
        title: Column(
          // Sử dụng Column để hiện thị nhiều dòng tiêu đề
          crossAxisAlignment: CrossAxisAlignment.start, // Căn lề trái
          children: [
            Text(
              'Ho Chi Minh city', // Tên thành phố
              style: TextStyle(fontSize: 14, color: Colors.grey[700]), // Cài đặt kiểu chữ
            ),
            Text(
              '29°C', // Nhiệt độ hiện tại
              style: TextStyle(fontSize: 12, color: Colors.grey[700]), // Cài đặt kiểu chữ
            ),
          ],
        ),
        actions: const [
          // Các hành động bên phải của AppBar
          Padding(
            padding: EdgeInsets.only(right: 16.0), // Thiết lập khoảng cách
            child: CircleAvatar(
              // Hình đại diện người dùng
              backgroundImage: AssetImage('assets/profile.jpg'), // Ảnh hình đại diện
              radius: 20, // Bán kính vòng tròn
              child: Center(
                child: Text(
                  'A', // Ký tự hiển thị trong Avatar (hình đại diện)
                  style: TextStyle(fontSize: 16, color: Colors.white), // Định dạng kiểu chữ
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        // Thanh điều hướng dưới cùng
        backgroundColor: Colors.black, // Màu nền của thanh điều hướng
        selectedItemColor: Colors.green, // Màu của mục được chọn
        onTap: _onItemTapped,
        unselectedItemColor: Colors.white, // Màu của các mục không được chọn
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home, color: Colors.black), // Biểu tượng trang chính
            label: '', // Nhãn (để trống trong trường hợp này)
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.message, color: Colors.black), // Biểu tượng tin nhắn
            label: '', // Nhãn (để trống trong trường hợp này)
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.gavel, color: Colors.black), // Biểu tượng luật
            label: '', // Nhãn (để trống trong trường hợp này)
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.more_horiz, color: Colors.black), // Biểu tượng nhiều hơn
            label: '', // Nhãn (để trống trong trường hợp này)
          ),
        ],
      ),
      body: _getBodyWidget(),
    );
  }

  // Xây dựng widget body
  Widget _getBodyWidget() {
    switch (_selectedIndex) {
      case 0:
        return _buildHome(); // Gọi phương thức cho giao diện chính
      case 1:
        return const MessageAI(); // Gửi đến giao diện tin nhắn
      case 2:
        return const OtherScreen(); // Gửi đến giao diện khác
      case 3:
        return const MoreScreen(); // Gửi đến giao diện khác
      default:
        return _buildHome();
    }
  }

  // Phương thức cho giao diện chính
  Widget _buildHome() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        // Sử dụng Column để hiện thị nhiều widget
        crossAxisAlignment: CrossAxisAlignment.start, // Căn lề trái
        children: [
          const Text(
            'Hello John,', // Lời chào đến người dùng
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold), // Định dạng kiểu chữ
          ),
          const Text(
            'Welcome back.', // Thông điệp chào đón
            style: TextStyle(fontSize: 16, color: Colors.grey), // Định dạng kiểu chữ
          ),
          const SizedBox(height: 20), // Khoảng cách giữa các widget
          Row(
            // Dòng để hiện thị thông tin về cân nặng và chiều cao
            mainAxisAlignment: MainAxisAlignment.spaceBetween, // Căn giữa
            children: [
              // Thẻ thông tin cho Cân nặng
              _buildInfoCard('Weight', '71 kg', Colors.green),
              // Thẻ thông tin cho Chiều cao
              _buildInfoCard('Height', '171 cm', Colors.green),
            ],
          ),
          const SizedBox(height: 10), // Khoảng cách giữa các dòng
          Row(
            // Dòng để hiện thị thông tin về số bước và calo đã tiêu thụ
            mainAxisAlignment: MainAxisAlignment.spaceBetween, // Căn giữa
            children: [
              // Thẻ thông tin cho Số bước với phụ đề
              _buildInfoCard('Steps', '867/6000', Colors.green, subtitle: '14%'),
              // Thẻ thông tin cho Calo đã tiêu thụ
              _buildInfoCard('Calories burnt', '256', Colors.red),
            ],
          ),
          const SizedBox(height: 10), // Khoảng cách giữa các dòng
          Row(
            // Dòng để hiện thị thông tin về Tần số tim và nút Gợi ý chế độ ăn
            mainAxisAlignment: MainAxisAlignment.spaceBetween, // Căn giữa
            children: [
              // Thẻ thông tin cho Tần số tim
              _buildInfoCard('Heart Rate', '89 BPM', Colors.green),
              GestureDetector(
                // Nhận diện sự kiện chạm
                onTap: () {
                  // Xử lý sự kiện khi nhấn nút Gợi ý chế độ ăn uống
                },
                child: Container(
                  height: 80, // Chiều cao của nút
                  width: (MediaQuery.of(context).size.width / 2) - 20, // Chiều rộng dựa trên kích thước màn hình
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15), // Bo góc
                    color: Colors.black, // Màu nền của nút
                  ),
                  child: const Center(
                    child: Text(
                      'Diet Suggestions', // Văn bản cho nút "Gợi ý chế độ ăn"
                      style: TextStyle(
                        color: Colors.white, // Màu chữ
                        fontSize: 16, // Kích thước chữ
                        fontWeight: FontWeight.bold, // Kiểu chữ đậm
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

  // Hàm xây dựng một thẻ thông tin với tiêu đề, dữ liệu và màu sắc
  Widget _buildInfoCard(String title, String data, Color color, {String? subtitle}) {
    return Container(
      padding: const EdgeInsets.all(16), // Padding cho thẻ
      height: 80, // Chiều cao của thẻ
      width: 160, // Chiều rộng của thẻ
      decoration: BoxDecoration(
        color: Colors.black, // Màu nền của thẻ
        borderRadius: BorderRadius.circular(10), // Bo góc thẻ
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start, // Căn lề trái cho nội dung trong thẻ
        children: [
          Text(
            title, // Tiêu đề được truyền vào
            style: const TextStyle(color: Colors.white, fontSize: 14), // Định dạng kiểu chữ
          ),
          const Spacer(), // Khoảng trống giữa tiêu đề và dữ liệu
          Row(
            // Dòng để hiện thị dữ liệu và phụ đề (nếu có)
            children: [
              Text(
                data, // Dữ liệu hiển thị
                style: TextStyle(
                  color: color, // Màu chữ phụ thuộc vào tham số truyền vào
                  fontSize: 18, // Kích thước chữ
                  fontWeight: FontWeight.bold, // Kiểu chữ đậm
                ),
              ),
              if (subtitle != null) ...[
                const SizedBox(width: 5), // Khoảng cách nếu có phụ đề
                Text(
                  subtitle, // Phụ đề (nếu có)
                  style: const TextStyle(color: Colors.white, fontSize: 14), // Định dạng kiểu chữ cho phụ đề
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}
