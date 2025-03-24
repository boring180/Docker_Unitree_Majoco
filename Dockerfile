FROM ros:foxy-ros-base

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
    && rm -rf /var/lib/apt/lists/* \
    libglfw3-dev \
    libxinerama-dev \
    libxcursor-dev \
    libxi-dev

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

ENTRYPOINT ["/start.sh"]