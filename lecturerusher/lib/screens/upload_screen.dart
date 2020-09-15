import 'package:flutter/material.dart';
import 'package:lecturerusher/constants.dart';
import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;

import 'dart:io';
import 'dart:convert';

class UploadScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: krusherAppBar,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          RaisedButton(
            onPressed: () async {
              FilePickerResult result = await FilePicker.platform.pickFiles();

              if (result != null) {
                print(result.paths);
                File file = File(result.paths[0]);
                var fileBytes = file.readAsBytesSync();
                String base64file = base64Encode(fileBytes);

                Map<String, dynamic> jsonMap = {
                  "file": base64file,
                };

                String jsonEncoded = json.encode(jsonMap);
                var response = await http.post(
                  "http://95c40b67c866.ngrok.io/uploadWAV",
                  headers: {
                    "Content-Type": "application/json",
                  },
                  body: jsonEncoded,
                );
                var decodedJson = json.decode(response.body);
                var decodedFile = base64Decode(decodedJson['file']);
                File f = File("/sdcard/recivied.wav");
                await f.writeAsBytes(decodedFile);
                print("wrote file successfully");
              }
            },
          ),
        ],
      ),
    );
  }
}
