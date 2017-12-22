cd model
./up2Run.py -g -i ../programs/basic.up2 -o basic.hex --runs 200 --verbosity "LAST"  
./up2Run.py -g -i ../programs/loop.up2 -o loop.hex --runs 200 --verbosity "LAST"
./up2Run.py -g -i ../programs/mem.up2 -o mem.hex --runs 200 --verbosity "LAST"
