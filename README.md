# Corda Development Network Docker Container

This project provides the necessary files to build and run a Docker container for a Corda development network. It includes a sample CorDapp and scripts to initialize and manage the Corda bootstrapper-network nodes.

## Prerequisites

Before you begin, ensure you have the following installed:

- Docker
- Docker Compose
- GNU Make (optional, for using Makefile shortcuts)

## Project Structure

- `cordapp/`: Contains the source code for the sample CorDapp (contracts, workflows, clients). To build and run your own cordapp, replace all the files with your own cordapp components.
- `Dockerfile`: Defines the steps to build the Docker image, including building the CorDapp and setting up the Corda nodes.
- `docker-compose.yaml`: Defines the services, networks, and volumes for running the Corda network using Docker Compose.
- `init.sh`: A script executed during the Docker image build process to run Corda database migrations for each node.
- `start-all.sh`: A script used inside the container to start all Corda nodes.
- `Makefile`: Provides convenient commands for building, running, and publishing the Docker image.
- `README.md`: This file.

## Building the Container

You can build the Docker image using the provided `Makefile` or directly with Docker commands.

### Using Makefile

The `Makefile` provides a simple way to build the image.

To build the image with the default repository (`sbir3japan`), project name (`corda-bootstrapper`), and tag (`local`):

```sh
make build
```

To specify a custom tag:

```sh
make build TAG=your-custom-tag
```

To specify a custom Docker repository and project name:

```sh
make build DOCKER_REPO=your-repo PROJECT=your-project-name TAG=your-tag
```

### Using Docker Directly

If you prefer not to use `make`, you can build the image using the `docker build` command:

```sh
docker build -t sbir3japan/corda-bootstrapper:local .
```

You can replace `sbir3japan/corda-bootstrapper:local` with your desired image name and tag.

## Running the Corda Network

Once the image is built, you can run the Corda development network.

### Using Makefile

The Makefile simplifies running the network:

```sh
make run
```

This command uses docker-compose.yaml to start the network in detached mode (`-d`).

### Using Docker Compose Directly

Alternatively, you can use Docker Compose directly:

```sh
docker compose -f docker-compose.yaml up -d
```

By default, docker-compose.yaml is hardcoded to expose the following RPC ports:

- 10003 for Notary
- 10006 for PartyA
- 10009 for PartyB
- 10012 for PartyC

IF you would like to change TEST NW structure, update `update-gradle.sh` and the port mappings in `docker-compose.yaml`.

## Container Initialization and Node Startup

- **Initialization (`init.sh`)**: During the Docker image build process (as defined in the `Dockerfile`), the `init.sh` script is executed. This script iterates through the deployed nodes and runs Corda database migration scripts (`run-migration-scripts --core-schemas --app-schemas`).

## Connecting to the Running Container

To get a shell inside the running container:

```sh
docker exec -it corda-bootstrapper bash
```

(Assuming your container is named `corda-bootstrapper` as defined in `docker-compose.yaml`).

## Node Startup

To start all nodes defined in `build.gradle`, go to `/home/corda` and run `start-all.sh` .

```shell
./start-all.sh
```

## Accessing the Nodes

The docker-compose.yaml file exposes the following RPC ports for the nodes:

- Notary: `10003`
- PartyA: `10006`
- PartyB: `10009`
- PartyC: `10012`

You can connect to these nodes using a Corda RPC client from your host machine.

## Stopping the Network

To stop and remove the containers defined in docker-compose.yaml:

```sh
docker compose -f docker-compose.yaml down
```

## Publishing the Image (Optional)

If you have built an image and want to push it to a Docker registry, you can use the `publish` target in the Makefile. Ensure you have logged in to your Docker registry first.

```sh
make publish
```

This will first run the `build` target and then push the image `${DOCKER_REPO}/${PROJECT}:${TAG}`. You can customize `DOCKER_REPO`, `PROJECT`, and `TAG` as environment variables if needed.
