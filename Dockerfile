# SlicerDockers/slicer
# https://github.com/pieper/SlicerDockers/blob/master/slicer/Dockerfile

# Slicer+extensions customized docker

FROM ubuntu:22.10

# Configure environment
ENV DOCKER_IMAGE_NAME='slicer-env'
ENV VERSION='2023-07-10' 

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

#ENTRYPOINT [ "/opt/slicer/Slicer" ]

COPY install_SlicerExtensions.py /

# add requests as helper package
RUN xvfb-run --auto-servernum \
    /opt/slicer/Slicer --python-script /install_SlicerExtensions.py 

ADD requirements.txt /
RUN /opt/slicer/bin/PythonSlicer -m pip install --upgrade pip && \
    /opt/slicer/bin/PythonSlicer -m pip install -r /requirements.txt

RUN xvfb-run --auto-servernum \
    /opt/slicer/Slicer -c 'slicer.modules.jupyterkernel.installInternalJupyterServer()'

#########################################################
# Extend napari with a preconfigured Xpra server target #
#########################################################

ENV DEBIAN_FRONTEND=noninteractive

# Install graphical libraries
RUN apt-get update && \
    apt-get install -y \
        build-essential \
        mesa-utils \
        libgl1-mesa-glx \
        libglib2.0-0 \
        libdbus-1-3 \
        libxi6 \
        libxcb-icccm4 \
        libxcb-image0 \
        libxcb-keysyms1 \
        libxcb-randr0 \
        libxcb-render-util0 \
        libxcb-xinerama0 \
        libxcb-xinput0 \
        libxcb-xfixes0 \
        libxcb-shape0

ENV DISTRO=jammy

# Install Xpra and dependencies
RUN apt-get install -y wget && \
    # add xpra GPG key:
    wget -O "/usr/share/keyrings/xpra.asc" https://xpra.org/xpra.asc && \
    # add the xpra repository:
    wget -O "/etc/apt/sources.list.d/xpra.sources" https://xpra.org/repos/$DISTRO/xpra.sources

# Install Xpra and dependencies
RUN apt-get update && \
    apt-get install -yqq \
        xpra && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

ENV DISPLAY=:100
ENV XPRA_PORT=9876
ENV XPRA_START="/opt/slicer/Slicer"
ENV XPRA_EXIT_WITH_CLIENT="yes"
ENV XPRA_XVFB_SCREEN="1920x1080x24+32"
EXPOSE 9876

CMD echo "Launching 3D Slicer on Xpra. Connect via http://localhost:$XPRA_PORT"; \
    xpra start \
    --bind-tcp=0.0.0.0:$XPRA_PORT \
    --html=on \
    --start="$XPRA_START" \
    --exit-with-client="$XPRA_EXIT_WITH_CLIENT" \
    --daemon=no \
    --xvfb="/usr/bin/Xvfb +extension Composite -screen 0 $XPRA_XVFB_SCREEN -nolisten tcp -noreset" \
    --pulseaudio=no \
    --notifications=no \
    --bell=no \
    $DISPLAY

ENTRYPOINT []