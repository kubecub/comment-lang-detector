# Copyright © 2023 KubeCub open source community. All rights reserved.
# Licensed under the MIT License (the "License");
# you may not use this file except in compliance with the License.

FROM golang:1.20 as builder

WORKDIR /build

ENV GOPROXY=https://goproxy.cn


COPY . .

RUN make build

FROM alpine:latest

WORKDIR /app

COPY --from=builder /build/_output/bin/platforms/linux/amd64/cld .

ENTRYPOINT ["./cld"]
