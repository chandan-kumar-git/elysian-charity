# Flutter Frontend Setup Guide

## Quick Start (If Flutter is Already Installed)

```bash
cd flutter_frontend
flutter pub get
flutter run -d chrome
```

## Complete Setup (If Flutter is Not Installed)

### Step 1: Install Flutter

#### Windows

1. **Download Flutter SDK**
   - Visit: https://docs.flutter.dev/get-started/install/windows
   - Download the latest stable release
   - Extract to `C:\src\flutter` (or your preferred location)

2. **Add to PATH**
   - Search for "Environment Variables" in Windows
   - Edit system PATH variable
   - Add: `C:\src\flutter\bin`

3. **Verify Installation**
   ```bash
   flutter doctor
   ```

#### macOS/Linux

```bash
# Install using snap (Linux)
sudo snap install flutter --classic

# Or download manually from
# https://docs.flutter.dev/get-started/install
```

### Step 2: Install Dependencies

Flutter requires additional tools:

1. **Chrome** (for web development)
   - Download from: https://www.google.com/chrome/

2. **Visual Studio Code** (recommended)
   - Download from: https://code.visualstudio.com/
   - Install Flutter extension
   - Install Dart extension

3. **Android Studio** (for mobile)
   - Download from: https://developer.android.com/studio
   - Install Android SDK
   - Configure emulator

### Step 3: Run Flutter Doctor

```bash
flutter doctor
```

This command checks your environment and displays a report. Fix any issues it identifies:

- ✓ Flutter SDK
- ✓ Chrome (web)
- ✓ Visual Studio Code
- ✓ Android Studio (optional)

### Step 4: Install Project Dependencies

```bash
cd flutter_frontend
flutter pub get
```

### Step 5: Run the App

#### Web (Easiest - No Emulator Needed)
```bash
flutter run -d chrome
```

#### Android Emulator
```bash
# List available devices
flutter devices

# Run on Android
flutter run -d android
```

#### Windows Desktop
```bash
flutter run -d windows
```

## Troubleshooting

### "Flutter command not found"

**Windows:**
1. Verify Flutter is in PATH
2. Restart PowerShell/CMD
3. Run `refreshenv` (if using Chocolatey)

**macOS/Linux:**
```bash
# Add to ~/.bashrc or ~/.zshrc
export PATH="$PATH:`pwd`/flutter/bin"
source ~/.bashrc  # or ~/.zshrc
```

### "Chrome not found"

```bash
# Set Chrome path manually
flutter config --chrome-executable="C:\Program Files\Google\Chrome\Application\chrome.exe"
```

### "No devices available"

For web development:
```bash
flutter config --enable-web
flutter devices
```

For Android:
1. Open Android Studio
2. Tools → AVD Manager
3. Create Virtual Device
4. Start emulator

### "pub get failed"

```bash
# Clear pub cache
flutter pub cache repair

# Try again
flutter pub get
```

### "Build failed"

```bash
# Clean build files
flutter clean

# Get dependencies
flutter pub get

# Run again
flutter run -d chrome
```

## IDE Setup

### Visual Studio Code (Recommended)

1. **Install Extensions**
   - Flutter (by Dart Code)
   - Dart (by Dart Code)
   
2. **Open Project**
   ```bash
   cd flutter_frontend
   code .
   ```

3. **Run/Debug**
   - Press F5 to start debugging
   - Or use "Run → Start Debugging"
   - Select "Chrome" as device

### Android Studio

1. **Open Project**
   - File → Open
   - Navigate to `flutter_frontend` folder

2. **Run**
   - Select device from dropdown
   - Click green play button

## Without Flutter Installation

If you cannot install Flutter, you can:

1. **Use the Next.js version** (already in your project)
   ```bash
   cd nextjs_frontend
   npm install
   npm run dev
   ```

2. **Use Online Flutter IDE**
   - DartPad: https://dartpad.dev/
   - FlutLab: https://flutlab.io/
   - Copy the code files to online IDE

3. **Request Build**
   - Share your code with someone who has Flutter
   - They can build APK/Web for you

## System Requirements

### Minimum
- OS: Windows 10+, macOS 10.14+, Linux
- RAM: 4GB
- Disk: 2.5GB for Flutter SDK
- Display: 1280x800 minimum

### Recommended
- RAM: 8GB+
- SSD storage
- Multi-core processor
- 1920x1080 display

## Quick Commands Reference

```bash
# Get packages
flutter pub get

# Run on web
flutter run -d chrome

# Run on mobile
flutter run -d android

# Hot reload (while running)
Press 'r' in terminal

# Hot restart (while running)
Press 'R' in terminal

# Open DevTools
Press 'd' in terminal

# List devices
flutter devices

# Check setup
flutter doctor

# Clean build
flutter clean

# Build for production
flutter build web
flutter build apk
```

## Alternative: Docker Setup (Advanced)

If you want to use Docker:

```dockerfile
# Dockerfile
FROM ghcr.io/cirruslabs/flutter:stable

WORKDIR /app
COPY . .
RUN flutter pub get

CMD ["flutter", "run", "-d", "web-server", "--web-port=8080", "--web-hostname=0.0.0.0"]
```

```bash
docker build -t elysian-flutter .
docker run -p 8080:8080 elysian-flutter
```

## Next Steps

Once the app is running:

1. ✅ Explore the dashboard
2. ✅ Test MetaMask prompt
3. ✅ Try donation modal
4. ✅ View transaction history
5. ✅ Test admin panel (if owner)
6. ✅ Customize colors/branding
7. ✅ Connect to real blockchain

## Getting Help

- Flutter Docs: https://docs.flutter.dev/
- Flutter Discord: https://discord.gg/flutter
- Stack Overflow: [flutter] tag
- Flutter Subreddit: r/FlutterDev

## Project Status

✅ **Complete** - All components implemented
- Dashboard with CoinWave design
- Web3 wallet service
- Contract interaction service
- All modals and widgets
- Animations and transitions
- Mobile-responsive design

🔄 **Mock Data** - Currently using simulated data
- Ready for real Web3 integration
- Contract calls can be hooked up
- MetaMask can be connected

## File Checklist

Make sure these files exist:

```
✅ pubspec.yaml
✅ lib/main.dart
✅ lib/screens/dashboard_screen.dart
✅ lib/services/wallet_service.dart
✅ lib/services/contract_service.dart
✅ lib/widgets/phone_container.dart
✅ lib/widgets/contract_balance_card.dart
✅ lib/widgets/transaction_preview.dart
✅ lib/widgets/metamask_prompt.dart
✅ lib/widgets/donation_modal.dart
✅ lib/widgets/admin_panel_modal.dart
✅ lib/widgets/transaction_ledger_modal.dart
```

---

Need help? Check the main README.md for more details!
