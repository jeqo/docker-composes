FROM redhat/ubi8 as cruise-control

RUN yum install -y java-11-openjdk-devel wget tar git

ENV CRUISE_CONTROL_HOME=/opt/cruise-control
ENV CRUISE_CONTROL_VERSION=2.5.134
WORKDIR ${CRUISE_CONTROL_HOME}
RUN wget https://github.com/linkedin/cruise-control/archive/refs/tags/${CRUISE_CONTROL_VERSION}.tar.gz
RUN tar -xzf ${CRUISE_CONTROL_VERSION}.tar.gz
WORKDIR cruise-control-${CRUISE_CONTROL_VERSION}
RUN git init && \
    git config --global user.email "cruise-control@localhost" && \
    git config --global user.name "Cruise Control" && \
    git add . && \
    git commit -m "Cruise control local repo."  && \
    git tag -a ${CRUISE_CONTROL_VERSION} -m "Init local version."
RUN ./gradlew jar copyDependantLibs

CMD ./kafka-cruise-control-start.sh ${CRUISE_CONTROL_HOME}/config/cruisecontrol.properties

FROM confluentinc/cp-kafka:7.3.3 as kafka

ENV CRUISE_CONTROL_HOME=/opt/cruise-control
ENV CRUISE_CONTROL_VERSION=2.5.134
COPY --from=cruise-control \
    ${CRUISE_CONTROL_HOME}/cruise-control-${CRUISE_CONTROL_VERSION}/cruise-control-metrics-reporter/build/libs/cruise-control-metrics-reporter-${CRUISE_CONTROL_VERSION}.jar \
    /usr/share/java/kafka/
