import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:pulse_storage/pulse_storage.dart';
import 'package:pulse_storage_platform_interface/pulse_storage_platform_interface.dart';

class MockPulseStoragePlatform extends Mock
    with MockPlatformInterfaceMixin
    implements PulseStoragePlatform {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('PulseStorage', () {
    late PulseStoragePlatform pulseStoragePlatform;

    setUp(() {
      pulseStoragePlatform = MockPulseStoragePlatform();
      PulseStoragePlatform.instance = pulseStoragePlatform;
    });

    group('getPlatformName', () {
      test('returns correct name when platform implementation exists',
          () async {
        const platformName = '__test_platform__';
        when(
          () => pulseStoragePlatform.getPlatformName(),
        ).thenAnswer((_) async => platformName);

        final actualPlatformName = await getPlatformName();
        expect(actualPlatformName, equals(platformName));
      });

      test('throws exception when platform implementation is missing',
          () async {
        when(
          () => pulseStoragePlatform.getPlatformName(),
        ).thenAnswer((_) async => null);

        expect(getPlatformName, throwsException);
      });
    });
  });
}
