// models/meal_reminder.dart
import 'package:flutter/material.dart';

class Diet {
  final String name;
  final String description;
  final double calories;

  Diet({
    required this.name,
    required this.description,
    required this.calories,
  });
}

class Time {
  final String mealType;
  final String time;

  Time({
    required this.mealType,
    required this.time,
  });
}

class DietTime {
  final List<Diet> diets;
  final List<Time> times;

  DietTime({
    required this.diets,
    required this.times,
  });

  void addDiet(Diet diet) {
    diets.add(diet);
  }

  void addTime(Time time) {
    times.add(time);
  }

  void displayDiets() {
    for (var diet in diets) {
      print('Tên món: ${diet.name}, Mô tả: ${diet.description}, Calo: ${diet.calories}');
    }
  }

  void displayTimes() {
    for (var time in times) {
      print('Loại bữa ăn: ${time.mealType}, Thời gian: ${time.time}');
    }
  }
}

