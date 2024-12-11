FROM lscr.io/linuxserver/webtop:amd64-ubuntu-kde-version-b7c41cf2
#FROM lscr.io/linuxserver/webtop:ubuntu-xfce-version-5b58d96e

# Configure environment
ENV DOCKER_IMAGE_NAME='slicer-env'
ENV VERSION='2024-12-11' 

# title
ENV TITLE="3D Slicer"

# ports and volumes
EXPOSE 3000

VOLUME /config

## Install Slicer

RUN apt-get update && \
    apt-get install -y vim xvfb git wget zip apt-transport-https ca-certificates\ 
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
# Slicer 5.2.2 https://download.slicer.org/bitstream/63f5bee68939577d9867b4c7
# Slicer 5.4.0 https://download.slicer.org/bitstream/64e0b4a006a93d6cff3638c
# Slicer 5.6.1 https://download.slicer.org/bitstream/657813b183a3201b44d4e6f
# Slicer 5.6.2
RUN SLICER_URL="https://download.slicer.org/bitstream/660f92ed30e435b0e355f1a4" && \
  wget -O Slicer.tar.gz $SLICER_URL && \
  tar xfz /Slicer.tar.gz -C /tmp && \
  #rm Slicer.tar.gz && \
  mv /tmp/Slicer* /slicer

RUN chmod 777 -R /slicer

COPY /desktop/slicer.desktop /usr/share/applications/
COPY /desktop/slicer.desktop /config/Desktop/
RUN chmod 777 /config/Desktop/slicer.desktop

COPY install_SlicerExtensions.py /

# add requests as helper package
RUN xvfb-run --auto-servernum /slicer/Slicer --no-splash --no-main-window --python-script /install_SlicerExtensions.py

ADD requirements.txt /
RUN /slicer/bin/PythonSlicer -m pip install --upgrade pip && \
    /slicer/bin/PythonSlicer -m pip install -r /requirements.txt

# Modify the skeletor/post/radiusextraction.py file using sed
RUN sed -i 's/np\.float/float/g' /slicer/lib/Python/lib/python3.9/site-packages/skeletor/post/radiusextraction.py

# Install pyslicer
RUN git clone https://github.com/gabnasello/pyslicer.git
RUN /slicer/bin/PythonSlicer -m pip install -e pyslicer/

RUN xvfb-run --auto-servernum /slicer/Slicer --no-splash --no-main-window -c 'slicer.modules.jupyterkernel.installInternalJupyterServer()'

COPY /desktop/jupyter.desktop /usr/share/applications/
COPY /desktop/jupyter.desktop /config/Desktop/
RUN chmod 777 /config/Desktop/jupyter.desktop

RUN chmod 777 -R /config/
#RUN chmod 777 -R /config/.cache
#RUN chmod 777 -R /config/.local

RUN chmod 777 -R /tmp/Slicer-/