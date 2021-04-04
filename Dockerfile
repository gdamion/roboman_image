
# This is an auto generated Dockerfile for ros:ros-core
# generated from docker_images/create_ros_core_image.Dockerfile.em
FROM osrf/ros:melodic-desktop-bionic

ARG user=roboman
ARG home=/home/$user

RUN apt-get update && apt-get install -q -y --no-install-recommends \
    dirmngr \
    gnupg2 \
    wget \
    apt-utils \
    && rm -rf /var/lib/apt/lists/*

# setup keys
RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys C1CF6E31E6BADE8868B172B4F42ED6FBAB17C654

# setup sources.list
RUN echo "deb http://packages.ros.org/ros/ubuntu bionic main" > /etc/apt/sources.list.d/ros1-latest.list

# setup environment
ENV LANG C.UTF-8
ENV LC_ALL C.UTF-8

ENV ROS_DISTRO melodic

# install ros packages
RUN apt-get update && apt-get install -y --no-install-recommends \
    ros-melodic-desktop-full=1.4.1-0*\
    python-rosdep python-rosinstall python-rosinstall-generator python-wstool build-essential python-catkin-tools \
    && rm -rf /var/lib/apt/lists/*

# RUN rosdep init
RUN rosdep update

# RUN apt-get install -y dconf-cli uuid-runtime fonts-powerline
# RUN echo "63" | bash -c  "$(wget -qO- https://git.io/vQgMr)"

# RUN printf "y \n y \n y \n" | apt install zsh
# RUN no | sudo -u ubuntu sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
# RUN chsh -s $(which zsh) $(USER)
# RUN chsh -s git clone https://github.com/zsh-users/zsh-autosuggestions ~/.oh-my-zsh/plugins/zsh-autosuggestions
# RUN chsh -s git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ~/.oh-my-zsh/plugins/zsh-syntax-highlighting

RUN useradd --create-home -s /bin/bash $user \
        && echo $user:ubuntu | chpasswd \
        && adduser $user sudo
WORKDIR $home
USER $user

# Init workspace
RUN mkdir -p $home/catkin_ws/src
RUN cd $home/catkin_ws \
    && catkin init \
    && catkin config --merge-devel \
    && catkin build

COPY --chown=$user entrypoint.sh .
RUN chmod +x entrypoint.sh
ENTRYPOINT ["./entrypoint.sh"]
CMD ["bash"]
