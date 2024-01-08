import 'package:flutter/material.dart';
import 'package:image_upload/provider/validations_provider.dart';
import 'package:image_upload/screens/student_selection.dart';
import 'package:image_upload/util/api.dart';
import 'package:image_upload/util/shared_prefs.dart';
import 'package:provider/provider.dart';
import 'package:workmanager/workmanager.dart';

@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((taskName, inputData) async {
    await sharedPrefs.init();
    if (taskName == "uploadImg") {
      // print("Uploading? ${sharedPrefs.studentId} ${sharedPrefs.lat} ${sharedPrefs.long}");
      await UserApi()
          .sendStudentInfo(
        id: sharedPrefs.studentId,
        lat: sharedPrefs.lat,
        long: sharedPrefs.long,
        selfie: sharedPrefs.selfie,
      )
          .then((value) {
        sharedPrefs.funcFeedback = "Successful";
        return true;
      }).catchError((err) {
        sharedPrefs.funcFeedback = "Error";
        return false;
      });
    }
    return true;
  });
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await sharedPrefs.init();
  await Workmanager().initialize(callbackDispatcher, isInDebugMode: true);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ValidationsProvider()),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueAccent),
          useMaterial3: true,
        ),
        home: const StudentSelectPage(),
      ),
    );
  }
}
