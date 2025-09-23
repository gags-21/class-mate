import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:image_upload/api_key.dart';
import 'package:image_upload/modals/student_modal.dart';
import 'package:image_upload/util/shared_prefs.dart';

class UserApi {
  // login
  Future<bool> loginWithEmail(String email, String pass) async {
    var uri = Uri.parse("https://www.bcaeducation.com/lms/api/student/login");
    try {
      var response = await http.post(uri, body: {
        "passkey": api_key,
        "email": email,
        "password": pass,
      });
      final studentData = jsonDecode(response.body);
      if (response.statusCode == 200) {
        sharedPrefs.student = StudentsList(
            id: studentData["student_id"], name: studentData["full_name"]);
        sharedPrefs.loggedIn = true;
        return true;
      } else {
        sharedPrefs.loggedIn = false;
        throw studentData["message"];
      }
    } on SocketException catch (e) {
      // log('error while login - $e');
      sharedPrefs.funcFeedback = "Failed! Please try again later";
      throw sharedPrefs.funcFeedback;
    } catch (err) {
      rethrow;
    }
  }

  // attendance timing
  Future<void> getValidateTime() async {
    var uri = Uri.parse("https://www.bcaeducation.com/lms/api/attendance-time");
    await http.post(uri, body: {
      "passkey": api_key,
    }).then((value) async {
      final time = json.decode(value.body)["AttendanceTime"];
      sharedPrefs.validTime = [time["start_time"], time["end_time"]];
      // sharedPrefs.validTime = ["10:00:00", "23:30:00"];
    }).catchError((err) {
      // log('Error while fetching data - $err');
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
    required String timestamp,
    required String selfie,
  }) async {
    Map<String, String> info = {
      "passkey": api_key,
      "student_id": id,
      "latitude": lat,
      "longitude": long,
      "attendance_timestamp": timestamp,
      "file": selfie,
    };
    var uri = Uri.parse(
        "https://www.bcaeducation.com/lms/api/student/attendance/store");
    try {
      var response = await http.post(
        uri,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(info),
      );
      if (response.statusCode == 200) {
        sharedPrefs.funcFeedback = "Successful";
        return response.body;
      } else {
        // log("Error coming ? ${response.body}");
        sharedPrefs.funcFeedback = json.decode(response.body)["message"];
        throw json.decode(response.body)["message"];
      }
    } on SocketException catch (e) {
      // log('error- $e');
      sharedPrefs.funcFeedback = "Failed! Please try again later";
      throw sharedPrefs.funcFeedback;
    } catch (e) {
      // log('error while pushing att. - $e');
      sharedPrefs.funcFeedback = "Failed! Please try again later";
      throw sharedPrefs.funcFeedback;
    }
  }
}
