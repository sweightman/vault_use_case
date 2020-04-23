FROM centos:7

ENV container docker

STOPSIGNAL SIGRTMIN+3

ENTRYPOINT ["/sbin/init"]

RUN yum -y install https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm && \
    yum update -y && \
    yum install unzip jq -y && \
    yum clean all
