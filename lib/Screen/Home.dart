import 'package:fit_25/Providers/weatherData.dart';
import 'package:fit_25/Screen/More.dart';
import 'package:fit_25/Screen/ChatAI.dart';
import 'package:fit_25/Screen/Weather.dart';
import 'package:fit_25/Widgets/info_card.dart';
import 'package:fit_25/Widgets/weather_card.dart';
import 'package:fit_25/Widgets/weatherhome_card.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart'; // Nhập môn Flutter material package

// Khai báo lớp MyHomePage kế thừa StatefulWidget
class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    Provider.of<WeatherProvider>(context, listen: false).fetchWeather();
    final weatherProvider = Provider.of<WeatherProvider>(context, listen: false);
    weatherProvider.fetchWeather(); // Gọi đầu tiên để lấy dữ liệu
    weatherProvider.startAutoRefreshing(); // Bắt đầu tự động làm mới
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final weatherProvider = Provider.of<WeatherProvider>(context);
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
              'logo', // Nhiệt độ hiện tại
              style: TextStyle(fontSize: 15, color: Colors.grey[700]), // Cài đặt kiểu chữ
            ),
          ],
        ),
        actions: const [
          // Các hành động bên phải của AppBar
          Padding(
            padding: EdgeInsets.only(right: 16.0,), // Thiết lập khoảng cách
            child: CircleAvatar(
              // Hình đại diện người dùng
              // backgroundImage: AssetImage('assets/profile.jpg'), // Ảnh hình đại diện
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

      bottomNavigationBar: BottomNavigationBar(
        // Thanh điều hướng dưới cùng
        type: BottomNavigationBarType.fixed, // Loại thanh điều hướng
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
        return const ChatScreen(); // Gửi đến giao diện tin nhắn
      case 2:
        return const WeatherScreen(); // Gửi đến giao diện khác
      case 3:
        return const MoreScreen(); // Gửi đến giao diện khác
      default:
        return _buildHome();
    }
  }

  // Phương thức cho giao diện chính
  Widget _buildHome() {
    final weatherProvider = Provider.of<WeatherProvider>(context);
    String formattedTime = DateFormat('hh:mm a').format(DateTime.now());
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        // Sử dụng Column để hiện thị nhiều widget
        crossAxisAlignment: CrossAxisAlignment.start, // Căn lề trái
        children: [
          Center(
              child: weatherProvider.isLoading // Kiểm tra trạng thái load
                  ? const CircularProgressIndicator(color: Colors.white)
                  : weatherProvider.error != null // Kiểm tra lỗi
                      ? Text(
                          weatherProvider.error!, // Kết quả lỗi
                          style: const TextStyle(color: Colors.red),
                        )
                      : WeatheHome(
                          weather: weatherProvider.weatherData!, // Lấy dữ liệu thời tiết
                          formattedDate: DateFormat('EEEE d, MMMM yyyy').format(DateTime.now()),

                        ),
            ),

          const SizedBox(height: 50),
          
          const Row(
            // Dòng để hiện thị thông tin về cân nặng và chiều cao
            mainAxisAlignment: MainAxisAlignment.spaceBetween, 
            // Căn giữa
            children: [
              // Thẻ thông tin cho Cân nặng
              InfoCard(title: 'Weight',data:  '71 kg',color:  Colors.green),
              // Thẻ thông tin cho Chiều cao
              InfoCard(title: 'Height',data:  '171 cm',color:  Colors.green),
            ],
          ),
          const SizedBox(height: 10), // Khoảng cách giữa các dòng
          const Row(
            // Dòng để hiện thị thông tin về số bước và calo đã tiêu thụ
            mainAxisAlignment: MainAxisAlignment.spaceBetween, // Căn giữa
            children: [
              // Thẻ thông tin cho Số bước với phụ đề
              InfoCard( title: 'Steps',data:  '867/6000',color:  Colors.green, subtitle: '14%'),
              // Thẻ thông tin cho Calo đã tiêu thụ
              InfoCard( title: 'Calories burnt',data:  '256',color: Colors.red),
            ],
          ),
          const SizedBox(height: 10), // Khoảng cách giữa các dòng
          Row(
            // Dòng để hiện thị thông tin về Tần số tim và nút Gợi ý chế độ ăn
            mainAxisAlignment: MainAxisAlignment.spaceBetween, // Căn giữa
            children: [
              // Thẻ thông tin cho Tần số tim
              const InfoCard(title:'Heart Rate', data: '89 BPM',color:  Colors.green),
              
              
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
}
