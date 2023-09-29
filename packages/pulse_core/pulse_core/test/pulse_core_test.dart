import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:pulse_core/pulse_core.dart';
import 'package:pulse_core_platform_interface/pulse_core_platform_interface.dart';

class MockPulseCorePlatform extends Mock
    with MockPlatformInterfaceMixin
    implements PulseCorePlatform {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('PulseCore', () {
    late PulseCorePlatform pulseCorePlatform;

    setUp(() {
      pulseCorePlatform = MockPulseCorePlatform();
      PulseCorePlatform.instance = pulseCorePlatform;
    });

    group('getPlatformName', () {
      test('returns correct name when platform implementation exists',
          () async {
        const platformName = '__test_platform__';
        when(
          () => pulseCorePlatform.getPlatformName(),
        ).thenAnswer((_) async => platformName);

        final actualPlatformName = await getPlatformName();
        expect(actualPlatformName, equals(platformName));
      });

      test('throws exception when platform implementation is missing',
          () async {
        when(
          () => pulseCorePlatform.getPlatformName(),
        ).thenAnswer((_) async => null);

        expect(getPlatformName, throwsException);
      });
    });
  });
}
