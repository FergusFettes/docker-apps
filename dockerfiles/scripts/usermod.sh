#!/usr/bin/env bash

# User
RUN \
     # Create HOME dir
     chown -R "${UID}":"${GID}" "${HOME}" && \
     # Create user
     sed "/${UNAME}/d" /etc/passwd && \
     echo "${UNAME}:x:${UID}:${GID}:${UNAME},,,:${HOME}:${SHELL}" \
     >> /etc/passwd && \
     echo "${UNAME}::17032:0:99999:7:::" \
     >> /etc/shadow && \
     # Create group
     sed "/${UNAME}/d" /etc/group && \
     echo "${GNAME}:x:${GID}:${UNAME}" && \
     >> /etc/group

