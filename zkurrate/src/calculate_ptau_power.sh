#!/bin/bash

INFOFILE=$1

CONSTRAINTS=$(cat $INFOFILE | grep Constraints | cut -d' ' -f7)
OUTPUTS=$(cat $INFOFILE | grep Outputs | cut -d' ' -f7)


function log2 {
    local x=0
    for (( y=$1-1 ; $y > 0; y >>= 1 )) ; do
        let x=$x+1
    done
    echo $x
}

z=$(log2 64)

# REVISIT: confirm this is the actual formula to calculate this
echo Tau Power: $(log2 $(( $CONSTRAINTS * $OUTPUTS )) )