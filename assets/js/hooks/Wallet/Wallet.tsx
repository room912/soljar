import React from "react";
import { FC, ReactNode, useMemo } from "react";
import {
  ConnectionProvider,
  WalletProvider,
} from "@solana/wallet-adapter-react";
import {
  WalletModalProvider,
  WalletMultiButton,
  WalletConnectButton,
  WalletModalButton,
  WalletDisconnectButton,
  WalletIcon,
} from "@solana/wallet-adapter-react-ui";
import * as web3 from "@solana/web3.js";
import WalletButton from "./WalletButton";

export interface Props {
  dispatch: (payload: Record<string, any>) => void;
}

const endpoint = web3.clusterApiUrl("devnet");

export default function Wallet({ dispatch }: Props) {
  return (
    <ConnectionProvider endpoint={endpoint}>
      <WalletProvider wallets={[]} autoConnect={true}>
        <WalletModalProvider>
          <WalletButton dispatch={dispatch} />
        </WalletModalProvider>
      </WalletProvider>
    </ConnectionProvider>
  );
}
