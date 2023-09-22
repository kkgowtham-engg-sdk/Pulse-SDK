import 'package:flutter_test/flutter_test.dart';
import 'package:pulse_core_platform_interface/pulse_core_platform_interface.dart';

class PulseCoreMock extends PulseCorePlatform {
  static const mockPlatformName = 'Mock';

  @override
  Future<String?> getPlatformName() async => mockPlatformName;
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  group('PulseCorePlatformInterface', () {
    late PulseCorePlatform pulseCorePlatform;

    setUp(() {
      pulseCorePlatform = PulseCoreMock();
      PulseCorePlatform.instance = pulseCorePlatform;
    });

    group('getPlatformName', () {
      test('returns correct name', () async {
        expect(
          await PulseCorePlatform.instance.getPlatformName(),
          equals(PulseCoreMock.mockPlatformName),
        );
      });
    });
  });
}
