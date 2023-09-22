import 'package:flutter/foundation.dart' show visibleForTesting;
import 'package:flutter/services.dart';
import 'package:pulse_core_platform_interface/pulse_core_platform_interface.dart';

/// An implementation of [PulseCorePlatform] that uses method channels.
class MethodChannelPulseCore extends PulseCorePlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('pulse_core');

  @override
  Future<String?> getPlatformName() {
    return methodChannel.invokeMethod<String>('getPlatformName');
  }
}
