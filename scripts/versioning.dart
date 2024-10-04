import 'dart:convert';
import 'dart:io';
import 'package:pub_semver/pub_semver.dart';

final modulesDir = 'packages';
const masterBranch = 'master';

final Map<String, String> updatedPackages = {};


Future<void> main(List<String> arguments) async {
  final bumpType = arguments.isNotEmpty ? arguments[0] : 'minor';

  final modules = Directory(modulesDir).listSync();
  updatePackagesIfRequired(modules,bumpType);
  processDependencies(updatedPackages, modules);
  updatePackagesIfRequired(modules,bumpType);
  print('Version update complete.');
}

Future<void> updatePackagesIfRequired(List<FileSystemEntity> modules, String bumpType) async {
  for (var module in modules) {
    if (module is Directory) {
      print('Processing module in ${module.path}');
      final packages = module.listSync();
      for (var package in packages) {
        if (package is Directory) {
          final pubspecPath = '${package.path}/pubspec.yaml';
          final pubspecFile = File(pubspecPath);
          if (pubspecFile.existsSync()) {
            var pubspecContent = pubspecFile.readAsStringSync();
            final versionString = _extractVersion(pubspecContent);
            if (versionString != null) {
              if (await isPackageVersionUpdateRequired(
                  package.path, masterBranch)) {
                print(
                    'Changes detected in ${package.path}. Doing Version Bump.');

                final newVersion = _bumpVersion(versionString, bumpType);
                pubspecContent = pubspecContent.replaceFirst(
                    'version: $versionString', 'version: $newVersion');
                pubspecFile.writeAsStringSync(pubspecContent);
                final packageName = getPackageName(pubspecContent);
                if (packageName != null) {
                  print(
                      "Caching package Name: $packageName, New Version: $newVersion");
                  updatedPackages[packageName] = newVersion;
                }
                print('Updated $pubspecPath to $newVersion');
              } else {
                print(
                    'No changes detected in ${package.path}. Bumping version.');
                continue;
              }
            } else {
              print('No version found in $pubspecPath');
            }
          } else {
            print('No pubspec.yaml found in ${package.path}');
          }
        }
      }
    }
  }
}

void processDependencies(
    Map<String, String> updatedPackages, List<FileSystemEntity> modules) {
  for (var moduleName in updatedPackages.keys) {
    for (var module in modules) {
      if (module is Directory) {
        final packages = module.listSync();
        for (var package in packages) {
          if (package is Directory) {
            final pubspecPath = '${package.path}/pubspec.yaml';
            final pubspecFile = File(pubspecPath);
            if (pubspecFile.existsSync()) {
              var pubspecContent = pubspecFile.readAsStringSync();
              // Check if this package file contains a dependency on the updated module
              if (pubspecContent.contains('  $moduleName:')) {
                final newVersion = updatedPackages[moduleName]!;
                // Update the dependency version
                final regex = RegExp('  $moduleName:.*');
                pubspecContent = pubspecContent.replaceAll(
                    regex, '  $moduleName: $newVersion');
                pubspecFile.writeAsStringSync(pubspecContent);
                print(
                    'Updated dependency $moduleName in $pubspecPath to version $newVersion');
              }
            }
          }
        }
      }
    }
  }
}

String? _extractVersion(String content) {
  final versionLine = content
      .split('\n')
      .firstWhere((line) => line.startsWith('version:'), orElse: () => '');
  if (versionLine.isNotEmpty) {
    return versionLine.split(':')[1].trim();
  }
  return null;
}

String _bumpVersion(String versionString, String type) {
  final version = Version.parse(versionString);
  late Version newVersion;
  switch (type) {
    case 'major':
      newVersion = version.nextMajor;
      break;
    case 'minor':
      newVersion = version.nextMinor;
      break;
    case 'patch':
      newVersion = version.nextPatch;
      break;
    default:
      throw ArgumentError(
          'Invalid bump type: $type. Must be major, minor, or patch.');
  }
  return newVersion.toString();
}

String? getPackageName(String pubspecContent) {
  final lines = pubspecContent.split('\n');
  for (var line in lines) {
    if (line.startsWith('name:')) {
      return line.split(':')[1].trim();
    }
  }
  return null;
}

Future<String> executeCommand(String command, List<String> arguments) async {
  String result = '';
  try {
    final process = await Process.start(command, arguments);
    final output = await process.stdout.transform(utf8.decoder).join();
    final errorOutput = await process.stderr.transform(utf8.decoder).join();
    final exitCode = await process.exitCode;

    if (exitCode == 0) {
      result = output.trim();
    } else {
      print('Command failed with exit code $exitCode: $errorOutput');
    }
  } catch (e) {
    print('Failed to run command: $e');
  }
  return result;
}

Future<bool> hasPackageChanged(String packagePath, String baseBranch) async {
  await executeCommand('git', ['fetch']);
  final tagId =
      await executeCommand('git', ['rev-list', '--tags', '--max-count=1']);
  final latestTag = await executeCommand('git', ['describe', '--tags', tagId]);
  final lastReleaseCommitId =
      await executeCommand('git', ['rev-parse', latestTag]);
  final baseBranchCommitId =
      await executeCommand('git', ['rev-parse', baseBranch]);

  final diff = await executeCommand(
      'git', ['diff', '--name-only', baseBranchCommitId, lastReleaseCommitId]);

  // Check if the package path is in the list of changed files
  return diff.split('\n').any((file) => file.startsWith(packagePath)) ||
      await hasUncommittedChanges(packagePath);
}

Future<bool> isPackageVersionUpdateRequired(
    String packagePath, String baseBranch) async {
  final packageHasChanged = await hasPackageChanged(packagePath, baseBranch);
  if (packageHasChanged) {
    return true;
  } else {
    return false;
  }
}

Future<bool> hasUncommittedChanges(String packagePath) async {
  final status = await executeCommand('git', ['status', '--porcelain', packagePath]);
  print("Has Uncommited Changes: ${status.isNotEmpty}");
  return status.isNotEmpty;
}
