import 'package:flutter/material.dart';
import 'package:image_upload/provider/validations_provider.dart';
import 'package:image_upload/screens/home.dart';
import 'package:image_upload/screens/offline_history.dart';
import 'package:image_upload/util/api.dart';
import 'package:image_upload/util/shared_prefs.dart';
import 'package:image_upload/widgets/components.dart';
import 'package:provider/provider.dart';

class StudentSelectPage extends StatefulWidget {
  const StudentSelectPage({super.key});

  @override
  State<StudentSelectPage> createState() => _StudentSelectPageState();
}

class _StudentSelectPageState extends State<StudentSelectPage> {
  bool isDataLoading = true;
  final apis = UserApi();
  Object? selectedName;
  bool validName = true;
  int? id;

  // snacks
  var snack =
      const SnackBar(content: Text("Enter Correct name from suggestions"));

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final validationProvider =
          Provider.of<ValidationsProvider>(context, listen: false);
      validationProvider.internetAvailability();

      if (sharedPrefs.funcFeedback != "No Feedback") {
        apis.getValidateTime().then((value) {
          validationProvider.validateTime(
              sharedPrefs.validTime[0], sharedPrefs.validTime[1]);
          validationProvider.isInTime
              ? apis.getStudentList().then((value) {
                  validationProvider.setStudents(sharedPrefs.studentList);
                  setState(() {
                    isDataLoading = false;
                  });
                }).catchError((err) {
                  setState(() {
                    isDataLoading = false;
                  });
                })
              : null;
          setState(() {
            isDataLoading = false;
          });
        }).catchError((err) {
          validationProvider.validateTime(
              sharedPrefs.validTime[0], sharedPrefs.validTime[1]);
          validationProvider.setStudents(sharedPrefs.studentList);
          setState(() {
            isDataLoading = false;
          });
        });
      } else if (sharedPrefs.funcFeedback == "No Feedback") {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => HistoryScreen(),
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final validationProvider =
        Provider.of<ValidationsProvider>(context, listen: false);

    Future<void> updateValidTime() async {
      setState(() {
        isDataLoading = true;
      });
      if (validationProvider.isInternet) {
        apis.getValidateTime().then((value) {
          validationProvider.validateTime(
              sharedPrefs.validTime[0], sharedPrefs.validTime[1]);
          validationProvider.isInTime
              ? apis.getStudentList().then((value) {
                  validationProvider.setStudents(sharedPrefs.studentList);
                  setState(() {
                    isDataLoading = false;
                  });
                }).catchError((err) {
                  setState(() {
                    isDataLoading = false;
                  });
                })
              : null;
          setState(() {
            isDataLoading = false;
          });
        }).catchError((err) {
          validationProvider.validateTime(
              sharedPrefs.validTime[0], sharedPrefs.validTime[1]);
          validationProvider.setStudents(sharedPrefs.studentList);
          setState(() {
            isDataLoading = false;
          });
        });
      }
    }

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      drawer: const MainDrawer(),
      body: Center(
        child: Consumer<ValidationsProvider>(builder: (context, status, _) {
          return SingleChildScrollView(
            child: SizedBox(
              height: size.height * 0.85,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  // app name
                  Image.asset("assets/title_logo.png"),
                  const SizedBox(
                    height: 50,
                  ),

                  // timing
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        isDataLoading
                            ? "Fetching Attendance timing"
                            : sharedPrefs.validTime.isNotEmpty
                                ? "Today's Attendance Time  \n ${sharedPrefs.validTime[0]} to ${sharedPrefs.validTime[1]}"
                                : "No data",
                        textAlign: TextAlign.center,
                      ),
                      IconButton.outlined(
                        onPressed: () async {
                          await updateValidTime();
                        },
                        iconSize: 20,
                        icon: const Icon(
                          Icons.refresh,
                        ),
                        enableFeedback: true,
                        tooltip: "Refresh timings",
                      )
                    ],
                  ),
                  SizedBox(
                    height: size.height * .13,
                  ),

                  // Previous attendance status
                  sharedPrefs.funcFeedback == "No Feedback"
                      ? const Text(
                          "Please connect to internet to push previous attendance first!",
                          style: TextStyle(color: Colors.red),
                        )
                      : Text(
                          sharedPrefs.funcFeedback,
                          style: TextStyle(color: Colors.orange),
                        ),

                  sharedPrefs.funcFeedback == "Successful"
                      ? const Text(
                          "Previous attendance marked Successfully",
                          style: TextStyle(
                            color: Colors.green,
                          ),
                        )
                      : const SizedBox(),
                  const SizedBox(
                    height: 20,
                  ),

                  // alert
                  isDataLoading
                      ? const SizedBox()
                      : status.isInTime &&
                              sharedPrefs.funcFeedback != "No Feedback"
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
                    child: Autocomplete(
                      fieldViewBuilder: (context, textEditingController,
                          focusNode, onFieldSubmitted) {
                        textEditingController.addListener(() {
                          validName = status.students.any((s) {
                            if (s.name == textEditingController.text) {
                              id = s.id;
                              sharedPrefs.student = s;
                              return true;
                            }
                            return false;
                          });
                          setState(() {});
                        });
                        return Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0),
                            border: Border.all(
                                color: validName
                                    ? Colors.black38
                                    : Colors.redAccent),
                          ),
                          child: TextField(
                            controller: textEditingController,
                            focusNode: focusNode,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(
                                borderSide: BorderSide.none,
                              ),
                              contentPadding: EdgeInsets.all(10),
                              hintText: "Enter Student Name",
                            ),
                          ),
                        );
                      },
                      optionsBuilder: (TextEditingValue textEditingValue) {
                        if (textEditingValue.text == '') {
                          return const Iterable<String>.empty();
                        } else {
                          List<String> matches = <String>[];
                          matches.addAll(
                            status.students.map((e) => e.name),
                          );
                          matches.retainWhere((s) {
                            return s
                                .toLowerCase()
                                .contains(textEditingValue.text.toLowerCase());
                          });
                          return matches;
                        }
                      },
                      onSelected: (String selection) {},
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
                              color:
                                  status.isInternet ? Colors.green : Colors.red,
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
                              isDataLoading
                                  ? null
                                  : validName && id != null
                                      ? status.isInTime
                                          ? Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      const AttendancePage()),
                                            )
                                          : null
                                      : ScaffoldMessenger.of(context)
                                          .showSnackBar(snack);
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
              ),
            ),
          );
        }),
      ),
    );
  }
}
