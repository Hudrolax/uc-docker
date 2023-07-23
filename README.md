## This is an example of how to run an undetected chromedriver inside a Docker container with GUI.
This image uses Ubuntu as the base image
This image uses x86 .deb package for installing Chrome and it can't be built on ARM or Apple Silicon docker hub host.

## How to run:
1. clone the repository
2. build the image: docker compose build
3. run: docker compose up
