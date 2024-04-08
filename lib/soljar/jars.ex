defmodule Soljar.Jars do
  @moduledoc """
  The Jars context.
  """

  import Ecto.Query, warn: false
  alias Soljar.Repo

  alias Soljar.Jars.Jar

  @doc """
  Returns the list of jars.

  ## Examples

      iex> list_jars()
      [%Jar{}, ...]

  """
  def list_jars do
    Jar
    |> order_by(desc: :inserted_at)
    |> Repo.all()
  end

  def user_jars(user_id) do
    Jar
    |> where([j], j.user_id == ^user_id)
    |> order_by(desc: :inserted_at)
    |> Repo.all()
  end

  @doc """
  Gets a single jar.

  Raises `Ecto.NoResultsError` if the Jar does not exist.

  ## Examples

      iex> get_jar!(123)
      %Jar{}

      iex> get_jar!(456)
      ** (Ecto.NoResultsError)

  """
  def get_jar!(id), do: Repo.get!(Jar, id)
  def get_jar_by_uri(uri) do
    Jar
    |> preload(:user)
    |> Repo.get_by(uri: uri)
  end

  def view_jar(uri) do
    case get_jar_by_uri(uri) do
      nil -> {:error, :not_found}
      jar -> bump_views(jar)
    end
  end

  def bump_views(jar) do
    jar
    |> Jar.bump_views_changeset(%{views: jar.views + 1})
    |> Repo.update()
    |> case do
      {:ok, jar} ->
        Phoenix.PubSub.broadcast!(Soljar.PubSub, "user:#{jar.user_id}", {__MODULE__, %Soljar.Jars.Events.JarUpdated{jar: jar}})
        {:ok, jar}
      error -> error
    end
  end

  @doc """
  Creates a jar.

  ## Examples

      iex> create_jar(%{field: value})
      {:ok, %Jar{}}

      iex> create_jar(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_jar(attrs \\ %{}) do
    %Jar{uri: Nanoid.generate(9)}
    |> Jar.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a jar.

  ## Examples

      iex> update_jar(jar, %{field: new_value})
      {:ok, %Jar{}}

      iex> update_jar(jar, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_jar(%Jar{} = jar, attrs) do
    jar
    |> Jar.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a jar.

  ## Examples

      iex> delete_jar(jar)
      {:ok, %Jar{}}

      iex> delete_jar(jar)
      {:error, %Ecto.Changeset{}}

  """
  def delete_jar(%Jar{} = jar) do
    Repo.delete(jar)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking jar changes.

  ## Examples

      iex> change_jar(jar)
      %Ecto.Changeset{data: %Jar{}}

  """
  def change_jar(%Jar{} = jar, attrs \\ %{}) do
    Jar.changeset(jar, attrs)
  end
end
