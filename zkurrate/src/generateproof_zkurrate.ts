//@ts-ignore TS7016
import * as snarkjs from 'snarkjs'
//@ts-ignore TS7016
import {existsSync, readFileSync, writeFileSync} from 'fs'
//@ts-ignore TS7016
import * as argparse from 'argparse'
//@ts-ignore TS7016
import * as bigInt from 'big-integer'
import {stringifyBigInts, unstringifyBigInts, genSolnInput, genSalt } from './utils'
import {pedersenHash} from './pedersen'

const main = async function() {
    const parser = new argparse.ArgumentParser({
        description: 'Generate a zk-SNARK proof in JavaScript'
    })

    parser.addArgument(
        ['-c', '--circuit'],
        { 
            help: 'the compiled .json file',
            required: true
        }
    )

    parser.addArgument(
        ['-vk', '--verifying-key'],
        { 
            help: 'the .json verifying key source file',
            required: true
        }
    )

    parser.addArgument(
        ['-pk', '--proving-key'],
        { 
            help: 'the .pk.json proving key source file',
            required: true
        }
    )

    parser.addArgument(
        ['-po', '--proof-output'],
        { 
            help: 'the .json output file for the proof',
            required: true
        }
    )

    parser.addArgument(
        ['-so', '--signals-output'],
        { 
            help: 'the .json output file for the public signals',
            required: true
        }
    )

    const args = parser.parseArgs();
    const provingKeyInput = args.proving_key
    const verifyingKeyInput = args.verifying_key
    const circuitFile = args.circuit
    const proofOutput = args.proof_output
    const publicSignalsOutput = args.signals_output

    var h = 104;
    var i = 105;

    const testCase = {
        "inArray": [stringifyBigInts((h << (8*0))+ (i << (8*1)))]   // <------------ example data we want to try on the circuit ('hi')
    }

    const testInput = { // <--------------------------------------- example data embbedded in some object named testInput
        inArray: testCase.inArray.toString(),
    }

    const provingKey = unstringifyBigInts(JSON.parse(readFileSync(provingKeyInput, "utf8")))
    const verifyingKey = unstringifyBigInts(JSON.parse(readFileSync(verifyingKeyInput, "utf8")))
    const circuitDef = JSON.parse(readFileSync(circuitFile, "utf8"))

    console.log(new Date(), 'Loading circuit')
    const circuit = new snarkjs.Circuit(circuitDef)

    console.log(new Date(), 'Calculating witness')
    const witness = circuit.calculateWitness(testInput) //  <-------------------------- compile the witness from the testInput (example data)
    console.log('My input inArray:', testInput.inArray)
    console.log('witness inArray:', witness[circuit.getSignalIdx('main.inArray')])
    console.log('witness out:', witness[circuit.getSignalIdx('main.out')])

    console.log(new Date(), 'Generating proof')
    const {proof, publicSignals} = snarkjs.groth.genProof(provingKey, witness); // <--------------- use the witness (example data in binary format) and the provingKey 
                                                                                //                  to create a proof and the signals (example data stripped from secrets) 
    writeFileSync(
        proofOutput,
        JSON.stringify(stringifyBigInts(proof)),
        'utf8'
    )
    writeFileSync(
        publicSignalsOutput,
        JSON.stringify(stringifyBigInts(publicSignals)),
        'utf8'
    )
}

main()

