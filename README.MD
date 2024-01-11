Quickly start an Odin project.  
Comes in Odin and Python flavours.  


Odin Version
```
=== Odin Start ===
Quickly start an Odin project.
Help:
  "--" or "-" can be used if desired.
  Required:
    help, h:     Prints this help.
    init, i:     Creates project in current directory.
    new. n <path>: Creates project in given directory.
  Optional:
    file, f [main, ols, mod, readme, license, odinfmt, gitignore, all]:
       Creates given files. Creates main, ols & readme when not used.
    dir, d [bin, src, all]:
       Creates given directories. Creates none when not used.

Examples:
  odin_start init
  odin_start new bean_maker
  odin_start -init --file main ols
  odin_start --new "bean maker" -dir all file main
```

Python Version
```
usage: Odin_Start.py [-h] (-i | -n PATH) [-f {main,ols,odinfmt,mod,readme,license,gitignore,all} [{main,ols,odinfmt,mod,readme,license,gitignore,all} ...]] [-d {bin,src,all} [{bin,src,all} ...]]

Quickly start an Odin project.

options:
  -h, --help            show this help message and exit
  -i, --init            creates project in current directory.
  -n PATH, --new PATH   creates project in given directory.
  -f {main,ols,odinfmt,mod,readme,license,gitignore,all} [{main,ols,odinfmt,mod,readme,license,gitignore,all} ...], --file {main,ols,odinfmt,mod,readme,license,gitignore,all} [{main,ols,odinfmt,mod,readme,license,gitignore,all} ...]
                        creates given files. creates main, ols & readme when not used.
  -d {bin,src,all} [{bin,src,all} ...], --dir {bin,src,all} [{bin,src,all} ...]
                        creates given directories. creates none when not used.
```

Notes:
- If `dir src` is set then `main.odin` will be made in there.

This project is not affiliated with nor endorsed by The Odin Programming Language or The Python Software Foundation & their contibuters.