import React from "react";

import {
  ConnectionProvider,
  WalletProvider,
  useConnection,
  useWallet,
} from "@solana/wallet-adapter-react";

import { LAMPORTS_PER_SOL } from "@solana/web3.js";

import {
  WalletModalProvider,
  WalletMultiButton,
  WalletConnectButton,
  WalletModalButton,
  WalletDisconnectButton,
  WalletIcon,
} from "@solana/wallet-adapter-react-ui";

import * as web3 from "@solana/web3.js";

const { useEffect, useState } = React;

export default function WalletButton() {
  const { connection } = useConnection();
  const { publicKey, sendTransaction, connect, disconnect } = useWallet();

  useEffect(() => {
    if (connection || publicKey) {
      disconnect();
    }
  }, [connection, publicKey]);

  return <></>;
}
