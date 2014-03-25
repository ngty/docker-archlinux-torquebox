FROM ngty/archlinux-jdk7
MAINTAINER ngty

# Install dependencies
RUN pacman --noconfirm -Syy nodejs unzip

# Configure the environment
ENV TORQUEBOX_HOME /opt/torquebox-3.0.2
ENV JRUBY_HOME $TORQUEBOX_HOME/jruby
ENV JBOSS_HOME $TORQUEBOX_HOME/jboss
ENV PATH $JRUBY_HOME/bin:$PATH

# Install torquebox
RUN cd /opt; \
  curl -OL http://torquebox.org/release/org/torquebox/torquebox-dist/3.0.2/torquebox-dist-3.0.2-bin.zip && \
  unzip -q torquebox-dist-3.0.2-bin.zip && \
  rm torquebox-dist-3.0.2-bin.zip

# Install java crypto extension
ADD oracle/UnlimitedJCEPolicyJDK7.zip /tmp/UnlimitedJCEPolicy.zip
RUN cd /tmp && \
  unzip -q UnlimitedJCEPolicy.zip && \
  mv /tmp/UnlimitedJCEPolicy/*.jar $JAVA_HOME/jre/lib/security/ && \
  rm -rf /tmp/UnlimitedJCEPolicy.zip /tmp/UnlimitedJCEPolicy

# Wrapper script to run torquebox
ENV RUNNER /usr/local/sbin/run_tbox
RUN echo "#!/bin/bash" > $RUNNER
RUN echo "PORT=\$( ip addr | grep inet | grep eth0 | \\" >> $RUNNER
RUN echo "        awk '{print \$2}' | sed 's|/.*||' )" >> $RUNNER
RUN echo "JAVA_OPTS=-Djboss.bind.address=\$PORT" >> $RUNNER
RUN echo "$JRUBY_HOME/bin/torquebox run" >> $RUNNER
RUN chmod +x $RUNNER

# Expose service port(s)
EXPOSE 8080

# Command to boot
ENTRYPOINT $RUNNER
