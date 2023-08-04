FROM ubuntu:20.04

# File Author (Mauricio Moldes) / Maintainer
MAINTAINER Manuel Rueda <manuel.rueda@cnag.crg.eu>

ENV DEBIAN_FRONTEND=noninteractive
# Build env 
RUN apt-get update && \
    apt-get -y install apt-utils wget bzip2 git cpanminus perl-doc gcc make libbz2-dev zlib1g-dev libncurses5-dev libncursesw5-dev liblzma-dev libcurl4-openssl-dev pkg-config libssl-dev aria2 unzip jq vim sudo default-jre python3-pip && \
    pip install xlsx2csv

# Download app
RUN mkdir /usr/share/beacon-ri
WORKDIR /usr/share/beacon-ri/
RUN git clone https://github.com/EGA-archive/beacon2-ri-tools.git

# Install Perl modules
WORKDIR /usr/share/beacon-ri/beacon2-ri-tools
RUN cpanm --sudo --installdeps .
WORKDIR /usr/share/beacon-ri/
