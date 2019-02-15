build:
	docker build -t tensorflow_build .

run:
	docker run -it --rm tensorflow_build
