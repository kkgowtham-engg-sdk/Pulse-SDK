import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pulse_core_ios/pulse_core_ios.dart';
import 'package:pulse_core_platform_interface/pulse_core_platform_interface.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('PulseCoreIOS', () {
    const kPlatformName = 'iOS';
    late PulseCoreIOS pulseCore;
    late List<MethodCall> log;

    setUp(() async {
      pulseCore = PulseCoreIOS();

      log = <MethodCall>[];
      TestDefaultBinaryMessengerBinding.instance!.defaultBinaryMessenger
          .setMockMethodCallHandler(pulseCore.methodChannel,
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
      PulseCoreIOS.registerWith();
      expect(PulseCorePlatform.instance, isA<PulseCoreIOS>());
    });

    test('getPlatformName returns correct name', () async {
      final name = await pulseCore.getPlatformName();
      expect(
        log,
        <Matcher>[isMethodCall('getPlatformName', arguments: null)],
      );
      expect(name, equals(kPlatformName));
    });
  });
}
