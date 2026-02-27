$ErrorActionPreference = "Stop"

# Use relative paths based on script location
$workspace = $PSScriptRoot
$androidProjectPath = "$workspace\icanteen-android"

Write-Host ">>> Starting iCanteen Portable Build Setup..." -ForegroundColor Cyan
Set-Location $workspace

# 1. Download and Extract OpenJDK 17
$jdkDir = "$workspace\jdk-17"
if (!(Test-Path $jdkDir)) {
    Write-Host ">>> Downloading OpenJDK 17..." -ForegroundColor Yellow
    $jdkUrl = "https://download.java.net/java/GA/jdk17.0.2/dfd4a8d0985749f896bed50d7138ee7f/8/GPL/openjdk-17.0.2_windows-x64_bin.zip"
    $jdkZip = "$workspace\jdk-17.zip"
    Invoke-WebRequest -Uri $jdkUrl -OutFile $jdkZip
    Write-Host ">>> Extracting OpenJDK 17..." -ForegroundColor Yellow
    Expand-Archive -Path $jdkZip -DestinationPath $workspace -Force
    # OpenJDK zip contains a folder naming like jdk-17.0.2
    $extractedFolder = Get-ChildItem -Path $workspace -Filter "jdk-17*" -Directory | Where-Object { $_.Name -ne "jdk-17" } | Select-Object -First 1
    if ($extractedFolder) { Rename-Item -Path $extractedFolder.FullName -NewName "jdk-17" }
    Remove-Item -Path $jdkZip
}
$env:JAVA_HOME = $jdkDir
$env:Path = "$jdkDir\bin;" + $env:Path
Write-Host ">>> Java configured: $env:JAVA_HOME"

# 2. Setup Android SDK
$sdkDir = "$workspace\android-sdk"
$cmdlineToolsDir = "$sdkDir\cmdline-tools\latest"

if (!(Test-Path $cmdlineToolsDir)) {
    Write-Host ">>> Setting up Android SDK and Command Line Tools..." -ForegroundColor Yellow
    if (!(Test-Path "$sdkDir\cmdline-tools")) {
        New-Item -ItemType Directory -Force -Path "$sdkDir\cmdline-tools" | Out-Null
        $cmdlineUrl = "https://dl.google.com/android/repository/commandlinetools-win-11076708_latest.zip"
        $cmdlineZip = "$workspace\cmdline-tools.zip"
        Write-Host ">>> Downloading Android Command Line Tools..." -ForegroundColor Yellow
        Invoke-WebRequest -Uri $cmdlineUrl -OutFile $cmdlineZip
        Expand-Archive -Path $cmdlineZip -DestinationPath "$sdkDir\cmdline-tools" -Force
        Remove-Item -Path $cmdlineZip
    }
    
    # Structure fix: sdkmanager expects to be in cmdline-tools/latest/bin
    if (!(Test-Path $cmdlineToolsDir)) {
        New-Item -ItemType Directory -Force -Path $cmdlineToolsDir | Out-Null
        $extractedItems = Get-ChildItem -Path "$sdkDir\cmdline-tools" -Exclude "latest"
        foreach ($item in $extractedItems) {
            Move-Item -Path $item.FullName -Destination $cmdlineToolsDir
        }
    }
}

$env:ANDROID_HOME = $sdkDir
$env:ANDROID_SDK_ROOT = $sdkDir
$sdkmanager = "$cmdlineToolsDir\bin\sdkmanager.bat"

Write-Host ">>> Accepting SDK Licenses..." -ForegroundColor Yellow
$licenseAccept = "y`n" * 15
$licenseAccept | & $sdkmanager --licenses --sdk_root=$sdkDir | Out-Null

Write-Host ">>> Installing Build Tools and Platforms (API 33)..." -ForegroundColor Yellow
& $sdkmanager "platforms;android-33" "build-tools;33.0.2" "platform-tools" --sdk_root=$sdkDir | Out-Null

# 3. Generating Keystore (If missing)
$keystorePath = "$androidProjectPath\iCanteenKeystore.jks"
if (!(Test-Path $keystorePath)) {
    Write-Host ">>> Generating Release Keystore..." -ForegroundColor Yellow
    $keytoolArgs = @(
        "-genkeypair", "-v",
        "-keystore", $keystorePath,
        "-keyalg", "RSA", "-keysize", "2048", "-validity", "10000",
        "-alias", "icanteenkey",
        "-dname", "CN=iCanteen, OU=App, O=iCanteen, L=Prague, ST=CZ, C=CZ",
        "-storepass", "icanteen123", "-keypass", "icanteen123"
    )
    & "$jdkDir\bin\keytool.exe" $keytoolArgs
}

# 4. Download and setup Gradle
$gradleDir = "$workspace\gradle-7.6.4"
if (!(Test-Path $gradleDir)) {
    Write-Host ">>> Downloading Gradle 7.6.4..." -ForegroundColor Yellow
    $gradleZip = "$workspace\gradle-7.6.4.zip"
    Invoke-WebRequest -Uri "https://services.gradle.org/distributions/gradle-7.6.4-bin.zip" -OutFile $gradleZip
    Expand-Archive -Path $gradleZip -DestinationPath $workspace -Force
    Remove-Item -Path $gradleZip
}

Write-Host ">>> Syncing Web Assets to Android Project..." -ForegroundColor Yellow
$webDest = "$androidProjectPath\app\src\main\assets\web"
if (Test-Path $webDest) { Remove-Item -Recurse -Force $webDest }
New-Item -ItemType Directory -Force -Path $webDest | Out-Null
Copy-Item -Path "$workspace\icanteen\*" -Destination $webDest -Recurse -Force

Write-Host ">>> Building Production APK..." -ForegroundColor Cyan
Set-Location $androidProjectPath
$gradleBin = "$gradleDir\bin\gradle.bat"
& $gradleBin assembleRelease

if ($LASTEXITCODE -eq 0) {
    $apkPath = "$androidProjectPath\app\build\outputs\apk\release\app-release.apk"
    Copy-Item -Path $apkPath -Destination "$workspace\iCanteen.apk" -Force
    Write-Host "`n>>> SUCCESS! APK: $workspace\iCanteen.apk" -ForegroundColor Green
}
else {
    Write-Host "`n>>> ERROR: Build failed. Check the logs above." -ForegroundColor Red
}
