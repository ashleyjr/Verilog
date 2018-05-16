#!/usr/bin/python
import os
import sys

def cmd_print(cmd):
    print "     Cmd: " + cmd
    os.system(cmd)

def main():
    for name in sorted(os.listdir(os.getcwd())):
        if ".c" in name:
            cmd_print("sdcc "+name)
    for name in sorted(os.listdir(os.getcwd())):
        if ".asm" in name:
            cmd_print("sdas8051 -plosgffw "+name)
            f = open(name.replace(".asm", ".lst"), 'r')
            h = f.read()
            f.close()
            f = open(name.replace(".asm",".mem"),'w')
            out = ["00"] * 30
            for line in h.split("\n")[0:-1]:
		if '[' in line:
                    print line
                    print line[6:12]
                    ptr = int(line[6:12], 16)
                    codes = line[13:21]
                    if 'r' in codes:
                        spl = 'r'
                    else:
                        spl = ' '
                    for code in codes.split(spl):
                        out[ptr] = code
                        ptr += 1
                   # str_byte = line.split(' ')
                   # for i in range(4,len(str_byte)):
                   #     f.write(str_byte[i] + "\n")
            print out
            for o in out:
                f.write(o+"\n")
            f.close()

if "__main__" == __name__:
    main()
