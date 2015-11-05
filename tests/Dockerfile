FROM nanobox/build:beta

# Remove existing engines, we don't want to test those
RUN rm -rf /opt/engines/*

# Create folders for this engine
RUN mkdir -p /opt/engines/ruby/bin && \
    mkdir -p /opt/engines/ruby/lib && \
    mkdir -p /opt/engines/ruby/templates

RUN curl https://codeload.github.com/nanobox-io/nanobox-engine-nodejs/tar.gz/master | \
    tar -xzC /opt/engines/ruby --strip-components 1

RUN curl https://codeload.github.com/nanobox-io/nanobox-engine-java/tar.gz/master | \
    tar -xzC /opt/engines/ruby --strip-components 1

# Add in this engine's files
ADD bin/. /opt/engines/ruby/bin
ADD lib/. /opt/engines/ruby/lib
ADD templates/. /opt/engines/ruby/templates