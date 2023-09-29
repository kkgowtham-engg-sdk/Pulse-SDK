import 'package:pulse_storage_platform_interface/pulse_storage_platform_interface.dart';

PulseStoragePlatform get _platform => PulseStoragePlatform.instance;

/// Returns the name of the current platform.
Future<String> getPlatformName() async {
  final platformName = await _platform.getPlatformName();
  if (platformName == null) throw Exception('Unable to get platform name.');
  return platformName;
}
