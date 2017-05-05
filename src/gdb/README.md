## Notes for building gdb 7.12 and gdb-7.7.1 statically (especially for cross-compiling)

First of all, just remove thread_db support. There is no clean way to do this via a configure option, so just use sed. I recommend you do this step on gdb-7.7.1 and gdb-7.12

```
$ cd gdb-7.12/gdb/gdbserver
$ sed -i -e 's/srv_linux_thread_db=yes//' configure.srv
```

Next, it might make your life easier to build using C instead of the new C++ build. GDB 7.7.1 will use C but 7.12 will default to C++

```
$ cd gdb-7.12/gdb/gdbserver
$ ./configure --host=whatever --disable-build-with-cxx CFLAGS='-fPIC -static'
```

Take a look at the scripts I use if you are cross-compiling and want to make life easier: https://github.com/mzpqnxow/gdb-7.12-crossbuilder



