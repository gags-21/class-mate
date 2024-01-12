import 'package:flutter/material.dart';
import 'package:image_upload/screens/about_screen.dart';
import 'package:image_upload/screens/login_screen.dart';
import 'package:image_upload/screens/offline_history.dart';
import 'package:image_upload/screens/policy_screen.dart';
import 'package:image_upload/util/shared_prefs.dart';

class MainDrawer extends StatelessWidget {
  const MainDrawer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Stack(
        children: [
      //   upper menu
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
                ListTile(
                  leading: const Icon(Icons.info_outline),
                  title: const Text("About"),
                  onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const AboutScreen())),
                ),
              ],
            ),
          ),

          //  lower
                   Align(
            alignment: Alignment.bottomCenter,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: OutlinedButton(
                    onPressed: () {
                      sharedPrefs.loggedIn = false;
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const LoginScreen(),
                        ),
                      );
                    },
                    style: ButtonStyle(
                      side: MaterialStateProperty.all(
                        const BorderSide(
                            color: Colors.red,
                            width: 1.0,
                            style: BorderStyle.solid),
                      ),
                      shape: MaterialStateProperty.all(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                      minimumSize: MaterialStateProperty.all(
                        const Size(300, 50),
                      ),
                    ),
                    child: const Text(
                      'Logout',
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Container(
                  width: double.infinity,
                  color: Colors.grey.shade200,
                  height: 40,
                  child: const Center(
                    child: Text("version 1.0"),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
