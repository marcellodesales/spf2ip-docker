FROM python:alpine

LABEL maintainer="marcello.desales@gmail.com"
LABEL origin="https://github.com/marcellodesales/docker-pycobertura"

#RUN apk add gcc g++ libxml2-dev libxslt-dev
# https://stackoverflow.com/questions/35931579/how-can-i-install-lxml-in-docker/57535436#57535436
RUN pip install --no-cache-dir pip install SPF2IP
    #apk add --no-cache --virtual .build-deps gcc libc-dev libxslt-dev && \
    # apk add --no-cache libxslt && \
   # apk del .build-deps

RUN SPF2IP --help

COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
