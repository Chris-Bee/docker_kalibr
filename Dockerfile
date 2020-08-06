FROM ros:indigo-ros-base
LABEL Description="kalibr"

# setup environment
ENV LANG C.UTF-8
ENV LC_ALL C.UTF-8
ENV TERM xterm
ENV container docker

RUN export DEBIAN_FRONTEND=noninteractive; \
    apt-get update && \
    apt-get dist-upgrade -y && \
    apt-get install -y \
    -o "Dpkg::Options::=--force-confdef"  \
    -o "Dpkg::Options::=--force-confold"  \
    build-essential \
    git \
    gnupg \
    htop \
    locales \
    lsb-release \
    nano \
    net-tools \
    openssh-client \
    sudo \
    vim \
    wget && \
    apt-get autoremove -y && \
    rm -rf /var/lib/apt/lists/*

# For ubuntu < 20.04 udev is a separate package
RUN apt-get update && apt-get install -y \
    udev \
    && rm -rf /var/lib/apt/lists/*

# Setup locales
RUN locale-gen en_US.UTF-8
ENV LANG='en_US.UTF-8' \
    LANGUAGE='en_US:en' \
    LC_ALL='en_US.UTF-8'

# Update python for ros
RUN apt-get update && apt-get install -y  \
    python-catkin-tools \
    python-rosdep \
    python-rosinstall \
    python-rosinstall-generator \
    python-wstool && \
    rm -rf /var/lib/apt/lists/*

## Install kalibr dependencies
RUN apt-get update && apt-get install -y \
    doxygen \
    ipython \
    libeigen3-dev \
    libv4l-dev \
    libboost-all-dev \
    libpoco-dev \
    libtbb-dev \
    libblas-dev \
    liblapack-dev \
    libopencv-dev \
    python-git \
    python-matplotlib \
    python-pip \
    python-pyx \
    python-scipy \
    python-setuptools \
    ros-indigo-vision-opencv \
    ros-indigo-image-transport-plugins \
    ros-indigo-cmake-modules \
    software-properties-common \
    software-properties-common && \
    rm -rf /var/lib/apt/lists/*

RUN pip install --upgrade --user pip
RUN pip -v install python-igraph==0.7.1.post6
#RUN pip -v install python-igraph==0.8

## Setup catkin workspace
RUN mkdir -p /kalibr/catkin_ws/src
WORKDIR /kalibr/catkin_ws
RUN bash -c 'source /opt/ros/indigo/setup.bash && catkin init'

## Get and build kalibr
WORKDIR /kalibr/catkin_ws/src
RUN git clone https://github.com/ethz-asl/Kalibr.git && cd Kalibr/  && git checkout 67fcce98676f6db2528
WORKDIR /kalibr/catkin_ws
RUN bash -c 'source /opt/ros/indigo/setup.bash && catkin build -DCMAKE_BUILD_TYPE=Release -j4'

RUN ln /dev/null /dev/raw1394

RUN mkdir /kalibr/data
WORKDIR /kalibr/data

#RUN useradd -md /kalibr kalibr
#USER kalibr
RUN echo "source /opt/ros/indigo/setup.bash" >> ~/.bashrc
RUN echo "source /kalibr/catkin_ws/devel/setup.bash" >> ~/.bashrc
