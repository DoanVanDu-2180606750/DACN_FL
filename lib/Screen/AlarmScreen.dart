import 'package:fit_25/Providers/dietProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MealReminderScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Đặt Báo Thức Bữa Ăn'),
      ),
      body: Column(
        children: [
          Expanded(
            child: Consumer<ReminderProvider>(
              builder: (context, reminderProvider, child) {
                return ListView.builder(
                  itemCount: reminderProvider.reminders.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text('Nhắc nhở lúc: ${reminderProvider.reminders[index]}'),
                    );
                  },
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: () async {
                TimeOfDay? selectedTime = await showTimePicker(
                  context: context,
                  initialTime: TimeOfDay.now(),
                );

                if (selectedTime != null) {
                  String formattedTime = selectedTime.format(context);
                  // Cập nhật danh sách nhắc nhở trong provider
                  Provider.of<ReminderProvider>(context, listen: false).addReminder(formattedTime);
                }
              },
              child: Text('Thêm Nhắc Nhở'),
            ),
          ),
        ],
      ),
    );
  }
}
