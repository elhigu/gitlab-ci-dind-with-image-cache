#!/bin/sh

set -x

FINAL_IMAGE_NAME=$1
shift

TEMP_IMAGE_NAME=custom-dind
TEMP_CONTAINER_NAME=temp

# create container where to pull images
docker build -t $TEMP_IMAGE_NAME .
docker run --detach --privileged --name $TEMP_CONTAINER_NAME $TEMP_IMAGE_NAME

# pull images
for image in "$@"; do 
  docker exec $TEMP_CONTAINER_NAME docker pull $image; 
  echo "Done: $image"
done

# find out used disk size and add 1-2GB extra 
USED_MB=$(docker exec $TEMP_CONTAINER_NAME df -m /var-lib-docker | grep /var-lib-docker | awk '{print $3}')
TRIM_TO_MB=$(expr $USED_MB + 2048)
TRIM_TO_GB=$(expr $TRIM_TO_MB / 1024)
echo "Resizing ext4 to ${TRIM_TO_GB}GB"

docker exec $TEMP_CONTAINER_NAME sh -c "echo $TRIM_TO_GB > /trim-ext4-on-next-start.txt"
docker stop $TEMP_CONTAINER_NAME
docker start $TEMP_CONTAINER_NAME

docker exec $TEMP_CONTAINER_NAME rm -fr /var-lib-docker/runtime
docker commit $TEMP_CONTAINER_NAME $FINAL_IMAGE_NAME
docker stop $TEMP_CONTAINER_NAME
docker rm $TEMP_CONTAINER_NAME
