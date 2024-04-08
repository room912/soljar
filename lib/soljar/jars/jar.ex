defmodule Soljar.Jars.Jar do
  use Ecto.Schema
  import Ecto.Changeset

  alias Soljar.Accounts.User
  alias Soljar.Transactions.Transaction

  schema "jars" do
    field :name, :string
    field :collector_name, :string
    field :description, :string
    field :uri, :string
    field :views, :integer, default: 0
    field :goal_amount, Money.Ecto.Amount.Type
    field :collected_amount, Money.Ecto.Amount.Type
    field :cluster_api_url, :string
    field :photo_path, :string

    belongs_to :user, User
    has_many :transactions, Transaction

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(jar, attrs) do
    jar
    |> cast(attrs, [:name, :description, :uri, :user_id, :collector_name, :collected_amount, :goal_amount, :cluster_api_url, :photo_path])
    |> assoc_constraint(:user)
    |> validate_required([:name, :uri, :collector_name, :goal_amount])
  end

  def bump_views_changeset(jar, attrs) do
    jar
    |> cast(attrs, [:views])
  end

  def qr(jar, width \\ 30) do
    content = "#{SoljarWeb.Endpoint.url()}/jars/#{jar.uri}"

    content
    |> QRCodeEx.encode()
    |> QRCodeEx.svg(width: width, background_color: "#FFF")
  end
end
