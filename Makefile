all: builder run

builder:
	docker build -t zkurrate_builder .

run:
	docker run -it --rm --name zkurrate_builder -v $(PWD):/zKurrate:ro zkurrate_builder bash
