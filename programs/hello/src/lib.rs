#![allow(unexpected_cfgs)]
#![allow(deprecated)]


use anchor_lang::prelude::*;

declare_id!("HmtoDcNaMTqP7M1wQqcQuChU3C5t2XKCkqkAdDRrKRqf");

#[program]
pub mod hello {
    use super::*;

    pub fn initialize(ctx: Context<Initialize>) -> Result<()> {
        msg!("Greetings from: {:?}", ctx.program_id);
        Ok(())
    }
}

#[derive(Accounts)]
pub struct Initialize {}
