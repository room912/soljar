defmodule SoljarWeb.JarLive.Index do
  use SoljarWeb, :live_view

  alias Soljar.Jars
  alias Soljar.Jars.Jar

  @impl true
  def mount(_params, _session, socket) do
    {:ok, stream(socket, :jars, Jars.list_jars())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Jar")
    |> assign(:jar, Jars.get_jar!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Jar")
    |> assign(:jar, %Jar{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Jars")
    |> assign(:jar, nil)
  end

  @impl true
  def handle_info({SoljarWeb.JarLive.FormComponent, {:saved, jar}}, socket) do
    {:noreply, stream_insert(socket, :jars, jar)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    jar = Jars.get_jar!(id)
    {:ok, _} = Jars.delete_jar(jar)

    {:noreply, stream_delete(socket, :jars, jar)}
  end
end
