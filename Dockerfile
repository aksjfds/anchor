FROM aksjfds/solana:full AS builder

FROM aksjfds/solana:base

COPY --from=builder /entrypoint /entrypoint

