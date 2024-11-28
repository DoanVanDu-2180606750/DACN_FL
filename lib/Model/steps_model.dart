
class StepData {
  final int currentSteps; // Số bước hiện tại
  final int targetSteps; // Số bước mục tiêu
  final Duration elapsedTime; // Thời gian đã trôi qua
  final int runningSteps; // Số bước đang được đếm
  final int caloriesBurned; // Số calo đã tiêu tốn

  StepData({
    required this.currentSteps,
    required this.targetSteps,
    required this.elapsedTime,
    required this.runningSteps,
    required this.caloriesBurned,
  });

  // Phương thức tạo đối tượng từ JSON
  factory StepData.fromJson(Map<String, dynamic> json) {
    return StepData(
      currentSteps: json['currentSteps'],
      targetSteps: json['targetSteps'],
      elapsedTime: Duration(seconds: json['elapsedTime']),
      runningSteps: json['runningSteps'],
      caloriesBurned: json['caloriesBurned'],
    );
  }

  // Phương thức chuyển đổi đối tượng thành JSON
  Map<String, dynamic> toJson() {
    return {
      'currentSteps': currentSteps,
      'targetSteps': targetSteps,
      'elapsedTime': elapsedTime.inSeconds, // Chia sẻ thời gian dưới dạng giây
      'runningSteps': runningSteps,
      'caloriesBurned': caloriesBurned,
    };
  }

  // Phương thức copyWith để tạo một bản sao của StepData với các thay đổi
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
      elapsedTime: elapsedTime ?? this.elapsedTime,
      runningSteps: runningSteps ?? this.runningSteps,
      caloriesBurned: caloriesBurned ?? this.caloriesBurned,
    );
  }
}
