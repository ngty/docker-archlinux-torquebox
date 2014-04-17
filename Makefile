IMG=ngty/archlinux-torquebox
TAG=3.0.x

build:
	docker build -t $(IMG):$(TAG) .

debug:
	docker run -i -t $(IMG):$(TAG) shell

push:
	docker push $(IMG)

