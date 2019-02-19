import matplotlib.pyplot as plt
import numpy as np
from matplotlib import cm

def update(a, b, c_a, c_b):
    a_n = (a*a - b*b) + c_a
    b_n = (2*a*b) + c_b
    return a_n, b_n

def main():

    h = 90
    w = 90
    data = np.zeros((w, h, 3), dtype=np.uint8)

    base_w = -1.55
    top_w  = -1.3

    base_h = -0.1
    top_h  = 0.1
    step_w = (top_w-base_w)/float(w)
    step_h = (top_h-base_h)/float(h)

    for i in range(h):
        print i
        for j in range(w):

            s_a = base_w + i*step_w
            s_b = base_h + j*step_h
            a = 0
            b = 0
            data[j,i] = 255
            for k in range(0, 256):
                a,b = update(a,b,s_a,s_b)
                if ((a*a)+(b*b) > 2):
                    data[j,i] = k

    plt.imshow(data,extent=[base_w,top_w,base_h,top_h])
    plt.show()



if "__main__" == __name__:
    main()

