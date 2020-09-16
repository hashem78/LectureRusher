import 'package:flutter/material.dart';
import 'package:lecturerusher/widgets/rusher_tile.dart';
import 'package:lecturerusher/constants.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';
import 'package:lecturerusher/models/recorder_model.dart';
import 'package:file_picker/file_picker.dart';

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
              Image(image: AssetImage("images/teck.png")),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    RusherTile(
                      text: "Upload Recording",
                      onTap: () async {
                        await Navigator.of(context).pushNamed("/uploadScreen");
                        FilePicker.platform
                            .clearTemporaryFiles()
                            .then((result) {
                          result
                              ? print("Sucessfully cleared cache")
                              : print("Error! cache not cleared!");
                        });
                      },
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
                    text: "About the project",
                    onTap: () {
                      showAboutDialog(
                        applicationIcon: Container(
                          height: 50,
                          width: 50,
                          child: Image.asset("images/app_icon.png"),
                        ),
                        children: [
                          Container(
                            width: 10,
                            height: 40,
                            child: Image(
                              image: AssetImage("images/aws.png"),
                            ),
                          ),
                          Container(
                            width: 50,
                            height: 70,
                            child: Image(
                              image: AssetImage("images/teck.png"),
                            ),
                          ),
                        ],
                        context: context,
                        applicationName: "Lecture Rusher",
                        applicationVersion: "1.0",
                        applicationLegalese:
                            "This project was made by Hashem Alayan for the Amazon Teckathon 2020 event, you can find the author on github at https://github.com/hashem78",
                      );
                    },
                    icon: Icon(
                      MdiIcons.information,
                      color: Colors.green,
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  RusherTile(
                    text: "Live Transcribe",
                    onTap: () =>
                        Navigator.of(context).pushNamed('/transcribeScreen'),
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
