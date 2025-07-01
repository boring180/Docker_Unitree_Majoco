FROM ros:humble-ros-base

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

# Copy configuration files
COPY scripts/start.sh /
COPY scripts/supervisord.conf /etc/supervisor/conf.d/
RUN chmod +x /start.sh

# Expose VNC and noVNC ports
EXPOSE 5900 6080

ENTRYPOINT ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]