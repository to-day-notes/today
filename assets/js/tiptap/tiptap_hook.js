import * as Y from "yjs";
import { Observable } from "lib0/observable";

class Provider extends Observable {
  constructor(ydoc) {
    super();
    this.doc = ydoc;
    ydoc.on("update", (update, origin) => {
      // ignore updates applied by this provider
      console.log("ydoc update");
      console.log(update, origin);
      if (origin !== this) {
        // this update was produced either locally or by another provider.
                     this.emit('update', [update])
      }
    });
    // listen to an event that fires when a remote update is received
    this.on("update", (update) => {
      console.log("provider update");
      console.log("update");
      Y.applyUpdate(ydoc, update, this); // the third parameter sets the transaction-origin
    });
  }
}

let TiptapHook = {
  async mounted() {
    let core = await import("@tiptap/core");
    let starterKit = await import("@tiptap/starter-kit");
    let collaboration = await import("@tiptap/extension-collaboration");
    let hocuspocusProvider = await import("@hocuspocus/provider");

    // Set up the Hocuspocus WebSocket provider
      const ydoc = new Y.Doc()
    const provider = new Provider(ydoc);

    const editor = new core.Editor({
      element: document.querySelector("#editor"),
      extensions: [
        starterKit.default.configure({
          // The Collaboration extension comes with its own history handling
          history: false,
        }),
        // Register the document with Tiptap
        collaboration.Collaboration.configure({
          document: provider.doc,
        }),
      ],
    });
    const editor1 = new core.Editor({
      element: document.querySelector("#editor1"),
      extensions: [
        starterKit.default.configure({
          // The Collaboration extension comes with its own history handling
          history: false,
        }),
        // Register the document with Tiptap
        collaboration.Collaboration.configure({
          document: provider.doc,
        }),
      ],
    });
  },
};

export { TiptapHook };
