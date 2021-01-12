#!/bin/bash
container=ssh_container2
image=ssh_container:dev
extra_run_args=""  
quiet=""  
workspace=/home/yk/workspace  
vnc_port=6081  
ssh_port=2222

# docker run -itd --rm \
docker run -itd \
--name $container \
-v $workspace:/home/user/workspace/ \
-p $vnc_port:8080 \
-p $ssh_port:22 \
$extra_run_args \
$image >/dev/null 