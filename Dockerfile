FROM alpine:3.11

RUN addgroup -S macaddresstool && \
    adduser -S -g macaddresstool macaddresstool

USER macaddresstool

WORKDIR /home/macaddresstool

CMD ["sh", "-c", "macaddresstool $@"]

# Add labels that are mostly static
LABEL maintainer="Ryan Luckie <rtluckie@gmail.com>" \
      org.opencontainers.image.title="macaddresstool" \
      org.opencontainers.image.description="A tool to retrieve information about MAC Addresses that uses macaddress.io" \
      org.opencontainers.image.url="https://github.com/rtluckie/macaddresstool" \
      org.opencontainers.image.source="git@github.com:rtluckie/macaddresstool" \
      org.opencontainers.image.vendor="Ryan Luckie" \
      org.label-schema.schema-version="1.0" \
      org.label-schema.name="macaddresstool" \
      org.label-schema.description="A tool to retrieve information about MAC Addresses that uses macaddress.io" \
      org.label-schema.url="https://github.com/rtluckie/macaddresstool" \
      org.label-schema.vcs-url="git@github.com:rtluckie/macaddresstool" \
      org.label-schema.vendor="Ryan Luckie"

COPY macaddresstool /usr/local/bin/macaddresstool

ARG BUILD_DATE
ARG VCS_REF

# Labels that will change on every build
LABEL org.opencontainers.image.revision="$VCS_REF" \
      org.opencontainers.image.created="$BUILD_DATE" \
      org.label-schema.vcs-ref="$VCS_REF" \
      org.label-schema.build-date="$BUILD_DATE"