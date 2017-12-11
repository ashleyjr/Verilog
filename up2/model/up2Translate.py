#!/usr/bin/python

class up2Translate:

    cmds={
        "ADD"           :   "0",
        "SUB"           :   "1",
        "OR"            :   "2",
        "NOR"           :   "3",
        "XOR"           :   "4",
        "NAND"          :   "5",
        "LSL"           :   "6",
        "LSR"           :   "7",
        "BNE"           :   "8",
        "BE"            :   "9",
        "JMP"           :   "A",
        "INT"           :   "B",
        "SHM"           :   "C",
        "MEM"           :   "D",
        "DSP"           :   "E",
        "PSP"           :   "F"
    }

    muxes={
        "R0,1,R1"       :   "0",
        "R1,1,R2"       :   "1",
        "R2,R0,R1"      :   "2",
        "R?,R0,R2"      :   "3",
        "R0,1,R1"       :   "4",
        "R1,1,R2"       :   "5",
        "R2,R0,R1"      :   "6",
        "R?,R0,R2"      :   "7",
        "R0,1,R1"       :   "8",
        "R1,1,R2"       :   "9",
        "R2,R0,R1"      :   "A",
        "R?,R0,R2"      :   "B",
        "R0,1,R1"       :   "C",
        "R1,1,R2"       :   "D",
        "R2,R0,R1"      :   "E",
        "R?,R0,R2"      :   "F"
    }

    use_muxes={
        "ADD",
        "SUB",
        "OR",
        "NOR",
        "XOR",
        "NAND",
        "LSL",
        "LSR"
    }

    use_address={
        "BNE",
        "BE",
        "JMP"
    }
