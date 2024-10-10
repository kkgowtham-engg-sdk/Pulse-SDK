import 'dart:convert';
import 'dart:io';
import 'package:pub_semver/pub_semver.dart';

final modulesDir = 'packages';
const masterBranch = 'master';

final Map<String, String> updatedPackages = {};

enum VersionChange { major, minor, patch }

Future<void> main(List<String> arguments) async {
  final bumpType = arguments.isNotEmpty ? arguments[0] : 'minor';

  final modules = Directory(modulesDir).listSync();
  print("---------Update Packages First Level----------");
  await updatePackagesIfRequired(modules, bumpType);
  print("----Updated Packages---");
  updatedPackages.forEach((key, value) {
    print("Package: $key, Version: $value");
  });
  print("---------Update Dependencies----------");
  processDependencies(updatedPackages, modules);
  print("---------Update Packages Second Level----------");
  updatePackagesIfRequired(modules,bumpType);
  print('Version update complete.');
  print("---------Second Level Update Dependencies----------");
  processDependencies(updatedPackages, modules);
}

Future<void> updatePackagesIfRequired(
    List<FileSystemEntity> modules, String bumpType) async {
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
            final packageName = getPackageName(pubspecContent);

            if (versionString != null && packageName != null) {
              if (updatedPackages.containsKey(packageName)) {
                print('Package $packageName is already updated to ${updatedPackages[packageName]}. Skipping update.');
                continue;
              }
              if (await isPackageVersionUpdateRequired(package.path, masterBranch)) {
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
                 //print( 'No changes detected in ${package.path}.');
                continue;
              }
            } else {
             // print('No version found in $pubspecPath');
            }
          } else {
           // print('No pubspec.yaml found in ${package.path}');
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
          //print("Processing Package: $package");
          if (package is Directory) {
            final pubspecPath = '${package.path}/pubspec.yaml';
            final pubspecFile = File(pubspecPath);
            if (pubspecFile.existsSync()) {
              updateDependencyVersion(
                  pubspecFilePath: pubspecPath,
                  moduleName: moduleName,
                  versionChange: VersionChange.major);
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
  final status =
  await executeCommand('git', ['status', '--porcelain', packagePath]);
  if(status.isNotEmpty){
    print("Has Uncommited Changes: ${status.isNotEmpty} in Package Path: $packagePath");
  }
  return status.isNotEmpty;
}

void updateDependencyVersion({
  required String pubspecFilePath,
  required String moduleName,
  required VersionChange versionChange,
}) {
  final pubspecFile = File(pubspecFilePath);
  String pubspecContent = pubspecFile.readAsStringSync();

  //final regex = RegExp('  $moduleName: ([0-9]+.[0-9]+.[0-9]+)');
  final regex = RegExp('  $moduleName: (\\^?[0-9]+\\.[0-9]+\\.[0-9]+)');

  final currentVersionMatch = regex.firstMatch(pubspecContent);


  if (currentVersionMatch != null) {
    final currentVersion = Version.parse(currentVersionMatch.group(1)!.replaceAll("^", ""));
    final newVersionInMap = updatedPackages[moduleName];
    if (newVersionInMap != null && currentVersion.toString() == newVersionInMap) {
      // The version has already been updated, skip the updates
      print('Dependency $moduleName in $pubspecFilePath is already updated to $newVersionInMap. Skipping update.');
      return;
    }

    Version newVersion;

    switch (versionChange) {
      case VersionChange.major:
        newVersion = currentVersion.nextMajor;
        break;
      case VersionChange.minor:
        newVersion = currentVersion.nextMinor;
        break;
      case VersionChange.patch:
        newVersion = currentVersion.nextPatch;
        break;
    }
    final currentVersionString = currentVersionMatch.group(1)!;
    final isCaretVersion = currentVersionString.startsWith('^');
    // If it's a caret version, only update if it's a major version change.
    if (isCaretVersion && versionChange != VersionChange.major) {
      print('Skipping non-major version update for caret version of $moduleName in $pubspecFilePath ');
      return;
    }

    if(isCaretVersion){
      // Replace the current version with the new version in the pubspec content.
      pubspecContent = pubspecContent.replaceFirst(currentVersionMatch.group(0)!,
          '  $moduleName: ^${newVersion.toString()}');
    }else{
      // Replace the current version with the new version in the pubspec content.
      pubspecContent = pubspecContent.replaceFirst(currentVersionMatch.group(0)!,
          '  $moduleName: ${newVersion.toString()}');
    }

    // Write the updated content to the pubspec file.
    pubspecFile.writeAsStringSync(pubspecContent);
    print('Updated1 $moduleName version to $newVersion in $pubspecFilePath');
  } else {
    print('Updated1 Version string for $moduleName not found in $pubspecFilePath');
  }
}
