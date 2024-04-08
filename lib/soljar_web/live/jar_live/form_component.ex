defmodule SoljarWeb.JarLive.FormComponent do
  use SoljarWeb, :live_component

  alias Soljar.Jars

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        <%= @title %>
        <:subtitle>Use this form to manage jar records in your database.</:subtitle>
      </.header>

      <.simple_form
        for={@form}
        id="jar-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input field={@form[:name]} type="text" label="Name" />
        <:actions>
          <.button phx-disable-with="Saving...">Save Jar</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{jar: jar} = assigns, socket) do
    changeset = Jars.change_jar(jar)

    {:ok,
     socket
     |> assign(assigns)
     |> assign_form(changeset)}
  end

  @impl true
  def handle_event("validate", %{"jar" => jar_params}, socket) do
    changeset =
      socket.assigns.jar
      |> Jars.change_jar(jar_params)
      |> Map.put(:action, :validate)

    {:noreply, assign_form(socket, changeset)}
  end

  def handle_event("save", %{"jar" => jar_params}, socket) do
    save_jar(socket, socket.assigns.action, jar_params)
  end

  defp save_jar(socket, :edit, jar_params) do
    case Jars.update_jar(socket.assigns.jar, jar_params) do
      {:ok, jar} ->
        notify_parent({:saved, jar})

        {:noreply,
         socket
         |> put_flash(:info, "Jar updated successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp save_jar(socket, :new, jar_params) do
    case Jars.create_jar(jar_params) do
      {:ok, jar} ->
        notify_parent({:saved, jar})

        {:noreply,
         socket
         |> put_flash(:info, "Jar created successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp assign_form(socket, %Ecto.Changeset{} = changeset) do
    assign(socket, :form, to_form(changeset))
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})
end
