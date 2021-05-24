all: builder run

builder:
	docker build -t zkurrate_builder .

run:
	docker run -it --rm --name zkurrate_builder -v $(PWD):/zKurrate:ro zkurrate_builder bash

zkmm-builder:
	docker build -f zkmm-docker/Dockerfile -t zkmm_builder zkmm-docker

zkmm-run:
	docker run -it --rm --name zkmm_builder -v $(PWD):/zKurrate:ro zkmm_builder bash
