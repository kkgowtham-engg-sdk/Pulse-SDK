import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:pulse_auth_platform_interface/src/method_channel_pulse_auth.dart';

/// The interface that implementations of pulse_auth must implement.
///
/// Platform implementations should extend this class
/// rather than implement it as `PulseAuth`.
/// Extending this class (using `extends`) ensures that the subclass will get
/// the default implementation, while platform implementations that `implements`
///  this interface will be broken by newly added [PulseAuthPlatform] methods.
abstract class PulseAuthPlatform extends PlatformInterface {
  /// Constructs a PulseAuthPlatform.
  PulseAuthPlatform() : super(token: _token);

  static final Object _token = Object();

  static PulseAuthPlatform _instance = MethodChannelPulseAuth();

  /// The default instance of [PulseAuthPlatform] to use.
  ///
  /// Defaults to [MethodChannelPulseAuth].
  static PulseAuthPlatform get instance => _instance;

  /// Platform-specific plugins should set this with their own platform-specific
  /// class that extends [PulseAuthPlatform] when they register themselves.
  static set instance(PulseAuthPlatform instance) {
    PlatformInterface.verify(instance, _token);
    _instance = instance;
  }

  /// Return the current platform name.
  Future<String?> getPlatformName();
}
