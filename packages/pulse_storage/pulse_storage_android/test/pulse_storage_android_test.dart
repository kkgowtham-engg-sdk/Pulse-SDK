import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pulse_storage_android/pulse_storage_android.dart';
import 'package:pulse_storage_platform_interface/pulse_storage_platform_interface.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('PulseStorageAndroid', () {
    const kPlatformName = 'Android';
    late PulseStorageAndroid pulseStorage;
    late List<MethodCall> log;

    setUp(() async {
      pulseStorage = PulseStorageAndroid();

      log = <MethodCall>[];
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
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
      PulseStorageAndroid.registerWith();
      expect(PulseStoragePlatform.instance, isA<PulseStorageAndroid>());
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
