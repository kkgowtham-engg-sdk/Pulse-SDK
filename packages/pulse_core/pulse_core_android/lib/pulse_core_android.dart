import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:pulse_core_platform_interface/pulse_core_platform_interface.dart';

/// The Android implementation of [PulseCorePlatform].
class PulseCoreAndroid extends PulseCorePlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('pulse_core_android');

  /// Registers this class as the default instance of [PulseCorePlatform]
  static void registerWith() {
    PulseCorePlatform.instance = PulseCoreAndroid();
  }

  @override
  Future<String?> getPlatformName() {
    return methodChannel.invokeMethod<String>('getPlatformName');
  }
}
