all: zkurrate zkmm

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

compile:
	circom zkurrate/circuits/zkurrate.circom \
	--r1cs zkurrate/build/zkurrate.r1cs   \
	--wasm zkurrate/build/zkurrate.wasm   \
	--sym  zkurrate/build/zkurrate.sym