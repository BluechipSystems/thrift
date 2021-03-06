# Licensed to the Apache Software Foundation (ASF) under one
# or more contributor license agreements. See the NOTICE file
# distributed with this work for additional information
# regarding copyright ownership. The ASF licenses this file
# to you under the Apache License, Version 2.0 (the
# "License"); you may not use this file except in compliance
# with the License. You may obtain a copy of the License at
#
#   http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing,
# software distributed under the License is distributed on an
# "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
# KIND, either express or implied. See the License for the
# specific language governing permissions and limitations
# under the License.
#

# Goal: provide a thrift-compiler Docker image
#
# further details on docker for thrift is here build/docker/
#
# TODO: push to apache/thrift-compiler instead of thrift/thrift-compiler

FROM debian:jessie
MAINTAINER Apache Thrift <dev@thrift.apache.org>

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update
RUN apt-get upgrade -y

# minimal dependencies
RUN apt-get install -y flex bison g++ cmake

ADD . /thrift

RUN mkdir cmake-build && cd cmake-build && cmake -DBUILD_COMPILER=ON -DBUILD_LIBRARIES=OFF -DBUILD_TESTING=OFF -DBUILD_EXAMPLES=OFF /thrift && make
RUN cp /cmake-build/bin/thrift /usr/bin/thrift

# Clean up
RUN apt-get clean && \
    rm -rf /var/cache/apt/* && \
    rm -rf /var/lib/apt/lists/* && \
    rm -rf /tmp/* && \
    rm -rf /var/tmp/* \
    rm -rf cmake-build

ENTRYPOINT ["/usr/bin/thrift"]
