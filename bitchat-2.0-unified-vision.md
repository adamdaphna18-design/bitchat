# bitchat 2.0: The Every-Phone Messenger

**Online-first, offline-capable, with a built-in AI agent economy on Solana/Base.**

## What Stays from Original Report (The Solid Foundation)
- **Noise Protocol over BLE mesh** (offline superpower)
- **NIP-17 encrypted DMs** over Nostr
- **Gossip sync + Bloom filters**
- **Out-of-band QR verification**

## What Changes (To Become Indispensable Online)

### 1. Identity Becomes Portable (Seed Phrase)
- User gets a BIP39 mnemonic on first launch.
- From that seed:
  - Nostr private key (for DMs, channels, presence)
  - Solana/Base keypair (for payments, AI agent wallet)
  - Noise static key (for BLE mesh)
- **Cross-device sync:** Just enter the seed on a new device → all keys are restored.

### 2. Global Ephemeral Channels (Online Magic #1)
- Anyone can create a `#topic` (e.g., `#worldcup-final`, `#tech-support`).
- Channel lives for 24h or until the owner deletes it.
- Messages are gift-wrapped (NIP-17) to the channel’s shared ephemeral key.
- No central server can shut it down.

### 3. Solana/Base Payment Layer (Online Magic #2)
- Every chat has a **Send Payment** button.
- Supports: SOL, USDC (on Solana or Base), and any SPL token.
- Transaction is signed locally → broadcast via Nostr + relay hint or direct RPC.
- **AI agents** (on-device or cloud) can autonomously pay for APIs (e.g., Amazon Bedrock) using USDC on Base.

### 4. Paywalled Channels (Sustainable Communities)
- Channel owner deploys a Solana program (or Base contract) that issues membership tokens.
- Monthly subscription: e.g., 5 USDC (auto-paid via smart contract).
- User’s wallet is checked before allowing posts.

### 5. Mesh Relay Incentives (Keeping Offline Alive)
- When your phone relays a BLE message for someone else, you earn a micro-fee (e.g., 0.01 USDC on Base).
- Micropayments are batched and settled every hour (to avoid spam).

### 6. Cross-Device Sync Without Clouds
- Your message history is encrypted per conversation.
- It is fragmented and stored on Nostr relays you pay (via Lightning or Solana).
- Your other device fetches fragments and reassembles.

---

## What A User Sees (Daily Experience)

**Morning**
“Good morning! Your AI agent paid 0.1 USDC to summarise 3 news channels. Tap to read.”

**Commute**
Subway cuts internet → mesh kicks in. Your “running late” message hops via 2 strangers. You earn 0.02 USDC for relaying a weather alert.

**Work**
You join `#design-feedback` (ephemeral). Post a screenshot (uploaded to IPFS, paid 0.5 USDC via Base). Colleagues tip you 1 USDC for the useful feedback.

**Evening**
You subscribe to `#exclusive-crypto-signals` for 10 USDC/month (Solana smart contract). The AI agent automatically deducts from your wallet. No PayPal, no credit card.

---

## Technical Roadmap (Priority Order)

| Step | Feature | Time | Dependencies |
| :--- | :--- | :--- | :--- |
| 1 | Seed-based identity (BIP39) + cross-device sync | 1 week | `KeychainManager` |
| 2 | Solana/Base wallet integration (derive from same seed) | 1 week | `SolanaSwift`, Base SDK |
| 3 | Send SOL/USDC in DM | 3 days | Wallet + Nostr event |
| 4 | Global ephemeral channels (24h TTL) | 2 weeks | New Nostr kind |
| 5 | Paywalled channels (Solana program) | 2 weeks | Smart contract dev |
| 6 | Mesh relay incentives (micro-payments) | 2 weeks | BLE listener + batching |
| 7 | AI agent wallet (sub-key + spending limits) | 2 weeks | Amazon Bedrock integration |

After 2–3 months of work, `bitchat` becomes:
- **Online-first** – works beautifully with full internet.
- **Financially autonomous** – users and their AI agents transact in SOL/USDC.
- **Truly decentralised** – no central server, no company controlling your identity or payments.
- **Every-phone worthy** – because it replaces WhatsApp + Venmo + ChatGPT all in one.
