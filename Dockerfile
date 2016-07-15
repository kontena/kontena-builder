FROM ubuntu:wily

RUN apt-get update && \
	DEBIAN_FRONTEND=noninteractive apt-get install -yq ca-certificates ssh ruby git curl && \
  apt-get clean && \
  rm -rf /var/lib/apt/lists/*

ENV DOCKER_VERSION=1.8.2
RUN curl -sL -o /usr/bin/docker https://get.docker.com/builds/Linux/x86_64/docker-${DOCKER_VERSION}
RUN chmod +sx /usr/bin/docker && \
    sed -i "s/#PasswordAuthentication yes/PasswordAuthentication no/" /etc/ssh/sshd_config && \
    echo "ClientAliveInterval 30" >> /etc/ssh/sshd_config && \
    mkdir -p /var/run/sshd && \
    useradd -d /home/git -m -s /bin/bash git && \
    mkdir -p /home/git/deploy && \
    gem install --no-ri --no-doc kontena-cli
ENV GIT_CLONE_OPTS="--recursive"
ADD gitserve.rb /usr/bin/gitserve
ADD pre_receive.rb /home/git/pre-receive
ADD run.sh /

VOLUME /home/git
ENTRYPOINT ["/run.sh"]
