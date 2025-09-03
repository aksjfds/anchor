FROM aksjfds/solana:base

WORKDIR entrypoint

COPY . .

RUN pnpm install

RUN solana config set -ul && \
solana-keygen new --no-bip39-passphrase

RUN anchor test

# docker build -t solana:full .