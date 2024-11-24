import 'package:fit_25/Providers/bodyProvider.dart';
import 'package:fit_25/Providers/timeProvider.dart';
import 'package:fit_25/Screen/BodyDetails.dart';
import 'package:fit_25/Screen/DietDetails.dart';
import 'package:fit_25/Screen/HeartDetails.dart';
import 'package:fit_25/Screen/More.dart';
import 'package:fit_25/Screen/ChatAI.dart';
import 'package:fit_25/Screen/Weather.dart';
import 'package:fit_25/Widgets/headhome_card.dart';
import 'package:fit_25/Widgets/info_card.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart'; 

// Khai báo lớp MyHomePage kế thừa StatefulWidget
class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool _isLoading = true;
  int _selectedIndex = 0;

  // Phương thức gọi khi người dùng chọn một mục trong BottomNavigationBar
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Phương thức xây dựng widget giao diện người dùng
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        // Tạo AppBar cho phần đầu của trang
        backgroundColor: Colors.white,
        elevation: 0,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'logo', // Nhiệt độ hiện tại
              style: TextStyle(fontSize: 15, color: Colors.grey[700]),
            ),
          ],
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

      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.green,
        onTap: _onItemTapped,
        unselectedItemColor: Colors.white,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home, color: Colors.black),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.message, color: Colors.black),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.gavel, color: Colors.black),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.more_horiz, color: Colors.black),
            label: '',
          ),
        ],
      ),
      body: _getBodyWidget(),
    );
  }

  // Phương thức cho giao diện chính
  Widget _buildHome() {
    final timeProvider = Provider.of<TimeProvider>(context);

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Row(
            children: [
              Column(
                children: [
                  Center(
                    child: WeatheHome(
                      formattedDate: DateFormat('EEEE d, MMMM yyyy').format(DateTime.now()),
                      formattedTime: timeProvider.formattedTime,
                    ),
                  ),
                ],
              ),
              const SizedBox( width: 30 ),
              const Column(
                children: [
                  Center(
                    child: Text(
                      'Huỳnh Đạo',
                      style: TextStyle(fontSize: 20, color: Colors.black, fontWeight: FontWeight.bold),
                    )
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 50),
          // Thông tin sức khỏe - Các thẻ thông tin
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Consumer<UserInfoProvider>(
                builder: (context, userInfoProvider, child) {
                  return InfoCard(
                    title: 'Weight',
                    data: '${userInfoProvider.weight} kg',
                    color: Colors.green,
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => UserInfoScreen()));
                    },
                  );
                },
              ),
              Consumer<UserInfoProvider>(
                builder: (context, userInfoProvider, child) {
                  return InfoCard(
                    title: 'Height',
                    data: '${userInfoProvider.height} m',
                    color: Colors.green,
                    onTap: () {},
                  );
                },
              ),
            ],
          ),
          const SizedBox(height: 10),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              InfoCard(
                title: 'Steps',
                data: '867/6000',
                color: Colors.green,
                onTap: () {},
              ),
              InfoCard(
                title: 'Calories burnt',
                data: '256',
                color: Colors.red,
                onTap: () {},
              ),
            ],
          ),
          const SizedBox(height: 10),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              InfoCard(
                title: 'Heart Rate',
                data: '89 BPM',
                color: Colors.green,
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const HeartSceen()));
                },
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const DietSreen()));
                },
                child: Container(
                  height: 80,
                  width: (MediaQuery.of(context).size.width / 2) - 20,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: Colors.black,
                  ),
                  child: const Center(
                    child: Text(
                      'Diet Suggestions',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
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

  // Phương thức để xác định widget nào được hiển thị dựa trên chỉ số chọn
  Widget _getBodyWidget() {
    switch (_selectedIndex) {
      case 0:
        return _buildHome(); // Gọi phương thức cho giao diện chính
      case 1:
        return const ChatScreen(); // Gửi đến giao diện tin nhắn
      case 2:
        return const WeatherScreen(); // Gửi đến giao diện thời tiết
      case 3:
        return const MoreScreen(); // Gửi đến giao diện khác
      default:
        return _buildHome();
    }
  }
}
