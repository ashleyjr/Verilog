import matplotlib.pyplot as plt
import numpy as np
from matplotlib import cm

def main():

    im = np.zeros((50,50))
    f = open("ip/generators/mandelbrot/output.txt")

    i = 0
    j = 0
    for line in f:
        csv = line.split(",")
        x = float(csv[0])
        y = float(csv[1])
        z = float(csv[2])

        im[i,j] = z
        print i,j
        if(i == 49):
            i = 0
            j = j + 1
            if(j == 50):
                break
        i = i + 1

    plt.imshow(im)
    plt.show()



if "__main__" == __name__:
    main()

