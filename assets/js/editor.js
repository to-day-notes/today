import { EditorState } from "prosemirror-state";
import { EditorView } from "prosemirror-view";
import { exampleSetup } from "prosemirror-example-setup";
import {
  collab,
  sendableSteps,
  receiveTransaction,
  getVersion,
} from "prosemirror-collab";

let createEditor = (clientID, authority, schema, element) => {
  let setup_plugins = exampleSetup({ schema: schema });
  let view = new EditorView(element, {
    state: EditorState.create({
      doc: authority.doc,
      plugins: setup_plugins.concat([
        collab({ version: authority.steps.length, clientID: clientID }),
      ]),
    }),
    dispatchTransaction(transaction) {
      let newState = this.state.apply(transaction);
      this.updateState(newState);
      let sendable = sendableSteps(newState);
      if (sendable)
        authority.receiveSteps(
          sendable.version,
          sendable.steps,
          sendable.clientID
        );
    },
  });

  authority.onNewSteps.push(function () {
    let newData = authority.stepsSince(getVersion(view.state));
    view.dispatch(
      receiveTransaction(view.state, newData.steps, newData.clientIDs)
    );
  });
};

export { createEditor };
