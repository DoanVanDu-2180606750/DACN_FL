import 'package:fit_25/Widgets/body_widget.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BodyScreen extends StatefulWidget {
  @override
  State<BodyScreen> createState() => _BodyScreenState();
}

class _BodyScreenState extends State<BodyScreen> {
  
  final TextEditingController heightController = TextEditingController();

  final TextEditingController weightController = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadUserData(); // Tải dữ liệu từ SharedPreferences
  }


    Future<void> loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    double? height = prefs.getDouble('height');
    double? weight = prefs.getDouble('weight');

    if (height != null && weight != null) {
      setState(() {
        heightController.text = height.toString();
        weightController.text = weight.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 20),
              const Text(
                "Cập nhật thông tin cơ thể",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueAccent,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 30),
              BodyWidgets.inputFields(heightController, weightController),
              const SizedBox(height: 30),
              BodyWidgets.saveButton(context, heightController, weightController),
              const SizedBox(height: 30),
              BodyWidgets.aiAdviceSection(context),
            ],
          ),
        ),
      ),
    );
  }
}