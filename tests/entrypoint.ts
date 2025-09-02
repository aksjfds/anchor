import * as anchor from "@coral-xyz/anchor";
import { Program } from "@coral-xyz/anchor";
import { Entrypoint } from "../target/types/entrypoint";

anchor.setProvider(anchor.AnchorProvider.env());
const program = anchor.workspace.entrypoint as Program<Entrypoint>;

program.methods.initialize().rpc().then(tx => {
  console.log("Your transaction signature", tx);
});

