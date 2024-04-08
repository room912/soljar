defmodule SoljarWeb.DemoLive do
  use SoljarWeb, :live_view

  def render(assigns) do
    ~H"""
      <div class="mt-16 flex justify-center px-16 xl:px-64">
        <video src="/images/demo.mov" class="rounded-xl" autoplay controls>
          Sorry, your browser doesn't support embedded videos, but don't worry, you can
          <a href="/images/demo.mov">download it</a>
          and watch it with your favorite video player!
        </video>
      </div>
    """
  end
end
