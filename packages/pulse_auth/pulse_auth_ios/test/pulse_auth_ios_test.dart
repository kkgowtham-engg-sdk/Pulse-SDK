import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pulse_auth_ios/pulse_auth_ios.dart';
import 'package:pulse_auth_platform_interface/pulse_auth_platform_interface.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('PulseAuthIOS', () {
    const kPlatformName = 'iOS';
    late PulseAuthIOS pulseAuth;
    late List<MethodCall> log;

    setUp(() async {
      pulseAuth = PulseAuthIOS();

      log = <MethodCall>[];
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(pulseAuth.methodChannel,
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

    test('can be registered', () {
      PulseAuthIOS.registerWith();
      expect(PulseAuthPlatform.instance, isA<PulseAuthIOS>());
    });

    test('getPlatformName returns correct name', () async {
      final name = await pulseAuth.getPlatformName();
      expect(
        log,
        <Matcher>[isMethodCall('getPlatformName', arguments: null)],
      );
      expect(name, equals(kPlatformName));
    });
  });
}
