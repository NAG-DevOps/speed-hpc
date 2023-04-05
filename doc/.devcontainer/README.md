# Speed HPC Utilities

## Development Container for LaTeX

> For use with [Visual Studio Code](https://code.visualstudio.com/) editor. [Details on this dev container extension](https://code.visualstudio.com/docs/devcontainers/containers).

### Introduction

This folder contains the necessary Docker files and environment dependencies, e.g. plugins and extensions, to start up a containerized environment with full support for authoring and building LaTeX documents.

The dev container configuration uses the container image from [qmcgaw/latexdevcontainer](https://hub.docker.com/r/qmcgaw/latexdevcontainer/) with `latest-full` tag.

The `devcontainer.json` manifests the recommended Visual Studio Code extensions and workspace configurations.

### Requirements

- Windows 10/11 x86-64 >= 1909 | x86-64 Linux distribution | macOS >=10.15 (Catalina)
- Visual Studio Code
- [Docker](https://docs.docker.com/get-docker/)

### Usage

- Open the repository root folder.
- <kbd>CTRL / ⌘ cmd + SHIFT + P</kbd> to bring up the command palette.
- Search for "Dev Container: Reopen in Container" and hit enter to run.

VS Code will then start a Docker container using the default image and configurations in this repository and automatically start a remote connection to the container using `ssh`.

### Understanding the files

> Note that the filenames are case-sensitive. On a non-sensitive OS like Windows, misnaming the file may result in undefined reference errors when using SCM tools (like git) across other OS's (Linux, macOS).

#### `devcontainer.json`

This file contains the properties (instructions) on how the dev container is set up for Code to remote into, as well as which useful extensions to install and settings to configure on container startup.

An important for this repository is `dockerComposeFile` (see [docker-compose.yml](#docker-composeyml)).

For more information on the properties, visit [containers.dev](https://containers.dev/implementors/json_reference/)

#### `Dockerfile`

This file is used by Docker as a set of instructions to build a container image. The build process starts from a base image. In our case, it is a prebuilt image with the necessary LaTeX tools loaded already.

[Dockerfile reference](https://docs.docker.com/engine/reference/builder/)
 | [Base image reference](https://hub.docker.com/r/qmcgaw/latexdevcontainer)

#### `docker-compose.yml`

Normally a `docker-compose.yml` file is used for starting up multiple peer-dependent containers. For example, a full-stack application orchestration may have these containers: frontend (running Apache2 or Node application), database (PostgreSQL, mongoDB), cache (Redis), or API gateway (nginx).

In our case, we use the file to give the directives for mounting the project folder, local Docker socket folder, local shell environment, etc. as a volume on the single dev container.

The `entrypoint` attribute at the end of the file to work around a bug from VS Code >= 1.64 (currently v1.73) when spinning up the containers using the extension. The workaround was detailed in this issue on the VS Code's repository: [microsoft/vscode-remote-release#6337](https://github.com/microsoft/vscode-remote-release/issues/6337).

[docker-compose.yml reference](https://docs.docker.com/compose/compose-file/)

#### `.dockerignore`

Functions similarly to the `.gitignore` in that it specifies the files and folders to exclude when running the `COPY` command in `Dockerfile`.
