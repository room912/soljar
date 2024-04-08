import React from "react";
import { lazy } from "react";
import { createRoot } from "react-dom/client";

const Wallet = lazy(() => import("./Wallet"));

export default {
  _rootEl: null,
  _recipientAddress: null,

  mounted() {
    const rootEl = document.getElementById(this.el.id);
    this._rootEl = createRoot(rootEl!);

    this.render([]); // render component with empty data

    this.handleEvent("authenticate", () => {
      this.pushEventTo("#login", "submit", {});
    });

    this.handleEvent("clear_session_storage", () => {
      sessionStorage.clear();
    });
  },

  destroyed() {
    if (!this._rootEl) return;
    this._rootEl.unmount();
  },

  async dispatch({ type, ...payload }: any) {
    switch (type) {
      case "CONNECT_WALLET":
        await this.connectWallet(payload);
        break;
      default:
        console.log(type);
        break;
    }
  },

  async connectWallet(payload: any) {
    await this.pushEventAsync("connect_wallet", { ...payload });
  },

  async pushEventAsync(event: string, payload: any) {
    return new Promise((accept, reject) => {
      this.pushEventTo("#login", event, payload, (reply) => {
        accept(reply);
      });
    });
  },

  render() {
    this._rootEl.render(
      <React.StrictMode>
        <Wallet dispatch={this.dispatch.bind(this)} />
      </React.StrictMode>
    );
  },
};
