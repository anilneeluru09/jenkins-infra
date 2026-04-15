FROM docker.io/jenkins/jenkins:lts-jdk17

USER root

RUN apt-get update \
    && apt-get install -y --no-install-recommends curl lsof netcat-openbsd ruby \
    && rm -rf /var/lib/apt/lists/*

USER jenkins

COPY plugins.txt /usr/share/jenkins/ref/plugins.txt
RUN jenkins-plugin-cli --plugin-file /usr/share/jenkins/ref/plugins.txt

COPY casc_configs/ /usr/share/jenkins/ref/casc_configs/
