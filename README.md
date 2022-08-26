# How-to
This template repo builds a container from its Dockerfiles and registers them in GHCR

It registers multiarch containers and can do staged builds. Staged builds are for when
you want multiple image tags registered at a single path. This allows you to maintain
one source repo for many purposes. Sometimes only the base images can be compiled
multiarch because the higher level images have unsupported dependencies.

The `docker-compose.yaml` file is an example... Each service can be an additional tag 
off the main registry path

