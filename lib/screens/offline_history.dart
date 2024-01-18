import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_upload/provider/validations_provider.dart';
import 'package:image_upload/util/api.dart';
import 'package:image_upload/util/shared_prefs.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

class HistoryScreen extends StatelessWidget {
  HistoryScreen({super.key});

  DateTime? currentBackPressTime;
  String feedback = "";

  @override
  Widget build(BuildContext context) {
    print("Current feedback , ${sharedPrefs.funcFeedback}");
    return PopScope(
      canPop: sharedPrefs.funcFeedback == "No Feedback" ||
              sharedPrefs.funcFeedback == "Sending"
          ? false
          : true,
      onPopInvoked: (didPop) {
        DateTime now = DateTime.now();
        if (sharedPrefs.funcFeedback == "No Feedback" ||
            sharedPrefs.funcFeedback == "Sending") {
          if (currentBackPressTime == null ||
              now.difference(currentBackPressTime ?? DateTime.now()) >
                  const Duration(seconds: 2)) {
            currentBackPressTime = now;
            var snack = const SnackBar(
                content: Text("Press Backbutton again to exit app"));
            ScaffoldMessenger.of(context).showSnackBar(snack);
            return;
          }
          exit(0);
        }
      },
      child: Scaffold(
        appBar: sharedPrefs.funcFeedback == "No Feedback" ||
                sharedPrefs.funcFeedback == "Sending"
            ? AppBar(
                leading: const SizedBox(),
                title: const Text("Offline History"),
              )
            : AppBar(
                title: const Text("Offline History"),
              ),
        body: Center(
          child: sharedPrefs.funcFeedback == "No Feedback" ||
                  sharedPrefs.funcFeedback == "Sending"
              ? Consumer<ValidationsProvider>(builder: (context, status, _) {
                  return Stack(
                    alignment: Alignment.center,
                    children: [
                      Align(
                        alignment: Alignment.topCenter,
                        child: Padding(
                          padding: const EdgeInsets.all(25.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(
                                height: 20,
                              ),
                              const Center(
                                child: Text(
                                  "First sync this attendance",
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.red,
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 30,
                              ),

                              // student info preview
                              Text(
                                "Name: ${sharedPrefs.studentName} \n\nLocation: ${sharedPrefs.lat}, ${sharedPrefs.long} \n\nIn Time: True",
                                style: const TextStyle(fontSize: 15),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              // feedbacks
                              feedback == ""
                                  ? const SizedBox()
                                  : Text(
                                      "Status - $feedback",
                                      style: const TextStyle(fontSize: 15),
                                    ),
                            ],
                          ),
                        ),
                      ),
                      // Upload btn with internet indicator
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Padding(
                          padding: const EdgeInsets.all(30),
                          child: Stack(
                            fit: StackFit.loose,
                            alignment: Alignment.topCenter,
                            children: [
                              Positioned(
                                bottom: 0,
                                child: Container(
                                  width: 280,
                                  height: 30,
                                  padding: const EdgeInsets.only(top: 10),
                                  decoration: BoxDecoration(
                                    color: status.isInternet
                                        ? Colors.green
                                        : Colors.red,
                                    borderRadius: const BorderRadius.only(
                                      bottomLeft: Radius.circular(10.0),
                                      bottomRight: Radius.circular(10.0),
                                    ),
                                  ),
                                  child: Center(
                                    child: Text(
                                      status.isInternet
                                          ? "Connected to network"
                                          : "Disconnected from network",
                                      style: const TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(bottom: 20),
                                child: FilledButton.tonal(
                                  onPressed: status.isInternet
                                      ? sharedPrefs.funcFeedback == "Sending"
                                          ? () async {
                                              feedback =
                                                  "This attendance may have already pushed, please restart your app in few minutes";
                                              (context as Element)
                                                  .markNeedsBuild();
                                              await UserApi()
                                                  .sendStudentInfo(
                                                id: sharedPrefs.studentId,
                                                lat: sharedPrefs.lat,
                                                long: sharedPrefs.long,
                                                selfie: sharedPrefs.selfie,
                                              )
                                                  .then((value) {
                                                sharedPrefs.funcFeedback =
                                                    "Successful";
                                              }).catchError((err) {
                                                sharedPrefs.funcFeedback = err;
                                              });
                                            }
                                          : () async {
                                              sharedPrefs.funcFeedback =
                                                  "No Feedback";

                                              status.loaderSwitcher(true);
                                              await UserApi()
                                                  .sendStudentInfo(
                                                id: sharedPrefs.studentId,
                                                lat: sharedPrefs.lat,
                                                long: sharedPrefs.long,
                                                selfie: sharedPrefs.selfie,
                                              )
                                                  .then((value) {
                                                var snack = const SnackBar(
                                                    content: Text(
                                                        "Attendance Pushed!!"));
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(snack);
                                                status.submission(1);
                                                status.loaderSwitcher(false);
                                              }).catchError((e) {
                                                var snack = SnackBar(
                                                    content:
                                                        Text(e.toString()));
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(snack);
                                                status.submission(2);
                                                status.loaderSwitcher(false);
                                              });
                                            }
                                      : () {},
                                  style: ButtonStyle(
                                    backgroundColor: !(status.isInternet)
                                        ? MaterialStateProperty.all(Colors.grey)
                                        : MaterialStateProperty.all(
                                            Colors.blueAccent),
                                    shape: MaterialStateProperty.all(
                                      RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                      ),
                                    ),
                                    minimumSize: MaterialStateProperty.all(
                                      const Size(300, 50),
                                    ),
                                  ),
                                  child: const Text(
                                    "Sync Attendance",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      status.dataLoading
                          ? Container(
                              color: Colors.black.withAlpha(100),
                              height: double.infinity,
                              width: double.infinity,
                              child: const Center(
                                  child: CircularProgressIndicator()),
                            )
                          : const SizedBox(),
                      status.isSubmittedSuccess
                          ? Container(
                              color: Colors.black.withAlpha(100),
                              height: double.infinity,
                              width: double.infinity,
                              child: Lottie.asset(
                                "assets/success_animation.json",
                                repeat: false,
                              ),
                            )
                          : const SizedBox(),
                      status.isSubmittedFailed
                          ? Container(
                              color: Colors.black.withAlpha(100),
                              height: double.infinity,
                              width: double.infinity,
                              child: Lottie.asset(
                                "assets/error_animation.json",
                                repeat: false,
                              ),
                            )
                          : const SizedBox(),
                      status.isSubmittedSuccess || status.isSubmittedFailed
                          ? Align(
                              alignment: Alignment.bottomCenter,
                              child: Padding(
                                padding: const EdgeInsets.only(bottom: 50),
                                child: FilledButton.tonal(
                                  onPressed: () {
                                    status.submission(0);
                                    Navigator.pop(context);
                                  },
                                  style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.all(
                                        Colors.blueAccent),
                                    shape: MaterialStateProperty.all(
                                      RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                      ),
                                    ),
                                    minimumSize: MaterialStateProperty.all(
                                      const Size(300, 50),
                                    ),
                                  ),
                                  child: const Text(
                                    'Go To Home',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),
                            )
                          : const SizedBox(),
                    ],
                  );
                })
              : const Text("No Previous History remaining"),
        ),
      ),
    );
  }
}
