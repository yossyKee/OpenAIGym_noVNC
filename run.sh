#!/bin/bash
container=ssh_container_04
image=ssh_container:dev
port=6081  
extra_run_args=""  
quiet=""  
workspace=/home/yk/workspace  
ssh_port=2222  
https_port=18888

# mount_local=" -v ${pwd_dir}:/home/user/work "  
# ${mount_local} \
port_arg="-p $port:6080"

docker run -itd --rm \
--name $container \
$port_arg  \
-v $workspace:/home/user/workspace/ \
-p $ssh_port:22 \
-p $https_port:8888 \
$extra_run_args \
$image >/dev/null 