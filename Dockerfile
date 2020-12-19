FROM ubuntu:20.04
LABEL maintainer="Alexander Jaeger - The Fittest GmbH"

ENV container docker
ENV LC_ALL C
ENV DEBIAN_FRONTEND noninteractive

RUN echo "APT::Get::Install-Recommends 'false'; \n\
  APT::Get::Install-Suggests 'false'; \n\
  APT::Get::Assume-Yes 'true'; \n\
  APT::Get::force-yes 'true';" > /etc/apt/apt.conf.d/00-general

# Install dependencies.
RUN apt-get update \
  && apt-get install -y --no-install-recommends \
  apt-utils \
  locales \
  python3-setuptools \
  python3-pip \
  software-properties-common \
  rsyslog \
  systemd \
  systemd-cron \
  sudo \
  iproute2  \
  ssl-cert \
  ca-certificates \
  apt-transport-https \
  curl \
  wget \
  && rm -Rf /usr/share/doc/* /usr/share/man/* /tmp/* /var/tmp/* \
  && apt-get clean
RUN sed -i 's/^\($ModLoad imklog\)/#\1/' /etc/rsyslog.conf

# Fix potential UTF-8 errors with ansible-test.
RUN locale-gen en_US.UTF-8

# Remove unnecessary getty and udev targets that result in high CPU usage when using
# multiple containers with Molecule (https://github.com/ansible/molecule/issues/1104)
RUN rm -f /lib/systemd/system/systemd*udev* \
  && rm -f /lib/systemd/system/getty.target

VOLUME ["/sys/fs/cgroup", "/tmp", "/run"]
