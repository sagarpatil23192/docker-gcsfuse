# Set the base image to Ubuntu
FROM nginx:latest

# File Author / Maintainer
MAINTAINER Sagar Patil


# Update the repository
RUN apt-get update

# Install necessary tools
RUN apt-get install -y vim wget dialog net-tools curl gnupg 


#Installing GCSFUSE Driver
RUN echo "deb http://packages.cloud.google.com/apt gcsfuse-xenial main" >> /etc/apt/sources.list.d/gcsfuse.list \
            && curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add - \
            && apt-get update \
            && apt-get install --no-install-recommends --no-install-suggests -y gcsfuse libfuse2 fuse \
            && rm -rf /var/lib/apt/lists/*


# Expose ports
EXPOSE 80

#Copying gcsfuse run script.
COPY gcsfuse-run.sh /usr/local/bin/run

COPY gcsfuse-run.sh /tmp/

#Changing script to executable.
RUN chmod +x /usr/local/bin/run

CMD ["/usr/local/bin/run"]
