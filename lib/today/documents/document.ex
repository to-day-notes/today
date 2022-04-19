defmodule Today.Documents.Document do
  use Ecto.Schema
  import Ecto.Changeset

  schema "documents" do
    field :body, :map
    field :name, :string

    timestamps()
  end

  @doc false
  def changeset(document, attrs) do
    document
    |> cast(attrs, [:name, :body])
    |> validate_required([:name, :body])
  end
end
