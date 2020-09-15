import 'package:flutter/material.dart';

class RusherUploadCheckBoxesModel extends ChangeNotifier {
  bool isFilePicked = false;
  bool isFileEncoded = false;
  bool isFileSentToServer = false;
  bool isResponseReceived = false;
  bool isDecoded = false;
  bool isSaved = false;

  void triggerIsFilePicked() {
    isFilePicked = true;
    notifyListeners();
  }

  void triggerIsFileEncoded() {
    isFileEncoded = true;
    notifyListeners();
  }

  void triggerIsFileSentToServer() {
    isFileSentToServer = true;
    notifyListeners();
  }

  void triggerIsResponseReceived() {
    isResponseReceived = true;
    notifyListeners();
  }

  void triggerIsDecoded() {
    isDecoded = true;
    notifyListeners();
  }

  void triggerIsSaved() {
    isSaved = true;
    notifyListeners();
  }

  void allToFalse() {
    isFilePicked = false;
    isFileEncoded = false;
    isFileSentToServer = false;
    isResponseReceived = false;
    isDecoded = false;
    isSaved = false;
    notifyListeners();
  }
}
