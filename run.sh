#!/bin/bash
container_name=gym_container
image=gym_container:dev

workspace=/home/yk/workspace  
vnc_port=6081  
ssh_port=2222

docker run -itd  --rm \
--name $container_name \
-v $workspace:/home/user/workspace/ \
-p $vnc_port:8080 \
-p $ssh_port:22 \
$image >/dev/null 
