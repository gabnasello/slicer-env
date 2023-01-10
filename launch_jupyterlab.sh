#!/bin/bash

# From Adding arguments and options to your Bash scripts
# https://www.redhat.com/sysadmin/arguments-options-bash-scripts

############################################################
# Help                                                     #
############################################################
Help()
{
   # Display Help
   echo "Shortcut for firing JupyterLab in Docker Containers."
   echo
   echo "Syntax: jl [-h|p]"
   echo "options:"
   echo "h     Print this Help."
   echo "p     set port (default is 7777)."
   echo
}

############################################################
############################################################
# Main program                                             #
############################################################
############################################################

# Set variables
Port=7777

############################################################
# Process the input options. Add options as needed.        #
############################################################
# Get the options
while getopts ":hp:" option; do
   case $option in
      h) # display Help
         Help
         exit;;
      p) # Enter a name
         Port=$OPTARG;;
     \?) # Invalid option
         echo "Error: Invalid option"
         exit;;
   esac
done

#export SHELL=/bin/bash; xvfb-run --auto-servernum /opt/slicer/bin/PythonSlicer -m jupyter lab --port=$Port --ip=0.0.0.0 --allow-root --no-browser

export SHELL=/bin/bash; xvfb-run --auto-servernum /opt/slicer/Slicer -c "slicer.util._executePythonModule('jupyter',['lab', '--port=${Port}', '--allow-root', '--ip=0.0.0.0', '--no-browser'])"


# xvfb-run --auto-servernum \
# /opt/slicer/Slicer -c "slicer.util._executePythonModule('jupyter',['lab', '--port=8888', '--allow-root', '--ip=0.0.0.0', '--no-browser'])"

# xvfb-run --auto-servernum \
# /opt/slicer/bin/Slicer -m jupyter lab --port=7777 --ip=0.0.0.0 --allow-root --no-browser
