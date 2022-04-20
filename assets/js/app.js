// If you want to use Phoenix channels, run `mix help phx.gen.channel`
// to get started and then uncomment the line below.
// import "./user_socket.js"

// You can include dependencies in two ways.
//
// The simplest option is to put them in assets/vendor and
// import them using relative paths:
//
//     import "../vendor/some-package.js"
//
// Alternatively, you can `npm install some-package --prefix assets` and import
// them using a path starting with the package name:
//
//     import "some-package"
//

// Include phoenix_html to handle method=PUT/DELETE in forms and buttons.
import "phoenix_html";
// Establish Phoenix Socket and LiveView configuration.
import { Socket } from "phoenix";
import { LiveSocket } from "phoenix_live_view";
import topbar from "../vendor/topbar";

import { Editor } from "@tiptap/core";
import StarterKit from "@tiptap/starter-kit";

let hooks = {};

let EditorHook = {
  mounted() {
    this.editor = new Editor({
      element: document.querySelector("#editor"),
      extensions: [StarterKit],
      editorProps: {
        attributes: {
          class: "focus:outline-none h-full border border-gray-500 rounded p-2",
        },
      },
      autofocus: true,
    });
    const saveButton = document.getElementById("save-document");
    saveButton.onclick = () => {
      const documentName = document.getElementById("document-name");
      if (documentName && documentName.value) {
        this.pushEventTo("#document-form", "create_document", {
          new_document_name: documentName.value,
          body: this.editor.getJSON(),
        });
      } else {
        this.pushEventTo("#document-form", "save_document", {
          body: this.editor.getJSON(),
        });
      }
    };
  },
  updated() {
    const documentContent = document.getElementById("document-content").value;
    this.editor.commands.setContent(JSON.parse(documentContent));
  },
};

hooks.EditorHook = EditorHook;
let csrfToken = document
  .querySelector("meta[name='csrf-token']")
  .getAttribute("content");
let liveSocket = new LiveSocket("/live", Socket, {
  params: { _csrf_token: csrfToken },
  hooks: hooks,
});

// Show progress bar on live navigation and form submits
topbar.config({ barColors: { 0: "#29d" }, shadowColor: "rgba(0, 0, 0, .3)" });
let topBarScheduled = undefined;

window.addEventListener("phx:page-loading-start", (info) => {
  if (!topBarScheduled) {
    topBarScheduled = setTimeout(() => topbar.show(), 200);
  }
});
window.addEventListener("phx:page-loading-stop", (info) => {
  clearTimeout(topBarScheduled);
  topBarScheduled = undefined;
  topbar.hide();
});

// connect if there are any LiveViews on the page
liveSocket.connect();

// expose liveSocket on window for web console debug logs and latency simulation:
// >> liveSocket.enableDebug()
// >> liveSocket.enableLatencySim(1000)  // enabled for duration of browser session
// >> liveSocket.disableLatencySim()
window.liveSocket = liveSocket;
