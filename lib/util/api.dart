import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:image_upload/api_key.dart';
import 'package:image_upload/util/shared_prefs.dart';

class UserApi {
  // attendance timing
  Future<void> getValidateTime() async {
    var uri = Uri.parse("https://www.bcaeducation.com/lms/api/attendance-time");
    var response = await http.post(uri, body: {
      "passkey": api_key,
    }).then((value) async {
      final time = json.decode(value.body)["AttendanceTime"];
       sharedPrefs.validTime = [time["start_time"], time["end_time"]];
      // sharedPrefs.validTime = ["21:00:00", "23:30:00"];
    }).catchError((err) {
      throw "Error";
    });
  }

  // students list
  Future<void> getStudentList() async {
    var uri = Uri.parse("https://www.bcaeducation.com/lms/api/students");
    var response = await http.post(uri, body: {
      "passkey": api_key,
    }).then((value) async {
      final students = value.body;
      sharedPrefs.studentList = students;
    }).catchError((err) {
      throw "Error";
    });
  }

  // post student details
  Future<String> sendStudentInfo({
    required String id,
    required String lat,
    required String long,
    required String selfie,
  }) async {
    Map info = {
      "passkey": api_key,
      "student_id": id,
      "latitude": lat,
      "longitude": long,
      "file": selfie,
    };
    var uri = Uri.parse(
        "https://www.bcaeducation.com/lms/api/student/attendance/store");
    try {
      var response = await http.post(uri, body: info);
      if (response.statusCode == 200) {
        return response.body;
      } else {
        throw Exception(response.body);
      }
    } catch (e) {
      throw "error - $e";
    }
  }
}
