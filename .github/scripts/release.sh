#!/bin/bash
# Replace 'YOUR_FLUTTER_PROJECTS_PATH' with the path to your main folder containing all Flutter projects
PROJECTS_PATH="../../"
tagName="${1}"
echo "Tag Fetched - $tagName"
pattern="-v[0-9]+\.[0-9]+\.[0-9]+$"
packageName=$(echo tagName | sed -E "s/$pattern//")
echo "$packageName"

# Find all directories that contain a pubspec.yaml file (assuming these are Flutter projects)
FLUTTER_PROJECT_DIRS=$(find "$PROJECTS_PATH" -name "pubspec.yaml" -exec dirname {} \;)
# Iterate through each project directory and run 'flutter pub get'
for dir in $FLUTTER_PROJECT_DIRS; do
      echo "$dir"
      if [[ "${dir: -${#packageName}}" == "$packageName" ]]; then
      pushd "$dir" > /dev/null
      echo "Running Flutter Pub Publish in $dir"
      flutter pub publish --force
      popd > /dev/null
      fi
done
echo "All Flutter projects updated."
