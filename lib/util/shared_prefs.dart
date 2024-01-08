import 'dart:convert';
import 'dart:io';

import 'package:image_upload/constants/shared_prefs_keys.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefs {
  late final SharedPreferences _sharedPrefs;

  Future<void> init() async {
    _sharedPrefs = await SharedPreferences.getInstance();
  }

  String get studentList => _sharedPrefs.getString(studentListKey) ?? "";
  List<String> get validTime => _sharedPrefs.getStringList(validTimeKey) ?? [];
  String get funcFeedback =>
      _sharedPrefs.getString(funcFeedbackKey) ?? "New";

  //  Student info
  String get studentId => _sharedPrefs.getString(studentIdKey) ?? "";
  String get lat => _sharedPrefs.getString(userLatKey) ?? "";
  String get long => _sharedPrefs.getString(userLongKey) ?? "";
  String get selfie => _sharedPrefs.getString(base64SelfieKey) ?? "";

  set userLocation(List<String> location) {
    _sharedPrefs.setString(userLatKey, location[0]);
    _sharedPrefs.setString(userLongKey, location[1]);
  }

  set validTime(List<String> time) {
    _sharedPrefs.setStringList(validTimeKey, time);
  }

  set studentList(String students) {
    _sharedPrefs.setString(studentListKey, students);
  }

  set studentId(String id) {
    _sharedPrefs.setString(studentIdKey, id);
  }

  set funcFeedback(String feedback) {
    _sharedPrefs.setString(funcFeedbackKey, feedback);
  }

  set selfieFile(File selfieFile) {
    List<int> imageBytes = selfieFile.readAsBytesSync();
    String base64Selfie = base64Encode(imageBytes);
    _sharedPrefs.setString(base64SelfieKey, base64Selfie);
  }
}

final sharedPrefs = SharedPrefs();
