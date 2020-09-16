import 'package:flutter/material.dart';
import 'package:lecturerusher/models/transcribe_model.dart';
import 'package:lecturerusher/widgets/rusher_tile.dart';
import 'package:lecturerusher/constants.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';
import 'package:lecturerusher/models/recorder_model.dart';
import 'package:file_picker/file_picker.dart';

GlobalKey<ScaffoldState> scaffoldState2 = GlobalKey<ScaffoldState>();

class MainScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldState2,
      appBar: krusherAppBar,
      backgroundColor: kbackgroundColor,
      body: Column(
        children: [
          Expanded(
            child: Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "         Welcome to Lecture Rusher By Hashem Alayan!         ",
                    style: TextStyle(
                      fontWeight: FontWeight.w300,
                      fontSize: 15,
                    ),
                  ),
                  Text(
                    "Here is a quick guide to use the app.",
                    style: TextStyle(
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                  Text(
                    "     1. To record audio single tap the record button, to pause double tap and to stop long press",
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: Colors.red,
                    ),
                  ),
                  Text(
                    "     2. To remove silences and filler words use the upload recording functionality to upload a .wav recording to LR servers for it to be processed",
                    style: TextStyle(
                      color: Colors.amber,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    "     3. To record audio and provide live transcription and text analysis use the live transcription button",
                    style: TextStyle(
                      color: Colors.blue,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                RusherTile(
                  text: "Upload Recording",
                  onTap: () async {
                    await Navigator.of(context).pushNamed("/uploadScreen");
                    FilePicker.platform.clearTemporaryFiles().then((result) {
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
                      scaffoldState2.currentState.showSnackBar(
                        SnackBar(
                          content: Text('Recording started'),
                        ),
                      );
                    },
                    onDobuleTap: () {
                      newW.changeState(1);
                      scaffoldState2.currentState.showSnackBar(
                        SnackBar(
                          content: Text('Recording paused'),
                        ),
                      );
                    },
                    onLongPress: () {
                      newW.changeState(2);
                      scaffoldState2.currentState.showSnackBar(
                        SnackBar(
                          content: Text('Recording stopped'),
                        ),
                      );
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
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                RusherTile(
                  text: "About the project",
                  onTap: () {
                    buildShowAboutDialog(context);
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
                  onTap: () {
                    Provider.of<TranScribeModel>(context, listen: false)
                        .updateText('Tap the button to start transcribing');
                    Provider.of<TranScribeModel>(context, listen: false)
                        .updateAnalysisText('');
                    Navigator.of(context).pushNamed('/transcribeScreen');
                  },
                  icon: Icon(
                    MdiIcons.textToSpeech,
                    color: Colors.blue,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void buildShowAboutDialog(BuildContext context) {
    return showAboutDialog(
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
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 40,
              height: 40,
              child: Image(
                image: AssetImage("images/lambda.png"),
              ),
            ),
            Container(
              width: 40,
              height: 40,
              child: Image(
                image: AssetImage("images/lightsail.png"),
              ),
            ),
            Container(
              width: 40,
              height: 40,
              child: Image(
                image: AssetImage("images/apigateway.png"),
              ),
            ),
            Container(
              width: 40,
              height: 40,
              child: Image(
                image: AssetImage("images/comprehend.png"),
              ),
            ),
          ],
        ),
      ],
      context: context,
      applicationName: "Lecture Rusher",
      applicationVersion: "1.0",
      applicationLegalese:
          "This project was made by Hashem Alayan for the Amazon Teckathon 2020 event, you can find the author on github at https://github.com/hashem78",
    );
  }
}
