# syntax = docker/dockerfile:1.4

################################################################################
FROM ubuntu:22.04 AS base
LABEL org.opencontainers.image.source=https://github.com/firefighterduck/agda-setup

################################################################################
FROM base AS builder

# Install alex and happy
RUN set -eux; \
    apt update; \
    apt install -y --no-install-recommends alex happy zlib1g-dev libncurses5-dev ghc cabal-install;

# Install agda
RUN --mount=type=cache,target=/root/.cabal/packages \
    set -eux; \
    cabal update; \
    cabal install Agda;

# Remove all the other bits to reduce the image size
RUN set -eux;\
    export AGDAPATH=$(ls /root/.cabal/store/ghc-8.8.4 | grep Agda);\
    cp -r /root/.cabal/store/ghc-8.8.4/${AGDAPATH} /root/agda-copy; \
    rm -rf /root/.cabal/store/ghc-8.8.4/;\
    mkdir /root/.cabal/store/ghc-8.8.4/; \
    cp -r /root/agda-copy /root/.cabal/store/ghc-8.8.4/${AGDAPATH};

################################################################################
FROM base AS app

SHELL ["/bin/bash", "-c"]

# Install alex and happy (and reduce the image further)
RUN set -eux; \
    apt update; \
    apt install -y --no-install-recommends alex happy zlib1g-dev libncurses5-dev; \
    apt clean autoclean; \
	apt autoremove --yes; \
	rm -rf /var/lib/{apt,dpkg,cache,log}/

# Get the pre-build agda version from the builder
COPY --from=builder /root/.cabal/store/ghc-8.8.4 /root/.cabal/store/ghc-8.8.4
COPY --from=builder /root/.cabal/bin /root/.cabal/bin

ADD agda-mode-0.3.11.vsix /root/agda-mode-0.3.11.vsix

ENV PATH=${PATH}:/root/.cabal/bin
