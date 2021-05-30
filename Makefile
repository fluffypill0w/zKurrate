# Uncomment the circuit (and its power) to use:
# NOTE: use `make circuit-info` to get the minimum value needed for PTAUPOWER

# Target circuit (release)
#CIRCUIT=zkurrate
#PTAUPOWER=15

# Dummy circuit (testing)
CIRCUIT=dummy
PTAUPOWER=8

all: compile

zkmm: zkmm-builder zkmm-run

zkmm-builder:
	docker build -f zkmm-docker/Dockerfile -t zkmm_builder zkmm-docker

zkmm-run:
	docker run -it --rm --name zkmm_builder -v $(PWD):/zKurrate:ro zkmm_builder bash

zkurrate: zkurrate-builder zkurrate-run 

zkurrate-builder:
	docker build -f zkurrate/Dockerfile -t zkurrate_builder zkurrate

zkurrate-run:
	docker run -it --rm --name zkurrate_builder -v $(PWD):/zKurrate:ro zkurrate_builder bash

zkurrate2-builder:
	docker build -f zkurrate/Dockerfile2 -t zkurrate2_builder zkurrate

zkurrate2-run:
	docker run -it --rm --name zkurrate2_builder -v $(PWD):/zKurrate zkurrate2_builder bash

frontend-builder:
	docker build -f app/frontend/Dockerfile -t frontend_builder app/frontend

frontend-run:
	docker run -it --rm --name frontend_builder -v $(PWD):/zKurrate -p 3000:3000/tcp frontend_builder bash

CIRCUITS=zkurrate/circuits
BUILDPATH=zkurrate/build
RESOURCESPATH=zkurrate/resources

###############################################################################
# circuit compilation rules                                                   #
###############################################################################
# compile R1CS
$(BUILDPATH)/$(CIRCUIT).r1cs: $(CIRCUITS)/$(CIRCUIT).circom
	circom $< --r1cs $@
# compile WASM
$(BUILDPATH)/$(CIRCUIT).wasm: $(CIRCUITS)/$(CIRCUIT).circom
	circom $< --wasm $@
# circuit info
$(BUILDPATH)/$(CIRCUIT).info: $(BUILDPATH)/$(CIRCUIT).r1cs
	snarkjs info -c $< > $@
# circuit power (~size)
$(BUILDPATH)/$(CIRCUIT).power: $(BUILDPATH)/$(CIRCUIT).info
	zkurrate/src/calculate_ptau_power.sh $< | tee > $(BUILDPATH)/$(CIRCUIT).power
# targets
compile: $(BUILDPATH)/$(CIRCUIT).r1cs
circuit-info: $(BUILDPATH)/$(CIRCUIT).power
	cat $(BUILDPATH)/$(CIRCUIT).info
	cat $(BUILDPATH)/$(CIRCUIT).power

################################################################################
# setup related rules                                                          #
################################################################################
# phase 1: ptau new
$(BUILDPATH)/pot$(PTAUPOWER)_0000.ptau:
	snarkjs powersoftau new bn128 $(PTAUPOWER) $@ -v
# phase 1: ptau contribute
$(BUILDPATH)/pot$(PTAUPOWER)_0001.ptau: $(BUILDPATH)/pot$(PTAUPOWER)_0000.ptau
	snarkjs powersoftau contribute $< $@ --name="First contribution" -v
# phase 1: ptau prepare
$(BUILDPATH)/pot$(PTAUPOWER)_final.ptau: $(BUILDPATH)/pot$(PTAUPOWER)_0001.ptau
	snarkjs powersoftau prepare phase2 $< $@ -v
# phase 2: zkey new
$(BUILDPATH)/$(CIRCUIT)_0000.zkey: $(BUILDPATH)/$(CIRCUIT).r1cs $(BUILDPATH)/$(CIRCUIT).ptau
	snarkjs zkey new $^ $@
# phase 2: zkey contribute
$(BUILDPATH)/$(CIRCUIT)_final.zkey: $(BUILDPATH)/$(CIRCUIT)_0000.zkey
	snarkjs zkey contribute $< $@ --name="1st Contributor Name" -v
# phase 2: zkey export
$(BUILDPATH)/$(CIRCUIT)_verification_key.json: $(BUILDPATH)/$(CIRCUIT)_final.zkey
	snarkjs zkey export verificationkey $< $@
# targets
setup-ptau-generate: $(BUILDPATH)/pot$(PTAUPOWER)_final.ptau
	ln -sf pot$(PTAUPOWER)_final.ptau $(BUILDPATH)/$(CIRCUIT).ptau
setup-ptau-download: $(RESOURCESPATH)/powersOfTau28_hez_final_$(PTAUPOWER).ptau
	ln -sf $(PWD)/$(RESOURCESPATH)/powersOfTau28_hez_final_$(PTAUPOWER).ptau $(BUILDPATH)/$(CIRCUIT).ptau
setup-ptau-default: setup-ptau-generate
setup-zkey: $(BUILDPATH)/$(CIRCUIT)_verification_key.json
verify-ptau: $(BUILDPATH)/pot$(PTAUPOWER)_final.ptau $(BUILDPATH)/$(CIRCUIT).r1cs $(BUILDPATH)/$(CIRCUIT)_final.zkey
	snarkjs powersoftau verify $<
	snarkjs zkey verify $(BUILDPATH)/$(CIRCUIT).r1cs $< $(BUILDPATH)/$(CIRCUIT)_final.zkey

################################################################################
# proof generation and verification test rules                                 #
################################################################################
# generate a witness
$(BUILDPATH)/$(CIRCUIT).wtns: $(BUILDPATH)/$(CIRCUIT).wasm $(RESOURCESPATH)/$(CIRCUIT).input
	snarkjs wtns calculate $^ $@
# generate a proof: proof part
$(BUILDPATH)/$(CIRCUIT)_proof.json: $(BUILDPATH)/$(CIRCUIT)_final.zkey $(BUILDPATH)/$(CIRCUIT).wtns
	snarkjs groth16 prove $(BUILDPATH)/$(CIRCUIT)_final.zkey $(BUILDPATH)/$(CIRCUIT).wtns $(BUILDPATH)/$(CIRCUIT)_proof.json $(BUILDPATH)/$(CIRCUIT)_public.json
# generate a proof: public part
$(BUILDPATH)/$(CIRCUIT)_public.json: $(BUILDPATH)/$(CIRCUIT)_final.zkey $(BUILDPATH)/$(CIRCUIT).wtns
	snarkjs groth16 prove $(BUILDPATH)/$(CIRCUIT)_final.zkey $(BUILDPATH)/$(CIRCUIT).wtns $(BUILDPATH)/$(CIRCUIT)_proof.json $(BUILDPATH)/$(CIRCUIT)_public.json 
# targets
witness: $(BUILDPATH)/$(CIRCUIT).wtns
generate-proof: $(BUILDPATH)/$(CIRCUIT)_proof.json
verify-proof: $(BUILDPATH)/$(CIRCUIT)_verification_key.json $(BUILDPATH)/$(CIRCUIT)_public.json $(BUILDPATH)/$(CIRCUIT)_proof.json
	snarkjs groth16 verify $^

################################################################################
# solidity code generation                                                     #
################################################################################
# solidity verifier
$(BUILDPATH)/$(CIRCUIT)_verifier.sol: $(BUILDPATH)/$(CIRCUIT)_final.zkey
	snarkjs zkey export solidityverifier $< $@
# solidity call data
$(BUILDPATH)/$(CIRCUIT)_calldata.json: $(BUILDPATH)/$(CIRCUIT)_public.json $(BUILDPATH)/$(CIRCUIT)_proof.json
	snarkjs zkey export soliditycalldata $^ | tee > $(BUILDPATH)/$(CIRCUIT)_calldata.json
# targets
solidity-verifier: $(BUILDPATH)/$(CIRCUIT)_verifier.sol
solidity-calldata: $(BUILDPATH)/$(CIRCUIT)_calldata.json
solidity: solidity-verifier solidity-calldata

remixd-start:
	remixd -s /zKurrate --remix-ide https://remix.ethereum.org

ipfs-start:
	mkdir -p /zKurrate/zkurrate/build
	jsipfs config --json API.HTTPHeaders.Access-Control-Allow-Origin "[\"*\"]"
	jsipfs config --json API.HTTPHeaders.Access-Control-Allow-Credentials "[\"true\"]"
	nohup jsipfs daemon --offline > /zKurrate/zkurrate/build/jsipfs.log &

# ipfs shutdown apparently don't work
ipfs-stop:
	kill $(ps aux | grep ipfs | grep -v grep | awk '{print $2}')

$(BUILDPATH)/review.hash: $(RESOURCESPATH)/review.txt
	jsipfs add --only-hash --quiet $< > $@

ipfs-hash: $(BUILDPATH)/review.hash
	cat $<

zkurrate/node_modules:
	cd zkurrate && npm install

test: | zkurrate/node_modules
	cd zkurrate && npm test

# Phony targets
.PHONY: compile circuit-info setup-ptau-generate setup-ptau-download setup-ptau-default setup-zkey verify-ptau witness generate-proof verify-proof clean solidity-verifier solidity-calldata solidity test

clean:
	rm -f $(BUILDPATH)/*
