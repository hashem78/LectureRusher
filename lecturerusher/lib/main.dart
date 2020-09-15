import 'package:flutter/material.dart';
import 'package:lecturerusher/constants.dart';
import 'widgets/rusher_tile.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:flutter/services.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:permission_handler/permission_handler.dart';

int s = 0;
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
                      onTap: () async {
                        // Request Microphone permission if needed
                        PermissionStatus statusMic =
                            await Permission.microphone.request();
                        PermissionStatus statusStorage =
                            await Permission.storage.request();
                        if (statusMic != PermissionStatus.granted)
                          throw RecordingPermissionException(
                              "Microphone permission not granted");
                        if (statusStorage != PermissionStatus.granted)
                          throw RecordingPermissionException(
                              "Microphone permission not granted");

                        var myRecorder =
                            await FlutterSoundRecorder().openAudioSession();
                        String path =
                            '/sdcard/${myRecorder.slotNo}-flutter_sound${ext[Codec.aacADTS.index]}';

                        print(path);
                        if (s % 2 == 0) {
                          print("started");
                          await myRecorder.startRecorder(
                            toFile: path,
                            codec: Codec.aacADTS,
                          );
                          s++;
                        } else {
                          print("ended");
                          await myRecorder.stopRecorder();
                          await myRecorder.closeAudioSession();
                          myRecorder = null;
                          s++;
                        }
                      },
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
