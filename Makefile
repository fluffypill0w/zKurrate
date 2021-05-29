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

$(BUILDPATH)/%.r1cs: $(CIRCUITS)/%.circom
	circom $< --r1cs $@

$(BUILDPATH)/pot12_0000.ptau:
	snarkjs powersoftau new bn128 12 $@ -v

$(BUILDPATH)/pot12_0001.ptau: $(BUILDPATH)/pot12_0000.ptau
	snarkjs powersoftau contribute $< $@ --name="First contribution" -v

compile: $(BUILDPATH)/zkurrate.r1cs

generic-setup: $(BUILDPATH)/pot12_0001.ptau


clean:
	rm $(BUILDPATH)/*