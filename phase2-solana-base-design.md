# Phase 2 Technical Design Doc: bitchat Solana & Base Layer

This document outlines the technical integration plan for adding Solana and Base network support to `bitchat`, transforming the application into a finance-enabled, decentralized super-app.

## 1. Wallet Layer

### 1.1 Goal
Seamlessly integrate a non-custodial wallet into the `bitchat` client on every phone, deriving cryptographic keys from the same root seed used for identity.

### 1.2 Implementation Steps
1. **SDK Integration:** Integrate a Solana mobile SDK (e.g., `SolanaSwift` or a web3.swift library with Solana support) via Swift Package Manager.
2. **Key Derivation:** Use the existing BIP39 seed phrase (from Phase 1) to derive the Solana Keypair (using the standard `m/44'/501'/0'/0'` derivation path).
3. **External Wallet Support:** Provide intent-based fallbacks to link external wallets like Phantom or Coinbase Wallet using standard deep links / WalletConnect, if the user prefers not to use the derived ephemeral wallet.
4. **Network Environment:** Default to devnet/testnet for the onboarding sandbox before smoothly transitioning users to mainnet.

## 2. Simple Send in Chat

### 2.1 Goal
Enable frictionless peer-to-peer sending of SOL or USDC directly within the chat interface, similar to sending an image or voice note.

### 2.2 Implementation Steps
1. **Nostr Event Definition:** Define a new custom event (e.g., Kind `30001`) representing a payment intent.
   - Example payload: `{ "action": "payment", "token": "USDC", "amount": 1.25, "recipient": "SolanaAddress" }`
2. **Transaction Construction:** When a user hits "Send", construct and sign the Solana transaction locally using the derived Keypair.
3. **Broadcasting:**
   - Broadcast the signed transaction directly to the Solana RPC.
   - Broadcast the Kind `30001` event via Nostr relays so the recipient's UI updates immediately with a "Payment Sent" bubble.
4. **UI Integration:** Add a specific "Transfer" or "Pay" button next to contacts in the Direct Message view.

## 3. AI Agent Economy Layer

### 3.1 Goal
Introduce lightweight, automated AI agents acting on behalf of the user, capable of spending programmed micropayments for services and infrastructure.

### 3.2 Implementation Steps
1. **Agent Sub-Keys:** Derive a deterministic sub-key from the main wallet specifically for the AI agent, granting it a limited allowance (e.g., max 10 SOL/day spending limit).
2. **Infrastructure Payments:**
   - Program the agent to autonomously pay micro-fees to premium Nostr relays to ensure message delivery and prevent spam.
   - Implement automated tips (Solana Pay) to mesh relays based on bandwidth contributed to the offline network.
3. **Service Integration:** Integrate with external AI oracles/APIs (like Amazon Bedrock) via Base (USDC), utilizing libraries like AgentCore.

## 4. Smart Contract for Paywalled Channels

### 4.1 Goal
Implement token-gated access for premium or exclusive channels, utilizing smart contracts to track subscriptions and prevent spam natively.

### 4.2 Implementation Steps
1. **Contract Deployment:** Deploy a subscription management program on Solana (or a Solidity contract on Base).
2. **Token Issuance:** When a user pays the subscription fee (e.g., 5 USDC), the contract issues a time-bound membership token (an NFT or SPL token valid for 30 days).
3. **Client-Side Gating:** Modify `ChatViewModel`'s write-access logic for premium channels. Before allowing the user to broadcast to the specific geohash/topic, query the blockchain RPC to verify the user's wallet holds the required membership token.

## 5. Cross-Chain Tips (With Bridge)

### 5.1 Goal
Ensure interoperability between users on different chains (e.g., a Bitcoin Lightning user tipping a Solana user) seamlessly.

### 5.2 Implementation Steps
1. **Bridge Integration:** Integrate APIs from cross-chain liquidity networks like Mayan or Wormhole.
2. **1-Click Swap:** When a user initiates a cross-chain tip, the UI (via Jupiter or Uniswap router wrappers) handles the swap quote and execution in the background, presenting a unified "Send Tip" experience to the user regardless of the underlying token natively held.

---

## Implementation Roadmap

| Step | Task | Estimated Time |
| :--- | :--- | :--- |
| 1 | Integrate Solana mobile wallet (keypair from existing seed) | 1 week |
| 2 | Add "Send SOL/USDC" button in DM view | 3 days |
| 3 | Support Base USDC (use Coinbase's SDK) | 1 week |
| 4 | Build AI agent wallet sub-key + spending limits | 2 weeks |
| 5 | Paywalled channel contract on Solana (or Base) | 1 week |
| 6 | Bridge for cross-chain tips (Jupiter/Wormhole) | 2 weeks |
