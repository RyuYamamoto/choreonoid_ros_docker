FROM nvidia/cudagl:9.2-runtime-ubuntu16.04

ENV NVIDIA_VISIBLE_DEVICES ${NVIDIA_VISIBLE_DEVICES:-all}
ENV NVIDIA_DRIVER_CAPABILITIES ${NVIDIA_DRIVER_CAPABILITIES:+$NVIDIA_DRIVER_CAPABILITIES,}graphics

RUN apt update && apt install -y lsb-release
RUN sh -c 'echo "deb http://packages.ros.org/ros/ubuntu $(lsb_release -sc) main" > /etc/apt/sources.list.d/ros-latest.list'
RUN apt-key adv --keyserver 'hkp://keyserver.ubuntu.com:80' --recv-key C1CF6E31E6BADE8868B172B4F42ED6FBAB17C654
RUN apt update
RUN apt install -y ros-kinetic-desktop-full

RUN apt install -y python-rosdep python-rosinstall
RUN rosdep init
RUN rosdep update
RUN echo "source /opt/ros/kinetic/setup.bash" >> ~/.bashrc
RUN bash -c "source ~/.bashrc"

RUN apt-get update
RUN apt-get install -y tmux
RUN apt-get install -y ipython
RUN apt-get install -y python
RUN apt-get install -y git tmux wget tar vim
RUN apt-get install -y ipython python python-pip
RUN apt-get install -y libeigen3-dev
RUN apt-get install -y libboost-all-dev
RUN apt-get install --allow-unauthenticated -y rviz ros-kinetic-jsk-rviz-plugins
RUN apt-get install --allow-unauthenticated -y python-wstool python-rosdep python-rospkg
RUN apt-get install --allow-unauthenticated -y python-rosinstall python-catkin-tools

RUN mkdir -p /root/catkin_ws/src
RUN cd /root/catkin_ws && catkin init
RUN rm /bin/sh && ln -s /bin/bash /bin/sh
RUN cd /root/catkin_ws/src && git clone https://github.com/s-nakaoka/choreonoid && cd /root/catkin_ws && catkin config --cmake-args -DBUILD_WRS2018=ON -DUSE_PYTHON3=OFF && source /opt/ros/kinetic/setup.bash
RUN cd /root/catkin_ws/src && \
	wstool init && \
	wstool set choreonoid_ros_pkg https://github.com/RyuYamamoto/choreonoid_ros_pkg.git --git -y && \
	wstool update choreonoid_ros_pkg
RUN rm /root/catkin_ws/src/choreonoid_ros_pkg/jvrc_models/CATKIN_IGNORE
RUN source /opt/ros/kinetic/setup.bash && \
	cd /root/catkin_ws && \
	rosdep install --from-paths src/choreonoid_ros_pkg --ignore-src --rosdistro $ROS_DISTRO -y && \
	export CMAKE_PREFIX_PATH=~/catkin_ws/devel:/opt/ros/$ROS_DISTRO
RUN apt install -y software-properties-common && pip install schema
RUN  add-apt-repository ppa:hrg/daily && \
	apt-get update && \
	apt-get install -y openhrp meshlab imagemagick python-omniorb openrtm-aist-python
RUN git clone https://github.com/fkanehiro/simtrans.git && \
	apt install -y python-setuptools && \
	easy_install pip && \
	cd simtrans && \
	pip install -r requirements.txt && \
	python setup.py install
RUN source /opt/ros/kinetic/setup.bash && \
	cd /root/catkin_ws && \
	catkin build choreonoid && \
	catkin build

RUN echo "source /opt/ros/kinetic/setup.bash" >> ~/.bashrc
RUN echo "source ~/catkin_ws/devel/setup.bash" >> ~/.bashrc

