import 'package:flutter/foundation.dart' show visibleForTesting;
import 'package:flutter/services.dart';
import 'package:pulse_auth_platform_interface/pulse_auth_platform_interface.dart';

/// An implementation of [PulseAuthPlatform] that uses method channels.
class MethodChannelPulseAuth extends PulseAuthPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('pulse_auth');

  @override
  Future<String?> getPlatformName() {
    return methodChannel.invokeMethod<String>('getPlatformName');
  }
}
