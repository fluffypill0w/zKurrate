# zKurrate

## Prerequisites

A Unix environment with a recent version (circa 2021) of the following tools:

 * GNU Make
 * Docker

## Build

Run `make zkurrate-builder` to prepare a builder container with all the tools.

Run `make zkurrate-run` to run the container with the code mounted in `/zKurrate`.

Inside the container, run `make setup-ptau-default verify-proof` to run all the circuit pipeline, generating the files at `zkurrate/build` directory (located `/zKurrate/zkurrate/build` inside the container).
