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
RUN tsc

WORKDIR /zkmm

RUN node build/mastermind/src/compile.js \
  -i mastermind/circuits/mastermind.circom \
  -o mastermind/circuits/mastermind.json -r

RUN mkdir -p mastermind/setup && \
  node build/mastermind/src/trustedsetup.js \
  -i mastermind/circuits/mastermind.json \
  -pk mastermind/setup/mastermind.pk.json \
  -vk mastermind/setup/mastermind.vk.json -r

RUN mkdir -p mastermind/proofs mastermind/signals && \
  node build/mastermind/src/generateproof.js \
  -c mastermind/circuits/mastermind.json \
  -vk mastermind/setup/mastermind.vk.json \
  -pk mastermind/setup/mastermind.pk.json \
  -po mastermind/proofs/mastermind.proof.json \
  -so mastermind/signals/testsignals.json

RUN node build/mastermind/src/test_js_verification.js \
  -c mastermind/circuits/mastermind.json \
  -vk mastermind/setup/mastermind.vk.json \
  -p mastermind/proofs/mastermind.proof.json \
  -s mastermind/signals/testsignals.json

