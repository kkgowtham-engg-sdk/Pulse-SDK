import 'package:flutter_test/flutter_test.dart';
import 'package:pulse_auth_platform_interface/pulse_auth_platform_interface.dart';
import 'package:pulse_auth_web/pulse_auth_web.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('PulseAuthWeb', () {
    const kPlatformName = 'Web';
    late PulseAuthWeb pulseAuth;

    setUp(() async {
      pulseAuth = PulseAuthWeb();
    });

    test('can be registered', () {
      PulseAuthWeb.registerWith();
      expect(PulseAuthPlatform.instance, isA<PulseAuthWeb>());
    });

    test('getPlatformName returns correct name', () async {
      final name = await pulseAuth.getPlatformName();
      expect(name, equals(kPlatformName));
    });
  });
}
