import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // プラットフォームチャネルの設定
  static const platform = MethodChannel('com.example.skyway_flutter/channel');

  // Skywayを開始するためのメソッド
  Future<void> startSkyway() async {
    try {
      final String result = await platform.invokeMethod('startSkyway');
      print(result);
    } on PlatformException catch (e) {
      print("Failed to start Skyway: '${e.message}'.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Skyway Flutter Demo'),
        ),
        body: Center(
          child: ElevatedButton(
            onPressed: startSkyway,
            child: Text('Start Skyway Video Call'),
          ),
        ),
      ),
    );
  }
}
