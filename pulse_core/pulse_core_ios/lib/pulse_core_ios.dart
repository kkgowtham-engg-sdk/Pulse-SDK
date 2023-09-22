import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:pulse_core_platform_interface/pulse_core_platform_interface.dart';

/// The iOS implementation of [PulseCorePlatform].
class PulseCoreIOS extends PulseCorePlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('pulse_core_ios');

  /// Registers this class as the default instance of [PulseCorePlatform]
  static void registerWith() {
    PulseCorePlatform.instance = PulseCoreIOS();
  }

  @override
  Future<String?> getPlatformName() {
    return methodChannel.invokeMethod<String>('getPlatformName');
  }
}
