let TiptapHook = {
  async mounted() {
    let core = await import("@tiptap/core");
    let starterKit = await import("@tiptap/starter-kit");
    let collaboration = await import("@tiptap/extension-collaboration");
    let y = await import("yjs");

    // Set up the Hocuspocus WebSocket provider
    const ydoc = new y.Doc();

    ydoc.on("update", (update, origin) => {
      let base64 = btoa(String.fromCharCode.apply(null, update));
      this.pushEvent("editor_changed", { update: base64 });
    });

    this.handleEvent("editor_changed", (data) => {
      let update = new Uint8Array(
        atob(data.update)
          .split("")
          .map((char) => char.charCodeAt(0))
      );
      y.applyUpdate(ydoc, update, this);
    });
    const editor = new core.Editor({
      element: document.querySelector("#editor"),
      extensions: [
        starterKit.default.configure({
          // The Collaboration extension comes with its own history handling
          history: false,
        }),
        // Register the document with Tiptap
        collaboration.Collaboration.configure({
          document: ydoc,
        }),
      ],
    });
  },
};

export { TiptapHook };
