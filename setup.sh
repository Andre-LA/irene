rm nprof.nelua
rm tico.nelua
rm -rf tinycoffee/

# clone tinycoffee
git clone https://github.com/canoi12/tinycoffee.git
cd tinycoffee

# build tinycoffee
mkdir build
cd build
cmake ..
make

cd ../../

echo "setup-tinycoffee: setup done"

# download tico
wget -O tico.nelua https://raw.githubusercontent.com/Andre-LA/tico-nelua/main/output/tico.nelua

# download nprof
wget -O nprof.nelua https://raw.githubusercontent.com/Andre-LA/nprof/master/nprof.nelua


# clone rotor
git clone https://github.com/Andre-LA/Rotor-nelua.git
