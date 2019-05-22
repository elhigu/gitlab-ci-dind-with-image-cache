FROM docker:dind

# would create ~20GB sparse ext4 partition for docker --data-root
# but docker (golang) doesn't handle sparse files well, redhat has been tracking
# when it gets fixed in https://bugzilla.redhat.com/show_bug.cgi?id=1244300
# https://github.com/golang/go/issues/13548

# NOTE: virtual filesystem is now created at runtime in entrypoint to make image building
#       and setting up faster. This will cause them docker commit to write sparse
#       file as flat file to committed image. Since we create pretty big sparse file, we
#       should trim it down before committing it.

# create ext4 virtual FS ... for some reason docker image will be ~2-3 times bigger...
# RUN dd of=/var-lib-docker.loopback.ext4 bs=1 seek=5G count=0
# RUN /sbin/mkfs.ext4 -q /var-lib-docker.loopback.ext4

COPY dockerd-entrypoint.sh /usr/local/bin/dockerd-entrypoint.sh
RUN chmod gou+x /usr/local/bin/dockerd-entrypoint.sh

RUN mkdir -p /var-lib-docker

# force overlay2 driver 
CMD ["--storage-driver=overlay2"]
