import 'package:fit_25/Providers/bodyProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UserInfoScreen extends StatelessWidget {
  final TextEditingController heightController = TextEditingController();
  final TextEditingController weightController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nhập Thông tin Cá nhân'),
        backgroundColor: Colors.blueAccent,
        elevation: 4.0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 20),

              // Title Section
              const Text(
                "Cập nhật thông tin cá nhân",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueAccent,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 30),

              // Input Fields in Card
              Card(
                elevation: 5.0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      // Height Input
                      TextField(
                        controller: heightController,
                        decoration: const InputDecoration(
                          labelText: "Chiều cao (m)",
                          border: OutlineInputBorder(),
                          hintText: "Nhập chiều cao của bạn",
                        ),
                        keyboardType: TextInputType.number,
                      ),
                      const SizedBox(height: 16),

                      // Weight Input
                      TextField(
                        controller: weightController,
                        decoration: const InputDecoration(
                          labelText: "Cân nặng (kg)",
                          border: OutlineInputBorder(),
                          hintText: "Nhập cân nặng của bạn",
                        ),
                        keyboardType: TextInputType.number,
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 30),

              // Save Button with enhanced style
              ElevatedButton(
                onPressed: () async {
                  double height = double.tryParse(heightController.text) ?? 0.0;
                  double weight = double.tryParse(weightController.text) ?? 0.0;

                  // Update user info
                  Provider.of<UserInfoProvider>(context, listen: false)
                      .updateUserInfo(height, weight);

                  // Fetch AI advice
                  await Provider.of<UserInfoProvider>(context, listen: false)
                      .fetchAIAdvice(height.toString(), weight.toString());

                  // Show Snackbar to notify user
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text("Thông tin đã được lưu!"),
                    duration: Duration(seconds: 2),
                  ));
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: Colors.blueAccent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text(
                  "Lưu thông tin",
                  style: TextStyle(fontSize: 18),
                ),
              ),

              const SizedBox(height: 30),

              // AI Advice Section
              Consumer<UserInfoProvider>(
                builder: (context, userInfoProvider, child) {
                  if (userInfoProvider.isLoading) {
                    // Show loading spinner when loading is true
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  return Card(
                    elevation: 5.0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: SingleChildScrollView(
                        child: Text(
                          userInfoProvider.aiAdvice,
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.green,
                          ),
                          textAlign: TextAlign.justify,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
