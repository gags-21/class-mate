import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("About Application"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            rowEntry("Application Name", "ClassMate - Student Attendance App"),
            rowEntry("Application Version", "1.1.0"),
            rowEntry("Deployment Date", "10 Jan 2024"),
          ],
        ),
      ),
    );
  }

  Padding rowEntry(String title , String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15.0),
      child: Row(
        children: [
          SizedBox(
            width: 170,
            child: Text(
             title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Flexible(
            child: Text(
             value,
              style: const TextStyle(
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
