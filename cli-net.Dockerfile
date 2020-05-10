# Pull cli base
FROM randomvilliager/docker-apps:cli-raw AS cli-base

ENV LANG en_US.UTF-8
ENV LC_ALL en_US.UTF-8
ENV LANGUAGE en_US.UTF-8
ENV UNAME ffettes

USER root
# Less essential..
RUN \
     apt update && apt install -y \
     locales openssh-server curl wget mosh iputils-ping iproute2

# Configuration
RUN \
     locale-gen en_US.UTF-8 && \
     mkdir /var/run/sshd && \
     sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd

USER $UNAME
EXPOSE 22
