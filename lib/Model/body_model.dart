class BodyInfo {
  double height; // Height in meters
  double weight; // Weight in kilograms

  BodyInfo({
    required this.height,
    required this.weight,
  });

  // Method to calculate BMI
  double calculateBMI() {
    if (height <= 0) {
      throw ArgumentError('Height must be greater than 0.');
    }
    if (weight <= 0) {
      throw ArgumentError('Weight must be greater than 0.');
    }
    return weight / (height * height); // BMI formula: weight (kg) / (height (m) * height (m))
  }

  @override
  String toString() {
    return 'BodyInfo(height: $height, weight: $weight, BMI: ${calculateBMI().toStringAsFixed(2)})';
  }
}
