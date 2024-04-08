defmodule Soljar.Repo.Migrations.AddPhotoPathToJars do
  use Ecto.Migration

  def change do
    alter table(:jars) do
      add :photo_path, :string
    end
  end
end
