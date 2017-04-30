## lsof

untar, source the env.src (after updating it to what you need), then run ./Configure. You can try a straight up 'make' command, it may work for you. If you get errors about TCP_SYN_SENT and such, you'll have to copy the enum containing these values from netinet/in.h in the system to dsock.c

Then, make should would fine. After make is successful:

```
rm lsof
V=1 make
```

Copy the last line, the one that builds lsof. Replace the ```-Llib -llsof``` and replace it with ```lib/liblsof.a -static```

You can then run ```file``` on your lsof binary and it should be statically linked in your architecture of choice
