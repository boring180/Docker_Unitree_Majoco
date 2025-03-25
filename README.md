# ROS2_Docker

## Attention
---
For Intel processors, please comment out the following line in the Dockerfile:
```bash
# ENV CFLAGS="-march=armv8.6-a"
# ENV CXXFLAGS="-march=armv8.6-a"
```
For Arm processors(e.g. Mac M1), please modify the following line in the Dockerfile:
[Check](https://en.wikipedia.org/wiki/ARM_architecture_family) the instruction set of your processor before modifying the following line.
For example, Mac M2 is armv8.6-a

But armv8.6-a is not supported by GCC 10. While armv8.3-a actually works for M2.
```bash
ENV CFLAGS="-march=armv8.3-a"
ENV CXXFLAGS="-march=armv8.3-a"
```
---
## Installation

### Setup the Docker Container
```bash
./setup_dev.sh
```

### Start the Docker Container
```bash
./start_dev.sh
```

### Stop the Docker Container
```bash
./stop_dev.sh
```

### Source the Unitree ROS2 Environment
```bash
source ~/unitree_ros2/setup.sh
```
---