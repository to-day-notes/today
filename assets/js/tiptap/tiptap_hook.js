let TiptapHook = {
  async mounted() {
    let core = await import("@tiptap/core");
    let starterKit = await import("@tiptap/starter-kit");
    let collaboration = await import("@tiptap/extension-collaboration");
    let hocuspocusProvider = await import("@hocuspocus/provider");

    // Set up the Hocuspocus WebSocket provider
    const provider = new hocuspocusProvider.HocuspocusProvider({
      url: "ws://127.0.0.1:1234",
      name: "example-document",
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
          document: provider.document,
        }),
      ],
    });
  },
};

export { TiptapHook };
