FROM alpine:3.11

RUN addgroup -S macaddresstool && \
    adduser -S -g macaddresstool macaddresstool

USER macaddresstool

WORKDIR /home/macaddresstool

CMD ["sh", "-c", "macaddresstool $@"]

COPY macaddresstool /usr/local/bin/macaddresstool

