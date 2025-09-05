FROM rust:slim AS rust


RUN apt update && apt install curl -y && \
curl --proto '=https' --tlsv1.2 -sSfL https://solana-install.solana.workers.dev | bash

RUN mkdir /mybin && \
mv /root/.local/share/solana/install/releases/stable-*/solana-release/bin/* / && \
\
mv /solana /solana-keygen /solana-test-validator /cargo-build-sbf /platform-tools-sdk /mybin/ && \
mv /root/.avm/bin/anchor-0.31.1 /mybin/anchor

# # 二阶段
FROM rust:slim

COPY --from=rust /mybin/ /usr/local/bin/

# nodejs
RUN apt update && apt install curl -y && \
apt clean && rm -rf /var/lib/apt/lists/* && \
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh | bash && \
\. "$HOME/.nvm/nvm.sh" && \
nvm install 22 && \
corepack enable pnpm && \
pnpm -v -y && \
echo 'export PATH=/usr/bin/versions/node/v22.19.0/bin:$PATH' >> .bashrc && \
\
anchor init --package-manager pnpm --no-git entrypoint && \
cd /entrypoint && \
solana config set -ul && \
solana-keygen new --no-bip39-passphrase && \
anchor test && \
\
rustup component add rustfmt

WORKDIR /entrypoint