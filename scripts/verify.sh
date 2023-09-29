#!/bin/bash
tag=$(git describe --tags --abbrev=0)

PROJECTS_PATH=".."
# Find all directories that contain a pubspec.yaml file (assuming these are Flutter projects)
FLUTTER_PROJECT_DIRS=$(find "$PROJECTS_PATH" -name "pubspec.yaml" -exec dirname {} \;)
# Iterate through each project directory and run 'flutter pub get'
for dir in $FLUTTER_PROJECT_DIRS; do
    echo "Checking Any Changes after Last Tag in $dir"
    if git diff --quiet "$tag" -- "$dir"; then
      echo "No changes to package since last tag. Aborting publish."
      exit 1
    fi
done