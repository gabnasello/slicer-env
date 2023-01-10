# SlicerDockers/slicer-plus
# https://github.com/pieper/SlicerDockers/blob/master/slicer-plus/Dockerfile

# Slicer+extensions customized docker

#ARG VERSION="5.0.3"

FROM stevepieper/slicer:5.0.3

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
ADD launch_jupyterlab.sh /
RUN echo "alias jl='bash /launch_jupyterlab.sh'" >> ~/.bashrc    

#xvfb-run --auto-servernum \
#/opt/slicer/bin/PythonSlicer -m jupyter lab --port=8888 --ip=0.0.0.0 --allow-root --no-browser 

# su researcher -c "xvfb-run --auto-servernum \
#       /opt/slicer/Slicer -c 'slicer.modules.jupyterkernel.installInternalJupyterServer()'"

# /opt/slicer/bin/PythonSlicer -m jupyter-kernelspec install "/opt/slicer/NA-MIC/Extensions-30893/SlicerJupyter/share/Slicer-5.0/qt-loadable-modules/JupyterKernel/Slicer-5.0" --replace --user

# /opt/slicer/bin/PythonSlicer -m ipykernel install "/opt/slicer/NA-MIC/Extensions-30893/SlicerJupyter/share/Slicer-5.0/qt-loadable-modules/JupyterKernel/Slicer-5.0" --replace --user --name slicer --display-name "Slicer 5.0.3"

# su researcher -c "xvfb-run --auto-servernum \
#       /opt/slicer/Slicer --python-script start_slicer_jupyter.py --nomain-window"

# import slicer
# slicer.util._executePythonModule('jupyter',['lab', '--port=8888', '--allow-root', '--ip=0.0.0.0', '--no-browser'])

#su researcher -c "xvfb-run --auto-servernum \
#      /opt/slicer/Slicer --launch SlicerApp-real start_slicer_jupyter.py"

# '--notebook-dir', '/home/researcher/'

#CMD ["sh", "-c", "./Slicer/bin/PythonSlicer -m jupyter notebook --port=$JUPYTERPORT --allow-root --ip=0.0.0.0 --no-browser --NotebookApp.default_url=/lab/"]