import { keymap } from "@milkdown/prose";
import { AtomList, createPlugin } from "@milkdown/utils";
import {
  redo,
  undo,
  yCursorPlugin,
  ySyncPlugin,
  yUndoPlugin,
} from "y-prosemirror";
import { XmlFragment } from "yjs";

export const y = createPlugin((utils, args) => {
  const type = args.ydoc.get("prosemirror", XmlFragment);

  const plugin = [
    ySyncPlugin(type),
    // yCursorPlugin(awareness),
    yUndoPlugin(),
    keymap({
      "Mod-z": undo,
      "Mod-y": redo,
      "Mod-Shift-z": redo,
    }),
  ];

  return {
    prosePlugins: () => plugin,
  };
});
export const collaborative = AtomList.create([y()]);
