import 'package:flutter/material.dart';
import 'package:lecturerusher/constants.dart';
import 'package:file_picker/file_picker.dart';
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
                print(base64file);
              }
            },
          ),
        ],
      ),
    );
  }
}