# Building Mawk

I noticed when trying to perform a static build that the Makefile seemed to be missing an entry for one of the source files. I added

```
makescan.o: nstd.h scancode.h
```

## Patching for a static build (and a working build)

It seems Makefile.in is missing an object. You can use the simple patch in this directory to fix that. Also the configure options don't seem to all be honored, so the following is a way to build it statically without any dirty hacks

```
$ cd mawk-1.3.4-20161120
$ patch -p1 < ../mawk-1.3.4-20161120-fix-makefile.patch
$ ./configure --host=mipsel-linux --with-build-cc=/opt/brcm/hndtools-mipsel-uclibc-3.2.3/bin/gcc CFLAGS='-fPIC -static'
$ make LIBS='/opt/brcm/hndtools-mipsel-uclibc-3.2.3/lib/libc.a /opt/brcm/hndtools-mipsel-uclibc-3.2.3/lib/libm.a' CFLAGS='-fPIC -static'
```
