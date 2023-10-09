Quickly start an Odin project.  
Comes as an Odin and Python flavours.  


Odin Version
```
=== Odin Start ===
Quickly start an Odin project.
Help:
  "--" or "-" can be used if desired.
  Required:
    help, h:       Prints this help.
    init, i:       Creates project in current directory.
    new, n <path>: Creates project in given directory.
  Optional:
    file, f [main, osl, odinfmt, mod, all]: Creates given files. Creates all when not used.
    dir, d [bin, src, all]:          Creates given directories. Creates none when not used.

Examples:
  odin_start init
  odin_start new bean_maker
  odin_start -init file main osl
  odin_start --new "bean maker" dir all file main
```

Python Version
```
usage: Odin Start [-h] (-i | -n PATH) [-f {main,osl,odinfmt,mod,all} [{main,osl,odinfmt,mod,all} ...]] [-d {bin,src,all} [{bin,src,all} ...]]

Quickly start a Odin project.

options:
  -h, --help            show this help message and exit
  -i, --init            Creates project in current directory.
  -n PATH, --new PATH   Creates project in given directory.
  -f {main,osl,odinfmt,mod,all} [{main,osl,odinfmt,mod,all} ...], --file {main,osl,odinfmt,mod,all} [{main,osl,odinfmt,mod,all} ...]
                        Creates given files. Creates all when not used.
  -d {bin,src,all} [{bin,src,all} ...], --dir {bin,src,all} [{bin,src,all} ...]
                        Creates given directories. Creates none when not used.
```

Notes:
- If `dir src` is set then `main.odin` will be made there.