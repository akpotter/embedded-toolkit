# embedded-toolkit
Useful executables (statically linked via muslibc or uClibc) for different variants of ARM and MIPS Linux systems (MSB, LSB, different ABIs including the elusive ARMEL-OABI, etc.) meant for doing low-level work on modern or *ancient* embedded devices (yes, I worked with an ARMEL-OABI system in the year 2017)

## Target OS

Just to be clear: this is Linux OS only stuff. No Solaris, AIX, etc, etc.. the aim was embedded devices, hence the title

## Recursive clone

```git clone --recursive https://github.com/mzpqnxow/embedded-toolkit```

A recursive clone will pull in some toolchain helpers into build-script/ that are otherwise hosted @ ssh://github.com/mzpqnxow/gdb-static-cross

## Intro

I recently needed a statically linked gdbserver for all of the above platforms, as well as some subtle variants- even MIPS-I and ARM with the "old" ABI! It was a little bit painful to build all of them, so I figured I would share them. If you find them useful, use them and let me know if you have issues, especially if you fix said issues. They are built from vanilla GDB 7.7.1 or gdb-7.12 sources, sometimes with patches found at [gdb-static-cross](https://github.com/mzpqnxow/gdb-static-cross) sometimes (rarely) with a small tweak to the final linking to get a static build- which should be an obsolete requirement if you use [gdb-static-cross](https://github.com/mzpqnxow/gdb-static-cross). When compiling on native architectures, in many cases I had to make sure the GDB build process didn't try to include thread support since there aren't any common packages (I've noticed) that have static libraries for libthread_db and the configure script will enable libthread_db if it detects it on your system. This is yet again provided for in [gdb-static-cross](https://github.com/mzpqnxow/gdb-static-cross)

This repository has, since creation, expanded to include more than gdbserver (see [prebuild-static-bins](https://github.com/mzpqnxow/embedded-toolkit/tree/master/prebuilt_static_bins) while the gdbserver specific stuff has been moved to [gdb-static-cross](https://github.com/mzpqnxow/gdb-static-cross)

The following software packages are being added slowly for different CPU architectures with varying instruction sets, byte-order, and ABI. They are all statically linked, meant to run standalone on any Linux system, intended for embedded devices. A small handful are untested so YMMV. Only gdbserver has been thoroughly tested. You will only find a few different builds of the following tools in this repository

* tcpdump (statically linked
* gawk (statically linked)
* lsof (statically linked)
* gdbserv (statically linked)
* tshd (statically linked)
* mawk (statically linked)
* libpcap (static library, used for linking into tcpdump so not present in this repo)

These tools are all of obvious value on embedded devices when doing things like reverse engineering/redteam testing/other low-level fiddling, except maybe gawk. Why gawk?

```
$ while [ 1 ];
> do
> /usr/sbin/process/that/forks/and/detaches; sleep 1;./gdbs --attach :12345 $(ps w | grep detache[s] | awk '{print $1}')
> done
```

This is a lot easier than checking the PID after manually restarting the process each time (assuming it is crashing a lot, and it is being analyzed upon each crash remotely. It's a timesaver.


## Notes

* When possible, these executables were built using musl as libc, but some were built with uClibc
* Some stuff may support or not support something you wanted (i.e. threading, IPv6, etc) and you're just stuck with the judgement call I made at the time :/
* Yes, you have to just trust me on these being 'safe' otherwise you can go build your own - I offer a $500 bug bounty to anyone who can find a backdoor planted by me (seriously, because I'm sure I didn't)

## High level supported targets

At least one of these binaries will work on almost any consumer router or other Linux based embedded device you can find:

* Linksys (err, Cisco)
* NETGEAR
* D-Link
* Asus
* .. etc, etc. .. 

Also the i486 and x86_64 versions will obviously work on commodity Linux workstations and servers

## Other targets

If you'd like another target architecture, either file an issue or send a pull request with your own after you've tested it, I'd be happy to have a wider collection of these as I do a fair amount of work on embedded devices and seem to always be coming across obscure ones that I don't already have a build for.

## General tips on performing a static build of GDB 7.7.1

Please see [gdb-static-cross](https://github.com/mzpqnxow/gdb-static-cross) as it helps to build the most recent version of gdb and contains some scripts to help you out if you're cross-compiling, which is usually the case with gdbserver, isn't it?
