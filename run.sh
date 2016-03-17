#!/bin/bash

echo "~~ Kontena App Builder ~~"

if [ -z "${AUTHORIZED_KEYS}" ]; then
  echo "=> AUTHORIZED_KEYS not set, exiting..."
  exit 1
else
  echo "=> Found authorized keys"
  mkdir -p /home/git/.ssh
  chmod 700 /home/git/.ssh
  touch /home/git/.ssh/authorized_keys
  chmod 600 /home/git/.ssh/authorized_keys
  IFS=$'\n'
  arr=$(echo ${AUTHORIZED_KEYS} | tr "," "\n")
  for x in $arr
  do
      x=$(echo $x |sed -e 's/^ *//' -e 's/ *$//')
      cat /home/git/.ssh/authorized_keys | grep "$x" >/dev/null 2>&1
      if [ $? -ne 0 ]; then
          echo "=> Adding public key to /home/git/.ssh/authorized_keys: $x"
          echo "command=\"/usr/bin/gitserve\",no-port-forwarding,no-X11-forwarding,no-agent-forwarding,no-pty $x" >> /home/git/.ssh/authorized_keys
      fi
  done
fi
chown git:git -R /home/git/

if [ -n "$KONTENA_VERSION" ]; then
  echo "=> Installing requested version of Kontena cli: ${KONTENA_VERSION}"
  gem install --no-ri --no-doc kontena-cli -v $KONTENA_VERSION
fi

if [ -n "$USERNAME" ] && [ -n "$EMAIL" ] && [ -n "$PASSWORD" ]; then
  echo "=> Logging in to docker registry $REGISTRY"
  docker login -u $USERNAME -e $EMAIL -p $PASSWORD $REGISTRY > /dev/null
  mv /root/.docker/config.json /home/git/.docker/
  chown git:git -R /home/git/.docker/
fi

exec /usr/sbin/sshd -D
