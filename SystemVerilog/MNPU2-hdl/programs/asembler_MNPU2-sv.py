import sys
import os

OUTPUT_FILE_NAME = "program"
OUTPUT_FOLDER_PATH = r".."

if len(sys.argv) > 1:
    asm_file = sys.argv[1]
    print("File:", asm_file)

    R0 = 0
    R1 = 1
    R2 = 2
    R3 = 3
    R4 = 4
    R5 = 5
    R6 = 6
    R7 = 7

    TRUE = 0
    NEQ, NZERO = 1, 1
    EQ, ZERO = 2, 2
    LT, NCARRY = 3, 3
    LEQ = 4
    GT = 5
    GEQ, CARRY = 6, 6
    MSB, LSB = 7, 7

    NOOP = 0 << 3
    RST = 0 << 3
    AST = 1 << 3
    ADD = 2 << 3
    BSUB = 3 << 3
    SUB = 4 << 3
    CMP = 5 << 3
    INC = 6 << 3
    DEC = 7 << 3
    RSH = 8 << 3
    LSH = 9 << 3
    XOR = 10 << 3
    OR = 11 << 3
    AND = 12 << 3
    NOT = 13 << 3
    IMM = 14 << 3
    IMA = 15 << 3
    SWP = 16 << 3
    CALL = 17 << 3
    RET = 18 << 3
    IN = 19 << 3
    OUT = 20 << 3
    BRC = 21 << 3
    PUSH = 22 << 3
    POP = 23 << 3
    POI = 24 << 3
    MST = 25 << 3
    MLD = 26 << 3
    ADDC = 27 << 3
    SUBC = 28 << 3
    NEG = 29 << 3
    NEGA = 30 << 3
    HALT = 31 << 3

    code = open(asm_file, "r")
    lines = code.readlines()
    length = len(lines)
    pc = 0
    page = 0
    byte = 0
    prev_label = ""
    twoscomp = 0
    bin_output = ""

    #find labels
    for i in range(0, length):
        line = lines[i].split()
        if pc>64:
            print("ERROR! line nr. " + str(i) + " - " + lines[i].replace("\n", " | overflows - pc = " + str(pc)))
        if len(line)!=0:
            if line[0][len(line[0])-1]==":": #label
                exec(line[0].replace(":", "") + "= pc")
                exec(line[0].replace(":", "") + "_page = page")
            elif line[0]=="]next_page]":
                    page+=1
                    pc = 0
            elif line[0][0]!="#" and line[0][0]!=";" and line[0][0]!="$":
                pc+=1

    pages = page # number of pages
    pc = 0
    page = 0

    for i in range(0, length):
        line = lines[i].split()
        if len(line)!=0:
            if line[0][0]!="#" and line[0][0]!=";" and line[0][0]!="$":
                if line[0]=="]next_page]":
                    for j in range(64-pc):
                        bin_output += "00000000\n"
                    page+=1
                    pc = 0
                else:
                    if line[0][len(line[0])-1]==":":
                        prev_label = line[0]
                    else:
                        if len(line)>1:
                            exec("byte = " + line[0] + " | " + line[1])
                        else:
                            exec("twoscomp = int(" + line[0] + ")")
                            if twoscomp>=0:
                                exec("byte = " + line[0])
                            else:
                                exec("byte = " + "(abs(int(" + line[0] + "))^255)+1")
                        bin_output += format(byte&255, "b").zfill(8) + "\n"
                        pc+=1
            if line[0][0]=="$":
                exec(" ".join(line[1:]))



    code = open(f"{OUTPUT_FOLDER_PATH}\\{OUTPUT_FILE_NAME}.bin", "w")
    code.write(bin_output)
    # while True:
    #     pass