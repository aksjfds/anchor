import * as anchor from "@coral-xyz/anchor";
import { Program } from "@coral-xyz/anchor";
import type { Entrypoint } from "../target/types/entrypoint";

anchor.setProvider(anchor.AnchorProvider.env());
const program = anchor.workspace.entrypoint as Program<Entrypoint>;
const connection = program.provider.connection;

describe("entrypoint", () => {
  // Configure the client to use the local cluster.
  anchor.setProvider(anchor.AnchorProvider.env());

  const program = anchor.workspace.entrypoint as Program<Entrypoint>;

  it("Is initialized!", async () => {
    const tx = await program.methods.initialize().rpc();
    printLogs(tx);
  });
});


// printLogs
const printLogs = (signature: string) => {
  connection.getParsedTransaction(signature, "confirmed").then(res => {
    const logMessages = res.meta.logMessages
      .filter(message => message.includes("log"));
    console.log(logMessages);
  });
}