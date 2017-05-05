## Notes for building gdb 7.12 and gdb-7.7.1 statically (especially for cross-compiling)

First of all, just remove thread_db support. There is no clean way to do this via a configure option, so just use sed. I recommend you do this step on gdb-7.7.1 and gdb-7.12

```
$ cd gdb-7.12/gdb/gdbserver
$ sed -i -e 's/srv_linux_thread_db=yes//' configure.srv
```

Next, it might make your life easier to build using C instead of the new C++ build. GDB 7.7.1 will use C but 7.12 will default to C++

```
$ cd gdb-7.12/gdb/gdbserver
$ ./configure --host=whatever --disable-build-with-cxx CFLAGS='-fPIC -static'
```

Take a look at the scripts I use if you are cross-compiling and want to make life easier: https://github.com/mzpqnxow/gdb-7.12-crossbuilder

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

## Cross-compiling with hndtools-mipsel-uclibc-4.2.4


