`srdokun` is a self-running [Lua](https://www.lua.org/) interpreter. It is meant to be combined with
a Lua program into a single, stand-alone program that  will execute the given Lua program when it is run.

# Building srdokun:
Requires <a href="https://cmake.org/download/">CMake</a> and a C++11 compiler.
```sh
$ cmake -G"... Makefiles"
$ make
```

# Usage:
```sh
$ ./glue ./srlua test.lua test    # compiles into an executable
```
```sh
$ ./test    # opens the executable
```

This software uses the source from [srlua](http://webserver2.tecgraf.puc-rio.br/~lhf/ftp/lua/ar/) .
