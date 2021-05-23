const chai = require("chai");
const path = require("path");

const tester = require("circom").tester;

//const Fr = require("ffjavascript").bn128.Fr;

const assert = chai.assert;

describe("My test", function () {

    this.timeout(100000000);

    it("Should equal true", async () => {
        assert(true);

        const circuit = await tester(path.join(__dirname, "", "zkurrate.circom"));
        await circuit.loadConstraints();

        assert.equal(circuit.nVars, 10);
        assert.equal(circuit.constraints.length, 17);

        const witness = await circuit.calculateWitness({ "inFirstByte": "104"}, true);
    });
});