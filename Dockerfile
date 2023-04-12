# Use Ubuntu 22.04 as the base image
FROM ubuntu:22.04

# Setup environment variables
ENV LANG C.UTF-8
ENV LC_ALL C.UTF-8
ENV DEBIAN_FRONTEND=noninteractive

# Update and upgrade the base image
RUN apt-get update && apt-get upgrade -y && apt-get install -y \
    software-properties-common

# Install basic utilities
RUN apt-get update && apt-get install -y \
    apt-utils \
    curl \
    gnupg2 \
    lsb-release \
    && rm -rf /var/lib/apt/lists/*

# Add the ROS2 repository and GPG key
RUN curl -s https://raw.githubusercontent.com/ros/rosdistro/master/ros.asc | apt-key add -
RUN echo "deb http://packages.ros.org/ros2/ubuntu $(lsb_release -cs) main" > /etc/apt/sources.list.d/ros2-latest.list

# Install ROS2 Humble Hawksbill
RUN apt-get update && apt-get install -y \
    ros-humble-desktop \
    && rm -rf /var/lib/apt/lists/*

# Setup ROS2 environment
RUN echo "source /opt/ros/humble/setup.bash" >> ~/.bashrc
RUN /bin/bash -c "source ~/.bashrc"

# Install additional ROS2 tools
RUN apt-get update && apt-get install -y \
    python3-colcon-common-extensions \
    && rm -rf /var/lib/apt/lists/*

# Set the working directory
WORKDIR /root/ros2_workspace

# Expose ROS2 ports
EXPOSE 10000-10010

CMD ["bash"]
