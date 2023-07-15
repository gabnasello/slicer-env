# Acknowledgements

# Build the docker images

From the project folder, run the command below:

```bash build.sh```

# Run docker container

## Standard approach (recommended)

From the project folder, run the command below:

```docker-compose up```

## Alternative approach

You can run the following command:

```docker run -it -p 9876:9876 -p 8888:8888 -e DISPLAY=$DISPLAY -v /tmp/.X11-unix:/tmp/.X11-unix:ro --device /dev/dri/ gnasello/slicer-env:2023-07-06.1```

# Run Slicer GUI

If you want to run the Slicer GUI, remember to allow X server connection before running the container:

```
xhost +local:*
```

You can run the following command:

```docker run -it -p 8888:8888 -e DISPLAY=$DISPLAY -v /tmp/.X11-unix:/tmp/.X11-unix:ro --entrypoint /opt/slicer/Slicer --device /dev/dri/ gnasello/slicer-env:2023-07-06.1```

and disallow  server connection after running the container:

```
xhost -local:*
```

# Use the Docker

Open ```localhost:9876``` in your browser to get a virtual desktop already running 3D Slicer.

## Fire Jupyter Lab Server

- Within Slicer GUI, go to ```Modules -> Developer Tools -> JupyterKernel```, choose the home directory for the Jupyter Lab Server and press the ```Start Jupyter server``` button.

**TO DO**: start the Jupyter Server with the command ```slicer.modules.jupyterkernel.startInternalJupyterServer('/home/researcher')```

- Move to the Python Interactor window and run the command
```slicer.util._executePythonModule("jupyter", ["server", "list"])```

- Copy the token and insert it when opening ```localhost:8888``` in your browser