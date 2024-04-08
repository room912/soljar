import React from "react";
import * as web3 from "@solana/web3.js";
import Pay from "./Pay";

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

export type Cluster = "devnet" | "testnet" | "mainnet-beta";

export interface Props {
  recipientAddress: string;
  clusterApiUrl: Cluster;
  usdRate: string;
  dispatch: (payload: Record<string, any>) => void;
}

export default function App({
  recipientAddress,
  clusterApiUrl,
  dispatch,
  usdRate,
}: Props) {
  let endpoint = "";

  if (clusterApiUrl === "mainnet-beta") {
    endpoint =
      "https://solana-mainnet.api.syndica.io/api-token/33h3joYyUtTUPzSRTTH7LLPvxjF12dvxuX2CNBTbHunsxCNqdC2FdN5ikQUvvCHFD8ZUkb3VgS4dzsaw2ZTXYEEYEDuhqHDU2uThJm1jLWUVhK9SaQRz8b73YmaEwnHjmFaYVLsoUFM5ZWvTk1vHJQ1258YYj2DgC2BVo8HRwmqPau37CSk3myD1Nu5fXDjnAw7EgSL6rjmd5x1YN3BGqkcUgahBTPNREmMKoiR8DGZi8vKumbgV8z4FQnkMx1MuEeajq7YHk8EpEGhWAYtSiwjY19W9hpyBBfJVX4T6NZZJ8qjTV7YW4C2hx3rNKk5XDN9nrCPzLgzmd7hzwQ6SxTwXnvQjssW1chFfpgS9q3Rgvi4aNDxyziXAAWcPJZ2S7AUvqJugE474CiJxiZ55AAsw1ZLAZ8A62fjNvPpHoAq12hRURbPvqgkUuQLE5w7bzVmxw85VeU8tBCXftTyQC44CrXDbsLatU87gnyQbAJTiYbU2YYQsW6iWzEhTC";
  } else {
    endpoint = web3.clusterApiUrl(clusterApiUrl);
  }

  const wallets = React.useMemo(() => [], []);

  return (
    <ConnectionProvider endpoint={endpoint}>
      <WalletProvider wallets={wallets} autoConnect={true}>
        <WalletModalProvider>
          <Pay
            clusterApiUrl={clusterApiUrl}
            recipientAddress={recipientAddress}
            usdRate={usdRate}
            dispatch={dispatch}
          />
        </WalletModalProvider>
      </WalletProvider>
    </ConnectionProvider>
  );
}
