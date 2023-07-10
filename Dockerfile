# SlicerDockers/slicer
# https://github.com/pieper/SlicerDockers/blob/master/slicer/Dockerfile

# Slicer+extensions customized docker

FROM ubuntu:22.10

# Configure environment
ENV DOCKER_IMAGE_NAME='slicer-env'
ENV VERSION='2023-07-06.1' 

# Not installing suggested or recommended dependencies in Ubuntu image
# https://octopus.com/blog/using-ubuntu-docker-image
RUN echo 'APT::Install-Suggests "0";' >> /etc/apt/apt.conf.d/00-docker
RUN echo 'APT::Install-Recommends "0";' >> /etc/apt/apt.conf.d/00-docker

RUN apt-get update && \
    apt-get install -y curl vim xvfb git apt-transport-https ca-certificates\ 
                        libfontconfig1 \
                        libxrender1 \
                        libgl1-mesa-dev \
                        libglu1-mesa \
                        libglu1-mesa-dev \
                        libxtst6 \
                        libxt-dev \
                        libpulse-dev \
                        libnss3-dev \
                        libxcomposite-dev \
                        libxcursor-dev \
                        libxi-dev \
                        libxrandr-dev \
                        libasound2-dev \
                        libegl1-mesa-dev \
                        libxdamage1	\
                        libxkbcommon-x11-0 \
                        qt5dxcb-plugin

# Slicer 4.11.20200930 https://download.slicer.org/bitstream/60add70fae4540bf6a89bfb4" && \
# Slicer 5.0.3 https://download.slicer.org/bitstream/62cc52d2aa08d161a31c1af0

# Slicer 5.2.2
RUN SLICER_URL="https://download.slicer.org/bitstream/63f5bee68939577d9867b4c7" && \
  curl -k -v -s -L $SLICER_URL | tar xz -C /tmp && \
  mv /tmp/Slicer* /opt/slicer

ENTRYPOINT [ "/opt/slicer/Slicer" ]

# COPY install_SlicerExtensions.py /tmp

# # add requests as helper package
# RUN su researcher -c "xvfb-run --auto-servernum \
#       /opt/slicer/Slicer --python-script /tmp/install_SlicerExtensions.py" ; 

COPY install_SlicerExtensions.py /

# add requests as helper package
RUN xvfb-run --auto-servernum \
    /opt/slicer/Slicer --python-script /install_SlicerExtensions.py 

# Install external Python packages
ADD requirements.txt /
RUN /opt/slicer/bin/PythonSlicer -m pip install --upgrade pip && \
    /opt/slicer/bin/PythonSlicer -m pip install -r /requirements.txt

RUN xvfb-run --auto-servernum \
    /opt/slicer/Slicer -c 'slicer.modules.jupyterkernel.installInternalJupyterServer()'

# ADD scripts/message.sh .
# RUN echo "bash /message.sh" >> ~/.bashrc