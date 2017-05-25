## Statically linking gawk

Note your toolchain *must* have wchar.h (wide character support) to build gawk. If you find yourself in the awkward (no pun intended) situation of needing an AWK interpreter without a toolchain with wide character support, you can use [http://invisible-island.net/mawk/mawk.html](mawk), which is included in this repository as well. Also note that the mawk configure script seems to not correctly pick up the correct include directory when cross-compiling so you'll have to pass it as a ```CFLAG``` using -I'

### Building

Proceed as usual (assuming you sourced the [activate-script-helpers](https://github.com/mzpqnxow/gdb-static-cross/tree/master/activate-script-helpers) script appropriate for your toolchain)

```
$ source env.src
$ tar -xvzf gawk-4.1.4
$ cd gawk-4.1.4
$ ./configure --prefix=$ROOT --host=$TARGET_HOST CFLAGS="$CFLAGS"
$ make -j && make install
```

You should have a statically library for gawk for your toolchain's architecture architecture, confirm with:

```
$ file gawk
gawk: ELF 32-bit MSB executable, MIPS, MIPS32 rel2 version 1, statically linked
```