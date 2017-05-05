## Static Build Scripts / Toolchain Helpers

Please see my small project @ https://github.com/mzpqnxow/gdb-7.12-crossbuilder, specifically the "activate" scripts which are named with a ".env" suffix. The gdb-7.12-crossbuilder repository includes several "activate" scripts that can be used to help set up your environment when cross-compiling things statically. It is not only useful for gdb, it can be used with any cross-compile toolchain. It will set up basic things like your target and ```PATH``` and it will also define a few useful things, like the path to common static libraries you will need when statically linking various applications.

## License

This software is released by copyright@mzpqnxow.com under terms of the GPLv2
Please see LICENSE or LICENSE.md for more information on GPLv2
