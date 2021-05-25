include "../../node_modules/circomlib/circuits/bitify.circom";
include "../../node_modules/circomlib/circuits/comparators.circom";
include "../../node_modules/circomlib/circuits/eddsa.circom";

template Main() {
    // Public inputs
    signal input inEmployerName;
    signal input inAmount;
    signal input inBankPublicKey;
    signal input inReviewIPFSHash;

    // Private inputs
    signal private input inEmployeeName;

    signal private input inSignatureLSB; // 0..32 bits
    signal private input inSignatureMSB; // 32..64 bits

    // Output
    signal output amountIsValid;
    signal output outReviewIPFSHash;

    // Amount must be greater than 500
    component amountComparator = LessThan(32); // TODO: update to newest circom version to allow GreaterThan
    amountComparator.in[0] <== 500;
    amountComparator.in[1] <== inAmount;

    amountIsValid <== amountComparator.out;

    // Compose the tuple from the individual components

    //// Transform components to their bit representations
    var employerNameSize = 2*8;
    component employerNameBits = Num2Bits(employerNameSize);
    employerNameBits.in <== inEmployerName;
    
    var employeeNameSize = 2*8;
    component employeeNameBits = Num2Bits(employeeNameSize);
    employeeNameBits.in <== inEmployeeName;

    var amountSize = 32;
    component amountBits = Num2Bits(amountSize);
    amountBits.in <== inAmount;

    //// Connect the components bits into a big number ...
    var tupleSize = employerNameSize + employeeNameSize + amountSize;
    component tupleBits2Num = Bits2Num(tupleSize);

    var offset = 0;
    for (var i=0; i<employerNameSize; i++) {
        tupleBits2Num.in[offset + i] <== employerNameBits.out[i];
    }
    offset = offset + employerNameSize;

    for (var i=0; i<employeeNameSize; i++) {
        tupleBits2Num.in[offset + i] <== employeeNameBits.out[i];
    }
    offset = offset + employeeNameSize;

    for (var i=0; i<amountSize; i++) {
        tupleBits2Num.in[offset + i] <== amountBits.out[i];
    }

    signal tupleNum;
    tupleNum <== tupleBits2Num.out;

    //// ... and convert back to a big bit array
    component msgBits = Num2Bits(tupleSize);
    msgBits.in <== tupleNum;

    //// Convert to bit array the public key
    component signatureABits = Num2Bits(256);
    signatureABits.in <== inBankPublicKey;

    //// Convert to bit array the signature parts
    component signatureR8Bits = Num2Bits(256);
    signatureR8Bits.in <== inSignatureLSB;

    component signatureSBits = Num2Bits(256);
    signatureSBits.in <== inSignatureMSB;

    // check that the fintech transaction tuple is correcty signed
    component signatureVerifier = EdDSAVerifier(tupleSize);

    for (var i=0; i<tupleSize; i++) { // tuple
        signatureVerifier.msg[i] <== msgBits.out[i];
    }
    for (var i=0; i<256; i++) { // public key
        signatureVerifier.A[i] <== signatureABits.out[i];
    }
    for (var i=0; i<256; i++) { // signature (R part)
        signatureVerifier.R8[i] <== signatureR8Bits.out[i];
    }
    for (var i=0; i<256; i++) { // signature (S part)
        signatureVerifier.S[i] <== signatureSBits.out[i];
    }

    // Pass the review IPFS hash as output
    //
    // The IPFS hash is 256 bits
    // (see https://docs.ipfs.io/concepts/content-addressing/#content-addressing-and-cids)
    // so its maximum value is lower than the zkSNARK prime used
    // (see https://docs.circom.io/1.-an-introduction/background#signals-of-a-circuit)
    // and we can pass it directly to output using an aux signal.
    signal reviewIPFSHash;

    outReviewIPFSHash <== reviewIPFSHash;
}

component main = Main();
