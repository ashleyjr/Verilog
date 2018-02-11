rm *.png
cd ..
./runsim.py -m vga_out -s
cd vga_out
./runsim_to_frames.py
