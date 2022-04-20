defmodule TodayWeb.EditorLive do
  use TodayWeb, :live_view
  alias Phoenix.LiveView.JS
  alias Today.Documents
  alias Today.Helpers

  def mount(_params, _uri, socket) do
    socket =
      socket
      |> assign(:documents, Documents.list_documents())
      |> assign(:current_document, nil)

    {:ok, socket}
  end

  def handle_params(%{"slug" => slug}, _uri, socket) do
    [id | _] = String.split(slug, "-")
    {:noreply, assign(socket, :current_document, Documents.get_document!(id))}
  end

  def handle_params(_params, _uri, socket) do
    {:noreply, socket}
  end

  def handle_event("create_document", params, socket) do
    document = Documents.create_document(params["new_document_name"], params["body"])

    socket =
      socket
      |> update(:documents, &[document | &1])
      |> assign(:current_document, document)

    {:noreply, socket}
  end

  def handle_event("save_document", %{"body" => body}, socket) do
    Documents.update_document(socket.assigns.current_document, %{body: body})
    {:noreply, socket}
  end

  def render(assigns) do
    ~H"""
    <div class="container flex p-2">
      <div class="mr-1 w-2/12">
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
            <%= if @current_document && @current_document.id == document.id do %>
              <li class="flex mb-2 text-blue-500 bg-gray-100 rounded">
                <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" fill="currentColor" viewBox="0 0 16 16">
                  <path d="M14 4.5V14a2 2 0 0 1-2 2H4a2 2 0 0 1-2-2V2a2 2 0 0 1 2-2h5.5L14 4.5zm-3 0A1.5 1.5 0 0 1 9.5 3V1H4a1 1 0 0 0-1 1v12a1 1 0 0 0 1 1h8a1 1 0 0 0 1-1V4.5h-2z" />
                </svg>
                <%= document.name %>
              </li>
            <% else %>
              <li class="flex mb-2 rounded cursor-pointer hover:bg-gray-100">
                <%= live_patch to: Routes.editor_path(@socket, :index, Helpers.slugify(document)), class: "w-full flex" do %>
                  <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" fill="currentColor" viewBox="0 0 16 16">
                    <path d="M14 4.5V14a2 2 0 0 1-2 2H4a2 2 0 0 1-2-2V2a2 2 0 0 1 2-2h5.5L14 4.5zm-3 0A1.5 1.5 0 0 1 9.5 3V1H4a1 1 0 0 0-1 1v12a1 1 0 0 0 1 1h8a1 1 0 0 0 1-1V4.5h-2z" />
                  </svg>
                  <%= document.name %>
                <% end %>
              </li>
            <% end %>
          <% end %>
        </ul>
      </div>
      <div id="editor-wrapper" phx-hook="EditorHook" class="w-10/12">
        <div id="toolbar" class="flex justify-center mb-2">
          <%= if @current_document do %>
            <span class="mr-3 text-xl"><%= @current_document.name %></span>
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
        <%= if @current_document do %>
          <input type="hidden" id="document-content" value={Jason.encode!(@current_document.body)} />
        <% end %>
      </div>
    </div>
    """
  end
end
