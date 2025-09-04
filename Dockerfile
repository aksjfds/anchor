# 第一阶段：构建
FROM rust:slim AS builder

RUN apt update && apt install -y \
    curl build-essential pkg-config libudev-dev llvm libclang-dev protobuf-compiler libssl-dev && \
    apt clean && rm -rf /var/lib/apt/lists/* && \
    mkdir /mybin && \
    export PATH="/mybin:$PATH" && \
    sh -c "$(curl -sSfL https://release.anza.xyz/stable/install)" && \
    mv /root/.local/share/solana/install/active_release/bin/* /mybin/ && \
    mv /root/.local/share/solana/install/releases/stable-*/solana-release/bin/platform-tools-sdk /mybin/ && \
    cargo install --git https://github.com/coral-xyz/anchor --tag v0.31.1 anchor-cli --locked

# 第二阶段：运行
FROM rust:slim

COPY --from=builder /mybin/* /usr/bin/
COPY --from=builder /usr/local/cargo/bin/anchor /usr/local/cargo/bin/anchor

# 安装 Node.js
ARG VERSION=v22.19.0
RUN apt update && apt install -y curl xz-utils && \
    apt clean && rm -rf /var/lib/apt/lists/* && \
    curl -fsSL https://nodejs.org/dist/$VERSION/node-$VERSION-linux-x64.tar.xz -o node.tar.xz && \
    tar -xJf node.tar.xz -C /usr/local --strip-components=1 && \
    rm node.tar.xz && \
    ln -s /usr/local/bin/node /usr/local/bin/nodejs && \
    npm config set registry https://registry.npmjs.org && \
    npm install -g pnpm ts-node

WORKDIR /entrypoint
COPY . .
RUN pnpm install && \
    solana config set -ul && \
    solana-keygen new --no-bip39-passphrase && \
    anchor test