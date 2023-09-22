import 'package:flutter/foundation.dart' show visibleForTesting;
import 'package:flutter/services.dart';
import 'package:pulse_storage_platform_interface/pulse_storage_platform_interface.dart';

/// An implementation of [PulseStoragePlatform] that uses method channels.
class MethodChannelPulseStorage extends PulseStoragePlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('pulse_storage');

  @override
  Future<String?> getPlatformName() {
    return methodChannel.invokeMethod<String>('getPlatformName');
  }
}
