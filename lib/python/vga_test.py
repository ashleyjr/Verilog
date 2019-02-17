from PIL import Image
from optparse import OptionParser
import numpy as np

def main():
    parser = OptionParser(usage="vga_test.py [-f file] [-w width]" )
    parser.add_option("-b", "--bits",   dest="bits")
    parser.add_option("-f", "--file",   dest="file")
    parser.add_option("-o", "--offset", dest="offset")
    parser.add_option("-w", "--width",  dest="width")
    (options, args) = parser.parse_args()

    f = open(options.file, "r")

    im = []
    for line in f:
        c = line.split(",")
        im.append((int(c[0]), int(c[1]), int(c[2]), int(c[3]), int(c[4])))

    o = int(options.offset)
    s = 256/(2 ** int(options.bits))
    w = int(options.width)
    h = len(im)/w
    print "INFO"
    print "\tEntries: " + str(len(im))
    print "\tHeight:  " + str(h)
    print "\tWidth:   " + str(w)


    data = np.zeros((h, w, 3), dtype=np.uint8)
    ptr = 0
    last_h = 0
    last_v = 0
    for i in range(h):
        for j in range(w):
            l = im[ptr]
            data[i,j] = [s*l[2],s*l[3],s*l[4]]
            if (l[1] == 1) and (last_h == 0):
                print "H:"+str(ptr)
            last_h = l[1]
            if (l[0] == 1) and (last_v == 0):
                print "V:"+str(ptr)
            last_v = l[0]
            ptr += 1

    img = Image.fromarray(data, 'RGB')
    img.show()


if "__main__" == __name__:
    main()

