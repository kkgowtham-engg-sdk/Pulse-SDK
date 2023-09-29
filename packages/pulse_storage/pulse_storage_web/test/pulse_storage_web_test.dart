import 'package:flutter_test/flutter_test.dart';
import 'package:pulse_storage_platform_interface/pulse_storage_platform_interface.dart';
import 'package:pulse_storage_web/pulse_storage_web.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('PulseStorageWeb', () {
    const kPlatformName = 'Web';
    late PulseStorageWeb pulseStorage;

    setUp(() async {
      pulseStorage = PulseStorageWeb();
    });

    test('can be registered', () {
      PulseStorageWeb.registerWith();
      expect(PulseStoragePlatform.instance, isA<PulseStorageWeb>());
    });

    test('getPlatformName returns correct name', () async {
      final name = await pulseStorage.getPlatformName();
      expect(name, equals(kPlatformName));
    });
  });
}
