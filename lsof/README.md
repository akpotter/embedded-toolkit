## Statically linked lsof binaries for ARM and MIPS systems

Note that because of how nsswitch.conf handling is implemented in uClibc and glibc, some things just won't work, YMMV, but I have had these work fine on embedded devices with all sorts of kernel versions. In fact, you're probably more likely to have problems on non-embedded systems because embedded systems might not make use of nsswitch.conf which is the main source of the problem

When running, try:

```
$./lsof -n -P -w
```
