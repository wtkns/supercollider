docker run \
    -it \
    -v /tmp/testing:./testing \
    -e "PACKAGER=Your Name <jms@wtkns.com>" \
    --rm \
    4383/apkbuild \
    newapkbuild test