FROM rust:slim AS rust


RUN apt update && apt install -y \
    curl build-essential pkg-config libudev-dev llvm libclang-dev \
    protobuf-compiler libssl-dev && \
sh -c "$(curl -sSfL https://release.anza.xyz/stable/install)" && \
mv /root/.local/share/solana/install/releases/stable-*/solana-release/bin/* /usr/bin/ && \
cargo install --git https://github.com/coral-xyz/anchor --tag v0.31.1 anchor-cli && \
mv /usr/local/cargo/bin/anchor /usr/bin/anchor

# 二阶段
FROM rust:slim

COPY --from=rust /usr/bin/* /usr/bin/

# nodejs
ARG VERSION=v22.19.0

RUN apt update && apt install -y curl xz-utils && \
apt clean && rm -rf /var/lib/apt/lists/*

RUN curl -fsSL https://nodejs.org/dist/$VERSION/node-$VERSION-linux-x64.tar.xz -o node.tar.xz \
 && tar -xJf node.tar.xz -C /usr/local --strip-components=1 \
 && rm node.tar.xz \
 && ln -s /usr/local/bin/node /usr/local/bin/nodejs \
 && npm install -g pnpm ts-node

WORKDIR entrypoint

COPY . .

RUN pnpm install && \
solana config set -ul && \
solana-keygen new --no-bip39-passphras && \
anchor test