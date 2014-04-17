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
ENV TORQUEBOX_RUNNER /usr/local/sbin/torquebox
ADD scripts/torquebox $TORQUEBOX_RUNNER

# Expose service port(s)
EXPOSE 8080

# Command to boot
ENTRYPOINT $TORQUEBOX_RUNNER
