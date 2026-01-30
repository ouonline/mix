`Mix` is a dynamic typed programming language, with interesting features from C, C++, and Lua. That's why it was named `Mix`. It's goal is to become an extensible and embeddable scripting language, and also a general purpose programming language if possible.

#build

```bash
mkdir build
cmake -B build -DMIX_DEPS_DIR=$PWD/deps
cmake --build build -j`nproc`
```

### TODO list

* hex/oct number format support
* documentation and tutorial
* coroutine
* emacs/vim syntax support
