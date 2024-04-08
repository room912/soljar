import React from "react";

import { useConnection, useWallet } from "@solana/wallet-adapter-react";

import { LAMPORTS_PER_SOL } from "@solana/web3.js";

import { WalletMultiButton } from "@solana/wallet-adapter-react-ui";

import * as web3 from "@solana/web3.js";
import { Cluster } from "./App";

export interface Props {
  recipientAddress: string;
  usdRate: string;
  clusterApiUrl: Cluster;
  dispatch: (payload: Record<string, any>) => void;
}

export default function Pay({
  recipientAddress,
  dispatch,
  usdRate,
  clusterApiUrl,
}: Props) {
  const { publicKey, sendTransaction } = useWallet();
  const [isInvalidAmount, setIsInvalidAmount] = React.useState(false);
  const [amount, setAmount] = React.useState("");
  const [name, setName] = React.useState("");
  const [message, setMessage] = React.useState("");
  const [isSubmitting, setIsSubmitting] = React.useState(false);

  const { connection } = useConnection();

  const handleDecimalsOnValue = (value) => {
    const regex = /([0-9]*[\.|\,]{0,1}[0-9]{0,4})/s;

    return value.match(regex)[0];
  };

  const handleNameChange = (e) => {
    setName(e.target.value);
  };

  const handleMessageChange = (e) => {
    setMessage(e.target.value);
  };

  const handleAmountChange = (e) => {
    const value = handleDecimalsOnValue(e.target.value);
    setIsInvalidAmount(!value);
    setAmount(value);
  };

  const calculateRate = (amount) => {
    return (Number(usdRate) * amount).toFixed(2);
  };

  const handleSubmit = async (event) => {
    event.preventDefault();

    if (!amount) {
      setIsInvalidAmount(true);
      return;
    }

    if (!publicKey) {
      return;
    }

    setIsSubmitting(true);

    const transaction = new web3.Transaction();

    const recipientPubKey = new web3.PublicKey(recipientAddress); // (event.target.recipient.value);

    const sendSolInstruction = web3.SystemProgram.transfer({
      fromPubkey: publicKey,
      toPubkey: recipientPubKey,
      lamports: LAMPORTS_PER_SOL * amount,
    });

    transaction.add(sendSolInstruction);

    try {
      const sig = await sendTransaction(transaction, connection);
      dispatch({
        type: "SUBMIT_TRANSACTION",
        payload: { sig, amount, message, name },
      });
    } catch (e) {
      dispatch({ type: "CANCEL_TRANSACTION", payload: { error: e.message } });
    }

    setIsSubmitting(false);
  };

  return (
    <>
      <form onSubmit={handleSubmit}>
        <div
          className={`w-full rounded-2xl bg-gradient-to-r ${
            isInvalidAmount
              ? "from-rose-400 via-pink-300 to-red-400"
              : "from-yellow-400 via-amber-300 to-orange-400"
          } p-1`}
        >
          <div className="h-full w-full bg-white rounded-xl text-center py-6">
            <div className="font-semibold text-sm">Amount to transfer</div>
            <div className="text-xs font-light text-gray-500">
              {clusterApiUrl} cluster
            </div>
            <div className="mt-2">
              <input
                type="text"
                name="amount"
                value={amount}
                onChange={handleAmountChange}
                className="p-0 border-0 font-bold text-5xl w-64 focus:outline-none focus:ring-0 text-center"
                placeholder="0"
              />
              <div className="text-xs">${calculateRate(amount)}</div>

              <div className="mt-4 flex justify-between px-4 space-x-2 font-semibold">
                <div className="w-1/3">
                  <button
                    type="button"
                    onClick={() => setAmount("0.1")}
                    className="w-full cursor-pointer border border-gray-200 rounded-full py-2 hover:bg-gray-100"
                  >
                    <div>+0.1</div>
                  </button>
                  <div className="text-xs font-light text-amber-500">
                    ${calculateRate(0.1)}
                  </div>
                </div>

                <div className="w-1/3">
                  <button
                    type="button"
                    onClick={() => setAmount("0.5")}
                    className="w-full cursor-pointer border border-gray-200 rounded-full py-2 hover:bg-gray-100"
                  >
                    +0.5
                  </button>
                  <div className="text-xs font-light text-amber-500">
                    ${calculateRate(0.5)}
                  </div>
                </div>
                <div className="w-1/3">
                  <button
                    type="button"
                    onClick={() => setAmount("1")}
                    className="w-full cursor-pointer border border-gray-200 rounded-full py-2 hover:bg-gray-100"
                  >
                    +1
                  </button>
                  <div className="text-xs font-light text-amber-500">
                    ${calculateRate(1)}
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>
        <div className="mt-6 flex flex-col space-y-2">
          <input
            name="text"
            className="py-2 px-3 block w-full rounded-lg text-zinc-900 focus:ring-0 sm:text-sm sm:leading-6 border border-zinc-300 focus:border-zinc-400"
            onChange={handleNameChange}
            value={name}
            placeholder="Name (optional)"
          />
          <input
            className="py-2 px-3 block w-full rounded-lg text-zinc-900 focus:ring-0 sm:text-sm sm:leading-6 border border-zinc-300 focus:border-zinc-400"
            name="text"
            onChange={handleMessageChange}
            value={message}
            placeholder="Message (optional)"
          />
        </div>

        <div className="mt-4">
          {publicKey ? (
            <button className="flex space-x-2 justify-center items-center w-full phx-submit-loading:opacity-75 rounded-lg bg-zinc-900 hover:bg-zinc-700 py-2 px-3 text-sm font-semibold leading-6 text-white active:text-white/80">
              <svg
                width="27"
                height="21"
                viewBox="0 0 398 312"
                fill="none"
                xmlns="http://www.w3.org/2000/svg"
              >
                <g clip-path="url(#clip0_951_484)">
                  <path
                    d="M64.6006 237.9C67.0006 235.5 70.3006 234.1 73.8006 234.1H391.201C397.001 234.1 399.901 241.1 395.801 245.2L333.101 307.9C330.701 310.3 327.401 311.7 323.901 311.7H6.50063C0.700627 311.7 -2.19937 304.7 1.90063 300.6L64.6006 237.9Z"
                    fill="url(#paint0_linear_951_484)"
                  />
                  <path
                    d="M64.6006 3.8C67.1006 1.4 70.4006 0 73.8006 0H391.201C397.001 0 399.901 7 395.801 11.1L333.101 73.8C330.701 76.2 327.401 77.6 323.901 77.6H6.50063C0.700627 77.6 -2.19937 70.6 1.90063 66.5L64.6006 3.8Z"
                    fill="url(#paint1_linear_951_484)"
                  />
                  <path
                    d="M333.101 120.101C330.701 117.701 327.401 116.301 323.901 116.301H6.50063C0.700627 116.301 -2.19937 123.301 1.90063 127.401L64.6006 190.101C67.0006 192.501 70.3006 193.901 73.8006 193.901H391.201C397.001 193.901 399.901 186.901 395.801 182.801L333.101 120.101Z"
                    fill="url(#paint2_linear_951_484)"
                  />
                </g>
                <defs>
                  <linearGradient
                    id="paint0_linear_951_484"
                    x1="360.88"
                    y1="-37.4557"
                    x2="141.214"
                    y2="383.293"
                    gradientUnits="userSpaceOnUse"
                  >
                    <stop stop-color="#00FFA3" />
                    <stop offset="1" stop-color="#DC1FFF" />
                  </linearGradient>
                  <linearGradient
                    id="paint1_linear_951_484"
                    x1="264.83"
                    y1="-87.6014"
                    x2="45.1636"
                    y2="333.147"
                    gradientUnits="userSpaceOnUse"
                  >
                    <stop stop-color="#00FFA3" />
                    <stop offset="1" stop-color="#DC1FFF" />
                  </linearGradient>
                  <linearGradient
                    id="paint2_linear_951_484"
                    x1="312.549"
                    y1="-62.6872"
                    x2="92.8828"
                    y2="358.062"
                    gradientUnits="userSpaceOnUse"
                  >
                    <stop stop-color="#00FFA3" />
                    <stop offset="1" stop-color="#DC1FFF" />
                  </linearGradient>
                  <clipPath id="clip0_951_484">
                    <rect width="397.7" height="311.7" fill="white" />
                  </clipPath>
                </defs>
              </svg>

              <span>
                {isSubmitting ? "Submitting..." : "Submit Transaction"}
              </span>
            </button>
          ) : (
            <WalletMultiButton className="testttt" />
          )}
        </div>
      </form>
    </>
  );
}
