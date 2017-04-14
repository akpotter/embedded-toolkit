# static-gdbserver-embedded
Prebuilt gdbserver executables for ARMEL, ARMHF, MIPSEL and MIPS platforms for Linux

## Intro

I recently needed a statically linked gdbserver for all of the above platforms, as well as some subtle variants. It was a little bit painful to build all of them, so I figured I would share them. Please, if you find them useful, take them. They are built from vanilla GDB 7.7.1 sources, with a small tweak to the final linking to get a static build. There was also some hackery required in some cases for unknown reasons, possibly bugs with gdb, to fix up missing #define values and such. Also, when compiling on native architectures, in many cases I had to make sure the GDB build process didn't try to include thread support since there aren't any common packages (I've noticed) that have static libraries for libthread_db and the configure script will enable libthread_db if it detects it on your system

## Notes

* These are statically linked with libdl.a but obviously libdl doesn't function on statically linked executables. I haven't run into any issues with it though, I haven't looked into what gdbserver would use libdl for. 
* There is no threading support
* Yes, you have to just trust me on these being 'safe' otherwise you can go build your own :>

## More detailed information on the build targets

I didn't keep very good documentation as a built all of these, I can't even tell you for sure which --target parameter I used. I tried to name each binary intuitively and as correctly as I could but here is a quick summary of each based on output from file(1)

```
gdbserver-7.7.1-armel:              ELF 32-bit LSB executable, ARM, version 1, statically linked, for GNU/Linux 2.4.3
gdbserver-7.7.1-armel-eabi5-sysv:   ELF 32-bit LSB executable, ARM, EABI5 version 1 (SYSV), statically linked, for GNU/Linux 2.6.26
gdbserver-7.7.1-armhf-eabi5-sysv:   ELF 32-bit LSB executable, ARM, EABI5 version 1 (SYSV), statically linked, for GNU/Linux 2.6.26
gdbserver-7.7.1-mipsel-mips32:      ELF 32-bit LSB executable, MIPS, MIPS32 version 1 (SYSV), statically linked
gdbserver-7.7.1-mipsel-ii:          ELF 32-bit LSB executable, MIPS, MIPS-II version 1, statically linked, for GNU/Linux 2.6.26
gdbserver-7.7.1-mips-ii:            ELF 32-bit MSB executable, MIPS, MIPS-II version 1, statically linked, for GNU/Linux 2.6.26
gdbserver-7.7.1-mips-mips32:        ELF 32-bit MSB executable, MIPS, MIPS32 version 1, statically linked, for GNU/Linux 2.6.26
gdbserver-7.7.1-mips-i:             ELF 32-bit MSB executable, MIPS, MIPS-I version 1 (SYSV), statically linked, not stripped
gdbserver-6.8-mips-i-rtl819x-lexra: ELF 32-bit MSB executable, MIPS, MIPS-I version 1 (SYSV), statically linked, not stripped

```

These are not stripped, go ahead and strip them if you want

Note the special rtl819x-lexra build. This is a build specific to rtl819x SoC with Lexra CPU. Lexra CPUs are a MIPS-I with some instructions not implemented (unaligned loads, stores, shifts)

Thanks to https://github.com/KrabbyPatty/rtl819x-toolchain for making a toolchain available to build this. I was unable to get gdb 7.7.1 to build, so it is version 6.8.

## Other targets

If you'd like another target architecture, either file an issue or send a pull request, I'd be happy to have a wider collection of these as I do a fair amount of work on embedded devices and seem to always be coming across ones that I don't already have a build for

## General tips on performing a static build of GDB 7.7.1

There is no supported what that I have found to to a static build of GDB 7.7.1. So I have my own routine. It is roughly like this:

```
$ export TARGET=mipsel-unknown-linux-uclibc
$ tar xzf gdb-7.7.1.tar.gz
$ cd gdb-7.7.1/gdb/gdbserver
$ ./configure --host=$TARGET
$ make -j
... usually, something superficial fails, like some #define is missing, etc ...
$ find ~/ -name \*.h -exec grep -Hn SOME_DEFINE {} \;
bah.h: #define SOME_DEFINE 12345
... add the #define into the source file that was complaining ...
$ make -j
... build is successful ...
$ rm gdbserver
$ V=1 make
... observer the final command to link gdbserver and copy it into your terminal ...
... remove the -ldl at the end and replace it with the path to libdl.a for the target architecture ...
... add -static as a flag and run the command ...
... see example below ...
$ ls gdbserver
... you have gdbserver, huzzah ...
```

### Example of fixing the final gcc command 

When you do rm gdbserver; V=1 make, here is an example of the before and after command:

#### Before

```
mipsel-linux-uclibc-gcc -g -O2    -I. -I. -I./../common -I./../regformats -I./.. -I./../../include -I./../gnulib/import -Ibuild-gnulib-gdbserver/import -Wall -Wdeclaration-after-statement -Wpointer-arith -Wformat-nonliteral -Wno-char-subscripts -Werror -DGDBSERVER  -rdynamic -o gdbserver agent.o ax.o inferiors.o regcache.o remote-utils.o server.o signals.o target.o waitstatus.o utils.o version.o vec.o gdb_vecs.o mem-break.o hostio.o event-loop.o tracepoint.o xml-utils.o common-utils.o ptid.o buffer.o format.o filestuff.o dll.o notif.o tdesc.o xml-builtin.o mips-linux.o mips-dsp-linux.o mips64-linux.o mips64-dsp-linux.o linux-low.o linux-osdata.o linux-procfs.o linux-ptrace.o linux-waitpid.o linux-mips-low.o mips-linux-watch.o hostio-errno.o thread-db.o proc-service.o build-gnulib-gdbserver/import/libgnu.a -ldl
```

#### After

```
mipsel-linux-uclibc-gcc -g -O2    -I. -I. -I./../common -I./../regformats -I./.. -I./../../include -I./../gnulib/import -Ibuild-gnulib-gdbserver/import -Wall -Wdeclaration-after-statement -Wpointer-arith -Wformat-nonliteral -Wno-char-subscripts -Werror -DGDBSERVER  -rdynamic -o gdbserver agent.o ax.o inferiors.o regcache.o remote-utils.o server.o signals.o target.o waitstatus.o utils.o version.o vec.o gdb_vecs.o mem-break.o hostio.o event-loop.o tracepoint.o xml-utils.o common-utils.o ptid.o buffer.o format.o filestuff.o dll.o notif.o tdesc.o xml-builtin.o mips-linux.o mips-dsp-linux.o mips64-linux.o mips64-dsp-linux.o linux-low.o linux-osdata.o linux-procfs.o linux-ptrace.o linux-waitpid.o linux-mips-low.o mips-linux-watch.o hostio-errno.o thread-db.o proc-service.o build-gnulib-gdbserver/import/libgnu.a /projects/hnd/tools/linux/hndtools-mipsel-linux-uclibc-4.2.3/lib/libdl.a -static
```

As stated above, the only difference is the '-ldl' has been swapped out with /projects/hnd/tools/linux/hndtools-mipsel-linux-uclibc-4.2.3/lib/libdl.a and the -static option has been added

### Building on a native MIPS Linux qemu image

I noticed that when using an actual MIPS archtecture OS to perform this build, I ran into issues with libthread_db when trying to statically link. Debian does not include a copy of this library and none of the options that seemed like they were supposed to disable threading worked. So my workaround was to "hide" the libthread_db related files before running the configure command. You can do this easily with find

WARNING: THIS IS A DANGEROUS COMMAND IF YOU DON'T KNOW WHAT YOU ARE DOING! IT IS ALMOST CERTAINLY A BETTER IDEA TO PATCH GDB CONFIGURE OR MAKEFILE FILES!

```
find / -name libthread_db\* -exec mv {} {}.bak \;
```
#### How do I know these binaries aren't backdoored?

They aren't. But you'll have to trust me on that unless you want to figure out how to build them yourself. It's not the most trivial thing to document and I don't really have the time if I wanted to
