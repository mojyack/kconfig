# shared helpers for the driver-analyzer scripts

import os
import re
import shlex

CONFIG_RE = re.compile(r"CONFIG_[0-9A-Z_]*")


# Walk `roots` for *.c files and run `extractor(path) -> list` on each.
# Returns a list of [path, *items] entries for files that yielded at least one item.
def walk_sources(roots, extractor):
    ret = []
    for root in roots:
        for cwd, dirs, files in os.walk(root):
            for f in files:
                if not f.endswith(".c"):
                    continue
                path = os.path.join(cwd, f)
                items = extractor(path)
                if items:
                    ret.append([path] + list(items))
    return ret


def dump_cache(entries, file):
    with open(file, "w") as f:
        for entry in entries:
            f.write(" ".join(entry) + "\n")


def load_cache(file):
    ret = []
    for line in open(file).read().splitlines():
        line = line.strip()
        if line:
            ret.append(line.split(" "))
    return ret


# Resolve the CONFIG_* symbol that controls `file` via its sibling Makefile.
# Returns (code, configs):
#   code 0 = no Makefile, code 1 = exact reference to <file>.o,
#   code 2 = no exact match, all CONFIG_* in the Makefile are returned as guesses.
def find_corresponding_config(file):
    makefile_path = os.path.dirname(file) + "/Makefile"
    if not os.path.exists(makefile_path):
        return (0, [])
    ret = []
    name = os.path.basename(file)[:-2] + ".o"
    makefile = open(makefile_path).read()
    for line in makefile.split("\n"):
        if name not in line or "CONFIG_" not in line:
            continue
        m = CONFIG_RE.search(line)
        if m:
            ret.append(m.group())
    if ret:
        return (1, ret)
    for match in CONFIG_RE.findall(makefile):
        ret.append(match)
    return (2, ret)


def load_config(file):
    ret = {}
    for line in open(file).read().splitlines():
        elms = shlex.split(line, comments=True)
        if len(elms) != 1:
            continue
        key, value = elms[0].split("=", 1)
        ret[key] = value
    return ret


def make_config_status(reference_config):
    def status(key):
        return f"({reference_config.get(key, 'n')})"

    return status


# Render the result of find_corresponding_config to stdout with consistent indentation.
def print_config_result(code, configs, config_status, indent="            "):
    match code:
        case 0:
            print(f"{indent}makefile not found")
        case 1:
            if len(configs) == 1:
                print(f"{indent}exactly", configs[0], config_status(configs[0]))
            else:
                for config in configs:
                    print(f"{indent}possibly", config, config_status(config))
        case 2:
            if len(configs) == 1:
                print(f"{indent}possibly", configs[0], config_status(configs[0]))
            else:
                print(f"{indent}cannot find exact match")
