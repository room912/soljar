defmodule SoljarWeb.LoginComponent do
  # In Phoenix apps, the line is typically: use MyAppWeb, :live_component
  use Phoenix.LiveComponent

  use SoljarWeb, :live_view

  alias Soljar.Accounts
  alias Soljar.Accounts.User

  def render(assigns) do
    ~H"""
    <div id="login">
      <.form for={@form} action={~p"/users/log_in"} as={:user} phx-trigger-action={@verify_signature} phx-target={@myself}>
        <.input type="hidden" name="address" value={@current_wallet_address} />
      </.form>


      <%= if @current_wallet_address do %>
        <div class="flex items-center justify-center">
          <div
            class="inline-block h-8 w-8 animate-spin rounded-full border-4 border-solid border-current border-e-transparent align-[-0.125em] text-surface motion-reduce:animate-[spin_1.5s_linear_infinite] dark:text-white"
            role="status">
            <span
              class="!absolute !-m-px !h-px !w-px !overflow-hidden !whitespace-nowrap !border-0 !p-0 ![clip:rect(0,0,0,0)]"
              >Loading...
            </span>
          </div>
        </div>
      <% end %>
    </div>
    """
  end

  def update(_assigns, socket) do
    {:ok,
    assign(socket,
      form: to_form(Accounts.change_user_registration(%User{email: "123@aa.aa"})),
      wallet_connected: false,
      current_wallet_address: nil,
      signature: nil,
      verify_signature: false
    )}
  end

  def handle_event("connect_wallet", %{"payload" => %{"address" => address}} = _params, socket) do
    dbg()
    {:noreply,
     socket
     |> assign(current_wallet_address: address)
     |> push_event("authenticate", %{})}
  end

  def handle_event("submit", _params, socket) do
    {:noreply, assign(socket, verify_signature: true)}
  end
end
