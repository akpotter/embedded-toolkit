## Statically linking gawk

Note your toolchain *must* have wchar.h (wide character support) to build gawk. If you find yourself in the awkward situation of needing an AWK interpreter but do not have wide character support in your toolchain, you can use mawk, which is included in this repository as well. Also note that the configure script seems to not correctly pick up the correct include directory when cross-compiling so you'll have to pass it as a ```CFLAG``` using -I'
