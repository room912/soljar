defmodule SoljarWeb.HelpLive do
  use SoljarWeb, :live_view

  def render(assigns) do
    ~H"""
      <div class="relative w-full px-6 py-12 mt-16 md:max-w-3xl md:mx-auto lg:max-w-4xl lg:pt-16 lg:pb-28">
        <article class="px-2 prose prose-invert lg:px-12 lg:prose-xl">
          <h2 phx-click={JS.toggle(to: "#wallet")} class="cursor-pointer hover:text-amber-500 animate-slidein300 opacity-0">How to create a phantom wallet?</h2>
          <ul id="wallet" class="hidden animate-slidein100 opacity-0">
            <li>
              <h3>Download extension for your browser</h3>
              <p>
                <.link href="https://chrome.google.com/webstore/detail/phantom/bfnaelmomeimhlpmgjnjophhpkkoljpa" target="_blank">Chrome</.link>,
                <.link href="https://addons.mozilla.org/en-US/firefox/addon/phantom-app/" target="_blank">Firefox</.link>,
                <.link href="https://chrome.google.com/webstore/detail/phantom/bfnaelmomeimhlpmgjnjophhpkkoljpa" target="_blank">Brave</.link>,
                <.link href="https://chrome.google.com/webstore/detail/phantom/bfnaelmomeimhlpmgjnjophhpkkoljpa" target="_blank">Edge</.link>
              </p>
            </li>
            <li>
              <h3>Download app for Mobile</h3>
              <p>
                <.link href="https://apps.apple.com/us/app/phantom-crypto-wallet/id1598432977" target="_blank">iOS</.link>,
                <.link href="https://play.google.com/store/apps/details?id=app.phantom&hl=en_US" target="_blank">Andriod</.link>
              </p>
            </li>
          </ul>
          <h2 phx-click={JS.toggle(to: "#login-a")} class="cursor-pointer hover:text-amber-500 animate-slidein500 opacity-0">How to login?</h2>
          <p id="login-a" class="hidden animate-slidein100 opacity-0">Select the Phantom wallet you'd like to receive funds in using the button above.</p>
          <h2 phx-click={JS.toggle(to: "#jar")} class="cursor-pointer hover:text-amber-500 animate-slidein700 opacity-0">How to create a jar?</h2>
          <p id="jar" class="hidden animate-slidein100 opacity-0">Fill out the form with the name of your jar, your name, and the goal amount to receive a unique link to your jar.</p>
          <h2 phx-click={JS.toggle(to: "#funds")} class="cursor-pointer hover:text-amber-500 animate-slidein700 opacity-0">How to receive funds?</h2>
          <p id="funds" class="hidden animate-slidein100 opacity-0">Share your jar link with sponsors. All funds will be collected directly into your wallet.</p>
        </article>
      </div>
    """
  end
end
