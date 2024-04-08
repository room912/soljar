defmodule Soljar.JarsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Soljar.Jars` context.
  """

  @doc """
  Generate a jar.
  """
  def jar_fixture(attrs \\ %{}) do
    {:ok, jar} =
      attrs
      |> Enum.into(%{
        name: "some name"
      })
      |> Soljar.Jars.create_jar()

    jar
  end
end
