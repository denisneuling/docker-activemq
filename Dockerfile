FROM ubuntu:14.04
MAINTAINER Denis Neuling <denisneuling@gmail.com>

ENV ACTIVEMQ_VERSION 5.12.0

# OS preparation
RUN \
    echo 8.8.8.8 >> /etc/resolve.conf && \
    echo 8.8.4.4 >> /etc/resolve.conf && \
	sed -i 's/archive.ubuntu.com/de.archive.ubuntu.com/g' /etc/apt/sources.list && \
    apt-get update && \
    apt-get install -y openjdk-7-jdk openjdk-7-jre-headless curl supervisor

# Prepare supervisord
RUN \
	mkdir -p /var/log/supervisor /var/lock/activemq /var/run/activemq

# Fetch ActiveMQ and set up / clean up
RUN \
	curl http://apache.openmirror.de/activemq/$ACTIVEMQ_VERSION/apache-activemq-$ACTIVEMQ_VERSION-bin.tar.gz -o /tmp/activemq.tar.gz 2>&1 && \
    tar -xzf /tmp/activemq.tar.gz -C / && \
	mv /apache-activemq-$ACTIVEMQ_VERSION /activemq && \
	rm -rf /activemq/webapps-demo && \
	rm -rf /activemq/examples && \
	rm -rf /activemq/docs && \
	rm -rf /activemq/activemq-all-5.12.0.jar

# Configure supervisord
ADD etc/supervisor/conf.d/supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# Copy extra libs for activemq
ADD activemq/lib/* /activemq/lib/

# Copy custom Configuration
ADD activemq/conf/* /activemq/conf/
ADD usr/bin/activemq /usr/bin/

# Expose AMQP and HTTP web console port to the host machine
EXPOSE 8161 5672

# Ship that shizzle
CMD ["/usr/bin/supervisord"]
