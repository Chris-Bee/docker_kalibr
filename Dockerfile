FROM ros:indigo-ros-base
LABEL Description="kalibr"

# setup environment
ENV LANG C.UTF-8
ENV LC_ALL C.UTF-8
ENV TERM xterm
ENV container docker

RUN sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen && \
    locale-gen

ENV LANG=en_US.UTF-8 \
    LANGUAGE=en_US:en \
    LC_ALL=en_US.UTF-8

RUN apt-get update && apt-get install -y git vim wget lsb-release gnupg && rm -rf /var/lib/apt/lists/*
RUN apt-get update && apt-get install -y python-catkin-tools python-rosdep python-rosinstall python-rosinstall-generator python-wstool build-essential && rm -rf /var/lib/apt/lists/*

## Install kalibr dependencies
RUN apt-get update && apt-get install -y python-setuptools python-rosinstall ipython libeigen3-dev libboost-all-dev doxygen libopencv-dev ros-indigo-vision-opencv ros-indigo-image-transport-plugins ros-indigo-cmake-modules software-properties-common software-properties-common libpoco-dev python-matplotlib python-scipy python-git python-pip ipython libtbb-dev libblas-dev liblapack-dev python-catkin-tools libv4l-dev python-pyx && rm -rf /var/lib/apt/lists/*

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
