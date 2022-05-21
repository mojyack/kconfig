import sys

def parse_config(file):
    result = {}
    for l in open(file).readlines():
        l = l.strip()
        if len(l) == 0 or l[0] == '#':
            continue

        splitted = l.split("=")
        result[splitted[0][7:]] = splitted[1]

    return result

original = parse_config(sys.argv[1])
custom = parse_config(sys.argv[2])

for k, v in original.items():
    if (v == "y" or v == "m") and not k in custom:
        print(f"A {k} is missing in custom config")
    elif v == "y" and custom[k] != "y":
        print(f"B {k} is modified to {custom[k]}")
    elif v == "m" and custom[k] == "n":
        print(f"C {k} is disabled")
