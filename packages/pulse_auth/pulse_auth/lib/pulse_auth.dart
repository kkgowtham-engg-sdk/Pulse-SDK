import 'package:pulse_auth_platform_interface/pulse_auth_platform_interface.dart';

PulseAuthPlatform get _platform => PulseAuthPlatform.instance;

/// Returns the name of the current platform.
Future<String> getPlatformName1() async {
  final platformName = await _platform.getPlatformName();
  if (platformName == null)
    throw Exception('Unable  to get platform name.');
  return platformName;
}
