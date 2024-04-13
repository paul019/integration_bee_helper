echo "Starting the export"
flutter build web
rm -rf docs
mkdir docs
mv build/web/{.,}* docs/
sed -i '' 's,<base href="/">,,g' docs/index.html
rmdir build/web