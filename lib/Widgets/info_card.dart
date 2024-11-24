// lib/widgets/info_card.dart

import 'package:flutter/material.dart';



class InfoCard extends StatelessWidget {
  final String title;
  final String data;
  final Color color;
  final String? subtitle;
  final VoidCallback? onTap;

  const InfoCard({
    Key? key,
    required this.title,
    required this.data,
    required this.color,
    this.subtitle,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector( // Sử dụng GestureDetector để nhận sự kiện nhấn
      onTap: onTap, // Gọi callback khi nhấn
      child: Container(
        height: 90,
        width: (MediaQuery.of(context).size.width / 2) - 20,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              title,
              style: TextStyle(fontSize: 17, color: Colors.white),
            ),
            const SizedBox(height: 5),
            Text(
              data,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: const Color.fromARGB(255, 14, 249, 65)),
            ),
            if (subtitle != null) ...[
              const SizedBox(height: 5),
              Text(
                subtitle!,
                style: TextStyle(color: Colors.white54),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
