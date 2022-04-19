defmodule Today.DocumentsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Today.Documents` context.
  """

  @doc """
  Generate a document.
  """
  def document_fixture(attrs \\ %{}) do
    {:ok, document} =
      attrs
      |> Enum.into(%{
        body: %{},
        name: "some name"
      })
      |> Today.Documents.create_document()

    document
  end
end
