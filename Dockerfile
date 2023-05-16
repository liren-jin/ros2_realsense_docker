FROM ros:humble-perception

ARG DEBIAN_FRONTEND=noninteractive
ENV WS_DIR="/ros2_ws"
WORKDIR ${WS_DIR}

SHELL ["/bin/bash", "-c"]

RUN apt-get update -y \
    && apt-get install -y \
    build-essential \
    cmake \
    git-all \
    software-properties-common

RUN apt-get update -y \
    && apt-key adv --keyserver keyserver.ubuntu.com --recv-key F6E65AC044F831AC80A06380C8B3A55A6F3EFCDE || apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-key F6E65AC044F831AC80A06380C8B3A55A6F3EFCDE \
    && add-apt-repository "deb https://librealsense.intel.com/Debian/apt-repo $(lsb_release -cs) main" -u \
    && apt-get install -y \
    librealsense2-dbg \
    librealsense2-dev \
    librealsense2-dkms \
    librealsense2-utils

RUN add-apt-repository ppa:kisak/kisak-mesa \
    && apt-get update -y \
    && apt upgrade -y \
    && apt-get install -y ros-${ROS_DISTRO}-rviz2 \
    && mkdir src \
    && cd src \
    && git clone https://github.com/IntelRealSense/realsense-ros.git -b ros2-development \
    && cd .. \
    && apt-get install -y python3-rosdep \
    && source /opt/ros/${ROS_DISTRO}/setup.bash \
    && rm /etc/ros/rosdep/sources.list.d/20-default.list \
    && rosdep init \
    && rosdep update \
    && rosdep install -i --from-path src --rosdistro ${ROS_DISTRO} --skip-keys=librealsense2 -y \
    && colcon build

ARG DEBIAN_FRONTEND=dialog