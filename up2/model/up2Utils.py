#!/usr/bin/python
import random
import math

class up2Utils:

    def randReg(self,bits,length):
        reg = []
        for i in range(0,length):
            reg.append(random.randint(0,(math.pow(2,bits)-1)))
        return reg

    def clog2(self, num):
        return int(math.ceil(math.log(num,2)))

    def fit(self, num, chunk):
        return int(math.ceil(float(self.clog2(num))/float(chunk)))

    def padding(self, length):
        space = ""
        for j in range(0,length):
            space += " "
        return space

