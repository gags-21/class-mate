import 'package:flutter/material.dart';
import 'package:image_upload/api_calls.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workmanager/workmanager.dart';

@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((taskName, inputData) async {
    final _sharedPreference = await SharedPreferences.getInstance();
    final data = await  UserApi().getData();
    _sharedPreference.setString('initial', 'Done !');
    return Future.value(true);
  });
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Workmanager().initialize(callbackDispatcher, isInDebugMode: true);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String? title;
  Future<String?> getString() async {
    UserApi().getData();
    final _sharedPreference = await SharedPreferences.getInstance();
    title = _sharedPreference.getString("apiJson") ?? "Nothing";
    setState(() {});
    return _sharedPreference.getString("apiJson") ?? "Nothing";
  }

  @override
  void initState() {
    super.initState();
    // Workmanager().registerPeriodicTask("checkNet", "uploadImg",
    //     frequency: const Duration(seconds: 5),
    //     constraints: Constraints(networkType: NetworkType.connected));
    getString();
  }

  void backgroundTask() {
    Workmanager().registerOneOffTask("imageUpload", "uploadImg",
        constraints: Constraints(networkType: NetworkType.connected));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              title.toString(),
            ),
            Text(
              'Data fetched from background',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: backgroundTask,
        tooltip: 'Increment',
        child: const Icon(Icons.run_circle),
      ),
    );
  }
}
