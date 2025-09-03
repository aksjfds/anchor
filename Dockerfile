FROM rust:slim

# dep
RUN apt update && apt install -y \
    curl \
    build-essential \
    pkg-config \
    libudev-dev llvm libclang-dev \
    protobuf-compiler libssl-dev

# solana cli
RUN sh -c "$(curl -sSfL https://release.anza.xyz/stable/install)" && \
export PATH="$HOME/.local/share/solana/install/active_release/bin:$PATH"

# anchor cli
RUN cargo install --git https://github.com/coral-xyz/anchor avm --force && \
avm install latest && \
avm use latest

# nodejs
RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh | bash

RUN export NVM_DIR="$HOME/.nvm" && \
. "$NVM_DIR/nvm.sh" && \
nvm install 22 && \
corepack enable pnpm && \
pnpm -v -y && \
npm install -g ts-node

# docker build -t solana:base .