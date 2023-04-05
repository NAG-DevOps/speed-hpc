FROM qmcgaw/latexdevcontainer:latest-full

# The following declarative commands are meant to extend the capabilities of the base Docker image

# Set not to invoke the Debian UI when using `apt[-get]`
RUN export DEBIAN_FRONTEND=noninteractive

# Install the missing `make` tool
RUN apt update -y && apt install -y make build-essential --no-install-recommends