/* include "../../node_modules/circomlib/circuits/babyjub.circom";
include "./pedersenhash.circom";
include "../../node_modules/circomlib/circuits/bitify.circom";

template Main() {
    // Public inputs
    signal input pubUserId;
    signal input pubEmployerName;
    signal input pubAmountMin;
    signal input pubAmountMax;
    signal input pubFintechPublicSigningKey;

    // Private inputs
    // signal private input privFintechTransactionTuple;
    signal private input privFintechTransactionTupleEmployerNameHash;
    signal private input privFintechTransactionTupleUserNonce;
    signal private input privFintechTransactionTupleAmount;
    signal private input privTransactionTupleSignature;
    signal private input privSalt;

    // Output
    signal output transactionTupleIsValid;

    var nb = 0;

    var guess = [pubGuessA, pubGuessB, pubGuessC, pubGuessD];
    var soln =  [privSolnA, privSolnB, privSolnC, privSolnD];

    // check that the fintech transaction tuple is correcty signed
    component babyCheck = BabyCheck();
    babyCheck.x <== out[0];
    babyCheck.y <== out[1];

    checkSignature(pubFintechPublicSigningKey, privFintechTransactionTuple, privTransactionTupleSignature) === true
    
    // check that the fintech transaction tuple says the money comes from the company


    getFintechTransactionEmployerName(privFintechTransactionTuple) === pubEmployerName

    // Count white pegs
    // block scope isn't respected, so k and j have to be declared outside
    var k = 0;
    var j = 0;
    for (j=0; j<4; j++) {
        for (k=0; k<4; k++) {
            // the && operator doesn't work
            if (j != k) {
                if (guess[j] == soln[k]) {pubGuessB
                    if (guess[j] > 0) {
                        nw += 1;
                        // Set matching pegs to 0
                        guess[j] = 0;
                        soln[k] = 0;
                    }
                }
            }
        }
    }

    // Create a constraint around the number of black pegs
    nb * nb === pubNumBlacks * nb;

    // Create a constraint around the number of white pegs
    nw * nw ===  pubNumWhites * nw;

    // Verify that the hash of the private solution matches pubSolnHash
    // via a constraint that the publicly declared solution hash matches the
    // private solution witness

    component pedersen = PedersenHashSingle();
    pedersen.in <== privSaltedSoln;

    solnHashOut <== pedersen.encoded;
    pubSolnHash === pedersen.encoded;
}

component main = Main();



//////

C (pubUserId, pubEmployerName, pubAmountMin, pubAmountMax, pubFintechPublicSigningKey, privFintechTransactionTuple, privTransactionTupleSignature, privSalt):

    // check that the fintech transaction tuple is correcty signed
    checkSignature(pubFintechPublicSigningKey, privFintechTransactionTuple, privTransactionTupleSignature) === true

    // check that the fintech transaction tuple says the money comes from the company
    getFintechTransactionEmployerName(privFintechTransactionTuple) === pubEmployerName
    
    // check that the fintech transaction tuple is related to the UserId
    getFintechTransactionUserNonce(privFintechTransactionTuple) === hash(pubUserId, privSalt)

    // check that the amount is higher than range minimum
    isHigherThan(getFintechTransactionAmount(privFintechTransactionData), pubSalaryMin) === true
    
    // check that the amount is lower than range maximum
    isLowerThan(getFintechTransactionAmount(privFintechTransactionData), pubSalaryMax) === true
    
//Fintech service needs to sign with EdDSA (Twisted Edwards Curve), application needs to check with babyCheck() from @iden3/circomlib
checkSignature() { ... } 

getFintechTransactionEmployerName() { ... }
getFintechTransactionUserNonce() { ... }
getFintechTransactionAmount() { ... }
hash() { ... }
isHigherThan() { ... }
isLowerThan() { ... } */
