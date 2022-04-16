defmodule TodayWeb.TiptapLive do
  use TodayWeb, :live_view

  def render(assigns) do
    ~H"""
    <div phx-hook="TiptapHook" id="editor"></div>
    """
  end
end
