#!/usr/bin/python
import random
import math

class up2Utils:

    def randReg(self,bits,length):
        reg = []
        for i in range(0,length):
            reg.append(random.randint(0,(math.pow(2,bits)-1)))
        return reg



