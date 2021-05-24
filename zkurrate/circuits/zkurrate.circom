//include "../../node_modules/circomlib/circuits/babyjub.circom";
include "../../node_modules/circomlib/circuits/pedersen.circom";
include "../../mastermind/circuits/pedersenhash.circom";
include "../../node_modules/circomlib/circuits/bitify.circom";
include "../../node_modules/circomlib/circuits/comparators.circom";
include "../../node_modules/circomlib/circuits/eddsa.circom";


/*
template Main() {
    signal input inArray;
    signal output out;

    signal aux;

    var bytes = 2;
    var n = 8*bytes;    

    component inArrayBits = Num2Bits(n);
    inArrayBits.in <== inArray;

    var hChar = 104;
    component hBits = Num2Bits(8);
    hBits.in <== hChar;

    var iChar = 105;
    component iBits = Num2Bits(8);
    iBits.in <== iChar;

    for (var i=0; i<8; i++) {
        inArrayBits.out[i+8*0] === hBits.out[i];
    }

    for (var i=0; i<8; i++) {
        inArrayBits.out[i+8*1] === iBits.out[i];
    }

    aux <== inArray - 1;
    out <== aux;
}
*/
/*
template EmployerNameHash(size) {
    signal input inEmployerName;
    signal output out[2];
    signal output outEncoded;

    component inBits = Num2Bits(size);
    inBits.in <== inEmployerName;

    component pedersen = Pedersen(size);
    for (var i=0; i<size; i++) {
        pedersen.in[i] <-- inBits.out[i];
    }

    out[0] <== pedersen.out[0];
    out[1] <== pedersen.out[1];

    component encoder = EncodePedersenPoint();
    encoder.x <== pedersen.out[0];
    encoder.y <== pedersen.out[1];

    outEncoded <== encoder.out;
}
*/
/* 
template EmployerNameComparator(size) {
    signal input pubEmployerName;
    signal input privFintechTransactionTupleEmployerName;

    component pubEmployerNameBits = Num2Bits(size);
    pubEmployerNameBits.in <== pubEmployerName;

    component privFintechTransactionTupleEmployerNameBits = Num2Bits(size);
    privFintechTransactionTupleEmployerNameBits.in <== privFintechTransactionTupleEmployerName;

    pubEmployerNameBits.out === privFintechTransactionTupleEmployerNameBits.out;
}
*/

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

    var employerNameSize = 2*8;
    component employerNameBits = Num2Bits(employerNameSize);
    employerNameBits.in <== inEmployerName;

    var employeeNameSize = 2*8;
    component employeeNameBits = Num2Bits(employeeNameSize);
    employeeNameBits.in <== inEmployeeName;

    var amountSize = 32;
    component amountBits = Num2Bits(amountSize);
    amountBits.in <== inAmount;

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
    signatureVerifier.msg <== msgBits.out;         // tuple      (tupleSize bits)
    signatureVerifier.A <== signatureABits.out;    // bank public key  (256 bits)
    signatureVerifier.R8 <== signatureR8Bits.out;  // signature R part (256 bits)
    signatureVerifier.S <== signatureSBits.out;    // signature S part (256 bits)
}

component main = Main();
