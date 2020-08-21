# Pull cli base
FROM ffettes/docker-apps:cli-raw AS cli-base

ENV LANG en_US.UTF-8
ENV LC_ALL en_US.UTF-8
ENV LANGUAGE en_US.UTF-8
ENV UNAME ffettes

USER root
RUN \
     apt update && apt install -y \
     locales openssh-server curl wget mosh iputils-ping iproute2 fping

# Configuration
RUN \
     locale-gen en_US.UTF-8 && \
     mkdir /var/run/sshd && \
     sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd

RUN \
     # So you can ssh in (if you are authorized)
     sed '/zsh/d' /startapp.sh && \
     echo "$(which sshd)" >> /startapp.sh && \
     # The next two lines are useful if you map your ssh keys in and want to use github
     echo "eval `ssh-agent -s`" >> /startapp.sh && \
     echo "ssh-add ~/.ssh/id_rsa" >> /startapp.sh && \
     # Chown the work folder
     echo "exec /bin/zsh" >> /startapp.sh

USER $UNAME
EXPOSE 22
