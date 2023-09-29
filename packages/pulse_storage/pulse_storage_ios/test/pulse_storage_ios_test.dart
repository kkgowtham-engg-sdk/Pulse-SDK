import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pulse_storage_ios/pulse_storage_ios.dart';
import 'package:pulse_storage_platform_interface/pulse_storage_platform_interface.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('PulseStorageIOS', () {
    const kPlatformName = 'iOS';
    late PulseStorageIOS pulseStorage;
    late List<MethodCall> log;

    setUp(() async {
      pulseStorage = PulseStorageIOS();

      log = <MethodCall>[];
      TestDefaultBinaryMessengerBinding.instance!.defaultBinaryMessenger
          .setMockMethodCallHandler(pulseStorage.methodChannel,
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
      PulseStorageIOS.registerWith();
      expect(PulseStoragePlatform.instance, isA<PulseStorageIOS>());
    });

    test('getPlatformName returns correct name', () async {
      final name = await pulseStorage.getPlatformName();
      expect(
        log,
        <Matcher>[isMethodCall('getPlatformName', arguments: null)],
      );
      expect(name, equals(kPlatformName));
    });
  });
}
