import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class UserApi {
  Future<void> getData() async {
    final sharedPreference = await SharedPreferences.getInstance();
    var uri = Uri.parse("https://jsonplaceholder.typicode.com/todos/1");
    var response = await http.get(uri);
    sharedPreference.setString("apiJson", response.body.toString());
  }
}
