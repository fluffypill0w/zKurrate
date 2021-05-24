FROM node:10-buster

RUN apt-get update && apt-get install -y yarn build-essential vim less git 

RUN git clone https://github.com/weijiekoh/zkmm

WORKDIR zkmm/mastermind

RUN apt-get install -y libgmp-dev
RUN npm install sha3@2.0.0 --save
RUN npm install blake-hash --save
RUN npm install scrypt --save
RUN npm i
RUN yarn install 
RUN npm install -g typescript

# horrible hack to inject our code in their build setup
COPY src/generateproof_zkurrate.ts src/generateproof_zkurrate.ts

RUN tsc

WORKDIR /zkmm

COPY . zkurrate

# generate r1cs representation of circuit
RUN node build/mastermind/src/compile.js \
  -i zkurrate/circuits/zkurrate.circom \
  -o zkurrate/circuits/zkurrate.json -r

# setup: obtain the proof key and the verification key
RUN mkdir -p zkurrate/setup && \
  node build/mastermind/src/trustedsetup.js \
  -i zkurrate/circuits/zkurrate.json \
  -pk zkurrate/setup/zkurrate.pk.json \
  -vk zkurrate/setup/zkurrate.vk.json -r

RUN mkdir -p zkurrate/proofs zkurrate/signals && \
  node build/mastermind/src/generateproof_zkurrate.js \
  -c zkurrate/circuits/zkurrate.json \
  -vk zkurrate/setup/zkurrate.vk.json \
  -pk zkurrate/setup/zkurrate.pk.json \
  -po zkurrate/proofs/zkurrate.proof.json \
  -so zkurrate/signals/testsignals.json

#RUN node build/mastermind/src/test_js_verification.js \
#  -c mastermind/circuits/mastermind.json \
#  -vk mastermind/setup/mastermind.vk.json \
#  -p mastermind/proofs/mastermind.proof.json \
#  -s mastermind/signals/testsignals.json
