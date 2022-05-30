cd crash-dialog
echo "Building crash dialog..."
lime build linux
cp build/openfl/linux/bin/CrashDialog ../export/release/linux/bin/CrashDialog
cd ..