/**************************************************
* License At Bottem
* Copyright (c) 2023 blob1807. All rights reserved.
***************************************************/
package odinstart

import "core:fmt"
import "core:os"
import str "core:strings"
import fp "core:path/filepath"

MOD_PKG: string: `{
    "version": "", 
    "description": "", 
    "url": "", 
    "readme": "", 
    "license": "", 
    "keywords": [""], 
    "dependencies": {"":""} 
}
`

OLS_JSON: string: `{{
    "$schema": "https://raw.githubusercontent.com/DanielGavin/ols/master/misc/ols.schema.json", 
    "collections": [ 
        {{ 
            "name": "core", 
            "path": "{0}core" 
        }}, 
    ], 
    "enable_document_symbols": true, 
    "enable_semantic_tokens": false, 
    "enable_hover": true, 
    "enable_snippets": true 
}}
`

ODINFMT_JSON: string: `{ 
    "$schema": "https://raw.githubusercontent.com/DanielGavin/ols/master/misc/odinfmt.schema.json", 
    "character_width": 100, 
    "spaces": 4, 
    "newline_limit": 2, 
    "tabs": true, 
    "tabs_width": 4, 
    "convert_do": false, 
    "exp_multiline_composite_literals": false, 
    "brace_style": "_1TBS", 
    "indent_cases": false, 
    "newline_style": "CRLF" 
}
`

MAIN_ODIN: string: 
`package {0} 
import "core:fmt"

main :: proc() {{ 
    fmt.println("Hellope") 
}}
`

README_MD: string :`# {0}
A cool thing that's going to change to world.
`

HELP :: `=== Odin Start ===
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
  {0} init 
  {0} new bean_maker 
  {0} -init --file main ols 
  {0} --new "bean maker" -dir all file main
`

Files :: bit_set[enum{Main, Ols, Odinfmt, Mod, Readme, License, Gitignore, All}]
Dirs :: bit_set[enum{Bin, Src, All}]

main :: proc() {
    assert(len(os.args) > 0, "Executable path wasn't passed by OS.")
    assert(len(os.args) < 14, "To many arguments were given.")

    help := fmt.aprintf(HELP, fp.short_stem(fp.base(os.args[0])))

    if len(os.args) == 1 {
        fmt.println(help)
        return
    }

    pkg_dir, arg: string
    setup, file_set, dir_set: bool
    files: Files
    dirs: Dirs

    for i:=1; i < len(os.args); {
        arg = str.trim_left(os.args[i], "-")
        switch arg {
        case "help", "h": 
            fmt.println(help)
            return

        case "init", "i":
            if setup {
                fmt.eprintln("\"new\" or \"init\" has already been provided\n")
                os.exit(1)
            }
            pkg_dir = os.get_current_directory()
            setup = true
            i += 1

        case "new", "n":
            if setup {
                fmt.eprintln("\"new\" or \"init\" has already been provided\n")
                os.exit(1)
            }
            if len(os.args) == i+1 {
                fmt.eprintln("No path was provided\n")
                os.exit(1)
            }
            pkg_dir = fp.clean(os.args[i+1])
            os.make_directory(pkg_dir)
            os.set_current_directory(pkg_dir)
            setup = true
            i += 2

        case "file", "f":
            if file_set {
                fmt.eprintln("You've already selected your files to write.\n")
                os.exit(1)
            }
            for a in os.args[i+1:] {
                i += 1
                s, _ := str.to_lower(a)
                switch s {
                case "mod", "mod.pkg"         : files += {.Mod}
                case "main", "main.odin"      : files += {.Main}
                case "osl", "osl.json"        : files += {.Ols}
                case "odinfmt", "odinfmt.json": files += {.Odinfmt}
                case "readme", "readme.md"    : files += {.Readme}
                case "license"                : files += {.License}
                case "gitignore", ".gitignore": files += {.Gitignore}
                case "all": files = {.Main, .Ols, .Odinfmt, .Mod, .Readme, .License, .Gitignore}; break
                case: i-=1; break
                }
            }
            if files == {} {
                fmt.eprintln("No files were given.\n")
                os.exit(1)
            }
            file_set = true
            i += 1

        case "dir", "d":
            if dir_set {
                fmt.eprintln("You've already selected your directories to make.\n")
                os.exit(1)
            }
            for a in os.args[i+1:] {
                i+=1
                switch a {
                case "bin": dirs += {.Bin}
                case "src": dirs += {.Src}
                case "all": dirs = {.Bin, .Src}; break
                case: i-=1; break
                }
            }
            if dirs == {} {
                fmt.eprintln("No directories were given.\n")
                os.exit(1)
            }
            dir_set = true
            i += 1
        case: 
            fmt.eprintf("Argument \"{0}\" isn't a valid argument.\n", arg)
            os.exit(1)
        }
    }

    if !setup {
        fmt.eprintf("You need to provide \"init\" or \"new\".\n\n")
        os.exit(1)
    }
    if !file_set do files = {.Main, .Ols, .Readme}

    w_ok: bool
    pkg_name, _ := str.replace_all(fp.base(pkg_dir), " ", "_")
    pkg_name, _ = str.replace_all(pkg_name, "-", "_")
    cur_dir := os.get_current_directory()
    file_name: string

    if .Bin in dirs do os.make_directory("bin")
    if .Src in dirs do os.make_directory("src")

    if .Main in files {
        file := fmt.aprintf(MAIN_ODIN, str.to_lower(pkg_name))
        if .Src in dirs {
            file_name, _ = fp.from_slash("src/main.odin")
            w_ok = os.write_entire_file(file_name, transmute([]byte)file)
        } else {
            w_ok = os.write_entire_file("main.odin", transmute([]byte)file)
        }
        if !w_ok do fmt.eprintln("Unable to write \"main.odin\" in", cur_dir)
    }
    if .Ols in files {
        root, _ := fp.to_slash(ODIN_ROOT)
        root, _ = str.replace_all(root, "/", "//")
        root, _ = fp.from_slash(root)
        file := fmt.aprintf(OLS_JSON, root)

        w_ok = os.write_entire_file("ols.json", transmute([]byte)file)
        if !w_ok do fmt.eprintln("Unable to write \"ols.json\" in", cur_dir)
    }
    if .Odinfmt in files {
        w_ok = os.write_entire_file("odinfmt.json", transmute([]byte)ODINFMT_JSON)
        if !w_ok do fmt.eprintln("Unable to write \"odinfmt.json\" in", cur_dir)
    }
    if .Mod in files {
        w_ok = os.write_entire_file("mod.pkg", transmute([]byte)MOD_PKG)
        if !w_ok do fmt.eprintln("Unable to write \"mod.pkg\" in", cur_dir)
    }
    if .Readme in files {
        file := fmt.aprintf(README_MD, str.to_lower(pkg_name))
        w_ok = os.write_entire_file("README.MD", transmute([]byte)file)
        if !w_ok do fmt.eprintln("Unable to write \"README.MD\" in", cur_dir)
    }
    if .License in files {
        t: []byte
        w_ok = os.write_entire_file("LICENSE", t)
        if !w_ok do fmt.eprintln("Unable to write \"LICENSE\" in", cur_dir)
    }
    if .Gitignore in files {
        t: []byte
        w_ok = os.write_entire_file(".gitignore", t)
        if !w_ok do fmt.eprintln("Unable to write \".gitignore\" in", cur_dir)
    }

    fmt.printf("Project \"{0}\" created in {1}", pkg_name, cur_dir)
    return
}

/****************************************************************************
* LICENSE: BSD-3-Clause
*
* Copyright (c) 2023 blob1807. All rights reserved.
*
* Redistribution and use in source and binary forms, with or without
* modification, are permitted provided that the following conditions are met:
*
* 1. Redistributions of source code must retain the above copyright notice, this
*    list of conditions and the following disclaimer.
*
* 2. Redistributions in binary form must reproduce the above copyright notice,
*    this list of conditions and the following disclaimer in the documentation
*    and/or other materials provided with the distribution.
*
* 3. Neither the name of the copyright holder nor the names of its
*    contributors may be used to endorse or promote products derived from
*    this software without specific prior written permission.
*
* THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
* AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
* IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
* DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
* FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
* DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
* SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
* CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
* OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
* OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*****************************************************************************/