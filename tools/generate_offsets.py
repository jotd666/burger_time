import re
vr = re.compile("(\w+)_([0-9a-f]{4})")
with open("../src/burgertime_6502.asm") as f:
    contents = f.read()
    data = set(re.findall(vr,contents))

for name,offset in sorted(data,key=lambda x:int(x[1],16)):
    if "dummy" not in name:
        print(f"{name}_{offset} = 0x{offset}")
