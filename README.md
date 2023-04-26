# Agda Setup

This repository contains a simple Dev Container setup to use with VSCode and Agda.
The following sections describe the basic steps to get a working Agda setup with VSCode Dev Containers.
The contained Dockerfile can alternatively also be used to build a different setup based on the same image.

## Preliminaries
Install VSCode and the DevContainers extension (unfortunately, this extension is proprietary and not available for VSCodium).

The next step is to install Docker. I suggest to use Docker Engine on Linux systems and Docker Desktop on any other system.
To find out, whether your system can run Docker Engine, try the following commands:

```bash
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh ./get-docker.sh --dry-run
```

If no error message occurs, you should be able to run `sudo sh get-docker.sh` and get a working Docker installation.
If you use Docker Engine also make sure to do the following steps:

```bash
sudo groupadd docker
sudo usermod -aG docker $USER
# Log out and back in (just closing the terminal does not suffice!)
newgrp docker
docker run hello-world
```
If the last command worked, you're ready to go.

For more info on how to install Docker see the official documentation at [docs.docker.com](https://docs.docker.com/desktop/install/linux-install/).

## Setup Working Directory
Once you have everything setup, you can either work in a local copy of this repository or a new working directory.
You need to copy the `.devcontainer.json` file from this repository to the new directory, if you want to use the dev container.
Once you have done this (or if you use this repository), you can start VSCode, open the directory and open it in the dev container.
You can do this either by clicking on the pop-up in the bottom right or by opening the command pallette (Ctrl+Shift+P on Linux) and choosing `Dev Containers: Reopen in Container`.

VSCode will then load the current directory through the container and automatically install the agda-mode extension (the fixed version from [here](https://github.com/banacorn/agda-mode-vscode/pull/140)) for easier interaction with Agda.
Because it has to fetch the image (~480MB) and setup everything, this may take a while.
In contrast, building Agda from scratch can take up to 15 minutes on a rather fast machine.
Once the agda-mode extension is loaded (this can e.g. be seen when the extension tab doesn't show the clock icon anymore), open any Agda file (e.g. the hello-world.agda provided in the repository) and press Ctrl+C followed by Ctrl+L.
If the Agda window pops up and shows `All done`, you're setup is done and works.

## Limitations
The Dev Containers workflow can be slower and more resource intensive then a native installation.
Moreover, the Agda installation provided in the container can not be used to compile standalone programs if that would require the Haskell FFI, as the container does not contain ghc or cabal to keep it small (~480MB vs. ~1.2GB).
If you want to have access to both ghc and cabal in the container feel free to change the Dockerfile and rebuild it yourself or switch to the `builder` target instead of the `app` target in the image.
The provided container has been build from the Dockerfile in this repository without any further changes.
You can also download the container directly without the dev container extension, e.g. by running `docker pull ghcr.io/firefighterduck/agdatt:latest`.

The setup has been tested on Ubuntu 22.04 LTS and Windows 11.
If it doesn't work on your system, please feel free to open up an issue or a PR.
