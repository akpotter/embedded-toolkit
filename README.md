# static-gdbserver-embedded
Prebuilt gdbserver executables for ARMEL, ARMHF, MIPSEL and MIPS platforms for Linux

## Intro

I recently needed a statically linked gdbserver for all of the above platforms. It was a little bit painful to build all of them, so I figured I would share them. Please, if you find them useful, take them. They are built from vanilla GDB 7.7.1 sources, with a small tweak to the final Makefile to get static builds. There was also some hackery required to make sure it didn't try to include thread support since there aren't any common packages (I've noticed) that have static libraries for libthread_db and the configure script will enable libthread_db if it detects it on your system

## Notes

* These are statically linked with libdl.a but obviously libdl doesn't function on statically linked executables. I haven't run into any issues with it though, I haven't looked into what gdbserver would use libdl for. 
* There is no threading support
* Yes, you have to just trust me on these being 'safe' otherwise you can go build your own :>

## Other targets

If you'd like another target architecture, either file an issue or send a pull request

