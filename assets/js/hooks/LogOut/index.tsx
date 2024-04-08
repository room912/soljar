import React from "react";
import { lazy } from "react";
import { createRoot } from "react-dom/client";
import {
  ConnectionProvider,
  WalletProvider,
} from "@solana/wallet-adapter-react";

import { BaseWalletAdapter } from "@solana/wallet-adapter-base";
import * as web3 from "@solana/web3.js";

const Disconnector = lazy(() => import("./Disconnector"));

export default {
  _rootEl: null,
  _employees: [],

  mounted() {
    const rootEl = document.getElementById(this.el.id);
    this._rootEl = createRoot(rootEl!);

    this.handleEvent("clear_session_storage", () => {
      console.log("cleared");
      this.render();
      this.pushEvent("log_out", {});
    });
  },

  render() {
    const endpoint = web3.clusterApiUrl("devnet");

    this._rootEl.render(
      <React.StrictMode>
        <ConnectionProvider endpoint={endpoint}>
          <WalletProvider wallets={[]} autoConnect={true}>
            <Disconnector />
          </WalletProvider>
        </ConnectionProvider>
      </React.StrictMode>
    );
  },
};
