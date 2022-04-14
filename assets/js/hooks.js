let EditorHook = {
  async mounted() {
    // Mix the nodes from prosemirror-schema-list into the basic schema to
    // create a schema with list support.
    let model = await import("prosemirror-model");
    let schema = await import("prosemirror-schema-basic");
    let schemaList = await import("prosemirror-schema-list");
    let authority = await import("./authority");
    let editor = await import("./editor");
    const mySchema = new model.Schema({
      nodes: schemaList.addListNodes(
        schema.schema.spec.nodes,
        "paragraph block*",
        "block"
      ),
      marks: schema.schema.spec.marks,
    });

    let doc = model.DOMParser.fromSchema(mySchema).parse("");
    let myAuthority = new authority.Authority(doc);
    editor.createEditor(
      1,
      myAuthority,
      mySchema,
      document.querySelector("#editor")
    );
    editor.createEditor(
      2,
      myAuthority,
      mySchema,
      document.querySelector("#editor1")
    );
    editor.createEditor(
      3,
      myAuthority,
      mySchema,
      document.querySelector("#editor2")
    );
  },
};

export { EditorHook };
