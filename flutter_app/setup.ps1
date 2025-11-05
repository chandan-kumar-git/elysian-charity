# Elysian Chain Flutter Setup Script
# Run this script to set up Flutter and run the application

Write-Host "🚀 Elysian Chain - Flutter Setup" -ForegroundColor Cyan
Write-Host "=================================" -ForegroundColor Cyan
Write-Host ""

# Check if Flutter is already in PATH
$flutterExists = Get-Command flutter -ErrorAction SilentlyContinue

if ($flutterExists) {
    Write-Host "✅ Flutter found in PATH" -ForegroundColor Green
    flutter --version
} else {
    Write-Host "⚠️  Flutter not found in PATH" -ForegroundColor Yellow
    Write-Host ""
    
    # Check if Flutter SDK exists in Desktop
    $flutterPath = "C:\Users\CHANDAN\Desktop\flutter"
    
    if (Test-Path $flutterPath) {
        Write-Host "✅ Flutter SDK found at: $flutterPath" -ForegroundColor Green
        Write-Host "📝 Adding Flutter to PATH..." -ForegroundColor Yellow
        
        # Add to current session PATH
        $env:PATH += ";$flutterPath\bin"
        
        Write-Host "✅ Flutter added to current session PATH" -ForegroundColor Green
        Write-Host ""
        Write-Host "💡 To make this permanent, add the following to your PowerShell profile:" -ForegroundColor Cyan
        Write-Host "   `$env:PATH += ';$flutterPath\bin'" -ForegroundColor White
        Write-Host ""
        
        # Verify Flutter
        flutter --version
    } else {
        Write-Host "❌ Flutter SDK not found" -ForegroundColor Red
        Write-Host ""
        Write-Host "Please download Flutter from:" -ForegroundColor Yellow
        Write-Host "https://docs.flutter.dev/get-started/install/windows" -ForegroundColor Cyan
        Write-Host ""
        Write-Host "Or run the download command:" -ForegroundColor Yellow
        Write-Host "Invoke-WebRequest -Uri 'https://storage.googleapis.com/flutter_infra_release/releases/stable/windows/flutter_windows_3.24.5-stable.zip' -OutFile 'flutter.zip'" -ForegroundColor White
        Write-Host "Expand-Archive flutter.zip -DestinationPath C:\Users\CHANDAN\Desktop\" -ForegroundColor White
        exit 1
    }
}

Write-Host ""
Write-Host "🔧 Setting up Flutter project..." -ForegroundColor Cyan

# Navigate to project directory
Set-Location "C:\Users\CHANDAN\Desktop\blockchain\flutter_app"

Write-Host "📦 Running flutter pub get..." -ForegroundColor Yellow
flutter pub get

if ($LASTEXITCODE -eq 0) {
    Write-Host "✅ Dependencies installed successfully" -ForegroundColor Green
} else {
    Write-Host "❌ Failed to install dependencies" -ForegroundColor Red
    exit 1
}

Write-Host ""
Write-Host "🌐 Checking for Chrome..." -ForegroundColor Cyan
flutter devices

Write-Host ""
Write-Host "🎨 Ready to launch!" -ForegroundColor Green
Write-Host ""
Write-Host "Run one of these commands:" -ForegroundColor Cyan
Write-Host "  flutter run -d chrome              # Launch in Chrome" -ForegroundColor White
Write-Host "  flutter run -d chrome --release    # Launch optimized build" -ForegroundColor White
Write-Host "  flutter build web                  # Build for production" -ForegroundColor White
Write-Host ""

# Ask if user wants to launch now
$launch = Read-Host "Launch app in Chrome now? (y/n)"
if ($launch -eq 'y' -or $launch -eq 'Y') {
    Write-Host ""
    Write-Host "🚀 Launching Elysian Chain Dashboard..." -ForegroundColor Cyan
    flutter run -d chrome
}

Write-Host ""
Write-Host "✨ Setup complete! Enjoy your premium Flutter dashboard!" -ForegroundColor Green