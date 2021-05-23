const chai = require("chai");
const path = require("path");

const tester = require("circom").tester;

const curve = require("ffjavascript").bn128.buildBn128(false);

const Fr = curve.Fr;

const assert = chai.assert;

describe("My test", function () {

    this.timeout(100000000);

    it("should give 'h' followed by 'i'", async () => {
        assert(true);

        const circuit = await tester(path.join(__dirname, "", "zkurrate.circom"));
        await circuit.loadConstraints();

        assert.equal(circuit.nVars, 18);
        assert.equal(circuit.constraints.length, 34);

        const witness = await circuit.calculateWitness({ "inArray": ["104", "105"]}, true);

        assert(Fr.eq(witness[0],Fr.e(1)));
       // assert(witness[1] == "105");
    });
});