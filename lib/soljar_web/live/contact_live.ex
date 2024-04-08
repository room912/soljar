defmodule SoljarWeb.ContactLive do
  use SoljarWeb, :live_view

  def render(assigns) do
    ~H"""
    <div class="mt-16 flex flex-col px-14 items-center">
      <div class="text-center">
        <h2 class="text-4xl font-bold">Contact us</h2>
        <p class="text-gray-400">Please leave your message with email to proceed</p>
      </div>

      <.simple_form for={@form} phx-change="change" phx-submit="send" class="w-full md:w-3/4 lg:w-1/2">
        <.input name="email" field={@form[:email]} label="Email" />
        <.input type="textarea" field={@form[:message]} label="Message" />

        <.button class="w-full">Let's Talk</.button>
      </.simple_form>
    </div>
    """
  end

  def mount(_params, _session, socket) do
    {:ok, assign(socket, form: to_form(%{email: "", message: ""}), errors: [])}
  end

  def handle_event("send", %{"email" => e, "message" => m}, socket) do
    Soljar.Mailer.send_tg_message(e, m)

    {:noreply,
     socket
     |> put_flash(:info, "Message sent, thanks :)")
     |> assign(form: to_form(%{email: "", message: ""}))}
  end

  def handle_event("change", %{"email" => _e, "message" => _m} = params, socket) do
    {:noreply, assign(socket, form: to_form(params))}
  end
end
