# SlicerDockers/slicer-plus
# https://github.com/pieper/SlicerDockers/blob/master/slicer-plus/Dockerfile

# Slicer+extensions customized docker

#ARG SLICERVERSION="5.0.3"

FROM stevepieper/slicer:5.0.3

# Configure environment
ENV DOCKER_IMAGE_NAME='slicer-env'
ENV VERSION='2023-01-25' 
ENV GUIPORT='8080'
ENV JL='8888'

ARG SLICER_EXTS

RUN DEBIAN_FRONTEND=noninteractive apt-get update && apt-get install -y xvfb

COPY install_SlicerExtensions.py /tmp

# add requests as helper package
RUN su researcher -c "xvfb-run --auto-servernum \
      /opt/slicer/Slicer --python-script /tmp/install_SlicerExtensions.py" ; 

# Install external Python packages
ADD requirements.txt .
RUN /opt/slicer/bin/PythonSlicer -m pip install --upgrade pip && \
    /opt/slicer/bin/PythonSlicer -m pip install -r requirements.txt

RUN xvfb-run --auto-servernum \
    /opt/slicer/Slicer -c 'slicer.modules.jupyterkernel.installInternalJupyterServer()'

ADD scripts/message.sh .
RUN echo "bash /message.sh" >> ~/.bashrc