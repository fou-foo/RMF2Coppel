mkdir /usr/local/nz
tar -xf nz-linuxclient-v7.2.1.10.tar.gz
cd linux
echo | sh ./unpack
cd ..
cd linux64
echo | sh ./unpack
yum -y install glibc-2.17-317.el7.i686
yum -y install libcom_err-1.42.9-19.el7.i686
yum -y install zlib-1.2.7-18.el7.i686
yum -y install ncurses-libs-5.9-14.20130511.el7_4.i686
cd /usr/local/nz
export NZ_PASSWORD="Y8UL3m2guod6LLAWxmf1"
.nzsql -host 10.44.14.126 -u big -d CENIC
