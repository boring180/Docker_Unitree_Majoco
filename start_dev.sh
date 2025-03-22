#!/bin/bash
# Docker run script

docker run -it \
    --name go2_robot \
    --privileged \
    -p 5900:5900 \
    -p 6080:6080 \
    -e DISPLAY=:0 \
    -e VNC_RESOLUTION=1080x720 \
    --shm-size=512m \
    -v $(pwd):/ws \
    --hostname localhost \
    unitree_ros2