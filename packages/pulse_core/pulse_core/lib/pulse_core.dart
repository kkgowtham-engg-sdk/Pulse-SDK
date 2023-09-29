import 'package:pulse_core_platform_interface/pulse_core_platform_interface.dart';

PulseCorePlatform get _platform => PulseCorePlatform.instance;

/// Returns the name of the current platform.
Future<String> getPlatformName() async {
  final platformName = await _platform.getPlatformName();
  if (platformName == null) throw Exception('Unable to get platform name.');
  return platformName;
}
