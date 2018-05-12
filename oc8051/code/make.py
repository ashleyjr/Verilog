#!/usr/bin/python
import os
import sys

def cmd_print(cmd):
    print "     Cmd: " + cmd
    os.system(cmd)

def main():
    for name in sorted(os.listdir(os.getcwd())):
        if ".asm" in name:
            cmd_print("as31 -Fbyte "+name)
            f = open(name.replace(".asm", ".byte"), 'r')
            h = f.read()
            f.close()
            f = open(name.replace(".asm",".mem"),'w')
            for line in h.split("\n")[0:-1]:
                found = False
                for i in range(0, 0x10000):
                    test = str(hex(i))[2:-1].upper().zfill(4)
                    if test in line:
                        f.write(line.split(": ")[1] + "\n")
                        found = True
                        break
                if not found:
                    f.write("00\n")
            f.close()

if "__main__" == __name__:
    main()
