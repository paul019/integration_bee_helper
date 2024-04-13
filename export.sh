echo "Starting the export"
flutter build web
rm -rf docs
mkdir docs
mv build/web/{.,}* docs/
rmdir build/web