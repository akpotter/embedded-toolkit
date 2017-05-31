## Static Build Scripts / Toolchain Helpers



Please see my small project @ [gdb-static-cross](https://github.com/mzpqnxow/gdb-static-cross), specifically the "activate" scripts which are named with a ".env" suffix. The gdb-7.12-crossbuilder repository includes several "activate" scripts that can be used to help set up your environment when cross-compiling things statically. It is not only useful for gdb, it can be used with any cross-compile toolchain. It will set up basic things like your target and ```PATH``` and it will also define a few useful things, like the path to common static libraries you will need when statically linking various applications. Optionally, see the env.src scripts that can be sourced in your shell, or just read for guidance on how to easily statically link each of various tools (gawk, gdb, libpcap, tcpdump, lsof, mawk, tsh, tshd) using any toolchain. There are also some patches as many software packages are not properly QA'd for cross-compiling or compiling *at all* on obscure architectures like MIPS-I or ARM-OABI. Optionally, when cloning this repository, use --recursive and it will pull that repository into this directory

## License

This software is released by copyright@mzpqnxow.com under terms of the GPLv2
Please see LICENSE or LICENSE.md in the root of this repository for more information on GPLv2
