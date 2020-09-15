import 'package:flutter/material.dart';
import 'package:lecturerusher/constants.dart';
import 'package:lecturerusher/screens/upload_screen.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';
import 'package:lecturerusher/models/recorder_model.dart';
import 'package:lecturerusher/screens/main_screen.dart';

void main() {
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
      statusBarColor: kbackgroundColor,
      systemNavigationBarColor: kbackgroundColor,
      statusBarBrightness: Brightness.dark,
      systemNavigationBarDividerColor: Colors.blue,
    ),
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => RecorderModel(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        initialRoute: '/',
        routes: {
          '/': (context) => MainScreen(),
          '/uploadScreen': (context) => UploadScreen(),
        },
      ),
    );
  }
}
