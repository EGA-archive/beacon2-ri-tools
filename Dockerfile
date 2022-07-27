##########################
## Build env
##########################

FROM ubuntu
RUN DEBIAN_FRONTEND=noninteractive apt-get update
RUN DEBIAN_FRONTEND=noninteractive apt-get -y install apt-utils wget bzip2 git cpanminus perl-doc gcc make libbz2-dev zlib1g-dev libncurses5-dev libncursesw5-dev liblzma-dev libcurl4-openssl-dev pkg-config libssl-dev aria2 unzip jq vim sudo default-jre

##########################
## Clone applications
##########################

WORKDIR /usr/share/

RUN mkdir beacon-ri

WORKDIR /usr/share/beacon-ri/

RUN git clone https://github.com/EGA-archive/beacon2-ri-tools.git

WORKDIR /usr/share/beacon-ri/beacon2-ri-tools

##########################
## Install perl libraries
##########################

RUN cpanm --sudo --installdeps .

WORKDIR /usr/share/beacon-ri/
