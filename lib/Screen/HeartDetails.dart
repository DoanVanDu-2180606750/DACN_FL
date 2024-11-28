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
  //  Widget chart = BPMChart(data);

  bool isBPMEnabled = false;
  Widget? dialog;

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
              ? dialog = HeartBPMDialog(
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
                    bpmValues.add(SensorValue(
                        value: value.toDouble(), time: DateTime.now()));
                  }),
                  // sampleDelay: 1000 ~/ 20,
                  // child: Container(
                  //   height: 50,
                  //   width: 100,
                  //   child: BPMChart(data),
                  // ),
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
              onPressed: () => setState(() {
                if (isBPMEnabled) {
                  isBPMEnabled = false;
                  // dialog.
                } else {
                  isBPMEnabled = true;
                }
              }),
            ),
          ),
        ],
      ),
    );
  }
}
