#!/usr/bin/env bash
set -euo pipefail
echo "Starting patch to convert Android v1 embedding -> v2 embedding (best-effort)"
ROOT="$PWD"
APP_DIRS=(
  "hok_regl_full_ready/hok_regl_android_fixed/android/app/src/main/java"
  "android/app/src/main/java"
)
FOUND=false

for d in "${APP_DIRS[@]}"; do
  if [ -d "$d" ]; then
    echo "Scanning $d for Java/Kotlin files..."
    # Find files containing the old import
    files=$(grep -R --line-number -l "io.flutter.app.FlutterActivity" "$d" || true)
    for f in $files; do
      echo "Patching Java file: $f"
      FOUND=true
      # Replace import line
      sed -i 's/import io.flutter.app.FlutterActivity;/import io.flutter.embedding.android.FlutterActivity;/' "$f"
      # Ensure class declaration uses FlutterActivity from embedding v2
      # Replace 'extends FlutterActivity' lines left as-is (import fixed)
      # Remove any usage of FlutterApplication in code (best-effort)
      sed -i 's/extends io.flutter.app.*/extends FlutterActivity/' "$f" || true
    done

    # Kotlin files: look for io.flutter.app.FlutterActivity usage and replace imports
    kfiles=$(grep -R --line-number -l "io.flutter.app.FlutterActivity" "$d" || true)
    for kf in $kfiles; do
      echo "Patching Kotlin file: $kf"
      FOUND=true
      sed -i 's/import io.flutter.app.FlutterActivity/import io.flutter.embedding.android.FlutterActivity/' "$kf"
    done

    # AndroidManifest.xml: remove android:name="io.flutter.app.FlutterApplication" if present
    manifest="$d/../../AndroidManifest.xml"
    if [ -f "$manifest" ]; then
      if grep -q 'io.flutter.app.FlutterApplication' "$manifest"; then
        echo "Removing io.flutter.app.FlutterApplication from $manifest"
        FOUND=true
        # Remove the android:name attribute that references the FlutterApplication
        sed -i 's/ android:name="io.flutter.app.FlutterApplication"//g' "$manifest"
      fi
    fi
  fi
done

if [ "$FOUND" = false ]; then
  echo "No obvious v1 embeddings found in scanned directories. You may need to run this script from repo root or adjust APP_DIRS in the script."
  exit 0
fi

echo "Patch complete. Please review changes, run 'flutter clean' and then 'flutter pub get' and try building."
echo "If MainActivity still relies on old APIs, open the activity file and ensure it looks like this (example provided in example_MainActivity.java):"
echo "  - Java example: class MainActivity extends FlutterActivity {}"
echo "  - Kotlin example: class MainActivity: FlutterActivity()"
exit 0
