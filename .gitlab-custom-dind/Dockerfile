FROM docker:dind

# create ext4 virtual FS (20MB = 40960, 20GB = 40960000)... it will be pretty big image
RUN dd if=/dev/zero of=/var-lib-docker.loopback.ext4 count=40960000
RUN /sbin/mkfs.ext4 -q /var-lib-docker.loopback.ext4

COPY dockerd-entrypoint.sh /usr/local/bin/dockerd-entrypoint.sh
RUN chmod gou+x /usr/local/bin/dockerd-entrypoint.sh

RUN mkdir -p /var-lib-docker
RUN echo "/var-lib-docker.loopback.ext4 /var-lib-docker ext4 loop" >> /etc/fstab 

# force overlay2 driver 
CMD ["--storage-driver=overlay2"]
