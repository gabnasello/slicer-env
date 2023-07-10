# Acknowledgements

This Docker is a fork of [pieper/SlicerDockers](https://github.com/pieper/SlicerDockers)

# Build the docker images

From the project folder, run the command below:

```bash build.sh```

# Run docker container

## Standard approach (recommended)

From the project folder, run the command below:

```docker-compose up -d```

You can get an interactive shell of the running docker-compose service with (slicer is the {SERVICENAME}):

```docker-compose exec slicer bash```

Then close the container with:

```docker-compose down```

## Alternative approach

You can run the following command:

```docker run -d -p 8080:8080 -p 7777:7777 --volume $HOME:/home/host_home --workdir /home/host_home --name slicer gnasello/slicer-env:latest```

# Run Slicer GUI

If you want to run the Slicer GUI, remember to allow X server connection before running the container:

```
xhost +local:*
```

and disallow  server connection after running the container:

```
xhost -local:*
```

docker run -it -e DISPLAY=$DISPLAY -v /tmp/.X11-unix:/tmp/.X11-unix:ro --entrypoint /opt/slicer/Slicer  --device /dev/dri/ gnasello/slicer-env:2023-07-06.1

docker run -it -e DISPLAY=$DISPLAY -v /tmp/.X11-unix:/tmp/.X11-unix:ro --device /dev/dri/ gnasello/slicer-env:2023-07-06.1

/opt/slicer/Slicer 

To connect to a container that is already running ("slicer" is the container name):

```docker exec -it slicer /bin/bash```

After use, you close the container with:

```docker rm -f slicer```

# Use the Docker

Open ```localhost:8080``` in your browser and click the "X11 Session" button

# Fire Jupyter Lab Server

- Within Slicer GUI, go to ```Modules -> Developer Tools -> JupyterKernel```, choose the home directory for the Jupyter Lab Server and press the ```Start Jupyter server``` button.

**TO DO**: start the Jupyter Server with the command ```slicer.modules.jupyterkernel.startInternalJupyterServer('/home/researcher')```

- Move to the Python Interactor window and run the command
```slicer.util._executePythonModule("jupyter", ["server", "list"])```

- Copy the token and insert it when opening ```localhost:8888``` in your browser