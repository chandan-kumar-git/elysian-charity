<div align="center">

<img src="docs/brand/wordmark.webp" alt="Elysian: Charity Donation Transparency" width="100%">

**A blockchain charity platform where every donation, NGO verification and withdrawal is a public, verifiable transaction.**

[Live app](https://elysian-charity.vercel.app) · Team Reverse Engineering · Smart contract, Flutter app and Next.js web dashboard

<img src="docs/screenshots/web-home.webp" alt="Elysian web app: contract health card with total value locked, performance trend and a connected wallet" width="100%">

</div>

## The problem

Donors rarely see where their money goes after it leaves their account. Elysian puts the whole flow on Ethereum: donations go into a smart contract, only NGOs verified by the owner can withdraw, and every movement is an on-chain event anyone can audit.

## Screens

The Flutter app, running on the web:

<table>
  <tr>
    <td width="34%" align="center"><img src="docs/screenshots/app-landing.webp" alt="Flutter app landing" width="260"></td>
    <td width="33%" align="center"><img src="docs/screenshots/app-mobile.webp" alt="Flutter app home" width="260"></td>
    <td width="33%" align="center"><img src="docs/screenshots/web-mobile.webp" alt="Web dashboard on a phone" width="260"></td>
  </tr>
  <tr>
    <td><b>Landing.</b> "Where technology meets hope", with Donate and demo entry points.</td>
    <td><b>App home.</b> Balance, today's donations and the app launcher: wallet, social, market, maps and more.</td>
    <td><b>Web dashboard.</b> Contract health and total value locked from the Next.js app.</td>
  </tr>
</table>

<table>
  <tr>
    <td width="50%"><img src="docs/screenshots/app-fund-flow.webp" alt="Fund flow page"></td>
    <td width="50%"><img src="docs/screenshots/web-transfers.webp" alt="Recent transfers"></td>
  </tr>
  <tr>
    <td><b>Fund flow.</b> How money moves through the contract: donate, verify, disburse, audit.</td>
    <td><b>Live feed.</b> Recent donations and disbursements with amounts and addresses, plus Donate and Etherscan links.</td>
  </tr>
</table>

## Smart contract

`contracts/ElysianCharity.sol` (Solidity 0.8.20, OpenZeppelin v5 `Ownable` and `ReentrancyGuard`):

| Function | Who | What it does |
|---|---|---|
| `donate()` | anyone | Send ETH to the pool; emits `DonationReceived` |
| `registerNGO()` / `removeNGO()` | owner | Verify or remove an NGO address; emits `NGOVerified` / `NGORemoved` |
| `withdrawFunds()` | owner | Release funds to a verified NGO; emits `FundsWithdrawn` |
| `emergencyWithdraw()` | owner | Pull all funds in an emergency |
| `getDonationStats()`, `getVerifiedNGOs()`, `getDonorContribution()`, `getNGOWithdrawals()` | anyone | Read-only views for the dashboards |

## Web app

Next.js 14, TypeScript, Tailwind CSS, ethers.js v6.

- **Wallet**: MetaMask connection, with an install guide when MetaMask is missing.
- **Donate**: amount input with quick amounts (0.1, 0.5, 1.0 ETH), validation and notifications.
- **Admin panel**: owner-only NGO registration, fund withdrawal and emergency controls.
- **Transaction ledger**: on-chain events with filtering, CSV export and Etherscan links.

## Mobile app

`flutter_app/` is the Flutter app (web3dart, flutter_animate) for the same contract. Only the web platform is set up in this repo; the live link above is that web build. Run `flutter create .` inside `flutter_app/` to add Android or iOS.

```bash
cd flutter_app
flutter pub get
flutter run -d chrome            # or: flutter build web --release
```

## Run locally

```bash
# contracts
npm install
npx hardhat compile
npx hardhat test
npx hardhat node                    # local chain on localhost:8545
node scripts/simple-deploy.cjs      # new terminal: deploy the contract

# web app
cd frontend
npm install
# frontend/.env.local:
#   NEXT_PUBLIC_CONTRACT_ADDRESS=<address printed by the deploy script>
#   NEXT_PUBLIC_OWNER_ADDRESS, NEXT_PUBLIC_NETWORK_NAME, NEXT_PUBLIC_BLOCK_EXPLORER
npm run dev                         # http://localhost:3000
```

## Project structure

```
contracts/       ElysianCharity.sol
scripts/         deploy scripts
test/            Hardhat tests
frontend/        Next.js web app (components: ElysianDashboard, DonationForm, AdminPanel, TransactionLedger, ...)
flutter_app/     Flutter mobile app
```
