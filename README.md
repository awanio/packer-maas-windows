# Packer MAAS Windows

[Packer](http://packer.io) [templates](https://www.packer.io/docs/templates/index.html),
associated scripts, and configuration for creating deployable Windows images for [MAAS](http://maas.io).

Template and scripts in this repo mostly credited to these repos:

* [canonical/packer-maas](https://github.com/canonical/packer-maas)
* [jakobadam/packer-qemu-templates](https://github.com/jakobadam/packer-qemu-templates)
* [joefitzgerald/packer-windows](https://github.com/joefitzgerald/packer-windows)
* [cagyirey/packer-windows-imaging-tools](https://github.com/cagyirey/packer-windows-imaging-tools)
* [cloudbase/cloudbase-init](https://github.com/cloudbase/cloudbase-init)
* [cloudbase/windows-curtin-hooks](https://github.com/cloudbase/windows-curtin-hooks)

## Prerequisites (to create the images)

* A machine running Ubuntu 18.04+ with the ability to run KVM virtual machines.
* qemu-utils
* [Packer](https://www.packer.io/intro/getting-started/install.html)
* The Windows installation ISO must be downloaded manually and placed it into `files` folder. You can download it [here.](https://www.microsoft.com/en-us/evalcenter/evaluate-windows-server-2019)
* [Windows Curtin Hook](https://github.com/cloudbase/windows-curtin-hooks/tarball/bb30d56) and placed it into `files` folder.
* [cloudbase-init](https://www.cloudbase.it/downloads/CloudbaseInitSetup_Stable_x64.msi) and placed it into `files` folder

## Requirements (to deploy the image)

* [MAAS](https://maas.io) 3.2.0 or above

## Building an image

Run this following packer command to build the image:
```
sudo PACKER_LOG=1 packer build windows.json
```

## Uploading an image to MAAS

```bash
maas $PROFILE boot-resources \
create name=windows/win2019 \
title='Windows Server 2019 Standard' \
architecture=amd64/generic \
filetype=ddtgz \
content@=windows-2019/standard.tar.gz
```
