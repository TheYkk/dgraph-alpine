######################
# STEP 1 build dgraph
######################
FROM golang:1.15-alpine AS builder

# build custom branch
ARG DGRAPH_BRANCH=v20.07.0

# Install git
RUN apk update && apk add --no-cache git
WORKDIR /app
# build dgraph binary
RUN git clone --branch ${DGRAPH_BRANCH} http://github.com/dgraph-io/dgraph
WORKDIR /app/dgraph
RUN CGO_ENABLED=0 go build -a -ldflags "-extldflags '-static -s'"  -v -o /dgraph ./dgraph

#####################
# STEP 2 build image
#####################
FROM alpine:3.12

COPY --from=builder /dgraph /usr/local/bin/dgraph

RUN mkdir /dgraph
WORKDIR /dgraph

EXPOSE 8080
EXPOSE 9080

CMD ["dgraph"]