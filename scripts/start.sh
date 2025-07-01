#!/bin/bash

# Start noVNC with specific host settings
/usr/share/novnc/utils/launch.sh --vnc localhost:5900 --listen 0.0.0.0:6080 &

# Keep container running
tail -f /dev/null