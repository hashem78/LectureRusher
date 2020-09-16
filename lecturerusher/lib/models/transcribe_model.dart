import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

class TranScribeModel extends ChangeNotifier {
  stt.SpeechToText speech = stt.SpeechToText();
  bool isListening = false;
  bool hasSpeech = false;
  String text = 'Tap the button to start transcribing';
  String analysisText = '';

  void updateAnalysisText(String text) {
    analysisText = text;
    notifyListeners();
  }

  void setListening(bool value) {
    isListening = value;
    notifyListeners();
  }

  void startListening() {}
  void stopListening() {}
  void cancelListening() {}
  void sethasSpeech(bool value) {
    hasSpeech = value;
    notifyListeners();
  }

  void updateText(String newText) {
    text = newText;
    notifyListeners();
  }
}
