## lsof

See env.src for an example of how to set up lsof for cross-compilation

## Basic steps after sourcing env.src

```
$ vi env.src
... plug in appropriate values ...
$ source env.src
$ tar -xvf lsof_4.89_src.tar
$ cd lsof_4.89_src
$ patch -p1 < lsof_4.89_src-hndtools-mipsel-linux-3.2.3.patch # optional obviously
$ ./Configure linux
... choose to customize, but don't take inventory ...
... turn off warnings, runtime kernel check ...
... accept other defaults ...
$ make -j
```

It is important that you follow env.src if you want a cross-compile and/or statically linked executable
