import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

class ValidationsProvider extends ChangeNotifier {
  // for internet
  bool _isInternet = false;
  bool _isInTime = false;

  bool get isInternet => _isInternet;
  bool get isInTime => _isInTime;

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

  void validateTime(String startTime, String endTime) {
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
  }
}
