IMG=ngty/archlinux-torquebox
TAG=3.0.x

build:
	docker build -t $(IMG):$(TAG) .

debug:
	docker run -i -t --entrypoint /bin/bash $(IMG):$(TAG)

push:
	docker push $(IMG)

