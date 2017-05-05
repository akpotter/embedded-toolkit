## Pre-built gdbserver executables for many platforms

These were used mostly on embedded devices. They were tested thoroughly and work very well. Just make sure you use the right one or you will get funny errors or segmentation faults. Note some of these were built with musl but most were built with uClibc (in case you're interested)

## Inventory

```
gdbserver-6.8-mips-i-rtl819x-lexra: ELF 32-bit MSB executable, MIPS, MIPS-I version 1 (SYSV), statically linked
gdbserver-7.12-mipsel-i:            ELF 32-bit LSB executable, MIPS, MIPS-I version 1 (SYSV), statically linked
gdbserver-7.7.1-armel-armv1:        ELF 32-bit LSB executable, ARM, version 1, statically linked
gdbserver-7.7.1-armel-eabi5-sysv:   ELF 32-bit LSB executable, ARM, EABI5 version 1 (SYSV), statically linked
gdbserver-7.7.1-armhf-eabi5-sysv:   ELF 32-bit LSB executable, ARM, EABI5 version 1 (SYSV), statically linked
gdbserver-7.7.1-mipsel-ii:          ELF 32-bit LSB executable, MIPS, MIPS-II version 1, statically linked
gdbserver-7.7.1-mipsel-mips32:      ELF 32-bit LSB executable, MIPS, MIPS32 version 1 (SYSV), statically linked
gdbserver-7.7.1-mips-i:             ELF 32-bit MSB executable, MIPS, MIPS-I version 1 (SYSV), statically linked
gdbserver-7.7.1-mips-ii:            ELF 32-bit MSB executable, MIPS, MIPS-II version 1, statically linked
gdbserver-7.7.1-mips-mips32:        ELF 32-bit MSB executable, MIPS, MIPS32 version 1, statically linked
gdbserver-7.7.1-mips-mips32-sysv:   ELF 32-bit MSB executable, MIPS, MIPS32 version 1 (SYSV), statically linked
```

These are not stripped, go ahead and strip them if you want. And once more, there are now many more than just gdbserver executables in this repository, explore the directory tree

Note the special rtl819x-lexra build. This is a build specific to rtl819x SoC with Lexra CPU. Lexra CPUs are a MIPS-I with some standard MIPS instructions not implemented, specifically unaligned/half-word loads, stores, shifts. Silly. Thanks to https://github.com/KrabbyPatty/rtl819x-toolchain for making a toolchain available to build this specific binary. I was unable to get gdb 7.7.1 to build, so it is version 6.8.

## Other options

If you want to build your own gdbserver from some toolchain of your own, take a look at my other repo @ https://github.com/mzpqnxow/gdb-7.12-crossbuilder as it may save you an hour or two of toiling with gdb, which doesn't have a straightforward README or configure option to produce a statically linked gdbserver
