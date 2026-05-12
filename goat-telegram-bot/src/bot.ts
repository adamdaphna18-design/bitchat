import { Telegraf } from "telegraf";
import { message } from "telegraf/filters";
import dotenv from "dotenv";
import { getOnChainTools, walletAddress } from "./agent";

dotenv.config();

const bot = new Telegraf(process.env.TELEGRAM_BOT_TOKEN!);

// Simple welcome
bot.start((ctx) => {
  ctx.reply(`🤖 GOAT Agent Bot active\nMy wallet: ${walletAddress}\n\nCommands:\n/transfer <amount> <to_address> - Send USDC\n/balance - Check USDC Balance`);
});

// /transfer 0.5 0x1234...
bot.command("transfer", async (ctx) => {
  const args = ctx.message.text.split(" ");
  if (args.length !== 3) {
    return ctx.reply("Usage: /transfer <amount> <recipient_address>\nExample: /transfer 0.5 0x123...");
  }

  const amount = parseFloat(args[1]);
  const to = args[2];

  if (isNaN(amount) || amount <= 0) {
    return ctx.reply("Amount must be a positive number (e.g., 0.5 for 0.5 USDC)");
  }

  if (!to.startsWith("0x") || to.length !== 42) {
    return ctx.reply("Invalid Ethereum address. Must start with 0x and be 42 chars.");
  }

  try {
    const tools = await getOnChainTools();
    const transferTool = tools.find((t: any) => t.name === "transfer");
    if (!transferTool) throw new Error("Transfer tool not found");

    // Convert amount to smallest unit (USDC = 6 decimals)
    const amountInBase = BigInt(Math.floor(amount * 10 ** 6));

    ctx.reply(`⏳ Sending ${amount} USDC to ${to.slice(0, 6)}...${to.slice(-4)}...`);

    const result = await transferTool.execute({
        amount: amountInBase.toString(),
        to: to,
        token: "USDC"
    });

    ctx.reply(`✅ Transfer successful! TX: ${result || "check explorer"}\nFrom: ${walletAddress}\nTo: ${to}\nAmount: ${amount} USDC`);
  } catch (error: any) {
    console.error(error);
    ctx.reply(`❌ Transfer failed: ${error.message || "Unknown error"}\nCheck wallet balance and gas funds.`);
  }
});

// Optional: /balance command
bot.command("balance", async (ctx) => {
  try {
    const tools = await getOnChainTools();
    const balanceTool = tools.find((t: any) => t.name === "get_token_balance");
    if (!balanceTool) throw new Error("Balance tool not found");

    const balance = await balanceTool.execute({ wallet: walletAddress, token: "USDC" });
    ctx.reply(`💰 USDC Balance: ${balance} USDC`);
  } catch (error: any) {
    ctx.reply(`Failed to fetch balance: ${error.message}`);
  }
});

bot.launch();
console.log("🤖 Bot is running...");
process.once("SIGINT", () => bot.stop("SIGINT"));
process.once("SIGTERM", () => bot.stop("SIGTERM"));
