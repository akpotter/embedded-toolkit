## Statically linked lsof binaries for ARM and MIPS systems

You may have issues with those versions not built with musl libc since their nsswitch libraries can't be statically linked. You might get away with running lsof as follows to suppress using /etc/hosts or /etc/services file:

```
$./lsof -n -P -w
```

For the musl libc statically compiled executables, there should be no problems so long as you have the right architecture
