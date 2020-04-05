import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:audioevents/audioevents.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> implements SpotifyEventsCallback {
  String _platformVersion = 'Unknown';

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String platformVersion;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      platformVersion = await Audioevents.platformVersion;
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
    });
  }

  Future<dynamic> callbackHandler (MethodCall call) async {

    // TODO(tek): this is working, hooray
    print('woohoo callback! ${call.arguments.toString()}');
    return "coo";
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Column(
          children: <Widget>[
            Center(
              child: Text('Running on: $_platformVersion\n'),
            ),
            RaisedButton(
              onPressed: () {
                print('woot');

                Audioevents.registerCallback(this);
              },
              child: Text("Roar"),
            )
          ],
        ),
      ),
    );
  }

  @override
  void metadataChanged() {
    print('metadataChanged');
  }

  @override
  void playbackStateChanged(bool isPlaying, int positionInMs) {
    print('play changed $isPlaying $positionInMs');
  }

}
