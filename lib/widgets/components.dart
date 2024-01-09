import 'package:flutter/material.dart';
import 'package:image_upload/screens/offline_history.dart';
import 'package:image_upload/screens/policy_screen.dart';

class MainDrawer extends StatelessWidget {
  const MainDrawer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Padding(
        padding: const EdgeInsets.only(top: 20.0, left: 10.0, bottom: 20.0),
        child: ListView(
          children: [
            ListTile(
              title: const Text("Offline History"),
              onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => HistoryScreen())),
            ),
              ListTile(
              title: const Text("Privacy Policy"),
              onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const PolicyScreen())),
            ),
          ],
        ),
      ),
    );
  }
}
