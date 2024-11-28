import 'package:flutter/material.dart';

class DietScreen extends StatelessWidget {
  const DietScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chế Độ Ăn Uống'),
        centerTitle: true,
      ),
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
          _buildDietItem('Salad trái cây', 'Một lựa chọn nhẹ nhàng và bổ dưỡng.', Icons.restaurant),
          _buildDietItem('Sinh tố xanh', 'Giàu vitamin và khoáng chất.', Icons.local_drink),
          _buildDietItem('Gà nướng', 'Thực phẩm giàu protein.', Icons.local_fire_department),
          _buildDietItem('Cá hồi nướng', 'Dinh dưỡng từ omega-3.', Icons.fastfood),
          _buildDietItem('Yogurt tự nhiên', 'Tốt cho hệ tiêu hóa.', Icons.icecream),

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
