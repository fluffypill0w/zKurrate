# Here node:12-buster is user since apparently circom command gives the
# following error if node:10-buster is used:
#
# ```
# ~# circom 
# internal/modules/cjs/loader.js:638
#    throw err;
#    ^
#
# Error: Cannot find module 'worker_threads'
#    at Function.Module._resolveFilename (internal/modules/cjs/loader.js:636:15)
#    at Function.Module._load (internal/modules/cjs/loader.js:562:25)
#    at Module.require (internal/modules/cjs/loader.js:692:17)
#    at require (internal/modules/cjs/helpers.js:25:18)
#    at Object.<anonymous> (/usr/local/lib/node_modules/circom/node_modules/ffjavascript/build/main.cjs:9:38)
#    at Module._compile (internal/modules/cjs/loader.js:778:30)
#    at Object.Module._extensions..js (internal/modules/cjs/loader.js:789:10)
#    at Module.load (internal/modules/cjs/loader.js:653:32)
#    at tryModuleLoad (internal/modules/cjs/loader.js:593:12)
#    at Function.Module._load (internal/modules/cjs/loader.js:585:3)
# ```
# 
# so node 12.x is as it support worker_threads by default.

FROM node:12-buster

RUN apt-get update && apt-get install -y yarn make g++ node-typescript

RUN npm install -g circom

WORKDIR zKurrate

COPY circuits/compiler_test.circom .

RUN circom compiler_test.circom --fast --verbose --r1cs compiler_test.r1cs
RUN rm compiler_test.circom compiler_test.r1cs

COPY .bashrc /root
