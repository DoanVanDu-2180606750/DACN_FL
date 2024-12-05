
class StepData {
  late final int currentSteps; // Số bước hiện tại
  final int targetSteps; // Số bước mục tiêu
  late final int caloriesBurned; // Số calo đã tiêu tốn

  StepData({
    required this.currentSteps,
    required this.targetSteps,
    required this.caloriesBurned,
  });

  // Phương thức tạo đối tượng từ JSON
  factory StepData.fromJson(Map<String, dynamic> json) {
    return StepData(
      currentSteps: json['currentSteps'],
      targetSteps: json['targetSteps'],
      caloriesBurned: json['caloriesBurned'],
    );
  }

  // Phương thức chuyển đổi đối tượng thành JSON
  Map<String, dynamic> toJson() {
    return {
      'currentSteps': currentSteps,
      'targetSteps': targetSteps,
      'caloriesBurned': caloriesBurned,
    };
  }

  StepData copyWith({
    int? currentSteps,
    int? targetSteps,
    Duration? elapsedTime,
    int? runningSteps,
    int? caloriesBurned,
  }) {
    return StepData(
      currentSteps: currentSteps ?? this.currentSteps,
      targetSteps: targetSteps ?? this.targetSteps,
      caloriesBurned: caloriesBurned ?? this.caloriesBurned,
    );
  }
}
