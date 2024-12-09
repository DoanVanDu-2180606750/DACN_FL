import 'package:fit_25/Model/food_model.dart';
import 'package:fit_25/Screen/Kcal.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class CalorieScreen extends StatefulWidget {
  @override
  _CalorieScreenState createState() => _CalorieScreenState();
}

class _CalorieScreenState extends State<CalorieScreen> {
  List<Map<String, String>> allFoods = [];
  List<Map<String, String>> filteredFoods = [];
  List<Foods> foods = [];

  Map<int, String> typeMapping = {
    1: 'Rau củ quả',
    2: 'Ngũ cốc',
    3: 'Trái cây',
    4: 'Các loại sữa',
    5: 'Các loại thịt',
    6: 'Các loại thủy hải sản',
    7: 'Món ăn khác',
  };

  Future<void> _getFoods() async {
    final String url = 'http://192.168.1.7:8080/api/get_diet';
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      setState(() {
        final jsonData = jsonDecode(response.body) as List;
        foods = jsonData.map((json) => Foods.fromJson(json)).toList();
        categorizedFoods.clear();

        for (var food in foods) {
          final typeName = typeMapping[food.type] ?? 'Khác';
          categorizedFoods.putIfAbsent(typeName, () => []).add({
            'name': food.name,
            'calories': food.calories,
            'protein': food.protein,
            'fat': food.fat,
            'fiber': food.fiber,
          });
        }
        allFoods.clear();
        categorizedFoods.forEach((_, foods) => allFoods.addAll(foods));
        filteredFoods = List.from(allFoods);
      });
    }
  }

  final Map<String, List<Map<String, String>>> categorizedFoods = {};

  @override
  void initState() {
    super.initState();
    _getFoods();
  }

  void filterResults(String query) {
    setState(() {
      filteredFoods = query.isEmpty
          ? List.from(allFoods)
          : allFoods
              .where((food) => food['name']!.toLowerCase().contains(query.toLowerCase()))
              .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bảng Tính Calo Theo Loại'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(70),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Autocomplete<String>(
              optionsBuilder: (TextEditingValue textEditingValue) {
                if (textEditingValue.text.isEmpty) {
                  return const Iterable<String>.empty();
                }
                return allFoods
                    .map((food) => food['name']!)
                    .where((name) => name.toLowerCase().contains(textEditingValue.text.toLowerCase()));
              },
              onSelected: (String selection) {
                setState(() {
                  filteredFoods = allFoods
                      .where((food) => food['name']!.toLowerCase() == selection.toLowerCase())
                      .toList();
                });
              },
              fieldViewBuilder: (context, controller, focusNode, onFieldSubmitted) {
                return TextField(
                  controller: controller,
                  focusNode: focusNode,
                  decoration: InputDecoration(
                    hintText: 'Tìm kiếm thực phẩm...',
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  onChanged: (value) => filterResults(value),
                );
              },
            ),
          ),
        ),
      ),
      body: ListView.builder(
        itemCount: filteredFoods.length,
        itemBuilder: (context, index) {
          final food = filteredFoods[index];
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(food['name']!, style: const TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Cal: ${food['calories']}/100g'),
                      Text('Protein: ${food['protein']}g'),
                      Text('Fat: ${food['fat']}g'),
                      Text('Fiber: ${food['fiber']}g'),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.border_color, size: 30,),
        onPressed: (){
        Navigator.push(context, MaterialPageRoute(builder: (context) => CalorieCalculatorScreen()));
      }),
    );
  }
}
