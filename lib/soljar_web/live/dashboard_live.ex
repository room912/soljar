defmodule SoljarWeb.DashboardLive do
  use SoljarWeb, :live_view

  alias Soljar.Accounts
  alias Soljar.Accounts.User
  alias Soljar.Jars.Jar
  alias Soljar.Transactions
  alias Soljar.Transactions.Transaction
  alias Soljar.Jars

  def render(assigns) do
    ~H"""
    <.menu />

    <.mobile_menu />

    <div class="flex-1 flex flex-col overflow-hidden">
      <.main_header wallet_address={@current_user.wallet_address} />

      <div class="flex-1 bg-gray-900 flex items-stretch overflow-hidden">
        <main class="flex-1 overflow-y-auto">
          <section
            aria-labelledby="primary-heading"
            class="min-w-0 flex-1 h-full flex flex-col lg:order-last"
          >
            <div class="p-8 md:p-16">
              <%= if length(@jars) > 0 do %>
                <div class="flex justify-between">
                  <div>
                    <h2 class="font-semibold text-2xl text-gray-50 tracking-tight">Your Jars</h2>
                    <p class="text-gray-300 text-sm">A list of all the jars in your account including their name, balance, views.</p>
                  </div>
                  <div>
                    <.link_button
                      class="py-2 flex justify-center md:py-1"
                      patch={~p"/dashboard/jars/new"}
                    >
                      <.icon name="hero-plus-solid" class="xl:mr-2" />
                      <span class="hidden xl:inline">Create jar</span>
                    </.link_button>
                  </div>
                </div>

                <ul role="list" class="space-y-2 mt-8">
                  <%= for jar <- @jars do %>
                      <li class="relative bg-gray-950 rounded-xl py-5 px-4 hover:bg-gray-800 group">
                        <.link patch={~p"/dashboard/jars/#{jar.id}/edit"}>
                          <div class="flex justify-between items-center space-x-3">
                            <div class="min-w-0 flex-1">
                              <span class="absolute inset-0" aria-hidden="true"></span>
                              <p class="text-sm font-semibold text-gray-100 truncate space-x-1">
                                <span class="text-gray-200 font-light"><%= jar.collector_name %></span>
                                <span>•</span>
                                <span><%= jar.name %></span>
                                <span>•</span>
                                <.network_label network={jar.cluster_api_url} />
                              </p>
                              <p class="text-xs text-gray-100 truncate mt-1">
                                <%= jar.description %>
                              </p>

                              <div class="text-sm mt-1 text-gray-400 flex space-x-1 items-center group-hover:text-rose-50">
                                <.icon name="hero-eye-mini" class="w-3 h-3" /> <span><%= jar.views %></span>
                              </div>
                            </div>

                            <div class="text-gray-50">
                              <p class="font-bold text-right"><%= Money.to_string(jar.collected_amount) || 0 %>/<%= jar.goal_amount %></p>
                              <p class="text-xs text-right text-gray-400 group-hover:text-rose-50"><%= to_usd(@rate.usd, jar.collected_amount) %>/<%= to_usd(@rate.usd, jar.goal_amount) %></p>
                            </div>
                          </div>
                        </.link>
                      </li>
                  <% end %>
                </ul>
              <% else %>
                <div class="text-center">
                  <svg
                    class="mx-auto h-12 w-12 text-gray-400"
                    fill="none"
                    viewBox="0 0 24 24"
                    stroke="currentColor"
                    aria-hidden="true"
                  >
                    <path
                      vector-effect="non-scaling-stroke"
                      stroke-linecap="round"
                      stroke-linejoin="round"
                      stroke-width="2"
                      d="M9 13h6m-3-3v6m-9 1V7a2 2 0 012-2h6l2 2h6a2 2 0 012 2v8a2 2 0 01-2 2H5a2 2 0 01-2-2z"
                    />
                  </svg>
                  <h3 class="mt-2 text-sm font-medium text-gray-50">No jars</h3>
                  <p class="mt-1 text-sm text-gray-500">Get started by creating a new jar.</p>
                  <div class="mt-6">
                    <.link_button
                      patch={~p"/dashboard/jars/new"}
                      class="py-2"
                    >
                      <.icon name="hero-plus-solid" class="mr-2" />
                      New Jar
                    </.link_button>
                  </div>
                </div>
              <% end %>
            </div>
          </section>
        </main>

        <aside class="hidden p-8 w-96 bg-gray-900 border-l border-gray-800 overflow-y-auto lg:block">
          <div :if={Enum.count(@transactions) == 0} class="text-center">
            <svg
              class="mx-auto h-12 w-12 text-gray-400"
              fill="none"
              viewBox="0 0 24 24"
              stroke="currentColor"
              aria-hidden="true"
            >
              <path
                vector-effect="non-scaling-stroke"
                stroke-linecap="round"
                stroke-linejoin="round"
                stroke-width="2"
                d="M9 13h6m-3-3v6m-9 1V7a2 2 0 012-2h6l2 2h6a2 2 0 012 2v8a2 2 0 01-2 2H5a2 2 0 01-2-2z"
              />
            </svg>
            <h3 class="mt-2 text-sm font-medium text-gray-50">No transactions</h3>
            <p class="mt-1 text-sm text-gray-500">Collect funds to see latest transactions.</p>
          </div>

          <div :if={Enum.count(@transactions) > 0}>
            <h2 class="text-gray-50 text-lg font-semibold tracking-tigh">Recent Transactions</h2>

            <div class="flex flex-col space-y-6 mt-8">
              <%= for transaction <- @transactions do %>
                <div class="flex text-gray-50 space-x-3 items-center">
                  <div class="flex-1 truncate">
                    <div>
                      <.link class="flex items-center space-x-2 text-sm group hover:text-rose-400" target="_blank" href={"https://solscan.io/tx/#{transaction.sig}?cluster=devnet"}>
                        <span><%= Transaction.to_string(transaction) %></span>
                        <.icon class="h-3 text-gray-100 group-hover:text-rose-400" name="hero-arrow-top-right-on-square" />
                      </.link>
                      <div class="text-gray-400 text-xs">
                        <.link patch={~p"/dashboard/jars/#{transaction.jar_id}/edit"} class="flex items-center space-x-2 group">
                          <.icon name="hero-archive-box-arrow-down" class="w-4 h-4 flex-shrink-0 text-gray-300 group-hover:text-rose-400" />
                          <span class="truncate text-gray-300 group-hover:text-rose-400"><%= transaction.jar.name %></span>
                        </.link>
                      </div>
                    </div>
                    <div class="text-xs text-gray-400 flex space-x-1">
                      <p><%= transaction.name %></p>
                      <p><%= transaction.message %></p>
                    </div>
                  </div>

                  <div class="text-xs flex justify-end flex-col w-28">
                    <div class="text-green-400 text-right">+<%= Money.to_string(transaction.amount) %></div>
                    <span class="text-right text-gray-400"><%= Timex.from_now(transaction.inserted_at) %></span>
                  </div>
                </div>
              <% end %>
            </div>
          </div>

        </aside>
      </div>
    </div>

    <.form
      id="log-out"
      for={%{}}
      as={:user}
      action={~p"/users/log_out"}
      method="post"
      phx-trigger-action={@trigger_log_out}
      phx-hook="LogOut"
    >
    </.form>

    <.modal
      :if={@live_action in [:new, :edit]}
      id="jar-modal"
      show
      on_cancel={JS.patch(~p"/dashboard")}
    >
      <.header>
        <%= @page_title %>

        <%!-- <%= if @current_jar do %>
          <.link class="text-blue-500 hover:text-blue-300" href={~p"/jars/#{@current_jar.uri}"} target="_blank"><%= @page_title %></.link>
          <.icon class="ml-1 text-blue-500" name="hero-arrow-up-right" />
        <% else %>
        <% end %> --%>

        <:subtitle>Use this form to manage your jar.</:subtitle>
      </.header>

      <div class="text-gray-400 text-xs flex flex-col space-y-1 mt-2 md:space-y-0 md:flex-row md:items-center md:space-x-3" :if={@current_jar}>
        <div class="relative">
          <.link type="hidden" id="jar-link" href={~p"/jars/#{@current_jar.uri}"}></.link>
          <div id="copy-tooltip" class="absolute -mt-4 text-center opacity-0 ml-20 bottom-0 md:ml-auto md:bottom-auto md:inset-x-0 ">Copied</div>

          <button class="flex space-x-1 items-center hover:text-gray-100" phx-click={JS.dispatch("phx:copy", to: "#jar-link")}><.icon name="hero-link" class="w-4 h-4" /><span>Copy Link</span></button>
        </div>
        <.link class="flex space-x-1 items-center hover:text-gray-100" href={~p"/jars/#{@current_jar.uri}"} target="_blank"><.icon name="hero-arrow-top-right-on-square" class="w-4 h-4" /><span>Open in new tab</span></.link>
      </div>

      <.simple_form for={@form} id="jar-form" phx-change="validate" phx-submit="save">
        <div class="flex w-full space-x-4">
          <.input field={@form[:name]} type="text" label="Jar Name*" />
          <.input field={@form[:collector_name]} type="text" label="Collector name*" />
        </div>
        <.input field={@form[:goal_amount]} value={if @current_jar, do: Money.to_decimal(@current_jar.goal_amount)} type="text" label={"Goal amount in SOL (1 SOL = #{@rate.usd})*"} />
        <div id="description" phx-hook="SymbolsCount" phx-update="ignore">
          <.input field={@form[:description]} maxlength="240" type="textarea" label="Description" />
          <div class="text-gray-400 text-xs flex justify-end mt-0"><span id="symbols-count">0</span>/240</div>
        </div>

        <div>
          <.label>
            Photo
          </.label>
          <div class="flex items-center mt-2">
            <div
              class={[
                "flex justify-center flex-shrink-0 items-center text-white font-semibold text-3xl",
                "w-20 h-20 bg-gradient-to-b from-purple-600 via-indigo-600 to-rose-600 border-purple-500 rounded-full",
                no_photo?(@current_jar, @uploads.photo.entries) && "p-5",
                !no_photo?(@current_jar, @uploads.photo.entries) && "overflow-hidden"
              ]}
            >
              <%= if no_photo?(@current_jar, @uploads.photo.entries) do %>
                <img class="w-auto h-auto" src="/images/jar.png" />
              <% else %>
                <%= for entry <- @uploads.photo.entries do %>
                  <.live_img_preview class="w-full h-full object-cover" entry={entry} />
                <% end %>
                <img :if={@uploads.photo.entries |> Enum.count() == 0} class="w-full h-full object-cover" src={@current_jar.photo_path} />
              <% end %>
            </div>
            <label
              class="ml-5 bg-gray-700 py-2 px-3 rounded-md shadow-sm text-sm leading-4 font-medium text-gray-100 hover:bg-gray-500 focus:outline-none focus:ring-2 focus:ring-indigo-500"
            >
              Change
              <.live_file_input class="hidden" id="upload" upload={@uploads.photo} />
            </label>
          </div>
        </div>

        <fieldset>
          <legend class="text-base font-medium text-gray-100">Select a network</legend>

          <div class="mt-4 grid grid-cols-1 gap-y-6 sm:grid-cols-3 sm:gap-x-4">
            <label
              phx-click="select_network"
              phx-value-network="devnet"
              class={
                [
                  @network == "devnet" && "ring-2 ring-indigo-700 border-transparent",
                  "relative bg-gray-800 border border-gray-600 rounded-lg shadow-sm p-4 flex cursor-pointer focus:outline-none"
                ]
              }
            >
              <input type="radio" name="devnet" value="devnet" class="sr-only" aria-labelledby="devnet">
              <div class="flex-1 flex">
                <div class="flex flex-col">
                  <span id="project-type-0-label" class="block text-sm font-medium text-gray-100"> Devnet </span>
                  <span id="project-type-0-description-0" class="mt-1 flex items-center text-sm text-gray-400">Tokens on Devnet are not real assets.</span>
                  <span id="project-type-0-description-1" class="mt-6 text-sm font-medium text-gray-100"> For testing purpose </span>
                </div>
              </div>
              <svg class={[@network != "devnet" && "invisible", "h-5 w-5 text-indigo-600"]} xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor" aria-hidden="true">
                <path fill-rule="evenodd" d="M10 18a8 8 0 100-16 8 8 0 000 16zm3.707-9.293a1 1 0 00-1.414-1.414L9 10.586 7.707 9.293a1 1 0 00-1.414 1.414l2 2a1 1 0 001.414 0l4-4z" clip-rule="evenodd" />
              </svg>
              <div class={[@network == "devnet" && "border border-indigo-700", @network != "devnet" && "border-2 border-transparent", "absolute -inset-px rounded-lg pointer-events-none"]} aria-hidden="true"></div>
            </label>

            <label
              phx-click="select_network"
              phx-value-network="testnet"
              class={
                [
                  @network == "testnet" && "ring-2 ring-indigo-700 border-transparent",
                  "relative bg-gray-800 border border-gray-600 rounded-lg shadow-sm p-4 flex cursor-pointer focus:outline-none"
                ]
              }
            >
              <input type="radio" name="testnet" value="testnet" class="sr-only" aria-labelledby="testnet">
              <div class="flex-1 flex">
                <div class="flex flex-col">
                  <span id="project-type-1-label" class="block text-sm font-medium text-gray-100"> Testnet </span>
                  <span id="project-type-1-description-0" class="mt-1 flex items-center text-sm text-gray-400">Tokens on Testnet are not real assets.</span>
                  <span id="project-type-1-description-1" class="mt-6 text-sm font-medium text-gray-100"> Oriented to be used by validators </span>
                </div>
              </div>
              <svg class={[@network != "testnet" && "invisible", "h-5 w-5 text-indigo-600"]} xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor" aria-hidden="true">
                <path fill-rule="evenodd" d="M10 18a8 8 0 100-16 8 8 0 000 16zm3.707-9.293a1 1 0 00-1.414-1.414L9 10.586 7.707 9.293a1 1 0 00-1.414 1.414l2 2a1 1 0 001.414 0l4-4z" clip-rule="evenodd" />
              </svg>
              <div class={[@network == "testnet" && "border border-indigo-700", @network != "testnet" && "border-2 border-transparent", "absolute -inset-px rounded-lg pointer-events-none"]} aria-hidden="true"></div>
            </label>

            <label
              phx-click="select_network"
              phx-value-network="mainnet-beta"
              class={
                [
                  @network == "mainnet-beta" && "ring-2 ring-green-700 border-transparent",
                  "relative bg-gray-800 border border-gray-600 rounded-lg shadow-sm p-4 flex cursor-pointer focus:outline-none"
                ]
              }
            >
              <input type="radio" name="mainnet-beta" value="mainnet-beta" class="sr-only" aria-labelledby="mainnet-beta">
              <div class="flex-1 flex">
                <div class="flex flex-col">
                  <span id="project-type-2-label" class="block text-sm font-medium text-gray-100"> Mainnet </span>
                  <span id="project-type-2-description-0" class="mt-1 flex items-center text-sm text-gray-400"> Tokens on Mainnet are real assets. </span>
                  <span id="project-type-2-description-1" class="mt-6 text-sm font-medium text-gray-100"> For production </span>
                </div>
              </div>
              <svg class={[@network != "mainnet-beta" && "invisible", "h-5 w-5 text-green-600"]} xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor" aria-hidden="true">
                <path fill-rule="evenodd" d="M10 18a8 8 0 100-16 8 8 0 000 16zm3.707-9.293a1 1 0 00-1.414-1.414L9 10.586 7.707 9.293a1 1 0 00-1.414 1.414l2 2a1 1 0 001.414 0l4-4z" clip-rule="evenodd" />
              </svg>
              <div class={[@network == "mainnet-beta" && "border border-green-700", @network != "mainnet-beta" && "border-2 border-transparent", "absolute -inset-px rounded-lg pointer-events-none"]} aria-hidden="true"></div>
            </label>
          </div>
        </fieldset>


        <:actions>
          <.button phx-disable-with="Saving...">Save Jar</.button>
          <button
            :if={@live_action in [:edit]}
            class="text-red-500 hover:text-red-400 text-sm font-semibold leading-6 py-2 px-3 rounded-lg"
            phx-click="delete"
            phx-value-id={if @current_jar, do: @current_jar.id}
            data-confirm="Are you sure?"
            phx-disable-with="Deleting..."
          >
            Delete Jar
          </button>
        </:actions>
      </.simple_form>
    </.modal>
    """
  end

  def mount(_params, _session, socket) do
    %{current_user: current_user} = socket.assigns

    if connected?(socket) do
      Accounts.subscribe(current_user.id)
    end

    rate = Soljar.SolRates.latest()
    jars = Jars.user_jars(current_user.id)
    transactions = Transactions.list_transactions(current_user.id)

    {:ok,
     socket
     |> assign(jars: jars, trigger_log_out: false, current_jar: nil, transactions: transactions, rate: rate, network: nil)
     |> assign(:uploaded_photos, [])
     |> allow_upload(:photo, accept: ~w(.jpg .jpeg))}
  end

  def handle_info({Soljar.Jars, %Soljar.Jars.Events.JarUpdated{jar: updated_jar}}, socket) do
    socket =
      socket
      |> update(:jars, fn jars ->
        jars |> Enum.map(fn jar -> if jar.id == updated_jar.id, do: updated_jar, else: jar end)
      end)

    {:noreply, socket}
  end

  def handle_info({Soljar.Jars, %Soljar.Jars.Events.JarUpdated{jar: updated_jar}}, socket) do
    socket =
      socket
      |> update(:jars, fn jars ->
        jars |> Enum.map(fn jar -> if jar.id == updated_jar.id, do: updated_jar, else: jar end)
      end)

    {:noreply, socket}
  end

  def handle_info({Soljar.Transactions, %Soljar.Transactions.Events.TransactionSubmited{transaction: transaction}}, socket) do
    socket =
      socket
      |> update(:transactions, fn transactions -> [transaction | transactions] end)

    {:noreply, socket}
  end

  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  def handle_event("validate", _params, socket) do
    {:noreply, socket}
  end

  def handle_event("log_out", _params, socket) do
    {:noreply, assign(socket, trigger_log_out: true)}
  end

  def handle_event("clear_session_storage", _params, socket) do
    {:noreply, push_event(socket, "clear_session_storage", %{})}
  end

  def handle_event("save", %{"jar" => jar_params}, socket) do
    uploaded_images =
      consume_uploaded_entries(socket, :photo, fn %{path: path}, _entry ->
        dest = Path.join([:code.priv_dir(:soljar), "static", "uploads", Path.basename(path)])
        # The `static/uploads` directory must exist for `File.cp!/2`
        # and MyAppWeb.static_paths/0 should contain uploads to work,.
        File.cp!(path, dest)
        {:ok, ~p"/uploads/#{Path.basename(dest)}"}
      end)

    photo_path = uploaded_images |> List.first()

    params =
      if photo_path do
        put_in(jar_params, ["photo_path"], photo_path)
      else
        jar_params
      end

    params =
      params
      |> Map.put("user_id", socket.assigns.current_user.id)
      |> Map.put("cluster_api_url", socket.assigns.network)

    save_jar(socket, socket.assigns.live_action, params)
  end

  defp save_jar(socket, :new, params) do
    case Jars.create_jar(params) do
      {:ok, _jar} ->
        {:noreply,
         socket
         |> put_flash(:info, "Jar created successfully")
         |> push_navigate(to: "/dashboard")}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp save_jar(socket, :edit, params) do
    case Jars.update_jar(socket.assigns.current_jar, params) do
      {:ok, _jar} ->
        {:noreply,
         socket
         |> put_flash(:info, "Jar updated successfully")
         |> push_navigate(to: "/dashboard")}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  def handle_event("delete", %{"id" => id}, socket) do
    jar = Jars.get_jar!(id)
    {:ok, _} = Jars.delete_jar(jar)

    {:noreply,
     socket
     |> put_flash(:info, "Jar created successfully")
     |> push_navigate(to: "/dashboard")}
  end

  def handle_event("select_network", %{"network" => network}, socket) do
    {:noreply, socket |> assign(:network, network)}
  end

  defp apply_action(socket, :new, _params) do
    changeset = Jars.change_jar(%Jar{})

    socket
    |> assign(page_title: "New Jar", current_jar: nil, network: nil)
    |> assign_form(changeset)
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    jar = Jars.get_jar!(id)
    changeset = Jars.change_jar(jar)

    socket
    |> assign(page_title: jar.name, current_jar: jar, network: jar.cluster_api_url)
    |> assign_form(changeset)
  end

  defp apply_action(socket, :page, _params) do
    socket
    |> assign(:page_title, "Listing Jars")
    |> assign(:jar, nil)
  end

  defp assign_form(socket, %Ecto.Changeset{} = changeset) do
    assign(socket, :form, to_form(changeset))
  end

  defp to_usd(rate, money) do
    Money.to_string(Money.multiply(rate, Money.to_decimal(money)), symbol_on_right: false, symbol_space: false)
  end

  defp no_photo?(nil, []), do: true
  defp no_photo?(%Jar{photo_path: nil}, []), do: true
  defp no_photo?(%Jar{photo_path: _path}, []), do: false
  defp no_photo?(_, _entries), do: false
end
