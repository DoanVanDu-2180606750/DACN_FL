// screens/steps_screen.dart
import 'package:fit_25/Providers/StepsProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:provider/provider.dart';

class StepsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => StepsProvider(),
      child: Scaffold(
        appBar: AppBar(
          title: Text('Step Counter'),
        ),
        body: Consumer<StepsProvider>(
          builder: (context, stepsProvider, child) {
            return Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Current Steps: ${stepsProvider.stepData.currentSteps}', style: TextStyle(fontSize: 24)),
                  Text('Calories Burned: ${stepsProvider.stepData.caloriesBurned}', style: TextStyle(fontSize: 24)),
                  Text('Target Steps: ${stepsProvider.stepData.targetSteps}', style: TextStyle(fontSize: 18)),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      // Logic để cập nhật mục tiêu số bước nếu cần
                    },
                    child: Text('Update Target Steps'),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
