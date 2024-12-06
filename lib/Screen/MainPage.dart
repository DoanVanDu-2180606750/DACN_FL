
import 'package:fit_25/Providers/loginProvider.dart';
import 'package:fit_25/Screen/ChatAI.dart';
import 'package:fit_25/Screen/Home.dart';
import 'package:fit_25/Screen/Login.dart';
import 'package:fit_25/Screen/User.dart';
import 'package:flutter/material.dart';
import 'package:fit_25/Screen/BodyDetails.dart';
import 'package:fit_25/Screen/DietDetails.dart';
import 'package:fit_25/Screen/HeartDetails.dart';
// import 'package:fit_25/Screen/More.dart';
import 'package:fit_25/Screen/StepsDetail.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  Future<void> _logout(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('loggedIn', false); // Đặt trạng thái đăng nhập là false
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginScreen()), // Quay lại trang đăng nhập
    );
  }
  
  int _selectedIndex = 0;

  // List of the screens for each tab
  static final List<Widget> _widgetOptions = <Widget>[
    HomeScreen(),
    BodyScreen(),
    const StepsDetailsScreen(),
    const HeartScreen(),
    const DietScreen(),
    const UserScreen(),
  ];

  // Method to call when the user selects a tab from the BottomNavigationBar
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
  @override
  Widget build(BuildContext context) {
    final image = Provider.of<UserProvider>(context, listen: false).image;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Image.asset('assets/Images/logo.png', height: 30),
      ),
      body: _widgetOptions[_selectedIndex], // Display the selected screen
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home'
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person), 
            label: 'Body'
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.directions_walk), 
            label: 'Walk'
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite), 
            label: 'Heart'
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.fastfood), 
            label: 'Diet'
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.more_horiz), 
            label: 'More'
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: Colors.green,
        unselectedItemColor: Colors.black,
      ),

      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.face_6, size: 30,),
        onPressed: (){
          Navigator.push(context, MaterialPageRoute(builder: (context) => const ChatScreen()));
        }),
    );
  }
}


