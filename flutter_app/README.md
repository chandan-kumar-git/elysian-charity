# Elysian Chain - Premium Flutter Dashboard 🚀

A stunning Flutter web application featuring a CoinWave-inspired design with elements from three premium templates:
- **ProfitPilot**: 3D floating golden coins, shimmer effects
- **DeFi Protocol**: Purple gradients, APY displays, risk badges  
- **FluxChain**: Glassmorphism, ambient glows, live transaction feed

## ✨ Features

### 🎨 Premium Design
- **3D Floating Coin Animation**: Smooth rotating Ethereum coin with golden glow
- **Glassmorphism Effects**: Modern translucent UI elements
- **Gradient Cards**: Purple-to-violet gradients with ambient lighting
- **Live Status Indicators**: Pulsing green badges for real-time updates
- **Verified Badge**: Trust indicators with shimmer effects

### 💎 Smart Contract Integration
- Real-time contract balance monitoring
- Live transaction feed with type indicators
- Donation functionality with preset amounts
- Admin panel for contract withdrawals
- MetaMask wallet connection

### 📊 DeFi Metrics
- **24h Volume**: Daily transaction volume tracking
- **APY Display**: Current annual percentage yield
- **TVL (Total Value Locked)**: Total contract value
- **USD Conversion**: Real-time ETH to USD estimates

### 🎭 Animations
- Smooth fade-in transitions
- Slide animations for cards
- Shimmer effects on golden elements
- Pulsing indicators for live data
- Scale animations on interactive elements

## 🛠️ Tech Stack

- **Flutter 3.24.5+**: Cross-platform framework
- **provider ^6.1.1**: State management
- **web3dart ^2.7.3**: Ethereum blockchain interaction
- **flutter_animate ^4.5.0**: Advanced animations
- **fl_chart ^0.66.0**: Beautiful charts (ready for analytics)
- **http ^1.2.0**: API communication
- **intl ^0.19.0**: Number formatting

## 📦 Installation

### Prerequisites
1. Flutter SDK 3.0.0 or higher
2. Chrome browser (for web development)
3. MetaMask extension (for wallet connection)

### Quick Start

1. **Navigate to project**:
   ```powershell
   cd c:\Users\CHANDAN\Desktop\blockchain\flutter_app
   ```

2. **Install dependencies**:
   ```powershell
   flutter pub get
   ```

3. **Run on web**:
   ```powershell
   flutter run -d chrome
   ```

4. **Build for production**:
   ```powershell
   flutter build web
   ```

## 🎯 Project Structure

```
flutter_app/
├── lib/
│   ├── main.dart                          # App entry point with MultiProvider
│   ├── screens/
│   │   └── dashboard_screen.dart         # Main dashboard with ambient effects
│   ├── widgets/
│   │   ├── phone_container.dart          # Responsive phone frame
│   │   ├── enhanced_balance_card.dart    # Main card with 3D coin & stats
│   │   ├── transaction_feed.dart         # Live transaction list
│   │   ├── donation_modal.dart           # Donation dialog
│   │   └── admin_panel_modal.dart        # Admin withdrawal dialog
│   └── services/
│       ├── wallet_service.dart           # MetaMask integration
│       └── contract_service.dart         # Smart contract calls
└── pubspec.yaml                          # Dependencies
```

## 🎨 Design Elements

### Color Palette
- **Primary Purple**: `#7c3aed` (Vibrant violet)
- **Secondary Purple**: `#6d28d9` (Deep violet)
- **Dark Purple**: `#5b21b6` (Rich purple)
- **Golden**: `#fbbf24` (Premium gold)
- **Success Green**: `#22c55e` (Bright green)
- **Background**: `#050816` → `#101747` (Dark gradient)

### Typography
- **Headers**: 28px-36px, Semi-bold/Bold
- **Body**: 14px-16px, Medium
- **Captions**: 10px-12px, Regular
- **Monospace**: For addresses

### Shadows & Glows
- Purple card glow: `blur: 30px, opacity: 0.5`
- Golden coin glow: `blur: 40px, opacity: 0.6`
- Ambient lights: `blur: 100px, spread: 50px`

## 🔗 Smart Contract Integration

### Wallet Connection
```dart
final walletService = Provider.of<WalletService>(context);
await walletService.connectWallet();
```

### Contract Interaction
```dart
final contractService = Provider.of<ContractService>(context);
await contractService.donate('0.5', userAddress);
```

### Admin Functions
```dart
if (walletService.isAdmin) {
  await contractService.withdraw('1.0', adminAddress);
}
```

## 🧪 Testing with TestSprite

### Setup TestSprite
```powershell
# Install TestSprite globally
npm install -g testsprite

# Run tests
testsprite run flutter_app/test
```

### Test Coverage
- Widget rendering tests
- Service interaction tests
- Animation performance tests
- Wallet connection flows
- Contract transaction simulations

## 🚀 Deployment

### Web Hosting
```powershell
# Build optimized web app
flutter build web --release

# Deploy to Firebase Hosting
firebase deploy --only hosting

# Or deploy to GitHub Pages
# Copy build/web/* to gh-pages branch
```

### Environment Variables
Create `.env` file:
```
CONTRACT_ADDRESS=0x...
INFURA_PROJECT_ID=your_project_id
ETHERSCAN_API_KEY=your_api_key
```

## 🎭 Animation Details

### 3D Floating Coin
- **Duration**: 4 seconds per rotation
- **Transform**: 3D rotation on Y-axis
- **Shadow**: Dynamic golden glow
- **Physics**: Sine wave oscillation

### Shimmer Effects
- **Duration**: 2-3 seconds
- **Color**: Semi-transparent overlay
- **Repeat**: Infinite loop
- **Timing**: Staggered for depth

### Glassmorphism
- **Backdrop**: Blur filter
- **Overlay**: Linear gradient (10% → 5% white)
- **Border**: 1px white at 10% opacity

## 📱 Responsive Design

- **Mobile**: 360px - 430px (optimized phone view)
- **Tablet**: 431px - 1024px (scaled phone container)
- **Desktop**: 1025px+ (centered phone frame)

## 🔧 Configuration

### pubspec.yaml
All dependencies are pre-configured with optimal versions for Flutter 3.24.5.

### Theme
Dark theme with purple accents defined in `main.dart`:
```dart
ColorScheme.dark(
  primary: Color(0xFF7c3aed),
  secondary: Color(0xFFfbbf24),
)
```

## 🐛 Debugging

### Common Issues

1. **Flutter not found**:
   ```powershell
   # Add Flutter to PATH
   $env:PATH += ";C:\Users\CHANDAN\Desktop\flutter\bin"
   ```

2. **Chrome not detected**:
   ```powershell
   flutter devices
   # Should show Chrome browser
   ```

3. **Dependencies error**:
   ```powershell
   flutter clean
   flutter pub get
   ```

4. **Web3 connection issues**:
   - Ensure MetaMask is installed
   - Check browser console for errors
   - Verify network connectivity

## 🎯 Roadmap

- [ ] Real Web3 integration with web3dart
- [ ] Chart analytics with fl_chart
- [ ] Multi-language support
- [ ] Dark/Light theme toggle
- [ ] Mobile app versions (iOS/Android)
- [ ] Push notifications for transactions
- [ ] QR code wallet scanning

## 📄 License

MIT License - feel free to use this design in your projects!

## 🙏 Credits

Design inspired by:
- ProfitPilot Mobile Wallet UI
- DeFi Protocol Dashboard
- FluxChain Crypto Wallet

Built with ❤️ using Flutter

---

**Ready to launch?** Run `flutter run -d chrome` and watch the magic! ✨