# SlicerDockers/slicer-plus
# https://github.com/pieper/SlicerDockers/blob/master/slicer-plus/Dockerfile

# Slicer+extensions customized docker

#ARG SLICERVERSION="5.0.3"

FROM stevepieper/slicer:5.0.3

# Configure environment
ENV DOCKER_IMAGE_NAME='slicer-env'
ENV VERSION='2023-01-25' 
ENV GUIPORT='8080'

ARG SLICER_EXTS

RUN DEBIAN_FRONTEND=noninteractive apt-get update && apt-get install -y xvfb

COPY install_SlicerExtensions.py /tmp

# add requests as helper package
RUN su researcher -c "xvfb-run --auto-servernum \
      /opt/slicer/Slicer --python-script /tmp/install_SlicerExtensions.py" ; 

# Install external Python packages
# Install also websockify and jupyter-server-proxy (from https://github.com/Slicer/SlicerDocker/blob/main/slicer-notebook/Dockerfile) 
ADD requirements.txt .
RUN /opt/slicer/bin/PythonSlicer -m pip install --upgrade pip && \
#    /opt/slicer/bin/PythonSlicer -m pip install --upgrade websockify && \
    /opt/slicer/bin/PythonSlicer -m pip install -r requirements.txt
#    /opt/slicer/bin/PythonSlicer -m pip install -e \
#      git+https://github.com/lassoan/jupyter-desktop-server#egg=jupyter-desktop-server \
#      git+https://github.com/jupyterhub/jupyter-server-proxy@v1.6.0#egg=jupyter-server-proxy


RUN xvfb-run --auto-servernum \
    /opt/slicer/Slicer -c 'slicer.modules.jupyterkernel.installInternalJupyterServer()'

# Set the jl command to create a JupytetLab shortcut
ADD scripts/launch_jupyterlab.sh /
RUN echo "alias jl='bash /launch_jupyterlab.sh -p $JLPORT'" >> ~/.bashrc    

ADD scripts/message.sh .
RUN echo "bash /message.sh" >> ~/.bashrc