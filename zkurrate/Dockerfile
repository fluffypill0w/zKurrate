FROM node:16-buster

RUN apt-get update && apt-get install -y yarn build-essential vim less git 

RUN npm install -g circom
RUN npm install -g snarkjs
RUN npm install -g circomlib
RUN npm install -g @remix-project/remixd
# node-pre-gyp needed by ipfs (bad bad packaging of ipfs) and @mapbox/node-pre-gyp is the new 'good' one
RUN npm install -g @mapbox/node-pre-gyp
RUN npm install -g debug@4.3.1 ipfs

# TODO: fix warnings in ipfs install
#
# npm WARN deprecated har-validator@5.1.5: this library is no longer supported
# npm WARN deprecated debug@4.1.1: Debug versions >=3.2.0 <3.2.7 || >=4 <4.3.1 have a low-severity ReDos regression when used in a Node.js environment. It is recommended you upgrade to 3.2.7 or 4.3.1. (https://github.com/visionmedia/debug/issues/797)
# npm WARN deprecated uuid@3.4.0: Please upgrade  to version 7 or higher.  Older versions may use Math.random() in certain circumstances, which is known to be problematic.  See https://v8.dev/blog/math-random for details.
# npm WARN deprecated debug@4.1.1: Debug versions >=3.2.0 <3.2.7 || >=4 <4.3.1 have a low-severity ReDos regression when used in a Node.js environment. It is recommended you upgrade to 3.2.7 or 4.3.1. (https://github.com/visionmedia/debug/issues/797)
# npm WARN deprecated debug@4.1.1: Debug versions >=3.2.0 <3.2.7 || >=4 <4.3.1 have a low-severity ReDos regression when used in a Node.js environment. It is recommended you upgrade to 3.2.7 or 4.3.1. (https://github.com/visionmedia/debug/issues/797)
# npm WARN deprecated request@2.88.2: request has been deprecated, see https://github.com/request/request/issues/3142

WORKDIR /zKurrate

# remixd
EXPOSE 65520/tcp

# ipfs
EXPOSE 5002/tcp