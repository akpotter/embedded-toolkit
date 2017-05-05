# --- Specific to tcpdump

Make sure libpcap.a has already been built and installed into your root. Edit the env.src file to match your configuration. Then the usual

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
