# --- Specific to tcpdump

Make sure libpcap.a has already been built statically and installed into your root. Edit the env.src file to match your configuration. Then proceed as normal (assuming you sourced the [activate-script-helpers](https://github.com/mzpqnxow/gdb-static-cross/tree/master/activate-script-helpers) script appropriate for your toolchain)

```
$ source env.src
$ tar -xvzf tcpdump-4.9.0.tar.gz
$ cd tcpdump-4.9.0
$ ./configure --prefix=$ROOT --host=$TARGET_HOST CFLAGS="$CFLAGS"
$ make -j
```

You shoudl have a statically linked tcpdump for that architecture, confirm with:

```
$ file tcpdump
tcpdump: ELF 32-bit LSB executable, MIPS, MIPS-I version 1 (SYSV), statically linked, for GNU/Linux 2.2.15, not stripped
```
