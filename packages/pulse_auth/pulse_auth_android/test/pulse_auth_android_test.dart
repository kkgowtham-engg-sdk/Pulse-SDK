import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pulse_auth_android/pulse_auth_android.dart';
import 'package:pulse_auth_platform_interface/pulse_auth_platform_interface.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('PulseAuthAndroid', () {
    const kPlatformName = 'Android';
    late PulseAuthAndroid pulseAuth;
    late List<MethodCall> log;

    setUp(() async {
      pulseAuth = PulseAuthAndroid();

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
      PulseAuthAndroid.registerWith();
      expect(PulseAuthPlatform.instance, isA<PulseAuthAndroid>());
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
