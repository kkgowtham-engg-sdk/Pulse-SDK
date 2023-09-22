import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:pulse_auth_platform_interface/pulse_auth_platform_interface.dart';

/// The Android implementation of [PulseAuthPlatform].
class PulseAuthAndroid extends PulseAuthPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('pulse_auth_android');

  /// Registers this class as the default instance of [PulseAuthPlatform]
  static void registerWith() {
    PulseAuthPlatform.instance = PulseAuthAndroid();
  }

  @override
  Future<String?> getPlatformName() {
    return methodChannel.invokeMethod<String>('getPlatformName');
  }
}
