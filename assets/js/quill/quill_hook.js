let QuillHook = {
  async mounted() {
    let quill = await import("quill");
    let editor = new quill.default("#editor", {
    });
  },
};

export { QuillHook };
