FROM azul/zulu-openjdk:17.0.15-jdk AS builder

COPY --chown=corda:corda ./cordapp /tmp/cordapp
COPY --chown=corda:corda ./update-gradle.sh /tmp/update-gradle.sh
RUN chmod +x /tmp/update-gradle.sh
RUN chmod +x /tmp/cordapp/gradlew

WORKDIR /tmp
RUN ./update-gradle.sh

WORKDIR /tmp/cordapp
RUN ./gradlew deployDefaultNodes

FROM azul/zulu-openjdk:17.0.15-jdk

RUN groupadd -g 1000 corda && \
    useradd -u 1000 -g corda -m -d /home/corda -s /bin/bash corda && \
    mkdir -p /home/corda/nodes && \
    chown -R corda:corda /home/corda && \
    chmod -R 755 /home/corda

COPY --from=builder /tmp/cordapp/build/nodes /home/corda/nodes
RUN chown -R corda:corda /home/corda/nodes

COPY --chown=corda:corda ./*.sh /home/corda/
RUN chmod +x /home/corda/*.sh

USER corda
RUN /home/corda/init.sh
