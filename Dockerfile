# sudo podman build --rm -t quay.io/rhtgptetraining/ocp-smtp-relay:1.0 .
# sudo podman run -it --rm quay.io/rhtgptetraining/ocp-smtp-relay:1.0 /bin/bash
# sudo podman run -v /dev/log:/dev/log -e MTP_RELAY=$smtp_host -e MTP_PORT=$smtp_port -e MTP_USER=$smtp_userid -e MTP_PASS=$smtp_passwd quay.io/rhtgptetraining/ocp-smtp-relay:1.0
# sudo podman login .....
# sudo podman push quay.io/rhtgptetraining/ocp-smtp-relay:1.0

FROM centos:7.6.1810

MAINTAINER JA Bride 

RUN yum update -y && \
    yum install -y postfix cyrus-sasl-plain && \
    yum clean all

ENV MTP_RELAY changeme
ENV MTP_PORT 587
ENV MTP_USER changeme
ENV MTP_PASS changeme

COPY main.cf /etc/postfix/main.cf

# For an image to support running as an arbitrary user, directories & files to be written to by processes in image should be owned by the root group and be read/writable by that group. 
# Files to be executed should also have group execute permissions.
RUN chgrp -R 0 /etc/postfix && \
    chmod -R g=u /etc/postfix
    
COPY docker-setup.sh /docker-setup.sh
RUN chmod +x /docker-setup.sh

# Container must run as root because it listens on port 25
# This will be a problem in OpenShift, so you'll have to add the anyuid scc to whatever service account is being used by linux container
USER root

EXPOSE 25

ENTRYPOINT /docker-setup.sh
