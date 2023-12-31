import 'package:flutter/material.dart';
import 'package:image_upload/provider/validations_provider.dart';
import 'package:image_upload/screens/home.dart';
import 'package:image_upload/util/api.dart';
import 'package:image_upload/util/shared_prefs.dart';
import 'package:provider/provider.dart';

class StudentSelectPage extends StatefulWidget {
  const StudentSelectPage({super.key});

  @override
  State<StudentSelectPage> createState() => _StudentSelectPageState();
}

class _StudentSelectPageState extends State<StudentSelectPage> {
  bool isDataLoading = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final validationProvider =
          Provider.of<ValidationsProvider>(context, listen: false);
      validationProvider.internetAvailability();

      UserApi().getValidateTime().then((value) {
        validationProvider.validateTime(
            sharedPrefs.validTime[0], sharedPrefs.validTime[1]);
        setState(() {
          isDataLoading = false;
        });
      }).catchError((err) {
        setState(() {
          isDataLoading = false;
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Consumer<ValidationsProvider>(builder: (context, status, _) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                isDataLoading
                    ? "Fetching Attendance timing"
                    : sharedPrefs.validTime.isNotEmpty
                        ? "Today's Attendance Time  \n ${sharedPrefs.validTime[0]} to ${sharedPrefs.validTime[1]}"
                        : "No data",
                textAlign: TextAlign.center,
              ),
              const Spacer(),
              isDataLoading
                  ? const SizedBox()
                  : status.isInTime
                      ? const Text(
                          "You can mark attendace!",
                          style: TextStyle(color: Colors.green),
                        )
                      : sharedPrefs.validTime.isNotEmpty
                          ? const Text(
                              "Sorry, Please mark attendace in given time.",
                              style: TextStyle(color: Colors.red),
                            )
                          : const Text(
                              "Please connect to internet",
                              style: TextStyle(
                                color: Colors.orange,
                              ),
                            ),
              const SizedBox(
                height: 20,
              ),
              // student search
              SizedBox(
                height: 50,
                width: 300,
                child: TextField(
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.all(10),
                    hintText: "Enter Student Name",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                ),
              ),

              // next btn with internet indicator
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
                          color: status.isInternet ? Colors.green : Colors.red,
                          borderRadius: const BorderRadius.only(
                            bottomLeft: Radius.circular(
                                10.0), // Adjust the radius as needed
                            bottomRight: Radius.circular(
                                10.0), // Adjust the radius as needed
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
                          isDataLoading
                              ? null
                              : status.isInTime
                                  ? Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const AttendancePage()),
                                    )
                                  : null;
                        },
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(
                            isDataLoading
                                ? Colors.grey.shade600
                                : status.isInTime
                                    ? Colors.blueAccent
                                    : Colors.red,
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
                          'NEXT',
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
          );
        }),
      ),
    );
  }
}
