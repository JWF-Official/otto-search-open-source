FROM alpine:3.16
ENTRYPOINT ["/sbin/tini","--","/usr/local/Otto/dockerfiles/docker-entrypoint.sh"]
EXPOSE 8080
VOLUME /etc/searx
VOLUME /etc/Otto

ARG Otto_GID=977
ARG Otto_UID=977

RUN addgroup -g ${Otto_GID} Otto && \
    adduser -u ${Otto_UID} -D -h /usr/local/Otto -s /bin/sh -G Otto Otto

ENV INSTANCE_NAME=Otto \
    AUTOCOMPLETE= \
    BASE_URL= \
    MORTY_KEY= \
    MORTY_URL= \
    Otto_SETTINGS_PATH=/etc/Otto/settings.yml \
    UWSGI_SETTINGS_PATH=/etc/Otto/uwsgi.ini

WORKDIR /usr/local/Otto


COPY requirements.txt ./requirements.txt

RUN apk upgrade --no-cache \
 && apk add --no-cache -t build-dependencies \
    build-base \
    py3-setuptools \
    python3-dev \
    libffi-dev \
    libxslt-dev \
    libxml2-dev \
    openssl-dev \
    tar \
    git \
 && apk add --no-cache \
    ca-certificates \
    su-exec \
    python3 \
    py3-pip \
    libxml2 \
    libxslt \
    openssl \
    tini \
    uwsgi \
    uwsgi-python3 \
    brotli \
 && pip3 install --upgrade pip wheel setuptools \
 && pip3 install --no-cache -r requirements.txt \
 && apk del build-dependencies \
 && rm -rf /root/.cache

COPY --chown=Otto:Otto . .

ARG TIMESTAMP_SETTINGS=0
ARG TIMESTAMP_UWSGI=0
ARG VERSION_GITCOMMIT=unknown

RUN su Otto -c "/usr/bin/python3 -m compileall -q searx"; \
    touch -c --date=@${TIMESTAMP_SETTINGS} searx/settings.yml; \
    touch -c --date=@${TIMESTAMP_UWSGI} dockerfiles/uwsgi.ini; \
    find /usr/local/Otto/searx/static -a \( -name '*.html' -o -name '*.css' -o -name '*.js' \
    -o -name '*.svg' -o -name '*.ttf' -o -name '*.eot' \) \
    -type f -exec gzip -9 -k {} \+ -exec brotli --best {} \+

# Keep these arguments at the end to prevent redundant layer rebuilds
ARG LABEL_DATE=
ARG GIT_URL=unknown
ARG Otto_GIT_VERSION=unknown
ARG LABEL_VCS_REF=
ARG LABEL_VCS_URL=
LABEL maintainer="Otto <${GIT_URL}>" \
      description="A privacy-respecting, hackable metasearch engine." \
      version="${Otto_GIT_VERSION}" \
      org.label-schema.schema-version="1.0" \
      org.label-schema.name="Otto" \
      org.label-schema.version="${Otto_GIT_VERSION}" \
      org.label-schema.url="${LABEL_VCS_URL}" \
      org.label-schema.vcs-ref=${LABEL_VCS_REF} \
      org.label-schema.vcs-url=${LABEL_VCS_URL} \
      org.label-schema.build-date="${LABEL_DATE}" \
      org.label-schema.usage="https://github.com/Otto/Otto-docker" \
      org.opencontainers.image.title="Otto" \
      org.opencontainers.image.version="${Otto_GIT_VERSION}" \
      org.opencontainers.image.url="${LABEL_VCS_URL}" \
      org.opencontainers.image.revision=${LABEL_VCS_REF} \
      org.opencontainers.image.source=${LABEL_VCS_URL} \
      org.opencontainers.image.created="${LABEL_DATE}" \
      org.opencontainers.image.documentation="https://github.com/Otto/Otto-docker"
