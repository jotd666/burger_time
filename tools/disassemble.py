

#in mame\src\mame\dataeast\decocpu7.cpp: change the following to be able to log the decryptions
r"""
uint8_t deco_cpu7_device::mi_decrypt::read_sync(uint16_t adr)
{
    static FILE *logger=NULL;

    uint8_t res = cprogram.read_byte(adr);
    if(had_written) {
        had_written = false;
        if((adr & 0x0104) == 0x0104)
        {
            auto old_res = res;
            res = bitswap<8>(res, 6,5,3,4,2,7,1,0);
            if (logger==NULL)
            {
                logger = fopen("log_cpu07.txt","w");
            }
            fprintf(logger,"adr: %04X, encrypted: %02X, decrypted: %02X\n",adr,old_res,res);

        }
    }
    return res;
}
"""

from capstone import *
import json
import re

log_re = re.compile("adr: (....), encrypted: (..), decrypted: (..)")

decrypt_dict = {}
encrypted_addresses = set()

# read the log we got from modified version of MAME
with open(r"K:\Emulation\MAME\log_cpu07.txt") as f:
    for line in f:
        m = log_re.match(line)
        if m:
            addr,encypted,decrypted = [int(x,16) for x in m.groups()]
            decrypt_dict[encypted] = decrypted
            encrypted_addresses.add(addr)



def bitswap(val, order):
    result = 0
    for i, bit_pos in enumerate(order):
        if val & (1 << bit_pos):  # Check if the bit at bit_pos is set
            result |= (1 << (len(order) - 1 - i))  # Set the bit in the new position
    return result
def decrypt_byte(value):
    return bitswap(value,[6, 5, 3, 4, 2, 7, 1, 0])


with open("rom.bin","rb") as f:
    full_contents = f.read()

mi = Cs(CS_ARCH_MOS65XX, CS_MODE_MOS65XX_6502)

start_address = 0xC000
offset = 0
prev_offset = 0
dummy_write_addresses = []

previous_mnemonic = ""
write_mnemonics = {"sta","stx","sty","dec","inc","pha","php","ror","asl","lsr"}

fake_instructions = {0xCB1D,0xCD3D,0xCD43,0xCD34,0xCD35,0xCD36,0xD162,0xD169,0xD16A,0xD16B,0xD16C,0xD16D,0xD16B}
forced_decrypt = {0xC303,0xCB1E,0xC94E,0xC9BC}  # this one has just been jumped to

with open("disasm.asm","w") as f:
    while True:
        instructions = bytearray(full_contents[offset:])
        address = start_address+offset
        decrypt = address in forced_decrypt

        if not decrypt and offset & 0x104 == 0x104:
            decrypt = previous_mnemonic in write_mnemonics and previous_args.lower() != 'a'

        if decrypt:
            # we have to decrypt
            # check if address is in address log
            crypted_instruction = instructions[0]
            instructions[0] = decrypt_byte(instructions[0])
            encrypted_addresses.discard(address)
            if crypted_instruction in decrypt_dict:


                if decrypt_dict[crypted_instruction] != instructions[0]:
                    print("Mismatch logged: {:02x} vs {:02x} for {:02x}".format(decrypt_dict[crypted_instruction] ,instructions[0],crypted_instruction))

##            else:
##                decrypt = False  # not covered

        it = mi.disasm(instructions,address)
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
        previous_args = i.op_str

        if decrypt:
            f.write("  ; dummy_write_decrpyt_trigger")
            dummy_write_addresses.append(prev_offset+start_address)
        f.write("\n{:04X}: {:9}{} {}".format(i.address, hexcode, i.mnemonic, i.op_str.replace("0x","$")))
        if decrypt:
            f.write(f"  ; prev_crypted {crypted_instruction:02x}")
        prev_offset = offset

        offset += i.size

        while offset+start_address in fake_instructions:
            # skip
            offset += 1
        if offset == 0xF65C-start_address:  # after this there's junk (actually some original source code!)
            break
    f.write("\n")

with open("dummy_writes.json","w") as f:
    json.dump(dummy_write_addresses,f,indent=2)

# print remaining addresses that were decrypted when running MAME but not statically
# helps to find the missing parts and corner cases (like fake code triggering decrypt, jumps)
for i in sorted(encrypted_addresses):
    print(hex(i))