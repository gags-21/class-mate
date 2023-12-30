import 'package:image_upload/constants/shared_prefs_keys.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefs {
  late final SharedPreferences _sharedPrefs;

  Future<void> init() async {
    _sharedPrefs = await SharedPreferences.getInstance();
  }

  String get lat => _sharedPrefs.getString(userLatKey) ?? "";
  String get long => _sharedPrefs.getString(userLatKey) ?? "";

  set userLocation(List<String> location) {
    print(location); 
    _sharedPrefs.setString(userLatKey, location[0]);
    _sharedPrefs.setString(userLongKey, location[1]);
  }
}

final sharedPrefs = SharedPrefs();
