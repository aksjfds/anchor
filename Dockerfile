FROM rust:slim AS builder

# dep
RUN apt update && apt install -y \
    curl build-essential pkg-config libudev-dev llvm libclang-dev \
    protobuf-compiler libssl-dev \
    && apt clean && rm -rf /var/lib/apt/lists/*

# solana cli
RUN sh -c "$(curl -sSfL https://release.anza.xyz/stable/install)" && \
    echo 'export PATH="$HOME/.local/share/solana/install/active_release/bin:$PATH"' >> ~/.bashrc

# anchor cli
RUN cargo install --git https://github.com/coral-xyz/anchor avm --force && \
avm install latest && avm use latest

# nodejs
RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh | bash && \
    export NVM_DIR="$HOME/.nvm" && \
    . "$NVM_DIR/nvm.sh" && \
    nvm install 22 && \
    corepack enable pnpm && \
    pnpm -v -y && \
    npm install -g ts-node


# 阶段2：运行环境
FROM rust:slim

# 复制工具
COPY --from=builder /root/.local/share/solana/install/active_release/bin/solana /root/.local/share/solana/install/active_release/bin/solana

COPY --from=builder /usr/local/cargo/bin/cargo /usr/local/cargo/bin/cargo

COPY --from=builder /root/.nvm/versions/node/v22.19.0/bin/node /root/.nvm/versions/node/v22.19.0/bin/node

COPY --from=builder /root/.nvm/versions/node/v22.19.0/bin/npm /root/.nvm/versions/node/v22.19.0/bin/npm

COPY --from=builder /root/.nvm/versions/node/v22.19.0/bin/pnpm /root/.nvm/versions/node/v22.19.0/bin/pnpm

COPY --from=builder /root/.nvm/versions/node/v22.19.0/bin/ts-node /root/.nvm/versions/node/v22.19.0/bin/ts-node

# 设置环境变量
ENV PATH="/root/.local/share/solana/install/active_release/bin:/usr/local/cargo/bin:/root/.nvm/versions/node/v22.19.0/bin:$PATH"

# 验证安装
RUN rustc --version && solana --version && anchor --version && node --version && npm --version && pnpm --version && ts-node --version
