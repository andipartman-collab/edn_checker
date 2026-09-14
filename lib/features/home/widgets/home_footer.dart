import 'package:flutter/material.dart';

class HomeFooter extends StatelessWidget {
  const HomeFooter({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [

        Divider(height: 30),

        Text(
          "Version 1.0",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.grey,
          ),
        ),

        SizedBox(height: 4),

        Text(
          "EDN Scanner",
          style: TextStyle(
            color: Colors.grey,
            fontSize: 12,
          ),
        ),

        SizedBox(height: 10),
      ],
    );
  }
}