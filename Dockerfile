#
#   Copyright (c) 2020 - present, Moritz Stötter (modern embedded)
#
#           ╭───────────────────────────────╮
#   .mail ──┼── moritz@modernembedded.tech ─┼── send()
#    .web ──┼─ https://modernembedded.tech ─┼── visit()
#           ╰───────────────────────────────╯
#
#   Licensed under the Apache License, Version 2.0 (the "License");
#   you may not use this file except in compliance with the License.
#   You may obtain a copy of the License at
#
#       http://www.apache.org/licenses/LICENSE-2.0
#
#   Unless required by applicable law or agreed to in writing, software
#   distributed under the License is distributed on an "AS IS" BASIS,
#   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#   See the License for the specific language governing permissions and
#   limitations under the License.
#
ARG BASE_IMAGE=ubuntu:latest

FROM ${BASE_IMAGE}

USER root

ARG SERIAL_GID=20

RUN userdel -rf ubuntu || true \
    && apt update \
    && apt install -y \
        gdb \
        openocd \
        openssh-server \
        pip \
        python-is-python3 \
        python3 \
        rsync \
        sudo \
        valgrind \
    && if ! getent group ${SERIAL_GID} > /dev/null; then groupadd -g ${SERIAL_GID} hostserial; fi \
    && usermod -aG $(getent group ${SERIAL_GID} | cut -d: -f1),users,tty,sudo user \
    || useradd --shell /bin/bash -d /home/user -G $(getent group ${SERIAL_GID} | cut -d: -f1),users,tty,sudo -m user \
    && service ssh start

COPY files/requirements.txt /tmp/requirements.txt
RUN rm -f /usr/lib/python*/EXTERNALLY-MANAGED \
    && pip install -r /tmp/requirements.txt

COPY files/entrypoint.sh /tmp/entrypoint.sh
COPY files/entry /tmp/entry

ARG CONAN_HOME
USER user
RUN echo "export PATH=$PATH" >> ~/.bashrc \
    && if [ -n "$CONAN_HOME" ]; then echo "export CONAN_HOME=$CONAN_HOME" >> ~/.bashrc; fi
USER root

EXPOSE 22

ENTRYPOINT ["/tmp/entrypoint.sh"]
