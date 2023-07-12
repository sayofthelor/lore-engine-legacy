cd crash-dialog
echo "Building crash dialog..."
haxelib run lime build linux
cp build/openfl/linux/bin/CrashDialog ../export/final/linux/bin/CrashDialog
cd ..