defmodule TodayWeb.EditorLive do
  use TodayWeb, :live_view

  def render(assigns) do
    ~H"""
    <div phx-hook="EditorHook" id="editors">
    <div id="editor" style="margin-bottom: 23px"></div>
    <div id="editor1" style="margin-bottom: 23px"></div>
    <div id="editor2" style="margin-bottom: 23px"></div>
    </div>
    """
  end
end
