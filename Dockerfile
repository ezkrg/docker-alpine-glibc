FROM alpine:3.4

ENV DESTDIR="/glibc" \
    GLIBC_LIBRARY_PATH="$DESTDIR/lib" \
    DEBS="libc6 libgcc1 libstdc++6" \
    GLIBC_LD_LINUX_SO="$GLIBC_LIBRARY_PATH/ld-linux-x86-64.so.2" \
    LIBC6_VER="2.24-8" \
    GCC_VER="4.9.2-10"

RUN echo "http://dl-cdn.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories \
 && echo "http://dl-cdn.alpinelinux.org/alpine/edge/main" >> /etc/apk/repositories \
 && echo "http://dl-cdn.alpinelinux.org/alpine/edge/community" >> /etc/apk/repositories \
 && apk add --update --no-cache --virtual .build-dependencies xz binutils patchelf \
 && wget -O /tmp/libc6_${LIBC6_VER}_amd64.deb http://ftp.debian.org/debian/pool/main/g/glibc/libc6_${LIBC6_VER}_amd64.deb \
 && wget -O /tmp/libgcc1_${GCC_VER}_amd64.deb http://ftp.debian.org/debian/pool/main/g/gcc-4.9/libgcc1_${GCC_VER}_amd64.deb \
 && wget -O /tmp/libstdc++6_${GCC_VER}_amd64.deb http://ftp.debian.org/debian/pool/main/g/gcc-4.9/libstdc++6_${GCC_VER}_amd64.deb \
 && cd /tmp \
 && for pkg in $DEBS; do \
        mkdir $pkg; \
        cd $pkg; \
        ar x ../$pkg*.deb; \
        tar -xf data.tar.*; \
        cd ..; \
    done \
 && mkdir -p $GLIBC_LIBRARY_PATH \
 && mv libc6/lib/x86_64-linux-gnu/* $GLIBC_LIBRARY_PATH \
 && mv libgcc1/lib/x86_64-linux-gnu/* $GLIBC_LIBRARY_PATH \
 && mv libstdc++6/usr/lib/x86_64-linux-gnu/* $GLIBC_LIBRARY_PATH \
 && apk del .build-dependencies \
 && rm -rf /tmp/*
