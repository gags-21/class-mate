import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

class ValidationsProvider extends ChangeNotifier {
  // for internet
  bool _isInternet = false;

  bool get isInternet => _isInternet;

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
}
