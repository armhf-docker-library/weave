#!/bin/sh

docker login \
  --username $DOCKER_USER \
  --password $DOCKER_PASSWORD \
  --email $DOCKER_EMAIL

COMPONENT=weave
docker build \
  --tag armhfbuild/$COMPONENT:$VERSION \
  weave/prog/$COMPONENT
docker push armhfbuild/$COMPONENT:$VERSION

COMPONENT=weaveexec
docker build \
  --tag armhfbuild/$COMPONENT:$VERSION \
  weave/prog/$COMPONENT
docker push armhfbuild/$COMPONENT:$VERSION

COMPONENT=plugin
docker build \
  --tag armhfbuild/weaveplugin:$VERSION \
  weave/prog/$COMPONENT
docker push armhfbuild/weaveplugin:$VERSION


# ensure prefix 'weave'
# weave${COMPONENT##weave}
