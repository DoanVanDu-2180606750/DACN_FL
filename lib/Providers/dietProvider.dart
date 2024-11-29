import 'package:fit_25/Screen/notification_service.dart';
import 'package:flutter/material.dart';

class ReminderProvider with ChangeNotifier {
  List<String> _reminders = [];

  List<String> get reminders => _reminders;

  void addReminder(String reminder) {
    _reminders.add(reminder);
    notifyListeners();

    // Chuyển đổi reminder thành TimeOfDay
    final timeParts = reminder.split(":");
    final time = TimeOfDay(hour: int.parse(timeParts[0]), minute: int.parse(timeParts[1]));

    // Lên lịch nhắc nhở
    NotificationService().scheduleNotification(time, 'Đến giờ ăn rồi!');
  }
}
