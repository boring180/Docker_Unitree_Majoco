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

Meantime, please comment out the following line according to your processor in the Dockerfile:
```bash
RUN mkdir -p ~/miniconda3 && \
# For Arm processors
    wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-aarch64.sh -O ~/miniconda3/miniconda.sh && \
# For x86 processors
    wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O ~/miniconda3/miniconda.sh && \
    bash ~/miniconda3/miniconda.sh -b -u -p ~/miniconda3 && \
    rm ~/miniconda3/miniconda.sh
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
Acknowledgement:
---
This project used the repository [isaac-go2-ros2](https://github.com/Zhefan-Xu/isaac-go2-ros2).