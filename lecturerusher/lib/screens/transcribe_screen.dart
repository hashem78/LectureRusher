import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:lecturerusher/constants.dart';
import 'package:lecturerusher/models/transcribe_model.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';
import 'dart:io';
import 'package:http/http.dart' as http;

GlobalKey<ScaffoldState> scaffoldState = GlobalKey<ScaffoldState>();

class TransScribeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<TranScribeModel>(builder: (context, w, _) {
      return Scaffold(
        backgroundColor: kbackgroundColor,
        key: scaffoldState,
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FloatingActionButton(
              tooltip: "Start/Stop/Intialize recording",
              onPressed: () async {
                if (!w.isListening) {
                  bool available = await w.speech.initialize(
                    onStatus: (val) => print('onStatus: $val'),
                    onError: (val) => print('onError: $val'),
                  );
                  if (available) {
                    w.setListening(true);
                    w.speech.listen(
                      onResult: (val) {
                        w.updateText(val.recognizedWords);
                      },
                    );
                  }
                } else {
                  w.setListening(false);
                  w.speech.stop();
                }
              },
              child: Icon(
                w.isListening
                    ? MdiIcons.microphoneOutline
                    : MdiIcons.microphoneOff,
              ),
            ),
            FloatingActionButton(
              heroTag: "1",
              tooltip: "Save transcription to local storage",
              child: Icon(
                Icons.save,
              ),
              onPressed: () {
                File f = File("/sdcard/lecture.txt");
                scaffoldState.currentState.showSnackBar(
                  SnackBar(
                    content: Text("Saved contents to lecture.txt in storage"),
                  ),
                );
                f.writeAsString(w.text + w.analysisText);
              },
            ),
            FloatingActionButton(
              tooltip: "Analyze text for various features",
              heroTag: "2",
              onPressed: () async {
                String url =
                    'https://z65meaof1g.execute-api.us-east-1.amazonaws.com/default/getData?text=${w.text}';
                var response = await http.get(url);
                if (response.statusCode != 200) {
                  scaffoldState.currentState.showSnackBar(
                    SnackBar(
                      content: Text(
                        "Unfortuanetly an error occured, please check your internet connection",
                        style: TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  );
                  return;
                }
                var jsonResponse = jsonDecode(response.body);

                var entities = jsonResponse['entities'];
                var syntax = jsonResponse['syntax'];

                String finalText =
                    '''Sentiment : ${jsonResponse['sentiment']}\nComercial Items: ${entities['comercial_items'] ?? 'none'}\nDates: ${entities['dates'] ?? 'none'}\nEvents: ${entities['events'] ?? 'none'}\nLocations: ${entities['locations'] ?? 'none'}\nOrganizations: ${entities['organizations'] ?? 'none'}\nPersons: ${entities['persons'] ?? 'none'}\nQuantities: ${entities['quantities'] ?? 'none'}\nTitles: ${entities['titles'] ?? 'none'}\nVerbs: ${syntax['verbs']}\nAdjectives: ${syntax['adjs']}\nNouns: ${syntax['nouns']}\nPronouns: ${syntax['pronouns']}\nInterjections: ${syntax['interjections']}\nAdverbs: ${syntax['adverbs']}''';
                finalText = finalText.replaceAll(RegExp(r'\['), '');
                finalText = finalText.replaceAll(RegExp(r'\]'), '');
                w.updateAnalysisText(finalText);
                scaffoldState.currentState.showSnackBar(
                  SnackBar(
                    content: Text(
                      "Text analysis complete",
                      style: TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                );
              },
              child: Text(
                'Analyze Text',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 10),
              ),
            ),
          ],
        ),
        appBar: krusherAppBar,
        body: SingleChildScrollView(
          reverse: true,
          child: Container(
            padding: const EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 150.0),
            child: Column(
              children: [
                Text(
                  w.text,
                  style: TextStyle(
                    fontSize: 32.0,
                    color: Colors.black,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                Text(
                  w.analysisText,
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.black38,
                    fontWeight: FontWeight.w300,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}
