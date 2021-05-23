//include "circomlib/circuits/babyjub.circom";
//include "../../node_modules/circomlib/circuits/pedersen.circom";
include "../../node_modules/circomlib/circuits/bitify.circom"; // TODO: remove?

//var pubEmployerNameSignalSize = 16*8;

template StringIsHello() {
    signal input inArray[1];
    signal output isHello;
    var n = 8;    
    
    component firstByteBits = Num2Bits(n);
    firstByteBits.in <-- inArray[0];    
    var hChar = 104;

    component hBits = Num2Bits(n);
    hBits.in <-- hChar;    
    
    for (var i=0; i<n; i++) {
        firstByteBits.out[i] === hBits.out[i];
    }
}

/*

template EmployerNameHash() {
    signal input inEmployerName;
    signal output out[2];
    signal output encoded;

    component pedersen = Pedersen(pubEmployerNameSignalSize);
    for (var m=0; m<pubEmployerNameSignalSize; m++) {
        pedersen.in[m] <-- inEmployerName[m];
    }
    
    out[0] <== pedersen.out[0];
    out[1] <== pedersen.out[1];

//    component encoder = EncodePedersenPoint();
//    encoder.x <== pedersen.out[0];
//    encoder.y <== pedersen.out[1];
//    encoded <== encoder.out;
}
*/

/*
template Main() {
    // Public inputs
    signal input pubUserId[20*8]; // assuming same length as Ethereum account
    signal input pubEmployerName; // assuming a max of 16 bytes // TODO: revisit to make it bigger
    //signal input in[3]; // dont use
    signal input in[256];
    signal input pubAmountMin[32];
    signal input pubAmountMax[32];
    signal input pubFintechPublicSigningKey; // TODO: revisit size

    // Private inputs
    // signal private input privFintechTransactionTuple;
    signal private input privFintechTransactionTupleEmployerNameHash; // TODO: revisit size
    signal private input privFintechTransactionTupleUserNonce;
    signal private input privFintechTransactionTupleAmount;
    signal private input privTransactionTupleSignature;
    signal private input privSalt[12*8]; // using a 12 bytes salt

    // Output
    signal output transactionTupleIsValid;


    // check that the fintech transaction tuple is correcty signed
    // TODO: checkSignature(pubFintechPublicSigningKey, privFintechTransactionTuple, privTransactionTupleSignature) === true
    
    //// check that the fintech transaction tuple is correcty signed
    //component babyCheck = BabyCheck();
    //babyCheck.x <== pubAmountMin ;
    //babyCheck.y <== out[1];

    // Check that the fintech transaction tuple says the money comes from the company
    //
    // Verify that the hash of the private solution matches privFintechTransactionTupleEmployerNameHash
    // via a constraint that the publicly declared solution hash matches the private solution witness
    //
    // The circuit to do it is:
    //
    //     pubEmployerName ===> in.[employerNameHashCircuit].encoded === privFintechTransactionTupleEmployerNameHash
    //
    //component employerNameHashCircuit = Pedersen(pubEmployerNameSignalSize);

/    component employerNameHashCircuit = EmployerNameHash();
    //employerNameHashCircuit.in <== in; // WRONG:   errStr: 'Signal not defined:main.employerNameHashCircuit.in',
    employerNameHashCircuit.inEmployerName <== pubEmployerName;

//    employerNameHashCircuit.in <== pubEmployerName;
//    privFintechTransactionTupleEmployerNameHash === employerNameHashCircuit.encoded;


    // Check that the fintech transaction tuple is related to the UserId
    // TODO: getFintechTransactionUserNonce(privFintechTransactionTuple) === hash(pubUserId, privSalt)

    // check that the amount is higher than range minimum
    // TODO: isHigherThan(getFintechTransactionAmount(privFintechTransactionData), pubSalaryMin) === true
    
    // check that the amount is lower than range maximum
    // TODO: isLowerThan(getFintechTransactionAmount(privFintechTransactionData), pubSalaryMax) === true
}
*/
//component main = Main();
component main = StringIsHello();