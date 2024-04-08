defmodule SoljarWeb.SettingsLive do
  use SoljarWeb, :live_view

  def render(assigns) do
    ~H"""
    <.menu />

    <.mobile_menu />

    <div class="flex-1 flex flex-col overflow-hidden">
      <.main_header wallet_address={@current_user.wallet_address} />

      <main class="flex-1 overflow-y-auto">
        <section
          aria-labelledby="primary-heading"
          class="min-w-0 flex-1 h-full flex flex-col lg:order-last"
        >
          <div class="p-8 md:p-16">
            <h2 class="font-semibold text-2xl text-gray-50 tracking-tight">Settings</h2>
          </div>
        </section>
      </main>

    </div>
    """
  end
end
