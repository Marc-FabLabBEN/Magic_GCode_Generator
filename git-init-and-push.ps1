$GITHUB_URL = "https://github.com/Marc-FabLabBEN/Magic_GCode_Generator.git"

if (Test-Path ".git") {
    Remove-Item -Recurse -Force ".git"
}

git init -b main
git config user.name "Marc FONTAINE"
git config user.email "marcfontaine33@gmail.com"
git add .
git commit -m "Initial commit - GCode 3D Generator v1.3"
git remote add origin $GITHUB_URL
git push -u origin main
