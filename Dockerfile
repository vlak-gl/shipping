FROM maven:3.2-jdk-8 AS builder
WORKDIR /usr/src/mymaven
COPY . /usr/src/mymaven
RUN mvn -DskipTests package
RUN cp target/*.jar /app.jar

FROM weaveworksdemos/msd-java:jre-latest

WORKDIR /usr/src/app
COPY --from=builder /app.jar ./app.jar

RUN	chown -R ${SERVICE_USER} ./app.jar

USER ${SERVICE_USER}

LABEL org.label-schema.vendor="Weaveworks" \
  org.label-schema.name="Socks Shop: Shipping" \
  org.label-schema.description="REST API for Shipping service" \
  org.label-schema.url="https://github.com/microservices-demo/shipping" \
  org.label-schema.vcs-url="github.com:microservices-demo/shipping.git" \
  org.label-schema.vcs-ref="test" \
  org.label-schema.schema-version="1.0"

ENTRYPOINT ["/usr/local/bin/java.sh","-jar","./app.jar", "--port=80"]
