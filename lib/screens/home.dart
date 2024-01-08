import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_upload/provider/validations_provider.dart';
import 'package:image_upload/util/api.dart';
import 'package:image_upload/util/helper.dart';
import 'package:image_upload/util/shared_prefs.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:workmanager/workmanager.dart';

class AttendancePage extends StatefulWidget {
  const AttendancePage({super.key});

  @override
  State<AttendancePage> createState() => _AttendancePageState();
}

class _AttendancePageState extends State<AttendancePage> {
  bool stateLoading = true;

  File? image;
  Future pickImage() async {
    try {
      final image = await ImagePicker()
          .pickImage(
        source: ImageSource.camera,
        preferredCameraDevice: CameraDevice.front,
      )
          .then((value) {
        if (value != null) sharedPrefs.selfieFile = File(value.path);
        return value;
      });
      if (image == null) return;
      final imageTemp = File(image.path);
      setState(() => this.image = imageTemp);
    } on PlatformException catch (e) {
      var snack = const SnackBar(content: Text("Something Went Wrong"));
      ScaffoldMessenger.of(context).showSnackBar(snack);
    }
  }

  @override
  void initState() {
    super.initState();
    detectLocation().then((value) {
      //  storing location
      sharedPrefs.userLocation = [
        value.latitude.toString(),
        value.longitude.toString()
      ];
      setState(() {
        stateLoading = false;
      });
    }).catchError((error) {
      switch (error) {
        case "Location services are disabled.":
          {
            var snack = const SnackBar(
                content: Text("Please enable location services to proceed."));
            ScaffoldMessenger.of(context).showSnackBar(snack);
            Navigator.pop(context);
          }

        case "Location permissions are permanently denied, we cannot request permissions.":
          {
            var snack = const SnackBar(
                content: Text(
                    "Location permissions are permanently denied, please give permissions to proceed."));
            ScaffoldMessenger.of(context).showSnackBar(snack);
            Navigator.pop(context);
          }

        case "Location permissions are denied":
          {
            var snack = const SnackBar(
                content: Text("Please give location permission to proceed."));
            ScaffoldMessenger.of(context).showSnackBar(snack);
            Navigator.pop(context);
          }
      }
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  Future<void> backgroundTask() async {
    await Workmanager().registerOneOffTask("imageUpload", "uploadImg",
        constraints: Constraints(networkType: NetworkType.connected));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF4586f5),
        foregroundColor: Colors.white,
        title: const Text("Mark Attendance"),
      ),
      body: Center(
        child: stateLoading
            ? const CircularProgressIndicator()
            : Consumer<ValidationsProvider>(builder: (context, status, _) {
                status.isInternet;
                return Stack(
                  alignment: Alignment.center,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        const SizedBox(
                          height: 20,
                        ),

                        // upload img
                        image == null
                            ? GestureDetector(
                                onTap: () {
                                  pickImage();
                                },
                                child: Container(
                                  height: 300,
                                  width: 300,
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: Colors.grey.shade200,
                                    borderRadius: const BorderRadius.all(
                                      Radius.circular(10),
                                    ),
                                  ),
                                  child: const Center(
                                    child: Icon(
                                      Icons.camera_front_outlined,
                                      color: Colors.grey,
                                      size: 50,
                                    ),
                                  ),
                                ),
                              )
                            : SizedBox(
                                height: 300,
                                width: 300,
                                child: Image.file(image!.absolute),
                              ),

                        // Upload btn with internet indicator
                        Padding(
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
                                  onPressed: () {
                                    if (image != null) {
                                      sharedPrefs.funcFeedback = "No Feedback";
                                      backgroundTask().then((value) {
                                        if (status.isInternet) {
                                          var snack = const SnackBar(
                                              content:
                                                  Text("Attendance Pushed!!"));
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(snack);
                                          status.submission(1);
                                          Future.delayed(
                                              const Duration(seconds: 3), () {
                                            exit(0);
                                          });
                                        } else {
                                          var snack = const SnackBar(
                                              content: Text(
                                                  "Attendance will be pushed once you connect to internet."));
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(snack);
                                          status.submission(2);
                                          Future.delayed(
                                              const Duration(seconds: 3), () {
                                            exit(0);
                                          });
                                        }
                                      });
                                    } else {
                                      var snack = const SnackBar(
                                          content: Text(
                                              "Please capture image first"));
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(snack);
                                    }
                                  },
                                  style: ButtonStyle(
                                    backgroundColor: image == null
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
                                    'Mark Attendance',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        )
                      ],
                    ),
                    status.isSubmittedSuccess
                        ? Container(
                            color: Colors.black.withAlpha(100),
                            height: double.infinity,
                            width: double.infinity,
                            child:
                                Lottie.asset("assets/success_animation.json"),
                          )
                        : const SizedBox(),
                    status.isSubmittedFailed
                        ? Container(
                            color: Colors.black.withAlpha(100),
                            height: double.infinity,
                            width: double.infinity,
                            child: Lottie.asset("assets/error_animation.json"),
                          )
                        : const SizedBox(),

                        // exit button
                  ],
                );
              }),
      ),
    );
  }
}
