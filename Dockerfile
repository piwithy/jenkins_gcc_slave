FROM ubuntu:20.04

LABEL maintainer="Pierre-Yves Jezegou <jezegoup@gmail.com>"

# Make sure the package repository is up to date.
RUN export DEBIAN_FRONTEND=noninteractive && \
    apt-get update && \
    #echo "update" && \
    apt-get -qy full-upgrade && \
    #echo "upgrade" && \
    apt-get install -qy git && \
# Install a basic SSH server
    apt-get install -qy openssh-server && \
    sed -i 's|session    required     pam_loginuid.so|session    optional     pam_loginuid.so|g' /etc/pam.d/sshd && \
    mkdir -p /var/run/sshd && \
# Install Java for jenkins integration
    apt-get install -qy openjdk-8-jdk && \
# Install Essentials Build tools
    apt-get install -qy build-essential && \
# Install gcc
    apt-get install -qy gcc && \
# Install make
    apt-get install -qy make && \
# Install cmake
    apt-get install -qy cmake && \
# Cleanup old packages
    apt-get -qy autoremove && \
# Add user jenkins to the image
    adduser --quiet jenkins && \
# Set password for the jenkins user (you may want to alter this).
    echo "jenkins:jenkins" | chpasswd && \
    mkdir /home/jenkins/.m2

#ADD settings.xml /home/jenkins/.m2/
# Copy authorized keys
COPY .ssh/authorized_keys /home/jenkins/.ssh/authorized_keys

RUN chown -R jenkins:jenkins /home/jenkins/.m2/ && \
    chown -R jenkins:jenkins /home/jenkins/.ssh/

# Standard SSH port
EXPOSE 22

CMD ["/usr/sbin/sshd", "-D"]
