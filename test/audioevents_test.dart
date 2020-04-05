import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:audioevents/audioevents.dart';

void main() {
  const MethodChannel channel = MethodChannel('audioevents');

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('getPlatformVersion', () async {
    expect(await Audioevents.platformVersion, '42');
  });
}
