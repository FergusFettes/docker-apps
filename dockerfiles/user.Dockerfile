FROM ubuntu:18.04

# User config
ENV UID="1000" \
    UNAME="ffettes" \
    GID="1000" \
    GNAME="ffettes" \
    SHELL="/bin/zsh" \
    HOME=/home/ffettes \
    EMAIL=fergusfettes@gmail.com

# User
RUN \
     # Create HOME dir
     mkdir -p "${HOME}" && \
     chown "${UID}":"${GID}" "${HOME}" && \
     # Create user
     echo "${UNAME}:x:${UID}:${GID}:${UNAME},,,:${HOME}:${SHELL}" \
     >> /etc/passwd && \
     echo "${UNAME}::17032:0:99999:7:::" \
     >> /etc/shadow && \
     # No password sudo
     mkdir /etc/sudoers.d/ && \
     echo "${UNAME} ALL=(ALL) NOPASSWD: ALL" \
     > "/etc/sudoers.d/${UNAME}" && \
     chmod 0440 "/etc/sudoers.d/${UNAME}" && \
     # Create group
     echo "${GNAME}:x:${GID}:${UNAME}" && \
     >> /etc/group

# Set up the git config
RUN \
     echo "[user]" > $HOME/.gitconfig && \
     echo "  email = $UNAME@cli-raw.image" >> $HOME/.gitconfig && \
     echo "  name = $UNAME" >> $HOME/.gitconfig

# Metadata.
ARG IMAGE_VERSION=helper
LABEL \
      org.label-schema.name="user-management" \
      org.label-schema.description="User management" \
      org.label-schema.version="${IMAGE_VERSION}" \
      org.label-schema.vcs-url="https://github.com/fergusfettes/docker-apps" \
      org.label-schema.schema-version="1.0"
