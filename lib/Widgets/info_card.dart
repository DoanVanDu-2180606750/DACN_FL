// lib/widgets/info_card.dart

import 'package:flutter/material.dart';

final List<Map<String, String>> infoCards = [
  {'title': 'Weight', 'data': '71 kg', 'color': 'green'},
  {'title': 'Height', 'data': '171 cm', 'color': 'green'},
  {'title': 'Steps', 'data': '867/6000', 'color': 'green', 'subtitle': '14%'},
  {'title': 'Calories burnt', 'data': '256', 'color': 'red'},
  {'title': 'Heart Rate', 'data': '89 BPM', 'color': 'green'},
];


class InfoCard extends StatelessWidget {
  final String title;
  final String data;
  final Color color;
  final String? subtitle;

  const InfoCard({
    Key? key,
    required this.title,
    required this.data,
    required this.color,
    this.subtitle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.all(10),
      height: 80,
      width: 160,
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(color: Colors.white, fontSize: 14),
          ),
          const Spacer(),
          Row(
            children: [
              Text(
                data,
                style: TextStyle(
                  color: color,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (subtitle != null)
                ...[
                  const SizedBox(width: 5), // Khoảng cách nếu có phụ đề
                  Text(
                    subtitle!,
                    style: const TextStyle(color: Colors.white, fontSize: 14),
                  ),
                ],
            ],
          ),
        ],
      ),
    );
  }
}
