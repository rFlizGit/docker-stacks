# Copyright (c) Jupyter Development Team.
# Distributed under the terms of the Modified BSD License.

# https://hub.docker.com/r/jupyter/base-notebook/tags
ARG BASE_CONTAINER=925388419436.dkr.ecr.us-west-1.amazonaws.com/base-notebook
FROM $BASE_CONTAINER

LABEL maintainer="Jupyter Project <jupyter@googlegroups.com>"
ENV TAG="aec555e49be6"

COPY binder/README.ipynb .

# Fix permissions on README.ipynb as root
USER root

RUN fix-permissions README.ipynb

# Switch back to jovyan to avoid accidental container runs as root
USER $NB_UID

WORKDIR $HOME
