ARG BASE_IMAGE=ubuntu:latest

FROM ${BASE_IMAGE}

USER root

ARG DIALOUT_GID=20

RUN userdel -rf ubuntu || true && \
    apt update && \
    apt install -y \
        gdb \
        openssh-server \
        rsync \
        sudo \
        valgrind && \
    groupmod -g ${DIALOUT_GID} dialout && \
    useradd --shell /bin/bash -d /home/user -G users,tty,dialout,sudo -m user && \
    service ssh start

COPY files/entrypoint.sh /tmp/entrypoint.sh
COPY files/entry /tmp/entry

USER user
RUN echo "export PATH=$PATH" >> ~/.bashrc
USER root

EXPOSE 22

ENTRYPOINT ["/tmp/entrypoint.sh"]
