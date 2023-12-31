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
      await Future.delayed(Duration(seconds: 5)).then((value) {
        sharedPrefs.validTime = [time["start_time"], time["end_time"]];
      });
    }).catchError((err) {
      throw "Error";
    });
  }
}
