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
      child: Stack(
        children: [
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              width: double.infinity,
              color: Colors.grey.shade200,
              height: 40,
              child: const Center(
                child: Text("version 1.0"),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 20.0, left: 10.0, bottom: 20.0),
            child: ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                      top: 20.0, left: 15.0, bottom: 20.0),
                  child: Align(
                      alignment: Alignment.centerLeft,
                      child: Image.asset(
                        "assets/logo.png",
                        height: 30,
                      )),
                ),
                ListTile(
                  leading: const Icon(Icons.history),
                  title: const Text("Offline History"),
                  onTap: () => Navigator.push(context,
                      MaterialPageRoute(builder: (context) => HistoryScreen())),
                ),
                ListTile(
                  leading: const Icon(Icons.privacy_tip_outlined),
                  title: const Text("Privacy Policy"),
                  onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const PolicyScreen())),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
