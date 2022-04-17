defmodule TodayWeb.TiptapLive do
  use TodayWeb, :live_view
  alias Phoenix.PubSub
  alias Today.Utils

  @impl true
  def mount(_params, _session, socket) do
    if connected?(socket), do: PubSub.subscribe(Today.PubSub, "tiptap")
    {:ok, assign(socket, :username, Utils.generate_name())}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <%= @username %>
    <div phx-hook="TiptapHook" id="editors">
      <div id="editor"></div>
    </div>
    """
  end

  @impl true
  def handle_event("editor_changed", %{} = params, socket) do
    PubSub.broadcast(Today.PubSub, "tiptap", {:editor_changed, params, socket.assigns.username})
    {:noreply, socket}
  end

  @impl true
  def handle_info({:editor_changed, data, origin}, socket) do
    username = socket.assigns.username

    case origin do
      ^username -> {:noreply, socket}
      _ -> {:noreply, push_event(socket, "editor_changed", data)}
    end
  end
end
