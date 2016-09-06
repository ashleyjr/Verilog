sudo apt-get install git
sudo apt-get install gawk
sudo apt-get install clang
sudo apt-get install tcl-dev
sudo apt-get install libreadline-dev
sudo apt-get install bison
sudo apt-get install flex
sudo apt-get install g++
sudo apt-get install libftdi-dev
sudo apt-get install verilog
sudo apt-get install gtkwave
sudo add-apt-repository ppa:saltmakrell/ppa
sudo apt-get update
sudo apt-get install yosys
git clone https://github.com/cliffordwolf/icestorm.git icestorm
cd icestorm
make -j$(nproc)
sudo make install
cd ..
git clone https://github.com/cseed/arachne-pnr.git arachne-pnr
cd arachne-pnr
make -j$(nproc)
sudo make install
cd ..
