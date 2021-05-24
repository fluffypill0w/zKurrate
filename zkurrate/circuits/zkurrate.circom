include "../../node_modules/circomlib/circuits/bitify.circom";

template StringIsHello() {
    signal input inArray;
    signal output z;
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

/*
    component secondByteBits = Num2Bits(n);
    secondByteBits.in <== inArray[1];  
    var iChar = 105;
*/
/*
    component iBits = Num2Bits(n);
    iBits.in <== iChar;  
*/
    for (var i=0; i<8; i++) {
        inArrayBits.out[i+8*0] === hBits.out[i];
    }

    for (var i=0; i<8; i++) {
        inArrayBits.out[i+8*1] === iBits.out[i];
    }

    var jChar = 106;
    component jBits = Num2Bits(8);
    jBits.in <== jChar;

    //for (var i=0; i<8; i++) {
    //    z.out[i] ==> iBits.out[i];
    //}
    jChar ==> z;
    
}

component main = StringIsHello();
