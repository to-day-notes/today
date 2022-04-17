let MilkdownHook = {
  async mounted() {
    let y = await import("yjs");
    const ydoc = new y.Doc();
    ydoc.on("update", (update, _origin) => {
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

    let core = await import("@milkdown/core");
    let commonmark = await import("@milkdown/preset-commonmark");
    let nord = await import("@milkdown/theme-nord");
    let wp = await import("y-websocket");
    let collaborative = await import("./collab");
    const wsProvider = new wp.WebsocketProvider(
      "ws://localhost:1234",
      "milkdown",
      ydoc
    );
    core.Editor.make()
      .use(nord.nord)
      .use(commonmark.commonmark)
      .use(
        collaborative.collaborative.configure(collaborative.y, {
          ydoc,
          awareness: null,
        })
      )
      .create();
  },
};

export { MilkdownHook };
