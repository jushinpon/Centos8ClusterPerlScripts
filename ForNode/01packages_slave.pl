#!/usr/bin/perl
use strict;
use warnings;


system("rm -rf /var/run/dnf.pid");
system('dnf -y groupinstall "Development Tools"');
system("yum install 'dnf-command(config-manager)'");
system("dnf install dnf-plugins-core -y");
system("dnf config-manager --set-enable powertools");

my @package = ("vim", "wget", "net-tools", "epel-release", "htop", "make"
			, "gcc-c++", "nfs-utils","yp-tools", "gcc-gfortran","psmisc"
			, "ypbind" , "rpcbind","xauth","oddjob-mkhomedir");

for (@package){system("dnf -y install $_");}
system("perl -p -i.bak -e 's/.*GSSAPIAuthentication.+/GSSAPIAuthentication no/;' /etc/ssh/sshd_config");
system("perl -p -i.bak -e 's/.*UseDNS.+/UseDNS no/;' /etc/ssh/sshd_config");
system("killall -9 dnf");
system("systemctl restart sshd");
system("dnf -y upgrade");
