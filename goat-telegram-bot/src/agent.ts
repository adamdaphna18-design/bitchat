import { getTools } from "@goat-sdk/core";
import { viem } from "@goat-sdk/wallet-viem";
import { erc20, USDC } from "@goat-sdk/plugin-erc20";
import { createWalletClient, http } from "viem";
import { privateKeyToAccount } from "viem/accounts";
import { base } from "viem/chains";
import dotenv from "dotenv";

dotenv.config();

// Validate required env vars
if (!process.env.EVM_PRIVATE_KEY || !process.env.EVM_PROVIDER_URL) {
  throw new Error("Missing EVM_PRIVATE_KEY or EVM_PROVIDER_URL in .env");
}

// 1. Setup wallet
const account = privateKeyToAccount(process.env.EVM_PRIVATE_KEY as `0x${string}`);
const walletClient = createWalletClient({
  account,
  chain: base,
  transport: http(process.env.EVM_PROVIDER_URL),
});

// 2. Configure GOAT on-chain tools
export const getOnChainTools = async () => {
    return await getTools({
        wallet: viem(walletClient),
        plugins: [
            erc20({
                tokens: [
                    USDC
                ]
            })
        ]
    });
};

// Helper to get wallet address
export const walletAddress = account.address;
