#!/usr/bin/python
import os
from os import listdir
from os.path import isfile, join

start = os.path.dirname(os.path.realpath(__file__))
ignores =   [   ".vcd",
                ".pdf"  ]
lst = open("list.txt", "wb")

for d in listdir(start):
    move = os.path.join(start, d)
    if (os.path.isdir(move) and d != ".git"):
        os.chdir(move)
        new = os.path.dirname(os.path.realpath(__file__))
        for f in listdir(new):
            add_to_list = True
            for ignore in ignores:
                if ignore in f:
                    add_to_list = False
            if add_to_list:
                lst.write(os.path.join(d,f) + "\n")
lst.close()



