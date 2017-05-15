# embedded-toolkit
Useful executables (statically linked via muslibc or uClibc) for different variants of ARM and MIPS Linux systems (MSB, LSB, different ABIs, etc.) meant for doing low-level work on modern or *ancient* embedded devices

## Intro

I recently needed a statically linked gdbserver for all of the above platforms, as well as some subtle variants- even MIPS-I and ARM with the "old" ABI! It was a little bit painful to build all of them, so I figured I would share them. Please, if you find them useful, take them. They are built from vanilla GDB 7.7.1 sources, with a small tweak to the final linking to get a static build. There was also some hackery required in some cases for unknown reasons, possibly bugs with gdb, to fix up missing #define values and such. Also, when compiling on native architectures, in many cases I had to make sure the GDB build process didn't try to include thread support since there aren't any common packages (I've noticed) that have static libraries for libthread_db and the configure script will enable libthread_db if it detects it on your system

This repository has expanded to include more than gdbserver obviously, but most of the notes here are about gdbserver.

Being added slowly for different CPU architectures with varying instruction sets, byte-order, and ABI. These are mostly untested, so beware. Only gdbserver has been thoroughly tested. You will only find a few different builds of the following tools in this repository

* libpcap (static library)
* tcpdump (statically linked)
* gawk (statically linked)
* lsof (statically linked)
* gdbserv (statically linked)
* tshd (statically linked)

These tools are all of obvious value on embedded devices, except mayhe gawk. Why gawk?

```
$ while [ 1 ];
> do
> /usr/sbin/process/that/forks/and/detaches; sleep 1;./gdbs --attach :12345 $(ps w | grep detache[s] | awk '{print $1}')
> done
```

This is a lot easier than checking the PID after manually restarting the process each time (assuming it is crashing a lot, and it is being analyzed upon each crash remotely.will save a TON of time


## Notes

* Some are linked with glibc or uClibc- this is a problem, moreso for some than others. They are slowly all being built with musl libc to get rid of all the issues with nsswitch.conf libraries.
* There will always be issues with gdbserver needing support for dlopen()/dlsym() but I haven't come across a case where it was actually needed/used, nor have I encountered a crash
* There is no threading support in gdbserver right now, intentionally
* Yes, you have to just trust me on these being 'safe' otherwise you can go build your own :>

## Other targets

If you'd like another target architecture, either file an issue or send a pull request, I'd be happy to have a wider collection of these as I do a fair amount of work on embedded devices and seem to always be coming across ones that I don't already have a build for

## General tips on performing a static build of GDB 7.7.1

Please see https://github.com/mzpqnxow/gdb-7.12-crossbuilder which actually has information and some scripts to build an even more recent version of gdb, version 7.12. It also has some scripts to help you out if you're cross-compiling, which is usually the case with gdbserver, isn't it?
