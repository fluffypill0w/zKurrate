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

CIRCUITS=zkurrate/circuits
BUILDPATH=zkurrate/build
RESOURCESPATH=zkurrate/resources

# compile R1CS
$(BUILDPATH)/$(CIRCUIT).r1cs: $(CIRCUITS)/$(CIRCUIT).circom
	circom $< --r1cs $@

# compile WASM
$(BUILDPATH)/$(CIRCUIT).wasm: $(CIRCUITS)/$(CIRCUIT).circom
	circom $< --wasm $@

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

compile: $(BUILDPATH)/$(CIRCUIT).r1cs

$(BUILDPATH)/$(CIRCUIT).info: $(BUILDPATH)/$(CIRCUIT).r1cs
	snarkjs info -c $< > $@

$(BUILDPATH)/$(CIRCUIT).power: $(BUILDPATH)/$(CIRCUIT).info
	zkurrate/src/calculate_ptau_power.sh $< | tee > $(BUILDPATH)/$(CIRCUIT).power

$(BUILDPATH)/$(CIRCUIT).wtns: $(BUILDPATH)/$(CIRCUIT).wasm $(RESOURCESPATH)/$(CIRCUIT).input
	snarkjs wtns calculate $^ $@

$(BUILDPATH)/$(CIRCUIT)_proof.json: $(BUILDPATH)/$(CIRCUIT)_final.zkey $(BUILDPATH)/$(CIRCUIT).wtns
	snarkjs groth16 prove $(BUILDPATH)/$(CIRCUIT)_final.zkey $(BUILDPATH)/$(CIRCUIT).wtns $(BUILDPATH)/$(CIRCUIT)_proof.json $(BUILDPATH)/$(CIRCUIT)_public.json

$(BUILDPATH)/$(CIRCUIT)_public.json: $(BUILDPATH)/$(CIRCUIT)_final.zkey $(BUILDPATH)/$(CIRCUIT).wtns
	snarkjs groth16 prove $(BUILDPATH)/$(CIRCUIT)_final.zkey $(BUILDPATH)/$(CIRCUIT).wtns $(BUILDPATH)/$(CIRCUIT)_proof.json $(BUILDPATH)/$(CIRCUIT)_public.json 

generate-proof: $(BUILDPATH)/$(CIRCUIT)_proof.json

verify-proof: $(BUILDPATH)/$(CIRCUIT)_verification_key.json $(BUILDPATH)/$(CIRCUIT)_public.json $(BUILDPATH)/$(CIRCUIT)_proof.json
	snarkjs groth16 verify $^

circuit-info: $(BUILDPATH)/$(CIRCUIT).power
	cat $(BUILDPATH)/$(CIRCUIT).info
	cat $(BUILDPATH)/$(CIRCUIT).power

setup-ptau-generate: $(BUILDPATH)/pot$(PTAUPOWER)_final.ptau
	ln -sf pot$(PTAUPOWER)_final.ptau $(BUILDPATH)/$(CIRCUIT).ptau

setup-ptau-downloaded: $(RESOURCESPATH)/powersOfTau28_hez_final_$(PTAUPOWER).ptau
	ln -sf $(PWD)/$(RESOURCESPATH)/powersOfTau28_hez_final_$(PTAUPOWER).ptau $(BUILDPATH)/$(CIRCUIT).ptau

default-setup-ptau: setup-ptau-generate

setup-zkey: $(BUILDPATH)/$(CIRCUIT)_verification_key.json

verify-ptau: $(BUILDPATH)/pot$(PTAUPOWER)_final.ptau $(BUILDPATH)/$(CIRCUIT).r1cs $(BUILDPATH)/$(CIRCUIT)_final.zkey
	snarkjs powersoftau verify $<
	snarkjs zkey verify $(BUILDPATH)/$(CIRCUIT).r1cs $< $(BUILDPATH)/$(CIRCUIT)_final.zkey

witness: $(BUILDPATH)/$(CIRCUIT).wtns

.PHONY: circuit-info setup-ptau-generate setup-ptau-downloaded default-setup-ptau setup-zkey verify-ptau clean

clean:
	rm -f $(BUILDPATH)/*