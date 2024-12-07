import 'package:flutter/material.dart';

class CalorieCalculatorScreen extends StatefulWidget {
  @override
  _CalorieCalculatorScreenState createState() => _CalorieCalculatorScreenState();
}

class _CalorieCalculatorScreenState extends State<CalorieCalculatorScreen> {
  final _foodController = TextEditingController();
  final _calorieController = TextEditingController();
  final _quantityController = TextEditingController();

  String _selectedUnit = 'g'; // Default unit is grams (g)
  final List<Map<String, dynamic>> _foodList = [];
  int _totalCalories = 0;

  void _addFood() {
    final foodName = _foodController.text;
    final caloriePerUnit = int.tryParse(_calorieController.text); // Calorie per 100g (for g) or per 1kg (for kg)
    final quantity = double.tryParse(_quantityController.text);

    if (foodName.isNotEmpty && caloriePerUnit != null && quantity != null) {
      // Convert quantity to grams if unit is kg
      double quantityInGram = _selectedUnit == 'kg' ? quantity * 1000 : quantity;

      // Calculate calories
      int calories = ((caloriePerUnit / 100) * quantityInGram).toInt();

      setState(() {
        _foodList.add({
          'name': foodName,
          'quantity': quantity,
          'unit': _selectedUnit,
          'calories': calories,
        });
        _totalCalories += calories;
      });

      // Clear the text fields
      _foodController.clear();
      _calorieController.clear();
      _quantityController.clear();
    } else {
      // Show a warning dialog if the inputs are invalid
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Invalid Input'),
          content: const Text('Please provide valid food, calorie, and quantity inputs.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Calorie Calculator'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Enter Food and Details:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _foodController,
              decoration: const InputDecoration(
                labelText: 'Food Name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _calorieController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Calories per 100g / 1kg',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _quantityController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Quantity',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                DropdownButton<String>(
                  value: _selectedUnit,
                  items: [
                    const DropdownMenuItem(value: 'g', child: Text('g (grams)')),
                    const DropdownMenuItem(value: 'kg', child: Text('kg (kilograms)')),
                  ],
                  onChanged: (value) {
                    setState(() {
                      _selectedUnit = value!;
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _addFood,
              child: const Text('Add Food'),
            ),
            const SizedBox(height: 20),
            const Text(
              'Food List:',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: _foodList.length,
                itemBuilder: (ctx, index) {
                  final foodItem = _foodList[index];
                  return ListTile(
                    title: Text(foodItem['name']),
                    subtitle: Text(
                        'Quantity: ${foodItem['quantity']} ${foodItem['unit']} - Calories: ${foodItem['calories']} cal'),
                  );
                },
              ),
            ),
            const Divider(),
            Text(
              'Total Calories: $_totalCalories cal',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}