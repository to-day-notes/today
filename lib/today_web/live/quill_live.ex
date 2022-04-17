defmodule TodayWeb.QuillLive do
  use TodayWeb, :live_view

  def render(assigns) do
    ~H"""
    <div phx-hook="QuillHook" id="editor"></div>
    """
  end
end
