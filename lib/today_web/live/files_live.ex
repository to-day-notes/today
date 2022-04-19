defmodule TodayWeb.FilesLive do
  use TodayWeb, :live_view
  alias Phoenix.LiveView.JS
  alias Today.Documents

  def mount(_params, _session, socket) do
    {:ok, assign(socket, :documents, Documents.list_documents()), layout: false}
  end

  def handle_event("create_document", %{"new_document_name" => name, "body" => body}, socket) do
    Documents.create_document(name, body)
    {:noreply, assign(socket, :documents, Documents.list_documents())}
  end

  def handle_event("create_document", %{"new_document_name" => name}, socket) do
    Documents.create_document(name)
    {:noreply, assign(socket, :documents, Documents.list_documents())}
  end

  def handle_event("save_document", %{"document" => document_id, "body" => body}, socket) do
    document = Documents.get_document!(document_id)
    Documents.update_document(document, %{body: body})
    {:noreply, assign(socket, :documents, Documents.list_documents())}
  end

  def render(assigns) do
    ~H"""
    <form class="flex mb-2" phx-submit="create_document" id="document-form">
      <input
        type="text"
        name="new_document_name"
        placeholder={gettext("New document name")}
        class="p-1 mr-1 w-11/12 rounded"
      />
      <button type="submit">
        <svg xmlns="http://www.w3.org/2000/svg" width="32" height="32" fill="currentColor" viewBox="0 0 16 16">
          <path d="M14 1a1 1 0 0 1 1 1v12a1 1 0 0 1-1 1H2a1 1 0 0 1-1-1V2a1 1 0 0 1 1-1h12zM2 0a2 2 0 0 0-2 2v12a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V2a2 2 0 0 0-2-2H2z" />
          <path d="M8 4a.5.5 0 0 1 .5.5v3h3a.5.5 0 0 1 0 1h-3v3a.5.5 0 0 1-1 0v-3h-3a.5.5 0 0 1 0-1h3v-3A.5.5 0 0 1 8 4z" />
        </svg>
      </button>
    </form>
    <ul class="">
      <%= for document <- @documents do %>
        <li
          class="flex mb-2 rounded cursor-pointer hover:bg-gray-100"
        phx-click={JS.push("load_document", value: %{document: document.id}, target: "#editor-wrapper")}
        >
          <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" fill="currentColor" viewBox="0 0 16 16">
            <path d="M14 4.5V14a2 2 0 0 1-2 2H4a2 2 0 0 1-2-2V2a2 2 0 0 1 2-2h5.5L14 4.5zm-3 0A1.5 1.5 0 0 1 9.5 3V1H4a1 1 0 0 0-1 1v12a1 1 0 0 0 1 1h8a1 1 0 0 0 1-1V4.5h-2z" />
          </svg>
          <%= document.name %>
        </li>
      <% end %>
    </ul>
    """
  end
end
