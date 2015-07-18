#!/usr/bin/python
import os
from os import listdir
from os.path import isfile, join

start = os.path.dirname(os.path.realpath(__file__))

lst = open("list.txt", "wb")

for d in listdir(start):
    move = os.path.join(start, d)
    if (os.path.isdir(move) and d != ".git"):
        os.chdir(move)
        new = os.path.dirname(os.path.realpath(__file__))
        for f in listdir(new):
            lst.write(os.path.join(d,f) + "\n")

lst.close()



