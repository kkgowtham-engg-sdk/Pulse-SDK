import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pulse_core_platform_interface/src/method_channel_pulse_core.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  const kPlatformName = 'platformName';

  group('$MethodChannelPulseCore', () {
    late MethodChannelPulseCore methodChannelPulseCore;
    final log = <MethodCall>[];

    setUp(() async {
      methodChannelPulseCore = MethodChannelPulseCore()
        ..methodChannel.setMockMethodCallHandler((MethodCall methodCall) async {
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
      final platformName = await methodChannelPulseCore.getPlatformName();
      expect(
        log,
        <Matcher>[isMethodCall('getPlatformName', arguments: null)],
      );
      expect(platformName, equals(kPlatformName));
    });
  });
}
