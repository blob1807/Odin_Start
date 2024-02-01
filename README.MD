# Odin Start (ostart)

Quickly start an Odin project.  
Comes in Odin and Python flavours.  


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
    file, f [main, ols, mod, readme, license, odinfmt, gitignore, all]:
       Creates given files. Creates main, ols & readme when not used.
    dir, d [bin, src, all]:
       Creates given directories. Creates none when not used.
    license, l <path> or <file name>
       Looks for a license at the path or a file in Odin_Start's dir.
       Looks for a 'LICENSE' file, if nothing is provided.
       Then addes it to the 'license' file. Does nothing if not used.

Examples:
  ostart init
  ostart new bean_maker
  ostart -init --file main ols
  ostart --new "bean maker" -dir all file main
  ostart i license bsd3.txt
  ostart n "cakes" f license main l
```

Python Version
```
usage: Odin_Start.py [-h] (-i | -n PATH) [-f {main,ols,odinfmt,mod,readme,license,gitignore,all} [{main,ols,odinfmt,mod,readme,license,gitignore,all} ...]] [-d {bin,src,all} [{bin,src,all} ...]] [-l [PATH or FILE]]

Quickly start an Odin project.

options:
  -h, --help            show this help message and exit
  -i, --init            creates project in current directory.
  -n PATH, --new PATH   creates project in given directory.
  -f {main,ols,odinfmt,mod,readme,license,gitignore,all} [{main,ols,odinfmt,mod,readme,license,gitignore,all} ...], --file {main,ols,odinfmt,mod,readme,license,gitignore,all} [{main,ols,odinfmt,mod,readme,license,gitignore,all} ...]
                        creates given files. creates main, ols & readme when not used.
  -d {bin,src,all} [{bin,src,all} ...], --dir {bin,src,all} [{bin,src,all} ...]
                        creates given directories. creates none when not used.
  -l [PATH or FILE], --license [PATH or FILE]
                        looks for a license at the path or a file in ostart's dir. looks for a 'LICENSE' file, if nothing is provided. then addes it to the 'license' file. does nothing if not used.
```

Notes:
- If `--dir src` is set then `main.odin` will be made in there.

This project is not affiliated with nor endorsed by The Odin Programming Language or The Python Software Foundation & their contibuters.