defmodule TodayWeb.EditorLive do
  use TodayWeb, :live_view
  alias Today.Documents

  def mount(_params, _session, socket) do
    {:ok, assign(socket, :document, nil), layout: false}
  end

  def handle_event("load_document", params, socket) do
    {:noreply, assign(socket, :document, Documents.get_document!(params["document"]))}
  end

  def render(assigns) do
    ~H"""
    <div id="editor-wrapper" phx-hook="EditorHook">
      <div id="toolbar" class="flex justify-center mb-2">
        <%= if @document do %>
          <span class="mr-3 text-xl"><%= @document.name %></span>
        <% else %>
          <input
            type="text"
            name="document_name"
            id="document-name"
            placeholder={gettext("Document name")}
            class="p-1 mr-1 rounded"
          />
        <% end %>
        <button id="save-document">
          <svg
            xmlns="http://www.w3.org/2000/svg"
            width="32"
            height="32"
            fill="currentColor"
            class="bi bi-save"
            viewBox="0 0 16 16"
          >
            <path d="M2 1a1 1 0 0 0-1 1v12a1 1 0 0 0 1 1h12a1 1 0 0 0 1-1V2a1 1 0 0 0-1-1H9.5a1 1 0 0 0-1 1v7.293l2.646-2.647a.5.5 0 0 1 .708.708l-3.5 3.5a.5.5 0 0 1-.708 0l-3.5-3.5a.5.5 0 1 1 .708-.708L7.5 9.293V2a2 2 0 0 1 2-2H14a2 2 0 0 1 2 2v12a2 2 0 0 1-2 2H2a2 2 0 0 1-2-2V2a2 2 0 0 1 2-2h2.5a.5.5 0 0 1 0 1H2z" />
          </svg>
        </button>
      </div>
      <div id="editor" class="h-screen" phx-update="ignore"></div>
      <%= if @document do %>
        <input type="hidden" id="document-id" value={@document.id} />
        <input type="hidden" id="document-content" value={Jason.encode!(@document.body)} />
      <% end %>
    </div>
    """
  end
end
