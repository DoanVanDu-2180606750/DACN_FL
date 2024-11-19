import 'package:flutter/material.dart';


class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});  


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Ho Chi Minh city',
              style: TextStyle(fontSize: 14, color: Colors.grey[700]),
            ),
            Text(
              '29°C',
              style: TextStyle(fontSize: 12, color: Colors.grey[700]),
            ),
          ],
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16.0),
            child: CircleAvatar(
              backgroundImage: AssetImage('assets/profile.jpg'), // Thay hình ảnh đại diện
              radius: 20,
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Hello John,',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            const Text(
              'Welcome back.',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildInfoCard('Weight', '71 kg', Colors.green),
                _buildInfoCard('Height', '171 cm', Colors.green),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildInfoCard('Steps', '867/6000', Colors.green, subtitle: '14%'),
                _buildInfoCard('Calories burnt', '256', Colors.red),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildInfoCard('Heart Rate', '89 BPM', Colors.green),
                GestureDetector(
                  onTap: () {
                    // Xử lý khi nhấn nút Diet suggestions
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
                        'Diet suggestions',
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
      ),

      bottomSheet: const BottomAppBar(
        color: Colors.white,
        child: ElevatedButton(onPressed: tinhtong(), child: child),
      ),
      int tinhtong(){
        int tong = 0;
        for (int i = 0; i < 10; i++) {
          tong += i;
          }
          return tong;
      }

      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.black,
        selectedItemColor: Colors.green,
        unselectedItemColor: Colors.white,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home, color: Colors.black), label: '',),
          BottomNavigationBarItem(icon: Icon(Icons.message, color: Colors.black), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.gavel, color: Colors.black), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.more_horiz, color: Colors.black), label: ''), 
        ],
      ),
    );
  }
  Widget _buildInfoCard(String title, String data, Color color, {String? subtitle}) {
    return Container(
      padding: const EdgeInsets.all(16),
      height: 80,
      width: 160,
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(color: Colors.white, fontSize: 14),
          ),
          const Spacer(),
          Row(
            children: [
              Text(
                data,
                style: TextStyle(
                  color: color,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (subtitle != null) ...[
                const SizedBox(width: 5),
                Text(
                  subtitle,
                  style: const TextStyle(color: Colors.white, fontSize: 14),
                ),
              ]
            ],
          ),
        ],
      ),
    );
  }
}

