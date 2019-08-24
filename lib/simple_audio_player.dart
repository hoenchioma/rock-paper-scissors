import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:audioplayer/audioplayer.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class SimpleAudioPlayer extends AudioPlayer {
  SimpleAudioPlayer() : super();

  void playSimpleAudio(SimpleAudioFile audioFile) {
    if (audioFile.path != null) {
      super.play(audioFile.path, isLocal: true);
    }
  }
}

class SimpleAudioFile {
  String path;

  SimpleAudioFile();

  factory SimpleAudioFile.load(String assetPath) {
    SimpleAudioFile audioFile = SimpleAudioFile();
    audioFile.load(assetPath);
    return audioFile;
  }

  void clear() {
    final dir = File(path);
    dir.delete();
  }

  Future<void> load(String assetPath) async {
    Directory tempDir = await getTemporaryDirectory();
    File tempFile = File('${tempDir.path}/simple_audio_${basename(assetPath)}');
    // if (tempFile.existsSync()) return; // if file is already loaded don't load
    final ByteData data = await rootBundle.load(assetPath);
    await tempFile.writeAsBytes(data.buffer.asUint8List(), flush: true);
    path = tempFile.uri.toString();
    print('finished loading, asset=$assetPath uri=$path');
  }
}
