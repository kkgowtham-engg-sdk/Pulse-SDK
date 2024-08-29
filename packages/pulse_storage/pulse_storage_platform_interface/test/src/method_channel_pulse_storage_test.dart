import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pulse_storage_platform_interface/src/method_channel_pulse_storage.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  const kPlatformName = 'platformName';

  group('$MethodChannelPulseStorage', () {
    late MethodChannelPulseStorage methodChannelPulseStorage;
    final log = <MethodCall>[];

    setUp(() async {
      methodChannelPulseStorage = MethodChannelPulseStorage();
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(methodChannelPulseStorage.methodChannel,
              (methodCall) async {
        log.add(methodCall);
        switch (methodCall.method) {
          case 'getPlatformName':
            return kPlatformName;
          default:
            return null;
        }
      });
    });
    tearDown(log.clear);

    test('getPlatformName', () async {
      final platformName = await methodChannelPulseStorage.getPlatformName();
      expect(
        log,
        <Matcher>[isMethodCall('getPlatformName', arguments: null)],
      );
      expect(platformName, equals(kPlatformName));
    });
  });
}
