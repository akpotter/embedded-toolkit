# Obsoleted by [https://github.com/mzpqnxow/gdb-static-cross](gdb-static-cross) but you can still use these binaries and I'll try to keep them in sync

First, please see [https://github.com/mzpqnxow/gdb-static-cross](gdb-static-cross) rather than following these steps as I believe I obsoleted this particular build with that repository. It has patches for the below issues and is much simpler

## Notes and patches for building gdbserver from gdb-7.12 and gdb-7.7.1 statically (especially for cross-compiling)

This is documentation and a few small patch files to make building statically linked gdbserver executables using various cross-compile toolchains easier. The patches I've made here are for the hndtools cross-compilers specifically but the build instructions will be helpful for any cross-compile toolchain. These same instructions are useful with musl-cross-make as well as OpenWrt pre-built toolchains. There's nothing terrivly advanced here, but the removal of ```srv_linux_thread_db``` really saves a lot of time that could easily be wasted

If you are using musl-cross-make or pre-built OpenWrt toolchains, take a look at the small scripts I use to make life easier @ https://github.com/mzpqnxow/gdb-7.12-crossbuilder

If you are using hndtools cross-compile toolchain, just use /opt/brcm as they suggest and set your ```PATH``` appropriately (and use the correct ```--host``` value with ```./configure```)

### Removing the need for libraries that are rarely included as static in distributions or toolchains (libthread_db)

Start by removing thread_db support. There is no clean way to do this via a configure option, so just use sed. I recommend you do this step on gdb-7.7.1 and gdb-7.12. This way you can get a statically linked exe without hacking to any more hacky things

```
$ cd gdb-7.12/gdb/gdbserver
$ sed -i -e 's/srv_linux_thread_db=yes//' configure.srv
```

### Do the usual compile, but disable the C++ build system to avoid needing libstdc++.a and other potential complications

While gdb-7.7.1 will use the standard C build process, 7.12 will default to using C++. You can easily turn this off at configure-time, so do it. Add your CFLAGS while you're at it.

```
$ cd gdb-7.12/gdb/gdbserver
$ ./configure --host=whatever --disable-build-with-cxx CFLAGS='-fPIC -static'
```

## Cross-compiling with hndtools-mipsel-3.2.3 or other old MIPSEL toolchains

There are quite a few problems with when trying to build with a *really* old hndtools compiler for MIPSEL. I made a patch to fix the issues, you can find it in this directory. Apply it and build like so to get a statically linked MIPS-I version 1 (SYSV) executable

```
$ tar -xf gdb-7.12.tar.xv
$ cd gdb-7.12
$ patch -p1 < ../gdb-7.12-hndtools-mipsel-3.2.3.patch
$ ./configure --host=whatever --disable-build-with-cxx CFLAGS='-fPIC -static'
$ make -j
$ file gdbserver 
gdbserver: ELF 32-bit LSB executable, MIPS, MIPS-I version 1 (SYSV), statically linked, for GNU/Linux 2.2.15, not stripped
```

Symptoms of needing this patch, in case someone needs to Google:

```
In file included from ../nat/gdb_ptrace.h:36,
                 from ../nat/linux-ptrace.h:23,
                 from linux-low.h:27,
                 from linux-low.c:20:
/opt/brcm/hndtools-mipsel-linux-3.2.3/mipsel-linux/sys-include/sys/ptrace.h:29: parse error before numeric constant
/opt/brcm/hndtools-mipsel-linux-3.2.3/mipsel-linux/sys-include/sys/ptrace.h:40: parse error before numeric constant
/opt/brcm/hndtools-mipsel-linux-3.2.3/mipsel-linux/sys-include/sys/ptrace.h:52: parse error before numeric constant
/opt/brcm/hndtools-mipsel-linux-3.2.3/mipsel-linux/sys-include/sys/ptrace.h:85: parse error before numeric constant
/opt/brcm/hndtools-mipsel-linux-3.2.3/mipsel-linux/sys-include/sys/ptrace.h:103: parse error before numeric constant
In file included from linux-low.h:27,
                 from linux-low.c:20:
../nat/linux-ptrace.h:58:1: warning: "PTRACE_SETOPTIONS" redefined
In file included from /opt/brcm/hndtools-mipsel-linux-3.2.3/mipsel-linux/sys-include/linux/ptrace.h:24,
                 from /opt/brcm/hndtools-mipsel-linux-3.2.3/mipsel-linux/sys-include/asm/user.h:4,
                 from /opt/brcm/hndtools-mipsel-linux-3.2.3/mipsel-linux/sys-include/linux/user.h:1,
                 from /opt/brcm/hndtools-mipsel-linux-3.2.3/mipsel-linux/sys-include/sys/user.h:1,
                 from /opt/brcm/hndtools-mipsel-linux-3.2.3/mipsel-linux/sys-include/sys/procfs.h:31,
                 from /opt/brcm/hndtools-mipsel-linux-3.2.3/mipsel-linux/sys-include/thread_db.h:28,
                 from ../nat/gdb_thread_db.h:22,
                 from linux-low.h:20,
                 from linux-low.c:20:
/opt/brcm/hndtools-mipsel-linux-3.2.3/mipsel-linux/sys-include/asm/ptrace.h:87:1: warning: this is the location of the previous definition
Makefile:263: recipe for target 'linux-low.o' failed
make: *** [linux-low.o] Error 1
```

You will actually encounter quite a few other errors after fixing the immediate issue(s) which is why the patch is so large

## Cross-compiling with gdb-7.12-hndtools-mipsel-linux-uclibc-4.2.3-static.patch

```
$ tar -xf gdb-7.12.tar.xv
$ cd gdb-7.12
$ patch -p1 < ../gdb-7.12-hndtools-mipsel-3.2.3.patch
$ ./configure --host=whatever --disable-build-with-cxx CFLAGS='-fPIC -static'
$ make -j
$ file gdbserver
gdbserver: ELF 32-bit LSB executable, MIPS, MIPS-I version 1 (SYSV), statically linked, for GNU/Linux 2.2.15, not stripped
```

Symptoms of needing this patch, in case someone needs to Google:

```

make[6]: Entering directory '/home/debian/Downloads/gdb-7.12/gdb/gdbserver/build-gnulib-gdbserver/import'
mipsel-linux-uclibc-gcc -DHAVE_CONFIG_H -I. -I../.././../gnulib/import -I..     -fPIC -static -MT mbrtowc.o -MD -MP -MF .deps/mbrtowc.Tpo -c -o mbrtowc.o ../.././../gnulib/import/mbrtowc.c
../.././../gnulib/import/mbrtowc.c: In function 'mbrtowc':
../.././../gnulib/import/mbrtowc.c:125: error: 'MB_CUR_MAX' undeclared (first use in this function)
../.././../gnulib/import/mbrtowc.c:125: error: (Each undeclared identifier is reported only once
../.././../gnulib/import/mbrtowc.c:125: error: for each function it appears in.)
Makefile:1452: recipe for target 'mbrtowc.o' failed
make[6]: *** [mbrtowc.o] Error 1
make[6]: Leaving directory '/home/debian/Downloads/gdb-7.12/gdb/gdbserver/build-gnulib-gdbserver/import'
Makefile:1472: recipe for target 'all-recursive' failed
make[5]: *** [all-recursive] Error 1
make[5]: Leaving directory '/home/debian/Downloads/gdb-7.12/gdb/gdbserver/build-gnulib-gdbserver/import'
Makefile:1354: recipe for target 'all' failed
make[4]: *** [all] Error 2
make[4]: Leaving directory '/home/debian/Downloads/gdb-7.12/gdb/gdbserver/build-gnulib-gdbserver/import'
Makefile:166: recipe for target 'subdir_do' failed
make[3]: *** [subdir_do] Error 1
make[3]: Leaving directory '/home/debian/Downloads/gdb-7.12/gdb/gdbserver/build-gnulib-gdbserver'
Makefile:121: recipe for target 'all' failed
make[2]: *** [all] Error 2
make[2]: Leaving directory '/home/debian/Downloads/gdb-7.12/gdb/gdbserver/build-gnulib-gdbserver'
Makefile:399: recipe for target 'subdir_do' failed
make[1]: *** [subdir_do] Error 1
make[1]: Leaving directory '/home/debian/Downloads/gdb-7.12/gdb/gdbserver'
Makefile:314: recipe for target 'all-lib' failed
make: *** [all-lib] Error 2
```

## Notes on MIPS32Rel2 builds

There is a bug in gdb-7.12 that kills gdbserver on start, this can be fixed at build time by patching the source

```
$ cd gdb-7.12
$ patch -p1 < /path/to/gdb-7.12-mips32rel2-sigprocmask-bug.patch
$ ...
```

The prebuilt gdbserver builds for mips32rel2 are updated with this patch so they should work fine. Note you may need to use ```--disable-packet=threads``` option when starting the gdbserver binary for some builds

