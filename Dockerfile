#
# Copyright 2014-2015 Red Hat, Inc. and/or its affiliates
# and other contributors as indicated by the @author tags.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

# Hawkular-Metrics DockerFile
#
# This dockerfile can be used to create a Hawkular-Metrics docker
# image to be run on Openshift.

FROM jboss/wildfly:8.2.0.Final

# The image is maintained by the Hawkular Metrics team
MAINTAINER Hawkular Metrics <hawkular-dev@lists.jboss.org>

# TODO: remove when we have a base image which includes JDK8 support itself
USER root
RUN yum install -y java-1.8.0-openjdk java-1.8.0-openjdk-devel; \
    yum clean all -y;

ENV JAVA_HOME /usr/lib/jvm/java-1.8.0
USER jboss

# Port 8080 is the http endpoint for interacting with Hawkular-Metrics
EXPOSE 8080

# The Hawkular Metrics version
ENV HAWKULAR_METRICS_VERSION 0.3.4-SNAPSHOT

# Get and copy the hawkular metrics war to the EAP deployment directory
RUN cd $JBOSS_HOME/standalone/deployments/ && \
    curl -Lo hawkular-metrics-api-jaxrs.war https://origin-repository.jboss.org/nexus/service/local/artifact/maven/content?r=public\&g=org.hawkular\&a=hawkular-metrics-api-jaxrs\&e=war&v=${HAWKULAR_METRICS_VERSION}

CMD $JBOSS_HOME/bin/standalone.sh -b 0.0.0.0 -bmanagement 0.0.0.0 -Dhawkular-metrics.cassandra-nodes=hawkular-cassandra -Dhawkular-metrics.backend=cass
