import 'package:flutter/material.dart';
import 'package:lecturerusher/widgets/rusher_tile.dart';
import 'package:lecturerusher/constants.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';
import 'package:lecturerusher/models/recorder_model.dart';

class MainScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: krusherAppBar,
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
                      onTap: () =>
                          Navigator.of(context).pushNamed("/uploadScreen"),
                      icon: Icon(
                        Icons.upload_file,
                        color: Colors.amber,
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Consumer<RecorderModel>(
                      builder: (context, newW, _) => RusherTile(
                        text: newW.recorderTitle,
                        onTap: () {
                          newW.changeState(0);
                          print("started");
                        },
                        onDobuleTap: () {
                          newW.changeState(1);
                          print("paused");
                        },
                        onLongPress: () {
                          newW.changeState(2);
                          print("stopped");
                        },
                        icon: Icon(
                          Icons.circle,
                          color: Colors.red,
                        ),
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
                    onTap: () {},
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
