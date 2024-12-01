import 'package:flutter/material.dart';


class CalorieScreen extends StatelessWidget {
  final List<Map<String, String>> foodCategories = [
    {'name': 'Rau củ quả', 'calories': '30 cal/100g'},
    {'name': 'Ngũ cốc', 'calories': '370 cal/100g'},
    {'name': 'Trái cây', 'calories': '50-100 cal/100g'},
    {'name': 'Các loại sữa', 'calories': '60-100 cal/100g'},
    {'name': 'Các loại thịt', 'calories': '250-300 cal/100g'},
    {'name': 'Các loại thủy hải sản', 'calories': '100-200 cal/100g'},
    {'name': 'Cháo', 'calories': '120 cal/100g'},
    {'name': 'Miến', 'calories': '150 cal/100g'},
    {'name': 'Phở', 'calories': '110 cal/100g'},
    {'name': 'Mì ăn liền', 'calories': '450 cal/100g'},
    {'name': 'Củ giàu tinh bột', 'calories': '70-100 cal/100g'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bảng Tính Calo'),
      ),
      body: ListView.builder(
        itemCount: foodCategories.length,
        itemBuilder: (context, index) {
          return Card(
            margin: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
            child: ListTile(
              title: Text(foodCategories[index]['name']!),
              subtitle: Text('Cal: ${foodCategories[index]['calories']}'),
            ),
          );
        },
      ),
    );
  }
}
