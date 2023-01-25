#!/bin/bash

BOLDGREEN='\033[1;32m'
NOCOLOR='\033[0m' # No Color

echo -e '\n '$BOLDGREEN $DOCKER_IMAGE_NAME:$VERSION $NOCOLOR' \n'

echo -e '\n List of servers available in this container\n'

GREEN='\033[0;32m'
echo -e $GREEN'   Slicer GUI\n'$NOCOLOR

echo -e 'http://'$HOST_NAME':'$GUIPORT'\n\n'