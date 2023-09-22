import 'package:flutter_test/flutter_test.dart';
import 'package:pulse_auth_platform_interface/pulse_auth_platform_interface.dart';

class PulseAuthMock extends PulseAuthPlatform {
  static const mockPlatformName = 'Mock';

  @override
  Future<String?> getPlatformName() async => mockPlatformName;
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  group('PulseAuthPlatformInterface', () {
    late PulseAuthPlatform pulseAuthPlatform;

    setUp(() {
      pulseAuthPlatform = PulseAuthMock();
      PulseAuthPlatform.instance = pulseAuthPlatform;
    });

    group('getPlatformName', () {
      test('returns correct name', () async {
        expect(
          await PulseAuthPlatform.instance.getPlatformName(),
          equals(PulseAuthMock.mockPlatformName),
        );
      });
    });
  });
}
