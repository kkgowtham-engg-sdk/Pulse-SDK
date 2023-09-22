import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:pulse_storage_platform_interface/pulse_storage_platform_interface.dart';

/// The iOS implementation of [PulseStoragePlatform].
class PulseStorageIOS extends PulseStoragePlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('pulse_storage_ios');

  /// Registers this class as the default instance of [PulseStoragePlatform]
  static void registerWith() {
    PulseStoragePlatform.instance = PulseStorageIOS();
  }

  @override
  Future<String?> getPlatformName() {
    return methodChannel.invokeMethod<String>('getPlatformName');
  }
}
