import 'package:flutter_test/flutter_test.dart';
import 'package:pulse_storage_platform_interface/pulse_storage_platform_interface.dart';

class PulseStorageMock extends PulseStoragePlatform {
  static const mockPlatformName = 'Mock';

  @override
  Future<String?> getPlatformName() async => mockPlatformName;
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  group('PulseStoragePlatformInterface', () {
    late PulseStoragePlatform pulseStoragePlatform;
    setUp(() {
      pulseStoragePlatform = PulseStorageMock();
      PulseStoragePlatform.instance = pulseStoragePlatform;
    });

    group('getPlatformName', () {
      test('returns correct name', () async {
        expect(
          await PulseStoragePlatform.instance.getPlatformName(),
          equals(PulseStorageMock.mockPlatformName),
        );
      });
    });
  });
}
