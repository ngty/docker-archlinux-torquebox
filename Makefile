IMG=ngty/archlinux-torquebox
TAG=3.0.x

build:
	docker build -t $(IMG):$(TAG) .

push:
	docker push $(IMG)

