
import 'package:flutter/material.dart';
import 'package:heart_bpm/chart.dart';
import 'package:heart_bpm/heart_bpm.dart';


class HeartScreen extends StatefulWidget {
  const HeartScreen({super.key});

  @override
  State<HeartScreen> createState() => _HeartScreenState();
}

class _HeartScreenState extends State<HeartScreen> {
  List<SensorValue> data = [];
  List<SensorValue> bpmValues = [];

  double totalBPM = 0.0;
  int countBPM = 0;

  bool isBPMEnabled = false;

  /// Hàm trung bình động (Moving Average)
  double movingAverage(List<double> values, int windowSize) {
    if (values.isEmpty) return 0.0;
    if (values.length < windowSize) {
      return values.reduce((a, b) => a + b) / values.length;
    }
    return values.sublist(values.length - windowSize).reduce((a, b) => a + b) / windowSize;
  }

  /// Render biểu đồ
  Widget buildChart(List<SensorValue> values) {
    if (values.isNotEmpty) {
      return Container(
        decoration: BoxDecoration(border: Border.all()),
        constraints: const BoxConstraints.expand(height: 180),
        child: BPMChart(values),
      );
    }
    return const SizedBox();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            // HeartBPM Dialog
            isBPMEnabled
                ? HeartBPMDialog(
                    context: context,
                    showTextValues: true,
                    borderRadius: 10,
                    sampleDelay: 300,
                    onRawData: (value) {
                      setState(() {
                        if (data.length >= 300) data.removeAt(2);
                        data.add(value);
                      });
                    },
                    onBPM: (value) {
                      // Bỏ qua giá trị nằm ngoài phạm vi 40-200 BPM (lọc ngưỡng)
                      if (value < 40 || value > 200) {
                        return;
                      }
                      setState(() {
                        if (bpmValues.length >= 300) bpmValues.removeAt(0);
                        bpmValues.add(SensorValue(value: value.toDouble(), time: DateTime.now())); // Sử dụng giá trị BPM trực tiếp
                        totalBPM += value.toDouble();
                        countBPM++;
                      });
                    },
                  )
                : const SizedBox(),

            // Biểu đồ thô
            buildChart(data),
            // Nút Bắt Đầu hoặc Dừng
            Center(
              child: ElevatedButton.icon(
                icon: const Icon(Icons.favorite_rounded),
                label: Text(isBPMEnabled ? "Dừng" : "Bắt đầu"),
                onPressed: () {
                  setState(() {
                    if (isBPMEnabled) {
                      isBPMEnabled = false;
                      double averageBPM = countBPM > 0 ? totalBPM / countBPM : 0;
                      // Hiển thị kết quả cho người dùng
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text("Kết quả"),
                          content: Text(
                            "Nhịp tim trung bình: ${averageBPM.toStringAsFixed(2)} BPM",
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                                totalBPM = 0;
                                countBPM = 0;
                                data.clear();
                                bpmValues.clear();
                              },
                              child: const Text("Đóng"),
                            ),
                          ],
                        ),
                      );
                    } else {
                      isBPMEnabled = true;
                    }
                  });
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
