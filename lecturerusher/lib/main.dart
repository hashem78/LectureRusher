import 'package:flutter/material.dart';
import 'package:lecturerusher/constants.dart';
import 'package:lecturerusher/screens/transcribe_screen.dart';
import 'package:lecturerusher/screens/upload_screen.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';
import 'package:lecturerusher/models/recorder_model.dart';
import 'package:lecturerusher/screens/main_screen.dart';
import 'package:lecturerusher/models/rusher_ucheckbox_model.dart';
import 'package:lecturerusher/models/transcribe_model.dart';

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
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<RecorderModel>(
          create: (context) => RecorderModel(),
        ),
        ChangeNotifierProvider<RusherUploadCheckBoxesModel>(
          create: (context) => RusherUploadCheckBoxesModel(),
        ),
        ChangeNotifierProvider<TranScribeModel>(
          create: (context) => TranScribeModel(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        initialRoute: '/',
        routes: {
          '/': (context) => MainScreen(),
          '/uploadScreen': (context) => UploadScreen(),
          '/transcribeScreen': (context) => TransScribeScreen(),
        },
      ),
    );
  }
}
