import React from "react";
import { lazy } from "react";
import App from "./App";
import { createRoot } from "react-dom/client";

export default {
  _rootEl: null,
  _recipientAddress: null,
  _clusterApiUrl: "devnet",
  _usdRate: null,

  mounted() {
    // create react root element
    const rootEl = document.getElementById(this.el.id);
    this._rootEl = createRoot(rootEl!);

    if (rootEl) {
      this._recipientAddress = rootEl.dataset.recipient;
      this._usdRate = rootEl.dataset.usdRate;
      this._clusterApiUrl = rootEl.dataset.clusterApiUrl;
    }

    this.render([]); // render component with empty data
  },

  destroyed() {
    if (!this._rootEl) return;
    this._rootEl.unmount();
  },

  async dispatch({ type, ...payload }: any) {
    switch (type) {
      case "SUBMIT_TRANSACTION":
        await this.submitTransaction(payload);
        break;
      case "CANCEL_TRANSACTION":
        await this.submitTransaction(payload);
        break;
      default:
        console.log(type);
        break;
    }
  },

  async submitTransaction(payload) {
    this.pushEvent("submit_transaction", payload);
  },

  render() {
    this._rootEl.render(
      <React.StrictMode>
        <App
          recipientAddress={this._recipientAddress}
          usdRate={this._usdRate}
          clusterApiUrl={this._clusterApiUrl}
          dispatch={this.dispatch.bind(this)}
        />
      </React.StrictMode>
    );
  },
};
