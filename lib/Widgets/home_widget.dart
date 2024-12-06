import 'package:flutter/material.dart';

class HomeWidget {
  // A method to build a reusable info card
  static Widget buildInfoBodyCard(String title, String data, {Color? color}) {
    return Card(
      color: color ?? const Color.fromARGB(255, 52, 198, 223),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 140,
                  height: 65,
                  child: Column(
                    children: [
                      Center(
                        child: Text(
                          title,
                          style: const TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Center(
                        child: Text(
                          data,
                          style: const TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // A method to build a reusable steps card
  static Widget buildStepsCards(String title, String data, {Color? color}) {
  return Container(
    width: 175,
    decoration: BoxDecoration(
      color: const Color.fromARGB(255, 28, 206, 61), // Màu nền cho toàn bộ khối
      borderRadius: BorderRadius.circular(12.0), // Bo góc toàn bộ khối
    ),
    padding: const EdgeInsets.all(16.0), // Khoảng cách padding bên trong
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Text(
                title, // Tiêu đề của thẻ
                style: const TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 10),
            Center(
              child: Text(
                data, // Dữ liệu hiển thị trong thẻ
                style: const TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ],
    ),
  );
}

}
