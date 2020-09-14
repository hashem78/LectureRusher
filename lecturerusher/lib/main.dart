import 'package:flutter/material.dart';
import 'package:lecturerusher/constants.dart';
import 'widgets/rusher_tile.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:flutter/services.dart';

void main() {
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      systemNavigationBarColor: Colors.transparent,
    ),
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => MainScreen(),
      },
    );
  }
}

class MainScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Lecture Rusher",
          style: TextStyle(color: Colors.black87, fontWeight: FontWeight.w300),
        ),
        elevation: 0,
        backgroundColor: kbackgroundColor,
      ),
      backgroundColor: kbackgroundColor,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    RusherTile(
                      text: "Upload",
                      icon: Icon(
                        Icons.upload_file,
                        color: Colors.amber,
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    RusherTile(
                      text: "Record",
                      icon: Icon(
                        Icons.circle,
                        color: Colors.red,
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  RusherTile(
                    text: "Sound tracks",
                    icon: Icon(
                      Icons.audiotrack,
                      color: Color(0xFF374257),
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  RusherTile(
                    text: "Live Transcribe",
                    icon: Icon(
                      MdiIcons.textToSpeech,
                      color: Colors.blue,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
