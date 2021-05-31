# zKurrate

zKurrate is a dapp for reviewing employers which proves that all reviewers have been 
paid by the companies that they review, but without revealing their identity or salary.

It is done thanks to Zero Knowledge technologies, specifically [Circom](https://github.com/iden3/circom) and [snarkjs](https://github.com/iden3/snarkjs).

Additionally the reviews are durable and censorship resistant thanks to storage in Ethereum and IPFS.

This project has been developed for the [0xHack Hackathon](https://gitcoin.co/hackathon/0x-hack).

For further details please check the [submission video](https://www.youtube.com/watch?v=eOdu522LmKs).

The project is still incomplete, but a live mock demo of the web interface is available at [zkurrate.com](https://zkurrate.com).

Please feel free to use it and contribute if you found it interesting :)

## Prerequisites

A Unix environment with a recent version (circa 2021) of the following tools:

 * GNU Make
 * Docker

## Build

Run `make zkurrate2-builder` to prepare a builder container with all the tools.

Run `make zkurrate2-run` to run the container with the code mounted in `/zKurrate`.

Inside the container, run `make setup-ptau-default verify-proof` to run all the circuit pipeline, generating the files at `zkurrate/build` directory (located `/zKurrate/zkurrate/build` inside the container).

# Third party software

This repository contains derived work from the following software with GPLv3 or compatible licenses (see https://dwheeler.com/essays/floss-license-slide.html):

 * https://github.com/DashboardPack/architectui-react-theme-free (MIT license)