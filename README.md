# Acknowledgements

# Build the docker images

From the project folder, run the command below:

```bash build.sh```

# Run docker container

## Standard approach (recommended)

From the project folder, run the command below:

```docker-compose up -d```

## Alternative approach

You can run the following command:

```docker run -it -d -p 3000:3000 gnasello/slicer-env:latest```

# Use the Docker

Open ```localhost:3000``` in your browser to get a virtual desktop already running 3D Slicer.

## Fire Jupyter Lab Server

- Within Slicer GUI, go to ```Modules -> Developer Tools -> JupyterKernel```, choose the home directory for the Jupyter Lab Server and press the ```Start Jupyter server``` button.
- Jupyter Lab is fired in the Firefox broswer inside the virtual desktop