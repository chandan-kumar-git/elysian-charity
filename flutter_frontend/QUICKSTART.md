# 🚀 Quick Start Guide

## Installation (First Time Only)

### Windows
```powershell
# 1. Download Flutter SDK from:
# https://docs.flutter.dev/get-started/install/windows

# 2. Extract to C:\src\flutter

# 3. Add to PATH:
# C:\src\flutter\bin

# 4. Verify installation
flutter doctor
```

### macOS/Linux
```bash
# Install via snap (Linux)
sudo snap install flutter --classic

# Or download from flutter.dev
# Then verify:
flutter doctor
```

## Run the App (Every Time)

```bash
# Navigate to project
cd flutter_frontend

# Install dependencies (first time)
flutter pub get

# Run on web (recommended)
flutter run -d chrome

# Or run on Android/iOS/Windows
flutter devices          # List available devices
flutter run -d android   # Run on Android
flutter run -d ios       # Run on iOS
flutter run -d windows   # Run on Windows
```

## Common Commands

```bash
# Hot reload changes (while running)
r

# Hot restart (while running)
R

# Quit app
q

# Clean build files
flutter clean

# List connected devices
flutter devices

# Check Flutter setup
flutter doctor

# Build for production
flutter build web
flutter build apk
```

## Troubleshooting

### "Flutter not found"
- Verify Flutter is in system PATH
- Restart terminal
- Run `flutter doctor`

### "No devices available"
- For web: Install Chrome
- For Android: Start Android emulator
- For iOS: Use macOS with Xcode

### "Pub get failed"
```bash
flutter pub cache repair
flutter pub get
```

### "Build failed"
```bash
flutter clean
flutter pub get
flutter run -d chrome
```

## Project Files

```
lib/
├── main.dart                          # App entry
├── screens/dashboard_screen.dart      # Main screen
├── services/
│   ├── wallet_service.dart            # Web3 wallet
│   └── contract_service.dart          # Contract
└── widgets/                           # UI components
    ├── phone_container.dart
    ├── contract_balance_card.dart
    ├── transaction_preview.dart
    ├── metamask_prompt.dart
    ├── donation_modal.dart
    ├── admin_panel_modal.dart
    └── transaction_ledger_modal.dart
```

## Key Features

✅ CoinWave design replica
✅ Web3 wallet integration
✅ Donation system
✅ Admin panel
✅ Transaction history
✅ Live charts
✅ Smooth animations
✅ Mobile responsive

## Customization

### Change Colors
Edit the `Color(0xFFxxxxxx)` values in widget files:
- Green: `0xFF4ade80`
- Orange: `0xFFfb923c`
- Blue: `0xFF3b82f6`

### Change Text
Edit strings in `dashboard_screen.dart`:
- "Elysian Chain"
- "Contract Health"
- Status bar text

### Connect Real Blockchain
Update `wallet_service.dart` and `contract_service.dart`:
- Add contract ABI
- Configure RPC URL
- Implement Web3 calls

## Getting Help

- 📚 Documentation: README.md, SETUP.md
- 🌐 Flutter Docs: https://docs.flutter.dev/
- 💬 Discord: https://discord.gg/flutter
- 📺 YouTube: Flutter's official channel

## Status

✅ **Complete** - All components built
⏳ **Mock Data** - Ready for real Web3 connection

---

**Quick Links:**
- [Full README](README.md) - Complete documentation
- [Setup Guide](SETUP.md) - Installation instructions

**Run Now:**
```bash
cd flutter_frontend
flutter pub get
flutter run -d chrome
```

🎉 **That's it! Your CoinWave-styled Elysian Chain dashboard is ready!**
