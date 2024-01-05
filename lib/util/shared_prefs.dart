import 'package:image_upload/constants/shared_prefs_keys.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefs {
  late final SharedPreferences _sharedPrefs;

  Future<void> init() async {
    _sharedPrefs = await SharedPreferences.getInstance();
  }

  String get studentList => _sharedPrefs.getString(studentListKey) ?? "";
  String get lat => _sharedPrefs.getString(userLatKey) ?? "";
  String get long => _sharedPrefs.getString(userLongKey) ?? "";
  List<String> get validTime => _sharedPrefs.getStringList(validTimeKey) ?? [];
  String get studentId => _sharedPrefs.getString(studentIdKey) ?? "";
  String get funcFeedback =>
      _sharedPrefs.getString(funcFeedbackKey) ?? "No Feedback";

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
}

final sharedPrefs = SharedPrefs();
