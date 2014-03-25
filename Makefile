IMG=ngty/archlinux-torquebox
TAG=latest

build:
	docker build -t $(IMG):$(TAG) .

push:
	docker push $(IMG)

