$ErrorActionPreference = "Stop"
$WorkingDir = "C:\Users\sam\Desktop\kk-20260223T185707Z-3-001\kk\icanteen-android"
$AndroidHome = "$WorkingDir\android-sdk"
$CmdLineToolsZip = "$WorkingDir\cmdline-tools.zip"
$GradleZip = "$WorkingDir\gradle.zip"
$GradleDir = "$WorkingDir\gradle-7.6.3"
$JdkZip = "$WorkingDir\jdk-17.zip"
$JdkDir = "$WorkingDir\jdk-17"

Write-Host "Setting up Android Build Environment..." -ForegroundColor Cyan

# 1. Download Command Line Tools
if (-not (Test-Path "$AndroidHome\cmdline-tools\latest\bin\sdkmanager.bat")) {
    Write-Host "Downloading Android SDK Command Line Tools..."
    if (-not (Test-Path $CmdLineToolsZip)) {
        Invoke-WebRequest -Uri "https://dl.google.com/android/repository/commandlinetools-win-11479570_latest.zip" -OutFile $CmdLineToolsZip
    }
    Write-Host "Extracting Command Line Tools..."
    Expand-Archive -Path $CmdLineToolsZip -DestinationPath "$AndroidHome\cmdline-tools" -Force
    Rename-Item -Path "$AndroidHome\cmdline-tools\cmdline-tools" -NewName "latest"
}

# 2. Setup Environment Variables for this session
$env:ANDROID_HOME = $AndroidHome

# 3. Bypass sdkmanager and let Gradle download the SDK by creating license files
Write-Host "Accepting licenses automatically..."
$LicensesDir = "$AndroidHome\licenses"
if (-not (Test-Path $LicensesDir)) {
    New-Item -ItemType Directory -Path $LicensesDir -Force | Out-Null
}
Set-Content -Path "$LicensesDir\android-sdk-license" -Value "24333f8a63b6825ea9c5514f83c2829b004d1fee`n84831b9409646a918e30573bab4c9c91346d8abd`n504667f4c0de7af1a06de9f4b1727b84351f2910"
Set-Content -Path "$LicensesDir\android-sdk-preview-license" -Value "84831b9409646a918e30573bab4c9c91346d8abd"
Set-Content -Path "$LicensesDir\android-googletv-license" -Value "601085b94cd77f0b54ff86406957099ebe79c4d6"
Set-Content -Path "$LicensesDir\android-sdk-arm-dbt-license" -Value "859f317696f67ef3d7f30a50a5560e7834b43903"
Set-Content -Path "$LicensesDir\mips-android-sysimage-license" -Value "e9acab5b5fba56d5a04c7190022c10827292c941"

# 4. Download Gradle
if (-not (Test-Path "$GradleDir\bin\gradle.bat")) {
    Write-Host "Downloading Gradle 7.6.3..."
    if (-not (Test-Path $GradleZip)) {
        Invoke-WebRequest -Uri "https://services.gradle.org/distributions/gradle-7.6.3-bin.zip" -OutFile $GradleZip
    }
    Write-Host "Extracting Gradle..."
    Expand-Archive -Path $GradleZip -DestinationPath $WorkingDir -Force
}

$env:PATH += ";$GradleDir\bin"

# 5. Download Portable JDK 17
if (-not (Test-Path "$JdkDir\bin\java.exe")) {
    Write-Host "Downloading Portable OpenJDK 17..."
    if (-not (Test-Path $JdkZip)) {
        # Eclipse Temurin 17 Windows x64 zip
        Invoke-WebRequest -Uri "https://github.com/adoptium/temurin17-binaries/releases/download/jdk-17.0.10%2B7/OpenJDK17U-jdk_x64_windows_hotspot_17.0.10_7.zip" -OutFile $JdkZip
    }
    Write-Host "Extracting JDK 17..."
    Expand-Archive -Path $JdkZip -DestinationPath $WorkingDir -Force
    # The zip usually extracts to a folder with the version name, rename it to just jdk-17
    $ExtractedFolder = Get-ChildItem -Path $WorkingDir -Directory -Filter "jdk-17*" | Select-Object -First 1
    if ($ExtractedFolder.Name -ne "jdk-17") {
        Rename-Item -Path $ExtractedFolder.FullName -NewName "jdk-17"
    }
}

$env:JAVA_HOME = $JdkDir
$env:PATH = "$JdkDir\bin;" + $env:PATH

# 6. Build Project
Write-Host "Building APK..." -ForegroundColor Cyan
Set-Location $WorkingDir
gradle clean assembleDebug

if ($?) {
    Write-Host "Build Successful! APK is located in app\build\outputs\apk\debug\" -ForegroundColor Green
} else {
    Write-Host "Build Failed." -ForegroundColor Red
}
