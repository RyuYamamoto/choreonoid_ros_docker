#!/bin/bash
xhost +si:localuser:root

docker run -it --gpus all --name choreonoid_ros --rm   \
	   --mount type=volume,src=mnt,dst=/mnt \
       -v /tmp/.X11-unix:/tmp/.X11-unix:rw \
       --net host \
       --privileged     \
       -e DISPLAY=$DISPLAY \
       --env="LANG=ja_JP.UTF-8" \
     --env QT_X11_NO_MITSHM=1 \
		choreonoid_ros_test \
		bash 
