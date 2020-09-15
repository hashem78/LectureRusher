import 'package:flutter/material.dart';
import 'package:lecturerusher/constants.dart';
import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;
import 'package:lecturerusher/models/rusher_ucheckbox_model.dart';
import 'package:provider/provider.dart';
import 'dart:io';
import 'dart:convert';
import 'dart:async';

class UploadScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: krusherAppBar,
      body: Center(
        child: Consumer<RusherUploadCheckBoxesModel>(builder: (context, w, _) {
          return Column(
            //mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                //width: 100,
                height: 220,
                child: Icon(
                  Icons.upload_file,
                  size: 220,
                  color: Colors.amber,
                ),
              ),
              RaisedButton(
                  onPressed: () async {
                    w.allToFalse();
                    FilePickerResult result =
                        await FilePicker.platform.pickFiles();
                    w.triggerIsFilePicked();
                    if (result != null) {
                      File file = File(result.paths[0]);
                      var fileBytes = file.readAsBytesSync();
                      String base64file = base64Encode(fileBytes);
                      w.triggerIsFileEncoded();

                      Map<String, dynamic> jsonMap = {
                        "file": base64file,
                      };

                      String jsonEncoded = json.encode(jsonMap);
                      w.triggerIsFileSentToServer();
                      var response = await http.post(
                        "http://22d9fcdb3de9.ngrok.io/uploadWAV",
                        headers: {
                          "Content-Type": "application/json",
                        },
                        body: jsonEncoded,
                      );
                      w.triggerIsResponseReceived();
                      var decodedJson = json.decode(response.body);
                      var decodedFile = base64Decode(decodedJson['file']);
                      w.triggerIsDecoded();
                      File f = File("/sdcard/recivied.wav");
                      await f.writeAsBytes(decodedFile);
                      w.triggerIsSaved();
                      print("wrote file successfully");
                    }
                  },
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Text(
                      "Pick File",
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                  ),
                  color: Colors.amber),
              CheckboxListTile(
                value: w.isFilePicked,
                title: Text("Picked file"),
                onChanged: (_) {},
              ),
              CheckboxListTile(
                value: w.isFileEncoded,
                title: Text("Encoded File"),
                onChanged: (_) {},
              ),
              CheckboxListTile(
                value: w.isFileSentToServer,
                title: Text("Sent file to server"),
                onChanged: (_) {},
              ),
              CheckboxListTile(
                value: w.isResponseReceived,
                title: Text("Received response from server"),
                onChanged: (_) {},
              ),
              CheckboxListTile(
                value: w.isDecoded,
                title: Text("Decoded final file"),
                onChanged: (_) {},
              ),
              CheckboxListTile(
                value: w.isSaved,
                title: Text("Saved file locally"),
                onChanged: (_) {},
              ),
            ],
          );
        }),
      ),
    );
  }
}
