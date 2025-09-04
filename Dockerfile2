# base ---------------------
# 一阶段
FROM rust:slim AS builder

RUN apt update && apt install -y \
    curl build-essential pkg-config libudev-dev llvm libclang-dev protobuf-compiler libssl-dev && \
\
\
mkdir /mybin && export PATH="/mybin:$PATH" && \
\
\
# solana cli
sh -c "$(curl -sSfL https://release.anza.xyz/stable/install)" && \
\
\
mv /root/.local/share/solana/install/active_release/bin/* /mybin/ && \
\
\
mv /root/.local/share/solana/install/releases/stable-72664e237c182faaff0fadfb6b15ba1ee4918e20/solana-release/bin/platform-tools-sdk /mybin/ && \
\
\
# anchor cli
cargo install --git https://github.com/coral-xyz/anchor --tag v0.31.1 anchor-cli

# 二阶段
FROM rust:slim

COPY --from=builder /mybin/* /usr/bin/

# avm and anchor
COPY --from=builder /usr/local/cargo/bin/anchor /usr/local/cargo/bin/anchor

# nodejs
ARG VERSION=v22.19.0

RUN apt update && apt install -y curl xz-utils && \
apt clean && rm -rf /var/lib/apt/lists/* && \
curl -fsSL https://nodejs.org/dist/$VERSION/node-$VERSION-linux-x64.tar.xz -o node.tar.xz \
&& tar -xJf node.tar.xz -C /usr/local --strip-components=1 \
&& rm node.tar.xz \
&& ln -s /usr/local/bin/node /usr/local/bin/nodejs \
&& npm install -g pnpm ts-node
# base ---------------------


# full ---------------
WORKDIR entrypoint

COPY . .

RUN pnpm install && solana config set -ul && \
solana-keygen new --no-bip39-passphrase && anchor test
