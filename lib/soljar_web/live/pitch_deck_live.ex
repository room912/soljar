defmodule SoljarWeb.PitchDeckLive do
  use SoljarWeb, :live_view

  def render(assigns) do
    ~H"""
    <div id="pitch-deck" phx-hook="Reveal" class="flex flex-col items-center justify-center px-4 h-full">
      <div class="reveal">
        <div class="slides">
          <section>
            <div class="flex justify-center"><img width="128" src="/images/jar.png" /></div>
            <h2>Soljar</h2>
            <p>simple crowdfunding payment tool</p>
            <div class="flex justify-center"><img width="256" src="/images/solana-logo.svg" /></div>
          </section>

          <section>
            <p>Crowdfunding should be simple for collector but it is not</p>
            <div class="flex justify-between space-x-3">
              <div class="w-1/2">
                <p>Expectations</p>
                <img src="/images/expectations.png"/>
              </div>
              <div class="w-1/2">
                <p>Reality</p>
                <ul class="text-2xl">
                  <li>several payment tools</li>
                  <li>non-anonymous payments</li>
                  <li>not all currencies available, especially cryptos</li>
                  <li>big commissions</li>
                  <li>financial regulations </li>
                  <li>slow withdrawals</li>
                  <li>…and many more complicated stuff</li>
                </ul>
              </div>
            </div>
          </section>

          <section>
            <p>Soljar is the easy crowdfunding payment tool for Solana in a weblink</p>
            <div class="flex justify-between space-x-3">
              <div class="w-1/2">
                <ul class="text-2xl">
                  <li>Create <span class="bg-gradient-to-r from-orange-600 via-amber-500 to-yellow-400 text-transparent bg-clip-text">SolJar</span></li>
                  <li>Set up fundraising goal in Solana</li>
                  <li>Share the weblink with donators</li>
                  <li>Get money directly on Solana wallet</li>
                  <li>Analyze page visits and transactions</li>
                </ul>
              </div>
              <div class="w-1/2">
                <img src="/images/jar-screen.png"/>
              </div>
            </div>
          </section>

          <section>
            <p>SolJar DEMO</p>
            <div class="flex justify-center">
              <video src="/images/demo-pitch.mov" class="rounded-xl w-5/6" controls poster="/images/jar-screen.png">
                Sorry, your browser doesn't support embedded videos, but don't worry, you can
                <a href="/images/demo-pitch.mov">download it</a>
                and watch it with your favorite video player!
              </video>
            </div>
          </section>

          <section>
            <p>SolJar team is the small group of web3 enthusiasts</p>
            <div class="flex justify-between space-x-3">
              <div class="w-1/2">
                <div class="w-full flex justify-center"><img width="128" src="/images/jar.png"/></div>
                <p>Mariia</p>
                <p>Product Manager,</p>
                <p>4+ years in finance</p>

              </div>
              <div class="w-1/2">
                <div class="w-full flex justify-center"><img width="128" src="/images/soljarb.png"/></div>
                <p>Oleksii,</p>
                <p>Full-Stack Software Engineer</p>
              </div>
            </div>
          </section>

          <section>
            <h2>SolJar target audience</h2>
            <ul>
              <li>Streamers, performances, artists – anyone who live on donations</li>
              <li>Charity and fundraising organisations who collect money from different sources</li>
              <li>Anyone who want to start crowdfunding campaign collecting Solana</li>
            </ul>
          </section>

          <section>
            <h2>SolJar purpose</h2>
            <ul>
              <li>Attract more people to the web3 universe through fundraising solutions</li>
              <li>Help people raise more funds through alternative tools</li>
              <li>Reduce dependence on regulators</li>
              <li>Give web3 community access to the anonymous fundraising</li>
            </ul>
          </section>

          <section>
            <h2>SolJar needs</h2>

            <ul>
              <li>Relevant feedback </li>
              <li>More interested audience and feedback from it</li>
              <li>Funds – we will use it to add new tools and promote SolJar within community</li>
            </ul>
          </section>

          <section>
            <h2>Perfection is simplicity!</h2>
            <h4>Your feedback is important</h4>
            <p><.link class="!text-yellow-500 hover:!text-yellow-200" navigate={~p"/contact"}>Leave feedback</.link></p>
            <p><.link href="https://soljars.com/jars/A8B_9o3Df">Donate</.link></p>
          </section>
        </div>
      </div>
    </div>
    """
  end
end
