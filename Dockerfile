FROM osrf/ros:humble-desktop

# Install dev ROS tools
RUN apt-get update && apt-get install -y \
    ros-dev-tools \
    && rm -rf /var/lib/apt/lists/*

# For Arm processors, please modify the following line to the native architecture. If not, please comment out the following line
ENV CFLAGS="-march=armv8.3-a"
ENV CXXFLAGS="-march=armv8.3-a"

# Install necessary packages
RUN apt-get update && apt-get install -y \
    git \
    python3-pip \
    x11vnc \
    xvfb \
    supervisor \
    xterm \
    fluxbox \
    && rm -rf /var/lib/apt/lists/*

# Install noVNC
RUN git clone https://github.com/novnc/noVNC.git /opt/novnc \
    && git clone https://github.com/novnc/websockify /opt/novnc/utils/websockify \
    && ln -s /opt/novnc/vnc.html /opt/novnc/index.html

# Set display environment variable
ENV DISPLAY=:1

# Update rosdep
RUN rosdep update

# Create workspace directory
WORKDIR /ws

# Set home directory
ENV HOME=/root

# Copy configuration files
COPY scripts/start.sh /
COPY scripts/supervisord.conf /etc/supervisor/conf.d/
RUN chmod +x /start.sh

# Expose VNC and noVNC ports
EXPOSE 5900 6080

# Install conda
RUN apt-get update && apt-get install -y \
    curl \
    && rm -rf /var/lib/apt/lists/*

RUN mkdir -p /opt/miniconda3 && \
# For Arm processors
    wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-aarch64.sh -O /opt/miniconda3/miniconda.sh
# For x86 processors
    # wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O /opt/miniconda3/miniconda.sh

RUN bash /opt/miniconda3/miniconda.sh -b -u -p /opt/miniconda3 && \
    rm /opt/miniconda3/miniconda.sh

# Install Issac Sim
RUN conda create -n isaaclab python=3.10 && \
    conda activate isaaclab && \
    pip install torch==2.5.1 torchvision==0.20.1 --index-url https://download.pytorch.org/whl/cu118 && \
    pip install --upgrade pip && \
    pip install 'isaacsim[all,extscache]==4.2.0' --extra-index-url https://pypi.nvidia.com

# Install Issac Lib
RUN git clone git@github.com:isaac-sim/IsaacLab.git && \
    sudo apt install cmake build-essential && \
    ./isaaclab.sh --install # or "./isaaclab.sh -i"

# Install prerequisite C extension
RUN conda activate isaaclab && \
    conda install -c conda-forge libstdcxx-ng

# Clone repository
RUN git clone https://github.com/Zhefan-Xu/isaac-go2-ros2.git

ENTRYPOINT ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]