#!/bin/bash

# Define the path to the modules directory
MODULES_DIR="packages"

# Determine the version bump type (major, minor, patch)
BUMP_TYPE=${1:-"minor"}

# Function to bump versions according to Semantic Versioning
bump_version() {
  local current_version=$1
  echo "Current version: $current_version"
  local IFS='.'
  local -a parts=($current_version)

  case "$BUMP_TYPE" in
    major)
      parts[0]=$((parts[0] + 1))
      parts[1]=0
      parts[2]=0
      ;;
    minor)
      parts[1]=$((parts[1] + 1))
      parts[2]=0
      ;;
    patch)
      parts[2]=$((parts[2] + 1))
      ;;
    *)
      echo "Error: Invalid bump type. Must be 'major', 'minor', or 'patch'."
      exit 1
      ;;
  esac

  echo "${parts[0]}.${parts[1]}.${parts[2]}"
}

for MODULE_DIR in $MODULES_DIR/*/
do
  echo "Processing module in $MODULE_DIR"
  for PACKAGE_DIR in $MODULE_DIR*/
  do
    PUBSPEC="$PACKAGE_DIR/pubspec.yaml"
    # Check if there are any changes in the git repository within the package directory
    if git diff --quiet HEAD $PACKAGE_DIR; then
      echo ""
      #echo "No changes detected in $PACKAGE_DIR"
    else
      echo "Changes detected in $PACKAGE_DIR"
      # Get current version from pubspec.yaml
      current_version=$(grep 'version:' $PUBSPEC | awk '{print $2}')
      if [[ ! $current_version ]]; then
        echo "No version found in $PUBSPEC"
        continue
      fi
      # Calculate the new version
      new_version=$(bump_version $current_version)
      # Update pubspec.yaml with the new version
      sed -i '' -E "s/version: [[:space:]]*$current_version/version: $new_version/" "$PUBSPEC"
      if [ $? -eq 0 ]; then
        echo "Updated $PUBSPEC to $new_version"
      else
        echo "Failed to update $PUBSPEC"
      fi
    fi
  done
done

echo "Version update complete."