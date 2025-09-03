FROM aksjfds/solana:base

ENV PATH="/root/.nvm/versions/node/v22.19.0/bin:${PATH}"
ENV PATH="/root/.local/share/solana/install/active_release/bin:${PATH}"

WORKDIR entrypoint

COPY . .

RUN pnpm install

RUN solana config set -ul && \
solana-keygen new --no-bip39-passphrase

RUN anchor build
RUN anchor test

# docker build -t solana:full .