## Statically linking gawk

Note your toolchain *must* have wchar.h (wide character support) to build gawk. Also note that the configure script seems to not correctly pick up the correct include directory when cross-compiling so you'll have to pass it as a ```CFLAG``` using -I'
