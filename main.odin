/**************************************************
* License At Bottem
* Copyright (c) 2023 blob1807. All rights reserved.
***************************************************/
package odinstart

import "core:fmt"
import "core:os"
import str "core:strings"
import fp "core:path/filepath"

MOD_PKG: string: 
"{\n"+
"    \"version\": \"\", \n"+
"    \"description\": \"\", \n"+
"    \"url\": \"\", \n"+
"    \"readme\": \"\", \n"+
"    \"license\": \"\", \n"+
"    \"keywords\": [\"\"], \n"+
"    \"dependencies\": {\"\":\"\"} \n"+
"}\n"

OSL_JSON: string: 
"{{\n"+
"    \"$schema\": \"https://raw.githubusercontent.com/DanielGavin/ols/master/misc/ols.schema.json\",\n"+
"    \"collections\": [\n"+
"        {{\n"+
"            \"name\": \"core\",\n"+
"            \"path\": \"{0}core\"\n"+
"        }},\n"+
"        {{\n"+
"            \"name\": \"vendor\",\n"+
"            \"path\": \"{0}vendor\"\n"+
"        }}\n"+
"    ],\n"+
"    \"enable_document_symbols\": true,\n"+
"    \"enable_semantic_tokens\": false,\n"+
"    \"enable_hover\": true,\n"+
"    \"enable_snippets\": true\n"+
"}}\n"

ODINFMT_JSON: string: 
"{ \n"+
"    \"$schema\": \"https://raw.githubusercontent.com/DanielGavin/ols/master/misc/odinfmt.schema.json\",\n "+
"    \"character_width\": 100, \n"+
"    \"spaces\": 4, \n"+
"    \"newline_limit\": 2, \n"+
"    \"tabs\": true, \n"+
"    \"tabs_width\": 4, \n"+
"    \"convert_do\": false, \n"+
"    \"exp_multiline_composite_literals\": false, \n"+
"    \"brace_style\": \"_1TBS\", \n"+
"    \"indent_cases\": false, \n"+
"    \"newline_style\": \"CRLF\" \n"+
"} \n"

MAIN_ODIN: string: 
"package {0}\n \n"+
"import \"core:fmt\"\n \n" +
"main :: proc() {{ \n"+
"    fmt.println(\"Hellope\") \n"+
"}} \n"

HELP ::
"=== Odin Start ===\n"+
"Quickly start an Odin project.\n"+
"Help:\n"+
"  \"--\" or \"-\" can be used if desired.\n"+
"  Required:\n"+
"    help, h:     Prints this help.\n"+
"    init, i:     Creates project in current directory.\n"+
"    new. n <path>: Creates project in given directory.\n"+
"  Optional:\n"+
"    file, f [main, osl, odinfmt, mod, all]: Creates given files. Creates all when not used.\n"+
"    dir, d [bin, src, all]:          Creates given directories. Creates none when not used.\n\n"+
"Examples:\n"+
"  {0} init\n"+
"  {0} new bean_maker\n"+
"  {0} -init file main osl\n"+
"  {0} --new \"bean maker\" dir all file main\n"

Files :: bit_set[enum{Main, Osl, Odinfmt, Mod, All}]
Dirs :: bit_set[enum{Bin, Src, All}]

main :: proc() {
    assert(len(os.args) > 0, "Executable path wasn't passed by OS.")
    assert(len(os.args) < 9, "To many arguments were given.")

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
            setup = true
            i += 2

        case "file", "f":
            if file_set {
                fmt.eprintln("You've already selected your files to write.\n")
                os.exit(1)
            }
            for a in os.args[i+1:] {
                i += 1
                switch a {
                case "mod", "mod.pkg"         : files += {.Mod}
                case "main", "main.odin"      : files += {.Main}
                case "osl", "osl.json"        : files += {.Osl}
                case "odinfmt", "odinfmt.json": files += {.Odinfmt}
                case "all": files = {.Main, .Osl, .Odinfmt, .Mod}; break
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
    if !file_set do files = {.Main, .Osl, .Odinfmt, .Mod}

    os.make_directory(pkg_dir)
    os.set_current_directory(pkg_dir)

    w_ok: bool
    pkg_name := fp.base(pkg_dir)
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
            w_ok = os.write_entire_file(file_name, transmute([]byte)file)
        }
        if !w_ok do fmt.eprintln("Unable to write \"main.odin\" in", cur_dir)
    }
    if .Osl in files {
        root, _ := fp.to_slash(ODIN_ROOT)
        root, _ = str.replace_all(root, "/", "//")
        root, _ = fp.from_slash(root)
        file := fmt.aprintf(OSL_JSON, root)

        w_ok = os.write_entire_file("osl.json", transmute([]byte)file)
        if !w_ok do fmt.eprintln("Unable to write \"osl.json\" in", cur_dir)
    }
    if .Odinfmt in files {
        w_ok = os.write_entire_file("odinfmt.json", transmute([]byte)ODINFMT_JSON)
        if !w_ok do fmt.eprintln("Unable to write \"odinfmt.json\" in", cur_dir)
    }
    if .Mod in files {
        w_ok = os.write_entire_file("mod.pkg", transmute([]byte)MOD_PKG)
        if !w_ok do fmt.eprintln("Unable to write \"mod.pkg\" in", cur_dir)
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
*
*****************************************************************************/