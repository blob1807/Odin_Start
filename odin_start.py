"""
**************************************************
* License At Bottom
* Copyright (c) 2023 blob1807. All rights reserved.
***************************************************
"""
import argparse, os, sys, platform
from pathlib import Path


MOD_PKG = """{
    "version": "",
    "description": "",
    "url": "",
    "readme": "",
    "license": "",
    "keywords": [""],
    "dependencies": {"":""}
}\n"""

OLS_JSON =  """{{
    "$schema": "https://raw.githubusercontent.com/DanielGavin/ols/master/misc/ols.schema.json",
    "collections": [
        {{
            "name": "core",
            "path": "{0}core"
        }}
    ],
    "enable_document_symbols": true,
    "enable_semantic_tokens": false,
    "enable_hover": true,
    "enable_snippets": true
}}\n"""

ODINFMT_JSON = """{
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
}\n"""

MAIN_ODIN = """package {0}

import "core:fmt"

main :: proc() {{
    fmt.println("Hellope")
}}\n"""

README_MD = """# {0}
A cool thing that's going to change to world.
\n"""


def main():
    ap = argparse.ArgumentParser(
        prog="Odin_Start.py",
        description="Quickly start an Odin project.")
    setup = ap.add_mutually_exclusive_group(required=True)
    setup.add_argument("-i","--init", action="store_true", help="creates project in current directory.")
    setup.add_argument("-n","--new", nargs=1, metavar="PATH", help="creates project in given directory.")

    ap.add_argument("-f", "--file", nargs="+", 
                    choices=["main", "ols", "odinfmt", "mod", "readme", "license", "gitignore", "all"], default=[],
                    help="creates given files. creates main, ols & readme when not used. ")
    ap.add_argument("-d", "--dir", nargs="+", choices=["bin", "src", "all"], default=[],
                    help="creates given directories. creates none when not used.")
    ap.add_argument("-l", "--license", nargs="?", default="", metavar="PATH or FILE",
                    help="looks for a license at the path or a file in Odin Start's dir. looks for a 'LICENSE' file, if nothing is provided. then addes it to the 'license' file. does nothing if not used.")

    if len(sys.argv) == 1:
        ap.print_help()
        return
    args = ap.parse_args()

    if args.init:
        curr_dir = Path.cwd()
        pkg_name = curr_dir.stem
    elif args.new:
        curr_dir = Path.cwd() / args.new[0]
        pkg_name = args.new[0]
        if not Path(pkg_name).exists():
            Path.mkdir(pkg_name)
    
    if not args.file:
        args.file = ["main", "ols", "readme"]
    elif "all" in args.file:
        args.file = ["main", "ols", "odinfmt", "mod", "readme", "license", "gitignore"]
    if "all" in args.dir:
        args.dir = ["bin", "src"]

    if "bin" in args.dir:
        Path.mkdir(curr_dir/"bin")
    if "src" in args.dir:
        Path.mkdir(curr_dir/"src")

    if "main" in args.file:
        path = curr_dir/"src" if "src" in args.dir else curr_dir
        Path(path/"main.odin").write_text(MAIN_ODIN.format(pkg_name))
    if "odinfmt" in args.file:
        Path(curr_dir/"odinfmt.json").write_text(ODINFMT_JSON)
    if "mod" in args.file:
        Path(curr_dir/"mod.pkg").write_text(MOD_PKG)
    if "readme" in args.file:
        Path(curr_dir/"README.MD").write_text(README_MD.format(pkg_name))
    if "gitignore" in args.file:
        Path(curr_dir/".gitignore").write_text("")
    
    if "osl" in args.file:
        odin_root = ""
        if os.getenv("ODIN_ROOT"):
            odin_root = os.getenv("ODIN_ROOT")
        else:
            for p in os.getenv("PATH").split(";"):
                p1 = Path(p).stem.lower()
                if "odin" in p1:
                    odin_root = p.replace("\\", "/")+"/"
                    if platform.system() == "Windows":
                        odin_root = odin_root.replace("/", "\\\\")
                    if p1 == "odin":
                        break

        if not odin_root:
            print("Unable to find Odin's path.")
            odin_root = "<path to odin>"
        else:
            print(f"Found Odin in: {odin_root}")
            
        Path(curr_dir/"ols.json").write_text(OLS_JSON.format(odin_root))

    if "license" in args.file:
        license = ""
        if args.license != "":
            lice_file = Path("LICENSE")
            if args.license != None:
                lice_file = Path(args.license)
            if not lice_file.exists():
                print("Unable able to find")
            else:
                license = lice_file.read_text()
        Path(curr_dir/"license").write_text(license)
    
    print(f"Project \"{pkg_name}\" created in {path}")
    return
    

if __name__ == "__main__":
    main()

"""
****************************************************************************
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
*****************************************************************************
"""