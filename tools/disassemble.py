from capstone import *
import json

# check EB7A what is done here?
#EB7A: F6 60    inc $60, x  ; dummy_write_decrpyt_trigger
#EB7C: C1 F5    cmp ($f5, x)
#EB7E: 6E BC 4F ror $4fbc
#or (prev)
#EB7A: F6 60    inc $60, x
#EB7C: 85 F5    sta $f5  ; dummy_write_decrpyt_trigger
#sEB7E: AE BC 4F ldx $4fbc

# INC makes no sense
#F3B9: EE 10 05 inc $0510  ; dummy_write_decrpyt_trigger
#F3BC: 4D 00 85 eor $8500
#F3BF: F5 EA    sbc $ea, x
#
# without it
# F3B9: EE 10 05 inc $0510
#F3BC: A9 00    lda #$00
#F3BE: 85 F5    sta $f5
#F3C0: EA       nop



with open("rom.bin","rb") as f:
    full_contents = f.read()

mi = Cs(CS_ARCH_MOS65XX, CS_MODE_MOS65XX_6502)

start_address = 0xC000
offset = 0
prev_offset = 0
dummy_write_addresses = []

previous_mnemonic = ""
write_mnemonics = {"sta","stx","sty"}

with open("disasm.asm","w") as f:
    while True:
        instructions = bytearray(full_contents[offset:])

        decrypt = False
        if offset & 0x104 == 0x104:
            decrypt = previous_mnemonic in write_mnemonics

        if decrypt:
            # we have to decrypt
            bits = "{:08b}".format(instructions[0])
            if bits.startswith("11"):
                instructions[0] = 0x24
            else:
                newbits = ["x"]*8
                for a,b in ((7,6),(6,5),(5,3),(4,4),(3,2),(2,7),(1,1),(0,0)):
                    newbits[7-b] = bits[7-a]

                instructions[0] = int("".join(newbits),2)
        it = mi.disasm(instructions,start_address+offset)
        try:
            i = next(it)
        except StopIteration:
            # either end of file or unknown instruction
            hexcode = "{:02X}".format(instructions[0])
            f.write("\n{:04X}: {:9}illegal".format(start_address+offset, hexcode))
            offset += 1
            continue

        hexcode = " ".join([f"{x:02X}" for x in i.bytes])

        previous_mnemonic = i.mnemonic
        if decrypt:
            f.write("  ; dummy_write_decrpyt_trigger")
            dummy_write_addresses.append(prev_offset+start_address)
        f.write("\n{:04X}: {:9}{} {}".format(i.address, hexcode, i.mnemonic, i.op_str.replace("0x","$")))
        prev_offset = offset

        offset += i.size
        if offset == 0xF65C-start_address:  # after this there's junk (actually some original source code!)
            break
    f.write("\n")

with open("dummy_writes.json","w") as f:
    json.dump(dummy_write_addresses,f,indent=2)