include "../../node_modules/circomlib/circuits/bitify.circom";

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

component main = Main();
