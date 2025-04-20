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

#### Build the update package
```bash
bitbake hailo-update-image
```
By default core-image-minimal is used as an update target. To change it, update the local.conf:
`HAILO_TARGET = "core-image-custom"`

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

## Output Artifacts

Output artifacts are located in the  
`build/tmp/deploy/images/hailo15-solidrun`

## Using the Package Manager

The demo image includes the `opkg` package manager. It is intended for installing lightweight tools and dependencies during development and evaluation.

**Note:** Using the package manager in production is not recommended.  
The package mirror is not maintained for production use, and installing large or critical packages may break the system.

**Note:** In order to use the package manager, the system time must be set correctly to verify TLS certificates.

### Package Repository

Packages can be browsed and installed from the following repository:  
[SolidRun Hailo IPK Package Feed](https://solidrun-packages.com/hailo/meta-solidrun-arm-hailo/ipk/)



## More Information
For the information on how to flash and boot the board 
please follow the [Quick Start Guide](https://solidrun.atlassian.net/wiki/spaces/developer/pages/722042882/HummingBoard+Hailo+15+SOM+Quick+Start+Guide)  
