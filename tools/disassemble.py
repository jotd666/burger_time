from capstone import *

with open("rom.bin","rb") as f:
    full_contents = f.read()

mi = Cs(CS_ARCH_MOS65XX, CS_MODE_MOS65XX_6502)

start_address = 0xC000
offset = 0
just_written = False
with open("disasm.asm","w") as f:
    while True:
        instructions = bytearray(full_contents[offset:])
        if just_written and offset & 0x104 == 0x104:
            # we have to decrypt
            bits = "{:08b}".format(instructions[0])
            newbits = ["x"]*8
            for a,b in ((7,6),(6,5),(5,3),(4,4),(3,2),(2,7),(1,1),(0,0)):
                newbits[7-b] = bits[7-a]

            instructions[0] = int("".join(newbits),2)

        it = mi.disasm(instructions,start_address+offset)
        try:
            i = next(it)
        except StopIteration:
            # either end of file or unknown instruction
            offset += 1
            continue

        hexcode = " ".join([f"{x:02X}" for x in i.bytes])

        just_written = i.mnemonic == "sta"

        f.write("{:04X}: {:9}{} {}\n".format(i.address, hexcode, i.mnemonic, i.op_str.replace("0x","$")))

        offset += i.size
        if offset == 0xF65C-start_address:  # after this there's junk (actually some original source code!)
            break
