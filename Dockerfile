
# build the static assets
FROM node as builder

WORKDIR /var/hugo
COPY src src
RUN cd src && \
    npm install && \
    npm run build:production

# build hugo container
FROM alpine:3.7

ENV HUGO_VERSION 0.42.2
ENV HUGO_BINARY hugo
ENV HUGO_RESOURCE hugo_${HUGO_VERSION}_Linux-64bit
ENV HUGO_ENV production

ADD https://github.com/spf13/hugo/releases/download/v${HUGO_VERSION}/${HUGO_RESOURCE}.tar.gz /tmp/

RUN  mkdir /tmp/${HUGO_RESOURCE} && tar -xvzf /tmp/${HUGO_RESOURCE}.tar.gz -C /tmp/${HUGO_RESOURCE}/ \
    && mv /tmp/${HUGO_RESOURCE}/${HUGO_BINARY} /usr/bin/hugo && rm -rf /tmp/hugo*

WORKDIR /var/hugo
COPY . .
COPY --from=builder /var/hugo .
RUN ls -al .

ENTRYPOINT [ "hugo" ]




