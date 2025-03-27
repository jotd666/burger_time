import json

with open("dummy_writes.json") as f:
    dummy_writes = set(json.load(f))
with open("../src/burgertime_6502.asm","r") as fr, open("../src/burgertime_6502_.asm","w") as fw:
    for line in fr:
        toks = line.split(":")
        if len(toks)>1 and len(toks[0])==4:
            address = int(toks[0],16)
            if address in dummy_writes:
                line = line.rstrip() + "  ; dummy_write\n"
        fw.write(line)