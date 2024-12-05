
import 'package:fit_25/Screen/FoodDetails.dart';
import 'package:fit_25/Screen/Home.dart';
import 'package:flutter/material.dart';

class DietScreen extends StatelessWidget {
  const DietScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          // Tiêu đề phần
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 16.0),
            child: Text(
              'Gợi ý thực phẩm lành mạnh',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ),
          _buildDietItem('Buổi sáng', 'Khởi đầu ngày mới với năng lượng lành mạnh.', Icons.breakfast_dining),
          _buildDietItem('Buổi trưa', 'Bữa ăn chính giàu dưỡng chất.', Icons.lunch_dining),
          _buildDietItem('Buổi chiều', 'Giúp cơ thể hồi phục với thực phẩm giàu protein.', Icons.fitness_center),
          _buildDietItem('Buổi tối', 'Bổ sung dinh dưỡng nhẹ nhàng, dễ tiêu.', Icons.nightlife),
          // Tiêu đề phần
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 16.0),
            child: Text(
              'Chế độ ăn kiêng',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ),
          _buildDietPlanItem('Chế độ ăn Địa Trung Hải', 'Nhiều trái cây, rau, ngũ cốc nguyên hạt và cá.'),
          _buildDietPlanItem('Chế độ ăn Keto', 'Nghiêng về thực phẩm giàu chất béo và ít carbs.'),
          _buildDietPlanItem('Chế độ ăn thuần chay', 'Chỉ bao gồm thực phẩm từ thực vật.'),
        ],
      ),

      floatingActionButton: FloatingActionButton(onPressed: (){
       Navigator.push(context, MaterialPageRoute(builder: (context) => CalorieScreen()));
      }),
    );
  }

  Widget _buildDietItem(String title, String description, IconData icon) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: ListTile(
        leading: Icon(icon, size: 40.0),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(description),
      ),
    );
  }

  Widget _buildDietPlanItem(String title, String description) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: ListTile(
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(description),
      ),
    );
  }
}
