import 'package:fit_25/Providers/heartProrvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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
  int totalBPM = 0;
  int countBPM = 0;

  bool isBPMEnabled = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Center(child: Text('Đo Nhịp Tim')),
      ),
      body: Column(
        children: [
          isBPMEnabled
              ? HeartBPMDialog(
                  context: context,
                  showTextValues: true,
                  borderRadius: 10,
                  onRawData: (value) {
                    setState(() {
                      if (data.length >= 100) data.removeAt(0);
                      data.add(value);
                    });
                  },
                  onBPM: (value) => setState(() {
                    if (bpmValues.length >= 100) bpmValues.removeAt(0);
                    bpmValues.add(SensorValue(value: value.toDouble(), time: DateTime.now()));
                    totalBPM += value;
                    countBPM++;
                  }),
                )
              : const SizedBox(),
          isBPMEnabled && data.isNotEmpty
              ? Container(
                  decoration: BoxDecoration(border: Border.all()),
                  height: 180,
                  child: BPMChart(data),
                )
              : const SizedBox(),
          isBPMEnabled && bpmValues.isNotEmpty
              ? Container(
                  decoration: BoxDecoration(border: Border.all()),
                  constraints: const BoxConstraints.expand(height: 180),
                  child: BPMChart(bpmValues),
                )
              : const SizedBox(),
          Center(
            child: ElevatedButton.icon(
              icon: const Icon(Icons.favorite_rounded),
              label: Text(isBPMEnabled ? "Dừng" : "Bắt đầu"),
              onPressed: () {
                setState(() {
                  if (isBPMEnabled) {
                    isBPMEnabled = false;
                    double averageBPM = countBPM > 0 ? totalBPM / countBPM : 0;

                    // Cập nhật provider với dữ liệu nhịp tim
                    Provider.of<HeartRateProvider>(context, listen: false).updateHeartRate(
                      averageBPM,
                      bpmValues,
                    );

                    // Hiển thị kết quả
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text("Kết quả"),
                        content: Text("Nhịp tim trung bình: ${averageBPM.toStringAsFixed(2)} BPM"),
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
    );
  }
}
