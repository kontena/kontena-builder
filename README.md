# Kontena App Builder

A docker image that builds and pushes Kontena apps (docker images) via git push.

## Install

Write ssh public key and registry password to Kontena Vault:

```
$ kontena vault write BUILDER_AUTHORIZED_KEYS "$(cat ~/.ssh/id_rsa.pub)"
$ kontena vault write BUILDER_REGISTRY_PASSWORD "password"
```

Deploy builder service to Kontena Grid:

```
$ kontena service create \
  -e KONTENA_VERSION=0.11.7
  -e USERNAME=username -e EMAIL=not@val.id -e REGISTRY=https://index.docker.io/ \
  --secret BUILDER_REGISTRY_PASSWORD:PASSWORD:env \
  --secret BUILDER_AUTHORIZED_KEYS:AUTHORIZED_KEYS:env \
  -v /var/run/docker.sock:/var/run/docker.sock builder kontena/git-builder:latest
$ kontena service deploy builder
```

Where:

- `AUTHORIZED_KEYS` is the ssh public used with `git push`
- `KONTENA_VERSION` (optional) is the kontena-cli version used by builder
- `USERNAME` (optional) is the username to use to log into the registry using `docker login`
- `EMAIL` (optional) is the email to use to log into the registry using `docker login`
- `PASSWORD` (optional) is the password to use to log into the registry using `docker login`
- `REGISTRY` (optional) is the registry url to login with `docker login`. Defaults to `https://index.docker.io/v1/`

## Usage

```
$ git remote add kontena git@builder.kontena.local:api-demo
$ git push kontena master
Counting objects: 12, done.
Delta compression using up to 4 threads.
Compressing objects: 100% (12/12), done.
Writing objects: 100% (12/12), 1.62 KiB | 0 bytes/s, done.
Total 12 (delta 4), reused 0 (delta 0)
remote: Already on 'master'
remote: Building image registry.kontena.local/api-demo:latest
remote: Sending build context to Docker daemon  5.12 kB
remote: Step 0 : FROM gliderlabs/alpine:3.2
remote:  ---> ee5699c5df0e
remote: Step 2 : RUN apk --update add ruby ruby-dev ca-certificates     libssl1.0 openssl libstdc++ tzdata
remote:  ---> Using cache
remote:  ---> c4a8783beb25
remote: Step 3 : ADD Gemfile /app/
remote:  ---> Using cache
remote:  ---> 20c114ebe90e
remote: Step 4 : ADD Gemfile.lock /app/
remote:  ---> Using cache
remote:  ---> 4039dc531431
remote: Step 5 : RUN apk --update add --virtual build-dependencies build-base openssl-dev &&     gem install bundler &&     cd /app ; bundle install --without development test &&     apk del build-dependencies
remote:  ---> Using cache
remote:  ---> afdb8d0a6066
remote: Step 6 : ADD . /app
remote:  ---> Using cache
remote:  ---> d46b20512b02
remote: Step 7 : RUN chown -R nobody:nogroup /app
remote:  ---> Using cache
remote:  ---> c46166576f5d
remote: Step 8 : USER nobody
remote:  ---> Using cache
remote:  ---> 5a2556d63f17
remote: Step 9 : ENV RACK_ENV production
remote:  ---> Using cache
remote:  ---> 453a679fc68c
remote: Step 10 : WORKDIR /app
remote:  ---> Using cache
remote:  ---> 076615372c13
remote: Step 11 : CMD ruby api.rb
remote:  ---> Using cache
remote:  ---> 387abaaaecbd
remote: Successfully built 387abaaaecbd
remote: Pushing image registry.kontena.local/secret-api-demo:latest to registry
remote: The push refers to a repository [registry.kontena.local/secret-api-demo] (len: 1)
remote: 4a8a484e88fb: Buffering to Disk
remote: 4a8a484e88fb: Image successfully pushed
remote: 0d4115d2a3f8: Buffering to Disk
remote: 0d4115d2a3f8: Image successfully pushed
remote: 9ad78de99e28: Buffering to Disk
remote: 9ad78de99e28: Image successfully pushed
remote: 536ed6017232: Buffering to Disk
remote: 536ed6017232: Image successfully pushed
remote: 57e32ce6113e: Buffering to Disk
remote: 57e32ce6113e: Image successfully pushed
remote: 0f3d7f15aa5a: Buffering to Disk
remote: 0f3d7f15aa5a: Image successfully pushed
remote: afdb8d0a6066: Image already exists
remote: 4039dc531431: Image already exists
remote: 20c114ebe90e: Image already exists
remote: c4a8783beb25: Image already exists
remote: 4c5b244431b0: Image already exists
remote: ee5699c5df0e: Image already exists
remote: latest: digest: sha256:122ba4a96df642b6faee67d36fcbe186d972d9be77cfd5db8e9bbee56b162751 size: 18941
To git@builder.kontena.local:api-demo
 * [new branch]      master -> master

```

## License

Kontena software is open source, and you can use it for any purpose, personal or commercial. Kontena is licensed under the Apache License, Version 2.0. See [LICENSE](LICENSE) for full license text.
