include "../../node_modules/circomlib/circuits/bitify.circom";
include "../../node_modules/circomlib/circuits/comparators.circom";
include "../../node_modules/circomlib/circuits/eddsa.circom";

template Main() {
    // Public inputs
    signal input inEmployerName;
    signal input inAmount;
    signal input inBankPublicKey;

    // Private inputs
    signal private input inEmployeeName;

    signal private input inSignatureLSB; // 0..32 bits
    signal private input inSignatureMSB; // 32..64 bits

    // Output
    signal output amountIsValid;

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

    //// Connect the components bits into a big bit signal    
    var tupleSize = employerNameSize + employeeNameSize + amountSize;
    component tupleBits2Num = Bits2Num(tupleSize);

    var offset = 0;
    for (var i=0; i<employerNameSize; i++) {
        tupleBits2Num.in[i] <== employerNameBits.out[i];
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

    component msgBits = Num2Bits(tupleSize);
    msgBits.in <== tupleNum;

    component signatureABits = Num2Bits(256);
    signatureABits.in <== inBankPublicKey;

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
}

component main = Main();
