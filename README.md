# Minimal Raspberry Pi 3 Linux configuration and Buildroot image

I was tired to get more than 100 MB of Linux modules by using the [`bcm2709`](https://github.com/raspberrypi/linux/blob/rpi-4.9.y/arch/arm/configs/bcm2709_defconfig) Linux kernel defconfig from the [Raspberry Pi official Linux repository](https://github.com/raspberrypi/linux), so I have created a *minimal* Linux configuration for the Raspberry Pi 3 and then adapted Buildroot 2018.02-git to get an embedded system with a small footprint.

Result:

- Kernal: 2.4 MB
- Rootfs: 3.7 MB (651 kB for the kernel modules)

## What do I have for that amount of bytes?

- Working HDMI + serial consoles
- Working Ethernet with DHCP
- Working internal Wifi with `wpa_supplicant` and DHCP
- A very simple GNU/Linux system that *boots* (from end of bootloader to start of init scripts) in 1.4 sec, you even have **vi** installed!

## What is missing?

- Bluetooth
- Almost all modules, so you will have to had the ones you need
- GPU related stuff

## How to use it?

Instead of making changes directly in [Buildroot's tree](https://github.com/buildroot/buildroot), I have prepared a simple `BR2_EXTERNAL` which can live alongside mainline Buildroot.

### Get Buildroot

Download or clone Buildroot in the parent directory

    $ git clone git://git.buildroot.net/buildroot

### Build the image

Create a new directory for the build (to keep the Buildroot tree clean), next to the freshly cloned `buildroot` directory

    $ mkdir build

To avoid duplicates in the downloaded files, I recommend using a separate directory for the downloads, so create another directory `buildroot_dl`

    $ mkdir buildroot_dl

Select your config

    $ cd build
    $ make BR2_EXTERNAL=../minimal_raspberrypi_buildroot/ O=$PWD -C ../buildroot/ raspberrypi3_minimal_defconfig

Then make

    $ make

After a while, the SD card image is ready in `images/sdcard.img`, you can then flash it with `dd` or [Etcher](https://etcher.io/) for example.

## FAQ

- Why stripping everything to get a system barely functional? *Just because we can*
- Why using **musl** as C library? *Just to give it a try*
- Why not using "x, y" repository already available? *Ah! interesting, I did not found it when I looked for it, please give me the URL to have a look*
- I have tried you image and the system do not boot in 1.4 sec? *This time was measured with the `quiet` argument given to the kernel, otherwise, the logs through the serial line slow down the boot. And by boot, I only mean the kernel boot, not the userspace (load network drivers then DHCP...)*
