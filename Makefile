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
PTAUPOWER=15
# NOTE: use make circuit-info to get the minimum value needed for PTAUPOWER

$(BUILDPATH)/%.r1cs: $(CIRCUITS)/%.circom
	circom $< --r1cs $@

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
$(BUILDPATH)/%_0000.zkey: $(BUILDPATH)/%.r1cs $(BUILDPATH)/%.ptau
	snarkjs zkey new $^ $@

# phase 2: zkey contribute
$(BUILDPATH)/%_final.zkey: $(BUILDPATH)/%_0000.zkey
	snarkjs zkey contribute $< $@ --name="1st Contributor Name" -v

# phase 2: zkey export
$(BUILDPATH)/%_verification_key.json: $(BUILDPATH)/%_final.zkey
	snarkjs zkey export verificationkey $< $@

compile: $(BUILDPATH)/zkurrate.r1cs

$(BUILDPATH)/zkurrate.info: $(BUILDPATH)/zkurrate.r1cs
	snarkjs info -c $< > $@

$(BUILDPATH)/zkurrate.power: $(BUILDPATH)/zkurrate.info
	zkurrate/src/calculate_ptau_power.sh $< | tee > $(BUILDPATH)/zkurrate.power

circuit-info: $(BUILDPATH)/zkurrate.power
	cat $(BUILDPATH)/zkurrate.info
	cat $(BUILDPATH)/zkurrate.power

setup-ptau-generate: $(BUILDPATH)/pot$(PTAUPOWER)_final.ptau
	ln -sf pot$(PTAUPOWER)_final.ptau $(BUILDPATH)/zkurrate.ptau

setup-ptau-downloaded: $(RESOURCESPATH)/powersOfTau28_hez_final_$(PTAUPOWER).ptau
	ln -sf $(PWD)/$(RESOURCESPATH)/powersOfTau28_hez_final_$(PTAUPOWER).ptau $(BUILDPATH)/zkurrate.ptau

setup-zkey: $(BUILDPATH)/zkurrate_verification_key.json

.PHONY: setup-ptau-generate circuit-info clean

clean:
	rm -f $(BUILDPATH)/*