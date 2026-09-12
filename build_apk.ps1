$env:GRADLE_USER_HOME = "D:\.gradle"
$env:TEMP = "D:\temp"
$env:TMP = "D:\temp"
Set-Location "D:\project\mywatchlist"
Write-Host "Starting flutter build apk --release with GRADLE_USER_HOME on D:\.gradle..."
flutter build apk --release
