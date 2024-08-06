import 'dart:convert';
import 'dart:io';

import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_upload/constants/shared_prefs_keys.dart';
import 'package:image_upload/modals/student_modal.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefs {
  late final SharedPreferences _sharedPrefs;

  Future<void> init() async {
    _sharedPrefs = await SharedPreferences.getInstance();
  }

  // authentication
  bool get loggedIn => _sharedPrefs.getBool(loggedInKey) ?? false;

  String get studentList => _sharedPrefs.getString(studentListKey) ?? "";
  List<String> get validTime => _sharedPrefs.getStringList(validTimeKey) ?? [];
  String get funcFeedback => _sharedPrefs.getString(funcFeedbackKey) ?? "New";

  //  Student info
  String get studentName => _sharedPrefs.getString(studentNameKey) ?? "";
  String get studentId => _sharedPrefs.getString(studentIdKey) ?? "";
  String get lat => _sharedPrefs.getString(userLatKey) ?? "";
  String get long => _sharedPrefs.getString(userLongKey) ?? "";
  String get timestamp => _sharedPrefs.getString(timestampKey) ?? "";
  String get selfie => _sharedPrefs.getString(base64SelfieKey) ?? "";

  set loggedIn(bool isLoggedIn) {
    _sharedPrefs.setBool(loggedInKey, isLoggedIn);
  }

  set userLocation(List<String> location) {
    _sharedPrefs.setString(userLatKey, location[0]);
    _sharedPrefs.setString(userLongKey, location[1]);
  }

  set timestamp(String timestamp) {
    _sharedPrefs.setString(timestampKey, timestamp);
  }

  set validTime(List<String> time) {
    _sharedPrefs.setStringList(validTimeKey, time);
  }

  set studentList(String students) {
    _sharedPrefs.setString(studentListKey, students);
  }

  set student(StudentsList student) {
    _sharedPrefs.setString(studentIdKey, student.id.toString());
    _sharedPrefs.setString(studentNameKey, student.name);
  }

  set funcFeedback(String feedback) {
    _sharedPrefs.setString(funcFeedbackKey, feedback);
  }

  void selfieFile(File selfieFile) async {
    // compress file
    XFile? compressedXFile = await FlutterImageCompress.compressAndGetFile(
        selfieFile.absolute.path, "${selfieFile.absolute.path}compressed.jpg",
        quality: 30);
    if (compressedXFile == null) {
      throw Exception("Image compression failed");
    }
    File compressed = File(compressedXFile.path);

    List<int> imageBytes = compressed.readAsBytesSync();
    String base64Selfie = base64Encode(imageBytes);
    _sharedPrefs.setString(base64SelfieKey, base64Selfie);
  }
}

final sharedPrefs = SharedPrefs();
