ARG BASE_CONTAINER=925388419436.dkr.ecr.us-west-1.amazonaws.com/datascience-notebook
FROM $BASE_CONTAINER

USER root
RUN apt update
RUN apt -y install curl
RUN curl -sL https://deb.nodesource.com/setup_14.x | bash -
RUN apt install nodejs -y

USER $NB_UID

RUN conda install --yes -c conda-forge \
    'elyra' && \
    jupyter lab build && \
    conda clean --all -f -y && \
    fix-permissions "${CONDA_DIR}" && \
    fix-permissions "/home/${NB_USER}"

WORKDIR $HOME