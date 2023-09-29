import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:pulse_auth/pulse_auth.dart';
import 'package:pulse_auth_platform_interface/pulse_auth_platform_interface.dart';

class MockPulseAuthPlatform extends Mock
    with MockPlatformInterfaceMixin
    implements PulseAuthPlatform {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('PulseAuth', () {
    late PulseAuthPlatform pulseAuthPlatform;

    setUp(() {
      pulseAuthPlatform = MockPulseAuthPlatform();
      PulseAuthPlatform.instance = pulseAuthPlatform;
    });

    group('getPlatformName', () {
      test('returns correct name when platform implementation exists',
          () async {
        const platformName = '__test_platform__';
        when(
          () => pulseAuthPlatform.getPlatformName(),
        ).thenAnswer((_) async => platformName);

        final actualPlatformName = await getPlatformName1();
        expect(actualPlatformName, equals(platformName));
      });

      test('throws exception when platform implementation is missing',
          () async {
        when(
          () => pulseAuthPlatform.getPlatformName(),
        ).thenAnswer((_) async => null);

        expect(getPlatformName1, throwsException);
      });
    });
  });
}
