# build from root of repo by running:
#   docker build . -f mode_build/Dockerfile

FROM colstrom/concourse-fuselage

RUN apk-install git ca-certificates libressl-dev \
    && update-ca-certificates \
    && apk update \
    && apk del openssl-dev \
    && rm -vf /var/cache/apk/*

COPY . /build
WORKDIR /build

RUN cp -f mode_build/concourse-github-status.gemspec ./ \
    && gem build concourse-github-status.gemspec \
    && gem install concourse-github-status-0.0.0.gem

WORKDIR /opt/resource

RUN find $(gem environment gemdirs) -type f -path '*/concourse-github-status-*/bin/*' -exec ln -s '{}' \;
