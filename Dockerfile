FROM alpine:3.20.0

LABEL net.juniper.description="Junos PyEZ library for Python in a lightweight container." \
    net.juniper.maintainer="Stephen Steiner <ssteiner@juniper.net>"

WORKDIR /source

## Copy project inside the container
ADD setup.* ./
ADD versioneer.py .
ADD requirements.txt .
COPY lib lib
COPY --chmod=777 entrypoint.sh /usr/local/bin/

## Install dependencies and PyEZ
RUN apk add --no-cache build-base python3-dev py3-pip libffi-dev bash \
    && python3 -m venv .venv \
    && source .venv/bin/activate \
    && python3 -m pip install -r requirements.txt \
    && python3 -m pip install . \
    && rm -rf /source/*

WORKDIR /scripts

VOLUME /scripts

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
