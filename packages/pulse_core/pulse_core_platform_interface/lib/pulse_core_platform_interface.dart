import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:pulse_core_platform_interface/src/method_channel_pulse_core.dart';

export 'some.dart';

/// The interface that implementations of pulse_core must implement.
///
/// Platform implementations should extend this class
/// rather than implement it as `PulseCore`.
/// Extending this class (using `extends`) ensures that the subclass will get
/// the default implementation, while platform implementations that `implements`
///  this interface will be broken by newly added [PulseCorePlatform] methods.
abstract class PulseCorePlatform extends PlatformInterface {
  /// Constructs a PulseCorePlatform.
  PulseCorePlatform() : super(token: _token);

  static final Object _token = Object();

  static PulseCorePlatform _instance = MethodChannelPulseCore();

  /// The default instance of [PulseCorePlatform] to use.
  ///
  /// Defaults to [MethodChannelPulseCore].
  static PulseCorePlatform get instance => _instance;

  /// Platform-specific plugins should set this with their own platform-specific
  /// class that extends [PulseCorePlatform] when they register themselves.
  static set instance(PulseCorePlatform instance) {
    PlatformInterface.verify(instance, _token);
    _instance = instance;
  }

  /// Return the current platform name.
  Future<String?> getPlatformName();
}
