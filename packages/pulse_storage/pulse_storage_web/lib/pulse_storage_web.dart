import 'package:pulse_storage_platform_interface/pulse_storage_platform_interface.dart';

/// The Web implementation of [PulseStoragePlatform].
class PulseStorageWeb extends PulseStoragePlatform {
  /// Registers this class as the default instance of [PulseStoragePlatform]
  static void registerWith([Object? registrar]) {
    PulseStoragePlatform.instance = PulseStorageWeb();
  }

  @override
  Future<String?> getPlatformName() async => 'Web';
}
