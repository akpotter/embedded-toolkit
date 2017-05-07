# Statically linked MIPS-I SYSV awk interpreter

## mawk-1.3.4, an alternative to GNU awk

This is a statically compiled executable built by an older toolchain (hndtools-3.2.3/MIPSEL/MIPS-I/SYSV) that was not built to support wide characters. Without wide character support, the GNU interpreter can not be built, so for this specific architecture/ABI, mawk is the alternative. For practically all other architectures, ABIs and byte-orders you should be fine using the statically linked GNU awk interpreters in ```../gawk/```

## Contents

```
mawk-1.3.4-mipsel-i-sysv: ELF 32-bit LSB executable, MIPS, MIPS-I version 1 (SYSV), statically linked
```

## Mawk

Thank you Thomas E. Dickey, the developer of Mawk, and alternative AWK interpreter. The Mawk site is http://invisible-island.net/mawk/mawk.html

## Copyright

Mawk is licensed under the GNU General Public License v2.0


