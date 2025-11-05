# Elysian Chain - Flutter Frontend

A beautiful, modern Flutter frontend for the Elysian Chain donation contract. This is a complete visual replica of the CoinWave design, adapted for your blockchain project.

## Features

- 🎨 **CoinWave Design** - Pixel-perfect recreation of the CoinWave UI
- 📱 **Mobile-First** - Phone container design for optimal mobile experience
- 🔗 **Web3 Integration** - Full Web3 wallet connectivity with MetaMask support
- 📊 **Live Charts** - Real-time contract balance visualization with fl_chart
- ✨ **Smooth Animations** - Flutter Animate for delightful interactions
- 🎯 **Admin Panel** - Secure admin access for contract owner
- 📜 **Transaction History** - Complete ledger with copy-to-clipboard
- 💰 **Donation System** - Easy donation flow with quick amounts

## Project Structure

```
lib/
├── main.dart                          # App entry point
├── screens/
│   └── dashboard_screen.dart          # Main dashboard with all components
├── services/
│   ├── wallet_service.dart            # Web3 wallet management
│   └── contract_service.dart          # Contract interactions
└── widgets/
    ├── phone_container.dart           # Phone-style container wrapper
    ├── contract_balance_card.dart     # Balance display with chart
    ├── transaction_preview.dart       # Recent transactions widget
    ├── metamask_prompt.dart           # MetaMask installation prompt
    ├── donation_modal.dart            # Donation modal dialog
    ├── admin_panel_modal.dart         # Admin withdrawal panel
    └── transaction_ledger_modal.dart  # Full transaction history
```

## Prerequisites

- Flutter SDK (3.0 or higher)
- Dart SDK
- Android Studio / VS Code with Flutter extensions (for mobile)
- Chrome (for web)

## Installation

1. Navigate to the Flutter frontend directory:
```bash
cd flutter_frontend
```

2. Install dependencies:
```bash
flutter pub get
```

3. Check your Flutter installation:
```bash
flutter doctor
```

## Running the App

### Web (Recommended for Development)
```bash
flutter run -d chrome
```

### Android
```bash
flutter run -d android
```

### iOS
```bash
flutter run -d ios
```

### Windows
```bash
flutter run -d windows
```

## Configuration

The app uses mock data by default. To connect to your actual blockchain:

1. Update `lib/services/wallet_service.dart`:
   - Configure your RPC URL
   - Set correct contract address
   - Update owner address

2. Update `lib/services/contract_service.dart`:
   - Add real contract ABI
   - Implement actual Web3 calls
   - Connect to blockchain network

## Mock Data

The app currently runs with simulated data:
- **Contract Balance**: 25.567 ETH
- **Lifetime Donations**: 142.340 ETH
- **Sample Transactions**: 4 mock transactions
- **Wallet Connection**: Simulated Web3 connectivity

## Key Components

### Dashboard Screen
The main screen featuring:
- Gradient background with ambient lighting
- Phone container for mobile-first design
- Status bar showing chain info
- Wallet connector button
- Admin settings (visible to contract owner only)
- Contract balance card with interactive chart
- Transaction preview with "View All" link

### Wallet Service
Manages Web3 connectivity:
- MetaMask detection
- Wallet connection simulation
- Admin access control
- Address formatting utilities

### Contract Service
Handles blockchain interactions:
- Balance tracking
- Donation processing
- Withdrawal management
- Transaction history
- USD conversion estimates

### Modals
Beautiful, animated modal dialogs:
- **Donation Modal**: ETH amount input with quick amounts
- **Admin Panel**: Withdrawal interface for contract owner
- **Transaction Ledger**: Full transaction history
- **MetaMask Prompt**: Installation guidance

## Design Features

### Colors (Dark Theme)
- Background: `#050816`, `#0b0f2b`, `#101747` (gradient)
- Surface: `#0c0c0c`
- Border: `#262626`
- Text Primary: `#ffffff`
- Text Secondary: `#9ca3af`
- Green (Donations): `#4ade80`
- Orange (Withdrawals): `#fb923c`
- Blue (Info): `#3b82f6`

### Typography
- **Headers**: Font weight 600-700
- **Body**: Font weight 400-500
- **Monospace**: Transaction hashes

### Animations
- Fade in: 300ms
- Slide animations: 400ms
- Scale effects: easeOutBack curve
- Stagger delays: 200ms intervals

## Dependencies

```yaml
dependencies:
  flutter:
    sdk: flutter
  provider: ^6.1.1           # State management
  web3dart: ^2.7.3           # Ethereum Web3 library
  fl_chart: ^0.66.0          # Beautiful charts
  flutter_animate: ^4.5.0    # Smooth animations
  http: ^1.2.0               # HTTP requests
```

## Browser Support (Web)

- Chrome ✅ (Recommended)
- Firefox ✅
- Safari ✅
- Edge ✅

**Note**: MetaMask integration works best on Chrome.

## Mobile Support

- Android 21+ (Lollipop)
- iOS 12+

## Future Enhancements

- [ ] Real Web3 integration with ethers.js/web3dart
- [ ] WalletConnect support
- [ ] Multiple chain support
- [ ] Transaction notifications
- [ ] QR code scanning for addresses
- [ ] Dark/Light theme toggle
- [ ] Multi-language support
- [ ] Export transaction CSV

## Troubleshooting

### "MetaMask not detected"
- Install MetaMask browser extension
- Ensure MetaMask is unlocked
- Refresh the page

### Charts not rendering
- Run `flutter pub get`
- Clear Flutter cache: `flutter clean`
- Rebuild: `flutter run`

### Hot reload issues
- Use `R` for full restart
- Check console for errors
- Restart the app

## Development Tips

1. **Hot Reload**: Press `r` in terminal to hot reload
2. **Hot Restart**: Press `R` for full restart
3. **DevTools**: Press `D` to open Flutter DevTools
4. **Quit**: Press `q` to quit

## Building for Production

### Web
```bash
flutter build web --release
```
Output in `build/web/`

### Android APK
```bash
flutter build apk --release
```
Output in `build/app/outputs/flutter-apk/`

### iOS
```bash
flutter build ios --release
```
Requires Xcode on macOS

## License

MIT License - Feel free to use for your projects!

## Credits

- **Design**: Inspired by CoinWave
- **Framework**: Flutter by Google
- **Web3**: web3dart package
- **Charts**: fl_chart package
- **Animations**: flutter_animate package

---

Built with ❤️ for the Elysian Chain project
