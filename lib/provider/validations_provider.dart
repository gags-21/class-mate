import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:image_upload/modals/student_modal.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

class ValidationsProvider extends ChangeNotifier {
  // for internet
  bool _isInternet = false;
  bool _isInTime = false;
  bool _isSubmittedSuccess = false;
  bool _isSubmittedFailed = false;
  bool _isDataLoading = false;

  // students
  List<StudentsList> _studentsList = [];

  bool get isInternet => _isInternet;
  bool get isInTime => _isInTime;
  List<StudentsList> get students => _studentsList;
  bool get isSubmittedSuccess => _isSubmittedSuccess;
  bool get isSubmittedFailed => _isSubmittedFailed;
  bool get dataLoading => _isDataLoading;

  void internetAvailability() {
    var result = InternetConnectionChecker().onStatusChange.listen((status) {
      switch (status) {
        case InternetConnectionStatus.connected:
          _isInternet = true;
          notifyListeners();
          break;
        case InternetConnectionStatus.disconnected:
          _isInternet = false;
          notifyListeners();
          break;
      }
    });
  }

  void loaderSwitcher(bool loading) {
    _isDataLoading = loading;
    notifyListeners();
  }

  bool validateTime(String startTime, String endTime) {
    DateTime now = DateTime.now();

    // functions to check time
    bool isAfterStartTime() {
      DateTime target = DateTime(
        now.year,
        now.month,
        now.day,
        int.parse(startTime.split(':')[0]),
        int.parse(startTime.split(':')[1]),
      );

      return now.isAfter(target);
    }

    bool isBeforeEndTime() {
      DateTime target = DateTime(
        now.year,
        now.month,
        now.day,
        int.parse(endTime.split(':')[0]),
        int.parse(endTime.split(':')[1]),
      );

      return now.isBefore(target);
    }

    _isInTime = isAfterStartTime() == isBeforeEndTime();
    notifyListeners();
    return _isInTime;
  }

  void setStudents(String students) {
    final studentListJson = json.decode(students);
    List studentsList = studentListJson["Students"];
    List<StudentsList> list = studentsList.map((stud) {
      return StudentsList(
          id: stud["id"],
          name:
              "${stud["first_name"]} ${stud["middle_name"]} ${stud["last_name"]}");
    }).toList();
    _studentsList = list;
    notifyListeners();
  }

  void submission(int submission) {
    if (submission == 1) {
      _isSubmittedFailed = false;
      _isSubmittedSuccess = true;
      notifyListeners();
    } else if (submission == 2) {
      _isSubmittedFailed = true;
      _isSubmittedSuccess = false;
      notifyListeners();
    } else if (submission == 0) {
      _isSubmittedFailed = false;
      _isSubmittedSuccess = false;
      notifyListeners();
    }
  }
}
