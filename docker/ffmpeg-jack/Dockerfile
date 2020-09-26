# I have no idea what state this was in when i abandoned it
FROM alpine:latest

# RUN apk --no-cache add alpine-sdk coreutils cmake \
#   && adduser -G abuild -g "Alpine Package Builder" -s /bin/ash -D builder \
#   && echo "builder ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers \
#   && mkdir /packages \
#   && chown builder:abuild /packages \
#   && mkdir -p /var/cache/apk \
#   && ln -s /var/cache/apk /etc/apk/cache

COPY privkey privkey.txt

# COPY /abuilder /bin/
# USER builder
# ENTRYPOINT ["abuilder", "-r"]
# WORKDIR /home/builder/package
# ENV RSA_PRIVATE_KEY_NAME ssh.rsa
# ENV PACKAGER_PRIVKEY /home/builder/${RSA_PRIVATE_KEY_NAME}
# ENV REPODEST /packages
# VOLUME ["/home/builder/package"]

#  LABEL maintainer="jms@wtkns.com"

#  RUN apk update && apk --no-cache add \
#      alpine-sdk \
#      git

# RUN adduser -S -G abuild $USERNAME
# RUN echo "$USERNAME:$USERNAME" | chpasswd 
# RUN echo "$USERNAME     ALL=(ALL) ALL" > /etc/sudoers
# RUN echo 'PACKAGER="$PACKAGER"' > /etc/abuild.conf

# RUN addgroup $USERNAME abuild

# RUN mkdir -p /var/cache/distfiles
# RUN chmod a+w /var/cache/distfiles
# RUN chgrp abuild /var/cache/distfiles 
# RUN chmod g+w /var/cache/distfiles

# RUN chmod 777 /home/jms

# USER $USERNAME
# WORKDIR /home/jms

# RUN git clone git://git.alpinelinux.org/aports

# RUN abuild-keygen -a -i
CMD ["/bin/sh"]