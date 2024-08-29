import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pulse_core_android/pulse_core_android.dart';
import 'package:pulse_core_platform_interface/pulse_core_platform_interface.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('PulseCoreAndroid', () {
    const kPlatformName = 'Android';
    late PulseCoreAndroid pulseCore;
    late List<MethodCall> log;

    setUp(() async {
      pulseCore = PulseCoreAndroid();

      log = <MethodCall>[];
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
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
      PulseCoreAndroid.registerWith();
      expect(PulseCorePlatform.instance, isA<PulseCoreAndroid>());
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
