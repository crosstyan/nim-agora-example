# Nim bindings for Agora RTSA

- [Nim Tutorial ](https://nim-lang.org/docs/tut1.html)
- [Nim Compiler User Guide](https://nim-lang.org/docs/nimc.html)
- [Nimble](https://github.com/nim-lang/nimble)
- [Leran Nim in Y minutes](https://learnxinyminutes.com/docs/nim/)
- [Dynlib pragma for import](https://nim-lang.org/docs/manual.html#foreign-function-interface-dynlib-pragma-for-import)
- [Loading a simple C function](https://nim-lang.org/docs/dynlib.html#examples-loading-a-simple-c-function)

```bash
nimble refresh
nimble install
nimble run
```

This project use [nimterop](https://github.com/nimterop/nimterop) to generate the bindings.
Check `generate.nim` for more infomation. Please also see [the comment of cImport macro](https://github.com/nimterop/nimterop/blob/bf088be9e925fb16d664d092afad4ab6019a78c7/nimterop/cimport.nim#L652-L703).

This example also use [gintro](https://github.com/StefanSalewski/gintro) as [gstreamer](https://gstreamer.freedesktop.org)'s bindings.
Maybe try to install the full [libgtk-4-dev](https://packages.debian.org/unstable/libgtk-4-dev).

*NOTE* When you try to generate/install gintro, if you're running in an
environment where no display installed (like Docker container or Raspberry),
the generation will not work.
[`gtk4Init()`](https://github.com/StefanSalewski/gintro/blob/0a6bbb59ebbae5da0d53009b2dcc7ced46b3b9d0/tests/gen.nim#L184)
cause this problem so you have to comment out it.

use `gen.sh` or `gen_toast.sh` to generate the bindings to `src/agora.nim`.
NOTE: I have manually modify the bindings by hands, so if you regenerate the bindings
the modification will be overrided. Check the git commit logs to see what I have done.

https://github.com/nim-lang/nimble/issues/221
