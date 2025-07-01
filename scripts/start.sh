#!/bin/bash

# Start noVNC
/opt/novnc/utils/novnc_proxy --listen 6080 "$@"