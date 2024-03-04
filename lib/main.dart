import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  static const platform = MethodChannel('com.example.skyway_flutter/skywayChannel');

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('SkyWay Flutter Demo'),
        ),
        body: Builder( // Builderを使用して新しいBuildContextを生成
          builder: (BuildContext context) { // このBuildContextはElevatedButtonのonPressedで利用される
            return Center(
              child: ElevatedButton(
                onPressed: () async {
                  try {
                    final String result = await platform.invokeMethod('startSkywaySession');
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text(result),
                    ));
                  } on PlatformException catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text("Failed to start Skyway session: ${e.message}"),
                    ));
                  }
                },
                child: Text('Start Skyway Session'),
              ),
            );
          },
        ),
      ),
    );
  }
}
