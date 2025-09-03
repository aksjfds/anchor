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



# 阶段2：运行环境
FROM rust:slim

# 复制工具
COPY --from=builder /root/.local/share/solana/install/active_release/bin /root/.local/share/solana/install/active_release/bin
RUN echo 'export PATH=/root/.local/share/solana/install/active_release/bin' >> .bashrc

COPY --from=builder /usr/local/cargo/bin /usr/local/cargo/bin

# nodejs
RUN apt update && apt install curl -y && \
apt clean && rm -rf /var/lib/apt/lists/*

RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh | bash && \
    export NVM_DIR="$HOME/.nvm" && \
    . "$NVM_DIR/nvm.sh" && \
    nvm install 22 && \
    corepack enable pnpm && \
    pnpm -v -y && \
    npm install -g ts-node