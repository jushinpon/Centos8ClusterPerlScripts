#!/usr/bin/perl
use strict;
use warnings;

## set unlimited ram memory
if(!`grep '* soft memlock unlimited' /etc/security/limits.conf`){
	`echo '* soft memlock unlimited' >> /etc/security/limits.conf`;
}
if(!`grep '* hard memlock unlimited' /etc/security/limits.conf`){
	`echo '* hard memlock unlimited' >> /etc/security/limits.conf`;
}

system("rm -rf /var/run/dnf.pid");
system('dnf -y groupinstall "Development Tools"');
system("yum install 'dnf-command(config-manager)'");
system("dnf install dnf-plugins-core -y");
system("dnf config-manager --set-enable powertools");
`dnf remove -y cockpit`;# not use this web manager tool for cluster
my @package = ("vim", "wget", "net-tools", "epel-release", "htop", "make"
			, "gcc-c++", "nfs-utils","yp-tools", "gcc-gfortran","psmisc"
			, "ypbind" , "rpcbind","xauth","oddjob-mkhomedir");

for (@package){system("dnf -y install $_");}
system("perl -p -i.bak -e 's/.*GSSAPIAuthentication.+/GSSAPIAuthentication no/;' /etc/ssh/sshd_config");
system("perl -p -i.bak -e 's/.*UseDNS.+/UseDNS no/;' /etc/ssh/sshd_config");
system("killall -9 dnf");
system("systemctl restart sshd");
system("dnf -y upgrade");
