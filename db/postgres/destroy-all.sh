#!/bin/sh

IMAGE_NAME=postgres

#docker stop $(docker ps -a -q)
#docker rm $(docker ps -a -q)
#docker rmi $(docker ps -a -q)

docker stop $IMAGE_NAME
docker rm $IMAGE_NAME
docker rmi $IMAGE_NAME
