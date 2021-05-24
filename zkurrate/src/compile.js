Object.defineProperty(exports, "__esModule", { value: true });
const argparse = require("argparse");
const compile = require("circom");
const tester = require("circom").tester;
const compiler = require("../../node_modules/circom/src/compiler.js");
const path = require("path");
const Scalar = require("ffjavascript").Scalar;

//@ts-ignore TS7016
const fs_1 = require("fs");
const main = async () => {
    const parser = new argparse.ArgumentParser({
        description: 'Compile the zk-SNARK circuit'
    });
    parser.addArgument(['-i', '--input'], { help: 'the .circom source file' });
    parser.addArgument(['-o', '--output'], { help: 'the .json output file' });
    parser.addArgument(['-r', '--overwrite'], {
        help: 'overwrite the output file',
        defaultValue: false,
        storeTrue: true,
        nargs: 0
    });
    const args = parser.parseArgs();
    const input = args.input;
    const output = args.output;
    const overwrite = args.overwrite != null || args.overwrite != false;
    if (!input) {
        console.log('Please specify an input .circom file.');
        return;
    }
    if (!fs_1.existsSync(input)) {
        console.error(input, 'does not exist');
        return;
    }
    if (!fs_1.existsSync(output) || overwrite) {
        try {
             const options = { prime: null };
	    options.prime = Scalar.fromString("21888242871839275222246405745257275088548364400416034343698204186575808495617");
 	    const circuitDef = await compiler(path.join("/zkurrate/zkurrate/circuits", "zkurrate.circom"), options);
//            const circuitDef = await compile(input);
            fs_1.writeFileSync(output, JSON.stringify(circuitDef), 'utf8');
        }
        catch (e) {
            console.error(e);
        }
    }
};
main();
//# sourceMappingURL=compile.js.map

