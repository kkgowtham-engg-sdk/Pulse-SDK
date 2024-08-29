import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:pulse_storage_platform_interface/'
    'src/method_channel_pulse_storage.dart';

export '';

/// The interface that implementations of pulse_storage must implement.
///
/// Platform implementations should extend this class
/// rather than implement it as `PulseStorage`.
/// Extending this class (using `extends`) ensures that the subclass will get
/// the default implementation, while platform implementations that `implements`
///  this interface will be broken by newly added [PulseStoragePlatform] methods
abstract class PulseStoragePlatform extends PlatformInterface {
  /// Constructs a PulseStoragePlatform.
  PulseStoragePlatform() : super(token: _token);

  static final Object _token = Object();

  static PulseStoragePlatform _instance = MethodChannelPulseStorage();

  /// The default instance of [PulseStoragePlatform] to use.
  ///
  /// Defaults to [MethodChannelPulseStorage].
  static PulseStoragePlatform get instance => _instance;

  /// Platform-specific plugins should set this with their own platform-specific
  /// class that extends [PulseStoragePlatform] when they register themselves.
  static set instance(PulseStoragePlatform instance) {
    PlatformInterface.verify(instance, _token);
    _instance = instance;
  }

  /// Return the current platform name.
  Future<String?> getPlatformName();
}
