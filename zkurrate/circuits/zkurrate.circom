include "../../node_modules/circomlib/circuits/bitify.circom";

template StringIsHello() {
    signal input inArray;
    signal output z;
    var n = 8;    
    
    component firstByteBits = Num2Bits(n);
    firstByteBits.in <== inArray;    
    var hChar = 104;

    component hBits = Num2Bits(n);
    hBits.in <== hChar;    
/*
    component secondByteBits = Num2Bits(n);
    secondByteBits.in <== inArray[1];  
    var iChar = 105;
*/
    z <== 106;
/*
    component iBits = Num2Bits(n);
    iBits.in <== iChar;  
*/
    for (var i=0; i<n; i++) {
        firstByteBits.out[i] === hBits.out[i];
        //secondByteBits.out[i] === iBits.out[i];
    }
    
}

component main = StringIsHello();
