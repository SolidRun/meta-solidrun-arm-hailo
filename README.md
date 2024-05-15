# Yocto meta-solidrun-arm-hailo repository

This repository hosts a Yocto Project meta-layer for building linux image for SolidRun Hailo 15 SOM. Follow the steps below to set up your environment and build images.

## Prebuilt images
Prebuilt images are available [here](https://images.solid-run.com/Hailo/hailo15/meta-solidrun-arm-hailo).

## Prerequisites

Ensure Python and `pip` are installed on your system to use `kas`.

## Install Steps

### 1. Install `kas`

`kas` helps manage Yocto Project layers and build configurations. Install it using pip:

```bash
pip install kas
```

### 2. Clone the Repository
```bash
mkdir solidrun-hailo15 && cd solidrun-hailo15
git clone https://github.com/SolidRun/meta-solidrun-arm-hailo
```

### 3. Checkout Dependencies with `kas`
```bash
kas checkout meta-solidrun-arm-hailo/kas/hailo15-solidrun.yaml
```
`kas` will checkout all the layer dependencies and generate `conf/bblayers.conf` and `conf/local.conf` files for the yocto build. You can modify those files to add another layer or change build parameters.

<a id="build-steps"></a>
## Build Steps

### 1. Initialize the BitBake Environment
Every time you open the project you first need to initialize a bitbake environment. This command will use existed build parameters and cache. 
```bash
source poky/oe-init-build-env
```

### 2. Build the image
```bash
bitbake core-image-minimal
```

## Build in the docker
It is recommended to use docker image in order to have consistent build environment.
1. Create a docker container:
```bash
docker build -t build_hailo15 --file meta-solidrun-arm-hailo/conf/docker/Dockerfile .
```
2. Run the container:
```bash
docker run -it -u "$(id -u):$(id -g)" -v ${PWD}:/work --workdir=/work build_hailo15
```
3. Run the build as described in the [Build Steps](#build-steps)

## Selecting camera.
This layer support two cameras: imx334 and imx678. imx334 is used by default; To use imx678 modify the local.conf file:

```patch
-MACHINE_FEATURES += "imx334"
+MACHINE_FEATURES += "imx678"
```
## Output Artifacts

Output artifacts are located in the  
`build/tmp/deploy/images/hailo15-solidrun`

## More Information
For the information on how to flash and boot the board 
please follow the [Quick Start Guide](https://solidrun.atlassian.net/wiki/spaces/developer/pages/722042882/HummingBoard+Hailo+15+SOM+Quick+Start+Guide)  
