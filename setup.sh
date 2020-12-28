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

wget -O tico.nelua https://raw.githubusercontent.com/Andre-LA/tico-nelua/main/output/tico.nelua
wget -O nprof.nelua https://raw.githubusercontent.com/Andre-LA/nprof/master/nprof.nelua
