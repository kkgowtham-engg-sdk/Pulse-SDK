import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pulse_auth_platform_interface/src/method_channel_pulse_auth.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  const kPlatformName = 'platformName';

  group('$MethodChannelPulseAuth', () {
    late MethodChannelPulseAuth methodChannelPulseAuth;
    final log = <MethodCall>[];

    setUp(() async {
      methodChannelPulseAuth = MethodChannelPulseAuth()
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
      final platformName = await methodChannelPulseAuth.getPlatformName();
      expect(
        log,
        <Matcher>[isMethodCall('getPlatformName', arguments: null)],
      );
      expect(platformName, equals(kPlatformName));
    });
  });
}
