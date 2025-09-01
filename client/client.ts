import * as anchor from "@coral-xyz/anchor";
import { Program } from "@coral-xyz/anchor";
import { Hello } from "../target/types/hello";

anchor.setProvider(anchor.AnchorProvider.env());

const program = anchor.workspace.hello as Program<Hello>;
program.methods.initialize().rpc().then(tx => {
    console.log("Your transaction signature", tx);
});