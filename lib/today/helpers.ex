defmodule Today.Helpers do
  def slugify(thing) when is_binary(thing) do
    thing
    |> String.downcase()
    |> String.replace(~r/[^a-z0-9\s-]/, "")
    |> String.replace(~r/(\s|-)+/, "-")
  end

  def slugify(thing) do
    "#{thing.id}-#{slugify(thing.name)}"
  end
end
