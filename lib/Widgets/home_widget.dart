import 'package:flutter/material.dart';

class HeadHome extends StatelessWidget {
  final String formattedDate;

  const HeadHome({
    super.key,
    required this.formattedDate,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          formattedDate,
          style: const TextStyle(
            fontSize: 18,
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}

//Body home page
class HomeWidget {
  // A method to build a reusable info card
  static Widget buildInfoCard(String title, String data, {Color? color}) {
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
                  )
                ],
              ),
            ],
          ),
        ),
    );
  }
}
