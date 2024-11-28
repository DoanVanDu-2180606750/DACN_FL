class BodyInfo {
  double height; 
  double weight; 

  BodyInfo({
    required this.height,
    required this.weight,
  });


  double calculateBMI() {
    if (height <= 0) {
      throw ArgumentError('Chiều cao phải lớn hơn không 0.');
    }
    if (weight <= 0) {
      throw ArgumentError('Cân nặng phải lớn hơn không 0.');
    }
    return weight / (height * height);
  }

  @override
  String toString() {
    return 'BodyInfo(height: $height, weight: $weight, BMI: ${calculateBMI().toStringAsFixed(2)})';
  }
}
