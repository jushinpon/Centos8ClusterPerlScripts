#yum all need package
system("dpkg --configure -a");
system("yum -y update");
system("yum -y --fix-broken install");
system("yum -y upgrade");
@package = ("make", "g++", "cmake");
foreach(@package){
system("yum -y install $_");
}
system("yum -y remove wget");
system("yum -y install wget");

#get GROMACS
$GROMACS_URL = "http://ftp.gromacs.org/pub/gromacs/gromacs-5.1.5.tar.gz";
system("wget -O gromacs-5.1.5.tar.gz $GROMACS_URL");
system("tar xfz gromacs-5.1.5.tar.gz");
chdir("gromacs-5.1.5");
mkdir("build");
chdir("build");
system("cmake .. -DGMX_BUILD_OWN_FFTW=ON -DREGRESSIONTEST_DOWNLOAD=ON -DGMX_GPU=off");
system("make -j 8");
system("make check");
system("make install");
if(!`grep 'export PATH=/usr/local/gromacs/bin:\$PATH' /etc/profile`){
`echo 'export PATH=/usr/local/gromacs/bin:\$PATH' >> /etc/profile`;
}
print"######################\nPlease reboot\n######################\n";