# Flutter Android V1 -> V2 Embedding Patch (Best-effort)

This package contains a safe, **best-effort** patch script to convert an Android Flutter project
that uses the **old V1 embedding** to the **V2 embedding** (so it can build with modern Flutter versions).

IMPORTANT: This script tries to find and patch common patterns, but it **cannot** guarantee a perfect automatic conversion
for every project. Always backup or commit your repository *before* running the script.

## What's included
- `patch_to_v2.sh` : A bash script that searches for `io.flutter.app.FlutterActivity` and `io.flutter.app.FlutterApplication`
  and replaces them with `io.flutter.embedding.android.FlutterActivity` and removes the `FlutterApplication` reference in `AndroidManifest.xml`.
- `example_MainActivity.java` : Minimal example of what a V2 `MainActivity` should look like.

## How to use
1. Download this ZIP and extract at your local machine.
2. Copy `patch_to_v2.sh` to the root of your repository (where the `.git` folder is), or run it from this extracted folder if your repository is nearby.
3. Make it executable:
   ```bash
   chmod +x patch_to_v2.sh
   ```
4. (Optional but recommended) Create a git commit so you can revert if needed:
   ```bash
   git add .
   git commit -m "WIP: before embedding v2 patch"
   ```
5. Run the script:
   ```bash
   ./patch_to_v2.sh
   ```
6. Inspect the changed files (especially the files under `android/app/src/main/java/` and `android/app/src/main/AndroidManifest.xml`).
7. Run locally:
   ```bash
   flutter clean
   flutter pub get
   flutter build apk --release
   ```

## If the script doesn't fully fix the project
- Open `android/app/src/main/java/.../MainActivity.java` (or `.kt`) and ensure the contents match the example in `example_MainActivity.java`.
- Replace the package declaration line `package com.example.yourapp;` with your actual package name.
- Remove any references to `FlutterApplication` in `AndroidManifest.xml`.

## Notes
- This is a minimal, conservative automated approach. Some plugins or custom native code may still rely on V1 APIs and need manual migration.
- If you want, I can perform the changes directly inside your repository files (you'd need to allow or provide the exact package path). I can also generate a full PR patch if you prefer.
