import 'package:pulse_core_platform_interface/pulse_core_platform_interface.dart';

/// The Web implementation of [PulseCorePlatform].
class PulseCoreWeb extends PulseCorePlatform {
  /// Registers this class as the default instance of [PulseCorePlatform]
  static void registerWith([Object? registrar]) {
    PulseCorePlatform.instance = PulseCoreWeb();
  }

  @override
  Future<String?> getPlatformName() async => 'Web';
}
