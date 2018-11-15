#!/usr/bin/python
import sys
import subprocess
from optparse import OptionParser

def main():
    ''' Options '''
    parser = OptionParser(usage="compare.py [-b ] [-m]" )
    parser.add_option("-b", "--back", dest="back")
    parser.add_option("-m", "--module", dest="module")
    (options, args) = parser.parse_args()

    if options.back is None:
        print "Error: Supply back"
        sys.exit()
    if options.module is None:
        print "Error: Supply module"
        sys.exit()

    back = int(options.back)
    module = str(options.module)

    ''' Get all commit hashes in reverse order '''
    p = subprocess.Popen(['git','log'], stdout=subprocess.PIPE)
    lines, err = p.communicate()
    commits = []
    for line in lines.split('\n'):
        if 'commit' in line:
            commits.append(line.replace('commit ',''))

    ''' Rollback '''
    q = subprocess.Popen(['git','checkout','master'],   stdout=subprocess.PIPE, stderr=subprocess.PIPE)
    q = subprocess.Popen(['git','reset','--hard'],      stdout=subprocess.PIPE, stderr=subprocess.PIPE)
    for i in range(0, back):
        q = subprocess.Popen(['git','checkout',commits[i]], stdout=subprocess.PIPE, stderr=subprocess.PIPE)
        q = subprocess.Popen(['git','log','-1','--pretty=%B'], stdout=subprocess.PIPE, stderr=subprocess.PIPE)
        out, err = q.communicate()
        print "*******************************************************"
        print i,commits[i]
        print out.replace('\n','')
        print "*******************************************************"
        q = subprocess.Popen(['git','reset','--hard'], stdout=subprocess.PIPE, stderr=subprocess.PIPE)
        q = subprocess.Popen(['python','lib/python/runsim.py','-m',module,'-j'], stdout=subprocess.PIPE, stderr=subprocess.PIPE)
        out, err = q.communicate()
        for line in out.split("\n"):
            if  ("SB" in line):
                print line

    q = subprocess.Popen(['git','checkout','master'],   stdout=subprocess.PIPE, stderr=subprocess.PIPE)
    q = subprocess.Popen(['git','reset','--hard'],      stdout=subprocess.PIPE, stderr=subprocess.PIPE)


if "__main__" == __name__:
    main()
