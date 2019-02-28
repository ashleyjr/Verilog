import matplotlib.pyplot as plt
import numpy as np
from matplotlib import cm
from math import floor

def main():

    f = open("ip/generators/mandelbrot/output.txt")

    i = 0
    j = 0
    x = []
    y = []
    z = []
    for line in f:
        csv = line.split(",")
        x.append(float(csv[0]))
        y.append(float(csv[1]))
        z.append(float(csv[2]))

    min_x = x[0]
    max_x = x[0]
    for a in x:
        if a < min_x:
            min_x = a
        if a > max_x:
            max_x = a
    min_y = y[0]
    max_y = y[0]
    for a in y:
        if a < min_y:
            min_y = a
        if a > max_y:
            max_y = a

    print "Min x   = ",min_x
    print "Max x   = ",max_x
    print "Min y   = ",min_y
    print "Max y   = ",max_y
    print "Entries =", len(z)
    range_x=max_x-min_x
    range_y=max_y-min_y
    s = np.sqrt(len(z))
    print "Sqrt    =",s
    step_x = range_x/s
    print "Step x  =",step_x
    step_y = range_y/s
    print "Step y  =",step_y


    im = np.zeros((int(s+1),int(s+1), 3), dtype=np.uint8)

    for i in range(0, len(x)):
        a = int(floor((x[i]-min_x)*(s/range_x)))
        b = int(floor((y[i]-min_y)*(s/range_y)))
        c = int(z[i])
        im[a,b] = (c,c,c)
        print a,b,c
    print im
    plt.imshow(im)
    plt.show()



if "__main__" == __name__:
    main()

