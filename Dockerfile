FROM golang:1.18-alpine

# Install Tini
RUN apk --no-cache --no-progress add tini

RUN go install -v github.com/Depado/goploader/server@latest && \
  cd $GOPATH/pkg/mod/github.com/!depado/goploader*/server && \
  mv -v assets templates /go/bin/server /opt/goploader

WORKDIR /opt/goploader

# Create custom entrypoint supports environment variables
RUN echo -e "#!/bin/ash\n/opt/goploader/server -c /etc/goploader/config.yml" > /entrypoint.sh && \
  chmod +x /entrypoint.sh

ENTRYPOINT ["/sbin/tini", "-vg", "--", "/entrypoint.sh"]
