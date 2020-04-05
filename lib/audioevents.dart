import 'dart:async';

import 'package:flutter/services.dart';

abstract class SpotifyEventsCallback {
  void metadataChanged();
  void playbackStateChanged(bool isPlaying, int positionInMs);
}

class BroadcastTypes {
  static final String SPOTIFY_PACKAGE = "com.spotify.music";
  static final String PLAYBACK_STATE_CHANGED = SPOTIFY_PACKAGE + ".playbackstatechanged";
  static final String QUEUE_CHANGED = SPOTIFY_PACKAGE + ".queuechanged";
  static final String METADATA_CHANGED = SPOTIFY_PACKAGE + ".metadatachanged";
}

class Audioevents {
  static const MethodChannel _channel =
      const MethodChannel('audioevents');

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

  static void registerCallback(SpotifyEventsCallback callback) async {
    await _channel.invokeMethod('initialize');

    _channel.setMethodCallHandler((MethodCall call) {
      if (call.method == "playbackStateChanged") {
        bool isPlaying = call.arguments[0];
        int ms = call.arguments[1];

        callback.playbackStateChanged(isPlaying, ms);
      } else if (call.method == "metadataChanged") {
        callback.metadataChanged();
      } else {
        throw UnimplementedError;
      }

      return;
    });
  }
}
