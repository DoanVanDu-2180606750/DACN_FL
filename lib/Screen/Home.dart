
import 'package:flutter/material.dart';
import 'package:fit_25/Screen/BodyDetails.dart';
import 'package:fit_25/Screen/DietDetails.dart';
import 'package:fit_25/Screen/HeartDetails.dart';
import 'package:fit_25/Screen/More.dart';
import 'package:fit_25/Screen/StepsDetail.dart';
import 'package:fit_25/Screen/Weather.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  
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
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'logo',
          style: TextStyle(fontSize: 15, color: Colors.grey),
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
    );
  }
}


