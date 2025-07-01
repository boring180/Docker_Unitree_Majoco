FROM ros:humble-ros-base

# For Arm processors, please modify the following line to the native architecture. If not, please comment out the following line
ENV CFLAGS="-march=armv8.3-a"
ENV CXXFLAGS="-march=armv8.3-a"

# Install build tools and ROS dependencies
RUN apt-get update && apt-get install -y \
    novnc \

# Update rosdep
RUN rosdep update


# Create workspace directory
WORKDIR /ws

EXPOSE 6080

# Copy and set up start script
COPY scripts/start.sh /
RUN chmod +x /start.sh
# RUN chmod +x /start.sh && sed -i 's/\r$//' /start.sh

ENTRYPOINT ["/start.sh"]