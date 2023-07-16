FROM lscr.io/linuxserver/webtop:amd64-ubuntu-kde-version-0f29909a
#FROM lscr.io/linuxserver/webtop:ubuntu-xfce-version-5b58d96e

# Configure environment
ENV DOCKER_IMAGE_NAME='slicer-env'
ENV VERSION='2023-07-16' 

# title
ENV TITLE=3DSlicer

# ports and volumes
EXPOSE 3000

VOLUME /config

## Install Slicer

RUN apt-get update && \
    apt-get install -y vim xvfb git apt-transport-https ca-certificates\ 
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
  mv /tmp/Slicer* /config/slicer

#RUN chmod 777 -R /config/slicer

COPY /desktop/slicer.desktop /usr/share/applications/
COPY /desktop/slicer.desktop /config/Desktop/
RUN chmod 777 /config/Desktop/slicer.desktop

COPY install_SlicerExtensions.py /

# add requests as helper package
RUN xvfb-run --auto-servernum /config/slicer/Slicer --no-splash --no-main-window --python-script /install_SlicerExtensions.py

ADD requirements.txt /
RUN /config/slicer/bin/PythonSlicer -m pip install --upgrade pip && \
    /config/slicer/bin/PythonSlicer -m pip install -r /requirements.txt

RUN xvfb-run --auto-servernum /config/slicer/Slicer --no-splash --no-main-window -c 'slicer.modules.jupyterkernel.installInternalJupyterServer()'

RUN chmod 777 -R /config/.cache
RUN chmod 777 -R /config/.local