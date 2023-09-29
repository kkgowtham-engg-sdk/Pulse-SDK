import 'package:pulse_auth_platform_interface/pulse_auth_platform_interface.dart';

/// The Web implementation of [PulseAuthPlatform].
class PulseAuthWeb extends PulseAuthPlatform {
  /// Registers this class as the default instance of [PulseAuthPlatform]
  static void registerWith([Object? registrar]) {
    PulseAuthPlatform.instance = PulseAuthWeb();
  }

  @override
  Future<String?> getPlatformName() async => 'Web';
}
