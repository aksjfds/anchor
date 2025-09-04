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
    await printLogs(tx);
  });
});


// printLogs
const printLogs = async (signature: string) => {
  const res = await connection.getParsedTransaction(signature, "confirmed");

  const logMessages = res.meta.logMessages
    .filter((message: string) => message.includes("log"));
  console.log(logMessages);
}