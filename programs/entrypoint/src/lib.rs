#![allow(unexpected_cfgs)]
#![allow(deprecated)]

use anchor_lang::prelude::*;

declare_id!("DWSiPGkkZy8Kd6dU4E9Tc8nYZDxhb9N2H1znhGthZsNB");

#[program]
pub mod entrypoint {
    use super::*;

    pub fn initialize(ctx: Context<Initialize>) -> Result<()> {
        msg!("Greetings from: {:?}", ctx.program_id);
        Ok(())
    }
}

#[derive(Accounts)]
pub struct Initialize {}
