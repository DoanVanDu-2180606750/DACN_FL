class Foods {
  final String name;
  final String calories;
  final String protein;
  final String fat;
  final String fiber; 
  final int type; // Type dạng số nguyên

  Foods({
    required this.name,
    required this.calories,
    required this.protein,
    required this.fat,
    required this.fiber,
    required this.type,
  });

  factory Foods.fromJson(Map<String, dynamic> json) {
    return Foods(
      name: json['name'],
      calories: json['calories'],
      protein: json['protein'],
      fat: json['fat'],
      fiber: json['fiber'],
      type: json['type'],
    );
  }

  

}
