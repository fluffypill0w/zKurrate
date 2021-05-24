all: zkurrate zkmm

zkmm: zkmm-builder zkmm-run

zkmm-builder:
	docker build -f zkmm-docker/Dockerfile -t zkmm_builder zkmm-docker

zkmm-run:
	docker run -it --rm --name zkmm_builder -v $(PWD):/zKurrate:ro zkmm_builder bash

zkurrate: zkurrate-builder zkurrate-run 

zkurrate-builder:
	docker build -f zkurrate-docker/Dockerfile -t zkurrate_builder zkurrate

zkurrate-run:
	docker run -it --rm --name zkurrate_builder -v $(PWD):/zKurrate:ro zkurrate_builder bash
