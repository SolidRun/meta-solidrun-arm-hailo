# Yocto meta-solidrun-arm-hailo repository

This repository hosts a Yocto Project meta-layer for building Linux images for the SolidRun Hailo-15 SOM (HummingBoard Hailo-15). It is based on the Hailo BSP release 1.12.1 (Yocto kirkstone, Linux 5.15.32, HailoRT 5.3.0). Follow the steps below to set up your environment and build images.

## Prebuilt images
Prebuilt images are available [here](https://images.solid-run.com/Hailo/hailo15/meta-solidrun-arm-hailo).

## The two images

| Image | kas configuration | What it is for |
|---|---|---|
| `core-image-hailo-dev` | `kas/hailo15-solidrun.yaml` | Development and evaluation image. Contains the Hailo runtime, the camera demos, the tuning tool, debugging tools and the package manager. This is the image SolidRun publishes. |
| `core-image-hailo` | `kas/hailo15-solidrun-production.yaml` | Production image. Same BSP and Hailo runtime, without the demos and development tools. A good base for a customer product. |

Both images come with an SWUpdate package (`hailo-update-image`) for updating a board that is already running.

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
For the development image:
```bash
kas checkout meta-solidrun-arm-hailo/kas/hailo15-solidrun.yaml
```
For the production image:
```bash
kas checkout meta-solidrun-arm-hailo/kas/hailo15-solidrun-production.yaml
```
`kas` will checkout all the layer dependencies and generate `conf/bblayers.conf` and `conf/local.conf` files for the yocto build. You can modify those files to add another layer or change build parameters. Running `kas checkout` again regenerates these two files.

<a id="build-steps"></a>
## Build Steps

### 1. Initialize the BitBake Environment
Every time you open the project you first need to initialize a bitbake environment. This command will use the existing build parameters and cache.
```bash
source poky/oe-init-build-env
```

### 2. Build the image
Development image:
```bash
bitbake core-image-hailo-dev
```
Production image (after the production `kas checkout`):
```bash
bitbake core-image-hailo
```

#### Build the update package
```bash
bitbake hailo-update-image
```
The image packed into the update package is set by `HAILO_TARGET` in the kas configuration (`core-image-hailo-dev` or `core-image-hailo`). Both configurations produce a file with the same name, `hailo-update-image-hailo15-solidrun.swu`, so rename it if you keep both.

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

Output artifacts are located in `build/tmp/deploy/images/hailo15-solidrun`.

| File | Use |
|---|---|
| `core-image-hailo-dev-hailo15-solidrun.wic.zst` and `.wic.bmap` | eMMC image, flashed with `bmaptool` from the flashing ramdisk (`core-image-hailo-…` for the production image) |
| `hailo-update-image-hailo15-solidrun.swu` | SWUpdate package, installed from the U-Boot menu or from a running system |
| `fitImage-core-image-flashing-ramdisk-hailo15-solidrun-hailo15-solidrun` | The flashing ramdisk loaded by the U-Boot menu entry "Boot to flashing ramdisk" |
| `hailo15_scu_bl.bin`, `scu_bl_cfg_a.bin`, `hailo15_scu_fw.bin`, `u-boot-spl.bin`, `u-boot.dtb.signed`, `u-boot-initial-env`, `customer_certificate.bin` | The qSPI flash content, programmed with the Hailo board tools |
| `hailo15_uart_recovery_fw.bin` | Recovery firmware loaded over UART before programming the qSPI |
| `u-boot-tfa.itb`, `fitImage` | U-Boot with TF-A and the kernel, both placed on the eMMC boot partition by the wic image |

## Setup Tools and Environment

Before flashing the board, install the Hailo board tools and required dependencies.

### Get the Hailo Board Tools

Download the Hailo Vision Processor Software Package from the [Hailo Developer Zone](https://hailo.ai/developer-zone/software-downloads/). Extract the archive and locate `hailo15_board_tools-<VERSION>.whl`. The version of the board tools must match the BSP version of the image (1.12.1 for this release); the tools are not part of this repository or of the Hailo BSP layers.

### Install Dependencies

Create a Python virtual environment and install the required packages:

```bash
python3 -m venv hailo15_env
source hailo15_env/bin/activate
pip install hailo15_board_tools-*.whl
sudo apt install u-boot-tools
```

`u-boot-tools` provides `mkenvimage`, which `hailo15_spi_flash_program` runs to turn the text file `u-boot-initial-env` into the environment image written to the qSPI flash.

### USB Permissions

The HummingBoard uses an FTDI USB-to-UART chip for serial console. To access it without root, create a udev rule:

```bash
sudo tee /etc/udev/rules.d/11-ftdi.rules > /dev/null << EOF
SUBSYSTEM=="usb", ATTR{idVendor}=="0403", ATTR{idProduct}=="6011", GROUP="plugdev", MODE="0664"
EOF
sudo udevadm control --reload-rules
```

## Flashing

The full procedure (qSPI with the board tools, eMMC with `bmaptool` from the flashing ramdisk, updates with SWUpdate) is described in the [Quick Start Guide](https://dev.solid-run.com/hailo/hailo-15/sbc-platform/hummingboard-hailo-15-som-quick-start-guide.md).

**Note:** when `bmaptool copy http://…` reports checksum mismatches while flashing over the network, download the `.wic.zst` and `.wic.bmap` files to the board first (for example with `wget`) and run `bmaptool copy` on the local files.

**Note:** the U-Boot device tree, the SPL and the kernel fitImage are signed, and the matching certificate is part of the qSPI set (`customer_certificate.bin`). SolidRun's signing key is not in this repository (it lives in `recipes-bsp/hailo-secureboot-assets`, which is git-ignored and injected by SolidRun's CI). A build without it uses Hailo's development keys, which works as long as the complete qSPI set and the images come from the same build.

### Network defaults

Both images, the flashing ramdisk and the update ramdisk configure `eth0` with the fixed address `10.0.0.1/24`; the PC side of the flashing and update flows is expected at `10.0.0.2`. There is no DHCP client on `eth0` by default. Two mechanisms hold the address in the main images: the static entry for `eth0` in `/etc/network/interfaces`, and a ConnMan wired profile that the `connman-static` init script writes on the first boot. To give the board a different network setup, change both (the `interfaces` file and the profile under `/var/lib/connman/`, or `connmanctl config`). A SWUpdate installs a fresh root filesystem, which sets the fixed address again on its first boot.

## Updating with SWUpdate

The update package `hailo-update-image-hailo15-solidrun.swu` rewrites the qSPI firmware set and the eMMC. The eMMC is repartitioned to Hailo's layout (64 MiB boot partition, 7328 MiB root filesystem, the remaining space as a data partition), so the first SWUpdate run on a board flashed with the wic image also changes the partition table.

The board downloads the package over HTTP from a PC, so the PC must serve the directory that contains the `.swu` file and be reachable from the board. The default addresses are 10.0.0.1 for the board and 10.0.0.2 for the PC (U-Boot variable `serverip`). On the PC:

```bash
cd build/tmp/deploy/images/hailo15-solidrun
sudo python3 -m http.server 80      # any HTTP server on port 80 works
nc -u -l -k 12345                   # optional, in a second terminal: shows the update log
```

There are two ways to start the update. Both run the same update ramdisk and give the same result.

**From the running system (development image):**

```bash
/etc/run_swupdate.sh -s 10.0.0.2 -r hailo-update-image-hailo15-solidrun.swu
```

Answer `yes`. The board reboots, U-Boot starts the update automatically, and after a few minutes the board reboots again into the updated system. `-s` stores the server IP in the U-Boot environment; without it U-Boot uses `serverip`. The file name is fixed by U-Boot to `hailo-update-image-<board>.swu`, so `-r` only checks it.

**From the U-Boot menu (both images, also when Linux does not boot):** stop the boot countdown on the serial console and select `SWUpdate`. U-Boot downloads the package from `serverip`.

**Note:** the production image (`core-image-hailo`) does not contain the `swupdate` program or the `run_swupdate.sh` script; Hailo installs them in the development image only. On the production image the U-Boot menu is the only way to start an update.

SWUpdate keeps the network configuration of the previous installation: `/etc/network/interfaces` is saved before the update and written back into the new root filesystem afterwards (a copy stays on the data partition as `network/interfaces.saved`). Flashing the wic image resets it to the image default.

If the download fails (server not reachable), the board stays in update mode and retries at every boot. To leave update mode without updating: select `U-Boot console` in the menu, run `run boot_mmc1`, and once Linux is up run `/etc/set_sw_image.sh a`. Programming the qSPI with the board tools also clears it.

## Using the SOM on a custom carrier

The Hailo-15 SOM can be used on a carrier board of your own with its own device tree. U-Boot normally selects the kernel device tree (a fitImage configuration) by reading the SOM revision from the SOM EEPROM, which is what the HummingBoard carriers need. On a custom carrier you switch that logic off and give U-Boot the name of the configuration to boot. Nothing in this layer has to be edited: your device tree, one U-Boot configuration fragment and one variable live in your own layer. The MAC address is still read from the SOM EEPROM.

### 1. Add your device tree to the kernel

In your layer, `recipes-kernel/linux/linux-yocto-hailo.bbappend` adds your DTS with a kernel patch (the patch creates `arch/arm64/boot/dts/hailo/<your-board>.dts` and adds a `dtb-$(CONFIG_ARCH_HAILO15) += <your-board>.dtb` line to the `Makefile` in that directory) and lists it in `KERNEL_DEVICETREE`:

```
FILESEXTRAPATHS:prepend := "${THISDIR}/files:"
SRC_URI:append = " file://0001-hailo15-add-the-<your-board>-device-tree.patch"
KERNEL_DEVICETREE:append = " hailo/<your-board>.dtb"
```

Your DTS includes `hailo15-sr-som.dtsi` (the SOM) and describes your carrier; `hailo15-solidrun.dts` (the HummingBoard IIoT) is the reference. The fitImage then contains a configuration named `conf-hailo_<your-board>.dtb` (Yocto builds the name from `conf-` and the DTB path with `/` replaced by `_`). `dumpimage -l fitImage` on the PC lists the configurations.

### 2. Tell U-Boot which configuration to boot

Switch the EEPROM-based selection off, in `conf/local.conf` (or in your machine configuration or kas file):

```
SOLIDRUN_EEPROM_DTS = "0"
```

and add a U-Boot configuration fragment in your layer, `recipes-bsp/u-boot/u-boot_%.bbappend`:

```
FILESEXTRAPATHS:prepend := "${THISDIR}/files:"
SRC_URI:append = " file://custom-carrier.cfg"
```

with `recipes-bsp/u-boot/files/custom-carrier.cfg`:

```
CONFIG_SOLIDRUN_FIT_CONF="conf-hailo_<your-board>.dtb"
```

Rebuild the image. At boot U-Boot prints `Selecting static fit config #conf-hailo_<your-board>.dtb` and the kernel reports your model string.

### Example

The files below were used to test this mechanism on a HummingBoard IIoT. The example device tree is the HummingBoard IIoT tree with another model string, so the boot log shows which tree U-Boot selected. The kernel patch adds `arch/arm64/boot/dts/hailo/hailo15-customer-example.dts`:

```
/dts-v1/;

#include "hailo15-solidrun.dts"

/ {
    model = "SolidRun HummingBoard IIoT (customer example DT)";
};
```

and the Makefile line `dtb-$(CONFIG_ARCH_HAILO15) += hailo15-customer-example.dtb`. With `KERNEL_DEVICETREE:append = " hailo/hailo15-customer-example.dtb"` in the kernel bbappend, `SOLIDRUN_EEPROM_DTS = "0"` in `local.conf` and `CONFIG_SOLIDRUN_FIT_CONF="conf-hailo_hailo15-customer-example.dtb"` in the U-Boot fragment, the boot log shows:

```
Selecting static fit config #conf-hailo_hailo15-customer-example.dtb
...
   Using 'conf-hailo_hailo15-customer-example.dtb' configuration
...
[    0.000000] Machine model: SolidRun HummingBoard IIoT (customer example DT)
```

### How it works

- `CONFIG_SOLIDRUN_EEPROM_DTS` (U-Boot Kconfig, `board/hailo/hailo15-solidrun/Kconfig`) enables the EEPROM-based selection. It is off in U-Boot's own defconfig. This layer switches it on with `SOLIDRUN_EEPROM_DTS ??= "1"` in `conf/machine/hailo15-solidrun.conf`, which makes the U-Boot recipe add the fragment `solidrun_eeprom_dts.cfg`. Setting the variable to `"0"` leaves the option off. With it on, a SOM rev 1.0 boots `conf-hailo_hailo15-solidrun.dtb` with the `hailo15-sr-som-v1-overlay.dtbo` overlay, a rev 1.1 boots the fitImage default.
- With the option off, U-Boot boots the configuration named by `CONFIG_SOLIDRUN_FIT_CONF`. An empty value means the fitImage default, which is the first DTB in `KERNEL_DEVICETREE`.
- A `fit_image_conf` value already present in the U-Boot environment wins in both cases, so a configuration can also be tried from the U-Boot console without rebuilding: `setenv fit_image_conf '#conf-hailo_<your-board>.dtb'` and `run boot_mmc1`.
- A wrong name stops the boot with `Could not find configuration node` instead of silently booting another device tree.

## Using the Package Manager

The development image includes the `opkg` package manager. It is intended for installing lightweight tools and dependencies during development and evaluation.

**Note:** Using the package manager in production is not recommended.  
The package mirror is not maintained for production use, and installing large or critical packages may break the system.

**Note:** In order to use the package manager, the system time must be set correctly to verify TLS certificates.

### Package Repository

Packages can be browsed and installed from the following repository:  
[SolidRun Hailo IPK Package Feed](https://solidrun-packages.com/hailo/meta-solidrun-arm-hailo/ipk/)

## More Information
For the information on how to flash and boot the board 
please follow the [Quick Start Guide](https://dev.solid-run.com/hailo/hailo-15/sbc-platform/hummingboard-hailo-15-som-quick-start-guide.md).
