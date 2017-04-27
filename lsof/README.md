## Statically linked lsof binaries for ARM and MIPS systems

Note that because of how nsswitch.conf handling is implemented in uClibc and glibc, some things just won't work

When running, try:

```
$./lsof -n -P -w
```
