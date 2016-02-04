#!/bin/sh

docker daemon --storage-driver overlay --graph /drone/docker &
apk add --update bash make sudo git perl sed

mkdir weave
cd weave
git clone https://github.com/weaveworks/weave.git .

sed -i 's|^RUN_FLAGS=-ti$|RUN_FLAGS=|' Makefile
sed -i 's|^DOCKERHUB_USER=weaveworks$|DOCKERHUB_USER=armhfbuild|' Makefile
sed -i 's|^WEAVEEXEC_DOCKER_VERSION=.*$|WEAVEEXEC_DOCKER_VERSION=1.9.1|' Makefile
sed -i 's|^DOCKER_DISTRIB_URL=https://get.docker.com/builds/Linux/x86_64/docker-$(WEAVEEXEC_DOCKER_VERSION).tgz$|DOCKER_DISTRIB_URL=https://github.com/armhf-docker-library/binaries/raw/master/docker-$(WEAVEEXEC_DOCKER_VERSION).tgz|' Makefile
sed -i 's|^\tcurl -o $(DOCKER_DISTRIB) $(DOCKER_DISTRIB_URL)$|\tcurl -o $(DOCKER_DISTRIB) -fsSL $(DOCKER_DISTRIB_URL)|' Makefile
sed -i 's|^FROM golang:.*$|FROM armhfbuild/golang:1.5.3|' build/Dockerfile
sed -i 's|^RUN go install -race -tags netgo std$|RUN go install -tags netgo std|' build/Dockerfile
sed -i 's|^FROM alpine$|FROM armhfbuild/alpine|' prog/weaveexec/Dockerfile

make exes
make .weaveexec.uptodate

# - make .weaver.uptodate
# - make prog/weaver/weaver
