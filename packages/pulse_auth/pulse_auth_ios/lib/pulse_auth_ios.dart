import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:pulse_auth_platform_interface/pulse_auth_platform_interface.dart';

/// The iOS implementation of [PulseAuthPlatform].
class PulseAuthIOS extends PulseAuthPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('pulse_auth_ios');

  /// Registers this class as the default instance of [PulseAuthPlatform]
  static void registerWith() {
    PulseAuthPlatform.instance = PulseAuthIOS();
  }

  @override
  Future<String?> getPlatformName() {
    return methodChannel.invokeMethod<String>('getPlatformName1');
  }
}
