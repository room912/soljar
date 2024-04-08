import React from "react";

import {
  ConnectionProvider,
  WalletProvider,
  useConnection,
  useWallet,
} from "@solana/wallet-adapter-react";

import { useAutoConnect } from "./AutoConnectProvider";

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

export interface Props {
  dispatch: (payload: Record<string, any>) => void;
}

export default function WalletButton({ dispatch }: Props) {
  const { connection } = useConnection();
  const { publicKey } = useWallet();

  useEffect(() => {
    if (!connection || !publicKey) {
      return;
    }

    connection.getAccountInfo(publicKey).then((info) => {
      dispatch({ type: "CONNECT_WALLET", payload: { address: publicKey } });
    });
  }, [connection, publicKey]);

  return (
    <div>
      <WalletMultiButton />
    </div>
  );
}
