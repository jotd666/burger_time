from shared import *

# various dirty but at least automatic patches applying on the specific track and field code
with open(source_dir / "burger_time.68k") as f:
    lines = list(f)
    i = 0

    while i < len(lines):
        line = lines[i]
        toks = line.split()
        if toks and toks[0] == "GET_ADDRESS":
            value = None
            value_str = toks[1]
            try:
                value = int(value_str,16)
            except ValueError:
                try:
                    value = int(value_str.rsplit("_",1)[0],16)
                except ValueError:
                    pass
            if value is not None and value < 0x100:
                # GET_ADDRESS in zero page. If we recognize the next instruction
                # there's a way to optimize the access, as it's legal and fast
                next_line = lines[i+1]
                toks = next_line.split("|")[0].split()
                if len(toks)==2:
                    inst,params = toks
                    inst = inst.split(".")[0]
                    subparams = params.split(",")
                    # we discard too complex moves
                    if len(subparams)==2:
                        src,dest = subparams
                        if "(a0)" in lines[i+2]:
                            i += 1
                            continue
                        if src == "(a0)" and dest in ["d0","d1","d2"]:
                            # read instruction
                            line = change_instruction(f"OP_R_ON_ZP_ADDRESS\t{inst},{value_str},{dest}",lines,i,remove_cont_lines=False)
                            lines[i+1] = ""
                        elif dest == "(a0)" and src in ["d0","d1","d2"]:
                            # read instruction
                            line = change_instruction(f"OP_W_ON_ZP_ADDRESS\t{inst},{value_str},{src}",lines,i,remove_cont_lines=False)
                            lines[i+1] = ""
        lines[i] = line
        i+=1

with open(source_dir / "burger_time_optim.68k","w") as fw:

    fw.writelines(lines)