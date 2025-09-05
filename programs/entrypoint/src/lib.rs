#![allow(unexpected_cfgs)]
#![allow(deprecated)]

use anchor_lang::prelude::*;

declare_id!("HrSp3iGMsXjgJXL5AZiA2UJ1XPaVDqaXgVUTGpZociiS");

#[program]
pub mod entrypoint {
    use super::*;

    pub fn initialize(ctx: Context<Initialize>, amount: u64) -> Result<()> {
        msg!("Greetings from: {:?}", ctx.program_id);
        msg!("Greetings from: {:?}", amount);
        Ok(())
    }
}

#[derive(Accounts)]
pub struct Initialize {}
