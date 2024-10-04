import 'package:pulse_auth_platform_interface/pulse_auth_platform_interface.dart';
import 'package:pulse_core/pulse_core.dart';

PulseAuthPlatform get _platform => PulseAuthPlatform.instance;

/// Returns the name of the current platform.
Future<String> getPlatformName1() async {
  final platformName = await _platform.getPlatformName();
  if (platformName == null) throw Exception('Unable  to get platform name.');
  return platformName;
}

/// Return version
String getVersions() {
  return '${getCoreVersion()}___Auth_0.0.3';
}
