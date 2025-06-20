FROM ros:foxy-ros-base

# Update GCC
RUN apt-get update && apt-get install -y \
    gcc-10 \
    g++-10 \
    && rm -rf /var/lib/apt/lists/*

# For Arm processors, please modify the following line to the native architecture. If not, please comment out the following line
ENV CFLAGS="-march=armv8.3-a"
ENV CXXFLAGS="-march=armv8.3-a"

# Install build tools and ROS dependencies
RUN apt-get update && apt-get install -y \
    build-essential \
    python3-colcon-common-extensions \
    python3-pip \
    python3-rosdep \
    python3-vcstool \
    git \
    ros-foxy-rmw-cyclonedds-cpp \
    ros-foxy-rosidl-generator-dds-idl \
    ros-foxy-rviz2 \
    ros-foxy-rqt \
    ros-foxy-rqt-common-plugins \
    x11vnc \
    xvfb \
    novnc \
    supervisor \
    fluxbox \
    tigervnc-common \
    net-tools \
    xterm \
    libglfw3-dev \
    libxinerama-dev \
    libxcursor-dev \
    libyaml-cpp-dev \
    libxi-dev \
    libeigen3-dev \
    && rm -rf /var/lib/apt/lists/* 

# Update rosdep
RUN rosdep update

# Clone unitree_ros2
RUN git clone https://github.com/unitreerobotics/unitree_ros2 ~/unitree_ros2

# Compile unitree_ros2
RUN bash -c "cd ~/unitree_ros2/cyclonedds_ws/src && \
    git clone https://github.com/ros2/rmw_cyclonedds -b foxy && \
    git clone https://github.com/eclipse-cyclonedds/cyclonedds -b releases/0.10.x && \
    cd .. && \
    colcon build --packages-select cyclonedds && \
    source /opt/ros/foxy/setup.bash && \
    colcon build"

# Compile unitree_sdk2
RUN bash -c "git clone https://github.com/unitreerobotics/unitree_sdk2.git /opt/unitree_robotics && \
    cd /opt/unitree_robotics && \
    mkdir build && \
    cd build && \
    cmake .. -DCMAKE_INSTALL_PREFIX=/opt/unitree_robotics && \
    make install"

# Install cyclonedds
RUN bash -c "cd ~ && \
    git clone https://github.com/eclipse-cyclonedds/cyclonedds -b releases/0.10.x && \
    cd cyclonedds && \
    mkdir build install && \
    cd build && \
    cmake .. -DCMAKE_INSTALL_PREFIX=../install && \
    cmake --build . --target install"

# Compile unitree_sdk2_python
RUN bash -c "cd ~ && \
    sudo apt install python3-pip && \
    git clone https://github.com/unitreerobotics/unitree_sdk2_python.git && \
    cd unitree_sdk2_python && \
    export CYCLONEDDS_HOME="~/cyclonedds/install" && \
    pip3 install -e ."

# # Install mujoco-3.2.7
# RUN bash -c "git clone https://github.com/google-deepmind/mujoco.git /opt/mujoco && \
#     cd /opt/mujoco && \
#     mkdir build install && \
#     cd build && \
#     cmake /opt/mujoco && \
#     cmake --build . && \
#     cmake /opt/mujoco -DCMAKE_INSTALL_PREFIX=/opt/mujoco/install && \
#     cmake --build . --target install"

# # Install unitree_mujoco
# RUN bash -c "git clone https://github.com/unitreerobotics/unitree_mujoco.git /opt/unitree_mujoco && \
#     cd /opt/unitree_mujoco/simulate && \
#     mkdir build && \
#     cd build && \
#     cmake .. -DCMAKE_PREFIX_PATH=/opt/mujoco/install && \
#     make -j4"

# Create workspace directory
WORKDIR /ws

# Set up noVNC
RUN mkdir -p /usr/share/novnc/utils/ && \
    ln -s /usr/share/novnc/vnc.html /usr/share/novnc/index.html

# Set display environment variable
ENV DISPLAY=:0

EXPOSE 5900 6080

# Copy and set up start script
COPY scripts/start.sh /
RUN chmod +x /start.sh
# RUN chmod +x /start.sh && sed -i 's/\r$//' /start.sh

ENTRYPOINT ["/start.sh"]