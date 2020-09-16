import 'package:flutter_sound/flutter_sound.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class RecorderModel extends ChangeNotifier {
  FlutterSoundRecorder recorder;
  RecorderModel();

  int state = 2;
  String recorderTitle = "Record";
  void changeState(int newState) async {
    // Alaways make sure we've got perms!
    PermissionStatus statusMic = await Permission.microphone.request();
    PermissionStatus statusStorage = await Permission.storage.request();
    if (statusMic != PermissionStatus.granted)
      throw RecordingPermissionException("Microphone permission not granted");
    if (statusStorage != PermissionStatus.granted)
      throw RecordingPermissionException("Storage permission not granted");
    // Start recording
    if (newState == 0) {
      // if the recorder is simply paused just resume

      if (recorder == null || recorder.isStopped) {
        recorder = await FlutterSoundRecorder().openAudioSession();
        String path =
            '/sdcard/${DateTime.now().millisecondsSinceEpoch}-recording${ext[Codec.pcm16WAV.index]}';
        await recorder.startRecorder(
          toFile: path,
          codec: Codec.pcm16WAV,
        );
      } else if (recorder.isPaused) {
        await recorder.resumeRecorder();
      }
      recorderTitle = "Recording";
    } else if (newState == 1) {
      // Pause Recorder
      if (recorder.isRecording) {
        await recorder.pauseRecorder();
      }
      recorderTitle = "Paused";
    } else if (newState == 2) {
      // Stop recording
      if (recorder == null) {
        newState = state;
        return;
      }
      if (recorder.isRecording || recorder.isPaused) {
        await recorder.stopRecorder();
        await recorder.closeAudioSession();
        recorder = null;
      }
      recorderTitle = "Record";
    }
    state = newState;
    notifyListeners();
  }
}
