import 'package:flutter_test/flutter_test.dart';
import 'package:pulse_core_platform_interface/pulse_core_platform_interface.dart';
import 'package:pulse_core_web/pulse_core_web.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('PulseCoreWeb', () {
    const kPlatformName = 'Web';
    late PulseCoreWeb pulseCore;

    setUp(() async {
      pulseCore = PulseCoreWeb();
    });

    test('can be registered', () {
      PulseCoreWeb.registerWith();
      expect(PulseCorePlatform.instance, isA<PulseCoreWeb>());
    });

    test('getPlatformName returns correct name', () async {
      final name = await pulseCore.getPlatformName();
      expect(name, equals(kPlatformName));
    });
  });
}
