defmodule TodayWeb.TiptapLive do
  use TodayWeb, :live_view

  def render(assigns) do
    ~H"""
    <div phx-hook="TiptapHook" id="editors">
      <div id="editor"></div>
      <div id="editor1"></div>
    </div>
    """
  end
end
