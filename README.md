## ROS2 Docker for Unitree Robotics Majoco simulation

This repository is for the simulation of Unitree Robotics with ROS2 and Mujoco. ROS2-foxy, Unitree_SDK2, and Mujoco are installed in the Docker container.
Following the instructions below, you can setup the Docker container and start the simulation.

---
## Prerequisites
- [Docker](https://docs.docker.com/get-docker/)

---
## Attention for different processors

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

## Attention for Windows users

For Windows users, please uncomment the following line in the Dockerfile:
```bash
# RUN chmod +x /start.sh && sed -i 's/\r$//' /start.sh
```
and comment the following line:
```bash
RUN chmod +x /start.sh
```
---
## Installation

#### Setup the Docker Container
```bash
./setup_dev.sh
```

#### Start the Docker Container
```bash
./start_dev.sh
```

#### Stop the Docker Container
```bash
./stop_dev.sh
```

#### Source the Unitree ROS2 Environment
```bash
source ~/unitree_ros2/setup.sh
```

#### Run the simulation
```bash
cd /opt/unitree_mujoco/simulate/build
./unitree_mujoco
```

---
