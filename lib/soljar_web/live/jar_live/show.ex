defmodule SoljarWeb.JarLive.Show do
  use SoljarWeb, :live_view

  alias Soljar.Jars
  alias Soljar.Jars.Jar

  def render(assigns) do
    ~H"""
    <%= if connected?(@socket) do %>
      <div class="py-20 bg-white h-full lg:px-10 lg:bg-gradient-to-r lg:from-cyan-500 lg:to-blue-500">
        <div class="flex flex-col lg:flex-row lg:rounded-xl lg:max-w-[900px] lg:mx-auto lg:drop-shadow lg:h-full">
          <div class="flex flex-col relative items-center lg:w-1/2 lg:justify-center lg:bg-slate-100 lg:px-12 lg:rounded-l-xl">
            <.link patch={~p"/jars/#{@jar.uri}/qr"} class="p-2 mb-2 lg:absolute bg-white border rounded-full lg:-mr-6 lg:-mt-6 lg:top-0 lg:right-0 h-12 w-12 flex items-center justify-center hover:bg-gray-100 hover:cursor-pointer">
              <%= raw(Jar.qr(@jar)) %>
            </.link>

            <div class={[
              "flex justify-center items-center text-white font-semibold text-3xl",
              "w-20 h-20 bg-gradient-to-b from-purple-600 via-indigo-600 to-rose-600 border-purple-500 rounded-full",
              !@jar.photo_path && "p-5",
              @jar.photo_path && "overflow-hidden"
            ]}>
              <%= if @jar.photo_path do %>
                <img class="w-full h-full object-cover" src={@jar.photo_path} />
              <% else %>
                <img class="w-auto h-auto" src="/images/jar.png" />
              <% end %>
            </div>

            <div class="mt-3 font-semibold text-sm"><%= @jar.collector_name %> collecting</div>
            <div class="mt-1 font-extrabold text-xl"><%= @jar.name %></div>
            <div class="mt-3 text-sm text-center">
              <%= @jar.description %>
            </div>
            <div class="mt-4 bg-gray-100 flex rounded-xl py-4 lg:bg-white">
              <div class="px-4 border-r border-gray-200 flex items-center space-x-3">
                <.icon name="hero-archive-box-solid" />
                <div>
                  <div class="text-xs font-medium text-gray-500 leading-3">Accumulated</div>
                  <div class="font-semibold"><%= @jar.collected_amount %></div>
                  <div class="text-xs font-light text-gray-400"><%= to_usd(@rate.usd, @jar.collected_amount) %></div>
                </div>
              </div>
              <div class="px-4 flex items-center space-x-2">
                <.icon name="hero-bolt-solid" />
                <div>
                  <div class="text-xs font-medium text-gray-500 leading-3">Goal</div>
                  <div class="font-semibold"><%= @jar.goal_amount %></div>
                  <div class="text-xs font-light text-gray-400"><%= to_usd(@rate.usd, @jar.goal_amount) %></div>
                </div>
              </div>
            </div>
          </div>

          <div
            :if={@recipient_address}
            id="jar-button"
            data-cluster-api-url={@jar.cluster_api_url}
            data-usd-rate={Money.to_decimal(@rate.usd)}
            data-recipient={@recipient_address}
            class="py-4 w-full px-6 lg:w-1/2 bg-white lg:flex lg:flex-col lg:justify-center lg:py-16 lg:px-16 lg:rounded-r-xl"
            phx-hook="Jar"
            phx-update="ignore"
          >
          </div>
        </div>
        <div class="hidden px-10 lg:flex justify-center mt-1">
          <.link class="text-gray-50 hover:text-blue-200 font-semibold tracking-tighter" navigate={~p"/dashboard"}>Manage your jar</.link>
        </div>
      </div>

      <.modal
        :if={@live_action in [:success]}
        id="error-modal"
        show
        secondary
        on_cancel={JS.patch(~p"/jars/#{@jar.uri}")}
      >
        <div class="flex flex-col items-center justify-center">
          <div class="bg-green-100 rounded-full p-3">
            <.icon name="hero-check-solid" class="w-6 h-6 text-green-500" />
          </div>
          <div class="mt-2 text-center text-gray-800">
            <h2 class="font-bold text-xl">Success</h2>
            <p>Your <.link class="text-blue-600 hover:text-blue-400" target="_blank" href={"https://solscan.io/tx/#{@transaction.sig}?cluster=devnet"}>transaction</.link> has been submitted</p>
          </div>

          <.button secondary class="mt-4 w-1/2" phx-click={JS.patch(~p"/jars/#{@jar.uri}")}>Back to jar</.button>
        </div>
      </.modal>

      <.modal
        :if={@live_action in [:error]}
        id="error-modal"
        show
        secondary
        on_cancel={JS.patch(~p"/jars/#{@jar.uri}")}
      >
        <div class="flex flex-col items-center justify-center">
          <div class="bg-rose-100 rounded-full p-3">
            <.icon name="hero-exclamation-triangle" class="w-6 h-6 text-rose-500" />
          </div>
          <div class="mt-2 text-center text-gray-800">
            <h2 class="font-bold text-xl">Fail</h2>
            <p>Your transaction has not been submitted.</p>
            <p><%= @error %></p>
          </div>

          <.button secondary class="mt-4 w-1/2" phx-click={JS.patch(~p"/jars/#{@jar.uri}")}>Back to jar</.button>
        </div>
      </.modal>

      <.modal
        :if={@live_action in [:qr]}
        id="qr-modal"
        secondary
        show
        on_cancel={JS.patch(~p"/jars/#{@jar.uri}")}
      >
        <div class="flex flex-col items-center justify-center">
          <%= raw(Jar.qr(@jar, 300)) %>
        </div>
      </.modal>

    <% else %>
      loading
    <% end %>
    """
  end

  @impl true
  def mount(_params, _session, socket) do
    rate = Soljar.SolRates.latest()
    {:ok, socket |> assign(recipient_address: nil, transaction: nil, error: nil, rate: rate)}
  end

  @impl true
  def handle_params(%{"uri" => uri}, _, socket) do
    if connected?(socket) do
      {:ok, jar} = Jars.view_jar(uri)

      {:noreply,
        socket
        |> assign(recipient_address: jar.user.wallet_address)
        |> assign(:jar, jar)}
    else
      {:noreply, socket}
    end
  end

  def handle_event("submit_transaction", %{"payload" => %{"sig" => _sign} = payload}, socket) do
    params = Enum.into(payload, %{"jar_id" => socket.assigns.jar.id})

    {:ok, transaction} = Soljar.Transactions.create_transaction(params)
    collected_amount = Money.add(Money.parse!(params["amount"]), socket.assigns.jar.collected_amount)
    {:ok, _} = Soljar.Jars.update_jar(socket.assigns.jar, %{collected_amount: collected_amount})

    {:noreply, socket |> assign(:transaction, transaction) |> push_patch(to: ~p"/jars/#{socket.assigns.jar.uri}/success")}
  end

  def handle_event("submit_transaction", %{"payload" => %{"error" => error}}, socket) do
    {:noreply, socket |> assign(:error, error) |> push_patch(to: ~p"/jars/#{socket.assigns.jar.uri}/error")}
  end

  defp to_usd(rate, money) do
    Money.to_string(Money.multiply(rate, Money.to_decimal(money)), symbol_on_right: false, symbol_space: false)
  end
end
