# Speed HPC Utilities

## Development Container for LaTeX

> For use with [Visual Studio Code](https://code.visualstudio.com/) editor. [Details on this dev container extension](https://code.visualstudio.com/docs/devcontainers/containers).

### Introduction

This folder contains the necessary Docker files and environment dependencies like plugins and extensions to start up a containerized environment with full support for authoring and building LaTeX documents.

The dev container configuration uses the container image from [qmcgaw/latexdevcontainer](https://hub.docker.com/r/qmcgaw/latexdevcontainer/) with `latest-full` tag.

The `devcontainer.json` manifests the recommended Visual Studio Code extensions.

### Requirements

- Windows 10/11 x86-64 >= 1909 | x86-64 Linux distribution | macOS >=10.15 (Catalina)
- Visual Studio Code
- [Docker](https://docs.docker.com/get-docker/)
- (After starting the container), you might need to run `apt install make build-essentail` to install the missing packages in the base container.

### Usage

- Open the repository root folder
- CTRL + SHIFT + P to bring up the command palette
- Search for "Dev Container: Reopen in Container" and hit enter to run.

VS Code will then start a Docker container using the image and configurations mentioned above and automatically start a remote connection to the container using `ssh`.
